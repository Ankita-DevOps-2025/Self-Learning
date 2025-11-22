front     ->  https://tutorbuddy.fiftyfivetech.io/login    email - khushi.malviya@fiftyfivetech.io   passwrd - Khushii@123
backend   -> https://tutorbackend.fiftyfivetech.io/management/health


provider curl - curl 'https://tutorbuddy.fiftyfivetech.io/api/auth/providers' \
  -H 'Accept: */*' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/json' \
  -H 'Referer: https://tutorbuddy.fiftyfivetech.io/login' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36' \
  -H 'sec-ch-ua: "Chromium";v="142", "Google Chrome";v="142", "Not_A Brand";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"'


  issue was in config part - secert was not correct
  