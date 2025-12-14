repository structure
/_pycache_/final.cpython-310.pyc
.env
.gitignore
formatted.py (final code)
final.py
requirements.txt


Content of files
# .env
OPENAI_API_KEY="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"

# .gitignore
/venv/
/node_modules/
/.next
/.env

===================
# requirements.txt
===================




=========================================================================================
# formatted.py
================

from fastapi import FastAPI
from pydantic import BaseModel
from openai import OpenAI
import json
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(title="Smart Travel Assistant API")
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

SYSTEM_PROMPT = """
You are Smart Travel Assistant. Your tasks:
1. Detect user intent (cab, flight, visa, hotel, tour, itinerary planning, etc.).
2. Ask relevant questions to get complete info.
3. Summarize answers in natural language for confirmation.
4. If intent = travel planning / itinerary → create a personalized day-wise itinerary.
5. After confirmation, update itinerary if user wants changes.
6. When finalized, generate clean JSON (user details + itinerary).
"""

sessions = {}

class ChatMessage(BaseModel):
    session_id: str
    user_input: str


def chat_gpt(messages):
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=messages,
        temperature=0.3
    )
    return response.choices[0].message.content.strip()


# -------------------------------
# NEW → Extract Q/A pairs from user answers
# -------------------------------
def extract_qa_pairs(raw_text):
    prompt = f"""
Convert the following text into a structured list of Q&A pairs.
Return strictly in JSON array format:
[
  {{ "question": "...", "answer": "..." }},
  ...
]

Text:
{raw_text}
"""
    messages = [{"role": "system", "content": "Extract clean Q&A pairs."},
                {"role": "user", "content": prompt}]
    result = chat_gpt(messages)

    try:
        return json.loads(result)
    except:
        return []


# -------------------------------
# NEW → Create HTML table dynamically
# -------------------------------
def generate_html_table(qa_list):
    if not qa_list:
        return "<p>No details found.</p>"

    html = """
    <table border="1" style="border-collapse: collapse; width: 80%; text-align: left;">
        <tr style="background-color:#f2f2f2;">
            <th style="padding:8px;">Question</th>
            <th style="padding:8px;">Answer</th>
        </tr>
    """
    for qa in qa_list:
        html += f"""
        <tr>
            <td style="padding:8px;">{qa['question']}</td>
            <td style="padding:8px;">{qa['answer']}</td>
        </tr>
        """
    html += "</table>"
    return html


# ===================================================================
# MAIN ENDPOINT
# ===================================================================
@app.post("/chat")
async def chat_endpoint(msg: ChatMessage):
    session_id = msg.session_id
    user_input = msg.user_input.strip()

    # --------------------- NEW SESSION ---------------------
    if session_id not in sessions:
        sessions[session_id] = {
            "state": "get_intent",
            "conversation": [{"role": "system", "content": SYSTEM_PROMPT}],
            "intent": None,
            "user_answers": "",
            "qa_pairs": [],
            "itinerary_text": "",
            "backend_json": None
        }

    session = sessions[session_id]
    state = session["state"]
    conversation = session["conversation"]

    conversation.append({"role": "user", "content": user_input})


    # ===================================================================
    # 1️⃣ DETECT INTENT
    # ===================================================================
    if state == "get_intent":
        session["user_answers"] = ""
        conversation.append({
            "role": "assistant",
            "content": f"User said: {user_input}. Detect intent and ask follow-up questions."
        })

        bot_reply = chat_gpt(conversation)

        detect_prompt = "Extract ONLY the main intent as one word."
        conversation.append({"role": "assistant", "content": detect_prompt})
        detected_intent = chat_gpt(conversation).lower()

        session["intent"] = detected_intent
        session["state"] = "collect_answers"

        return {"bot": bot_reply, "state": "collect_answers", "intent": detected_intent}


    # ===================================================================
    # 2️⃣ COLLECT ANSWERS
    # ===================================================================
    elif state == "collect_answers":
        session["user_answers"] += " " + user_input

        summary_prompt = f"Summarize user's details clearly:\n{session['user_answers']}"
        conversation.append({"role": "assistant", "content": summary_prompt})
        summary = chat_gpt(conversation)

        # build html table
        qa_pairs = extract_qa_pairs(session["user_answers"])
        session["qa_pairs"] = qa_pairs
        html_table = generate_html_table(qa_pairs)

        session["state"] = "confirm"

        return {
            "bot": summary + "\n\nPlease confirm if these details are correct.",
            "state": "confirm",
            "html_output": html_table,
            "qa_pairs": qa_pairs
        }


    # ===================================================================
    # 3️⃣ CONFIRM DETAILS
    # ===================================================================
    elif state == "confirm":
        lower = user_input.lower()

        if any(w in lower for w in ["yes", "confirm", "ok", "final", "done", "correct", "looks good"]):
            intent = session["intent"]

            # 3A ITINERARY PATH
            if intent in ["itinerary", "tour", "travel", "trip"]:

                itinerary_prompt = f"""
Create a personalized day-wise itinerary (3–7 days) based on:

User details:
{session['user_answers']}

Include:
- Day number
- Activities + timing
- Highlights
- Tips
Return in markdown.
"""
                conversation.append({"role": "assistant", "content": itinerary_prompt})
                itinerary_text = chat_gpt(conversation)

                session["itinerary_text"] = itinerary_text
                session["state"] = "review_itinerary"

                return {
                    "bot": "Here is your suggested itinerary:\n\n" + itinerary_text,
                    "state": "review_itinerary",
                    "html_output": generate_html_table(session["qa_pairs"])
                }

            # 3B NON-ITINERARY PATH → JSON OUTPUT
            json_prompt = f"Convert user details into clean JSON:\n{session['user_answers']}"
            conversation.append({"role": "assistant", "content": json_prompt})
            backend_json = chat_gpt(conversation)

            session["backend_json"] = backend_json
            session["state"] = "done"

            return {
                "bot": "Thanks! Here is your final JSON.",
                "state": "done",
                "backend_json": backend_json,
                "html_output": generate_html_table(session["qa_pairs"])
            }

        # 3C CORRECTION
        elif any(w in lower for w in ["change", "edit", "update"]):
            session["state"] = "correction"
            return {"bot": "Sure! Please tell me what to update.", "state": "correction"}

        else:
            return {"bot": "Please confirm with yes or specify the change.", "state": "confirm"}


    # ===================================================================
    # 4️⃣ HANDLE CORRECTIONS
    # ===================================================================
    elif state == "correction":
        session["user_answers"] = user_input

        qa_pairs = extract_qa_pairs(user_input)
        session["qa_pairs"] = qa_pairs
        html_table = generate_html_table(qa_pairs)

        session["state"] = "confirm"

        return {
            "bot": "I’ve updated the details. Please confirm.",
            "state": "confirm",
            "html_output": html_table,
            "qa_pairs": qa_pairs
        }


    # ===================================================================
    # 5️⃣ REVIEW ITINERARY (Update allowed)
    # ===================================================================
    elif state == "review_itinerary":
        lower = user_input.lower()

        # 5A CONFIRM ITINERARY
        if any(w in lower for w in ["yes", "confirm", "looks good", "final"]):
            json_prompt = f"""
Convert the following into structured JSON:
User details: {session['user_answers']}
Itinerary: {session['itinerary_text']}
"""
            conversation.append({"role": "assistant", "content": json_prompt})
            backend_json = chat_gpt(conversation)

            session["backend_json"] = backend_json
            session["state"] = "done"

            return {
                "bot": "Great! Here is your final itinerary JSON.",
                "state": "done",
                "backend_json": backend_json,
                "html_output": generate_html_table(session["qa_pairs"])
            }

        # 5B UPDATE ITINERARY
        update_prompt = f"""
User wants this update: {user_input}

Old itinerary:
{session['itinerary_text']}

Update ONLY what is needed and return new markdown itinerary.
"""
        conversation.append({"role": "assistant", "content": update_prompt})
        updated_plan = chat_gpt(conversation)

        session["itinerary_text"] = updated_plan

        return {
            "bot": "Here is the updated itinerary:\n\n" + updated_plan,
            "state": "review_itinerary",
            "html_output": generate_html_table(session["qa_pairs"])
        }


    # ===================================================================
    # 6️⃣ END SESSION
    # ===================================================================
    elif state == "done":
        session["state"] = "get_intent"
        return {
            "bot": "Would you like to book another service or plan another trip?",
            "state": "get_intent"
        }