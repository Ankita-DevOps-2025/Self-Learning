Name of Requestor: Ankita Meena
Cloud Platform: Azure
Type of Request: Permission Update for Existing App Registration
Date of Request: 20/11/2025
Expected Completion Date: 20/12/2025
Environment: Development & Staging (for testing purpose only)
Application Details:
    App Name: Project EKI
    Current Status: App Registration already exists in directory
    Required Action: Update permissions to enable email access functionality
List of Permissions to be Added:
    Mail.Read (Read user mail)
    Mail.Send (Send mail as a user)
    Mail.ReadWrite (Read and write access to user mail)
    MailboxSettings.Read (Read user mailbox settings)
    offline_access(For referesh token to avoid multiple logins)
Purpose of Permission Update: To enable email integration functionality for Project NexGen, including:
    Reading user emails for application features
    Sending emails on behalf of authenticated users
    Managing email-related application workflows
    Testing email integration in development environment
Estimated Monthly Cost: (FREE) Adding delegated permissions to existing Azure AD App Registration does not incur additional costs.
Additional Notes:
    No production impact anticipated
    Permissions required for testing email integration features in Project NexGen
    App registration already exists - only permission updates needed
    Essential for validating email functionality before production deployment






===============================================================

N### Request Details

Request Details

Name of Requestor: Ankita Meena
Cloud Platform: Azure
Type of Request: Deployment Configuration & Permission Updates for Azure Function
Date of Request: 20/11/2025
Expected Completion Date: 20/12/2025
Environment: Development and Staging (for testing purposes only)

Application Details:
   - App Name: Project EKI
   - Current Status: Application is in the development phase, with Azure Function configuration and CI/CD setup needed for testing and validation.
   - Required Action:
     1. Configure Azure Function for deployment
     2. Set up CI/CD pipeline for continuous integration and delivery
     3. Ensure public network access for testing purposes

List of Permissions to be Added:
   - Azure Function Contributor Role: Required for deploying and managing Azure Functions
   - Storage Blob Contributor: For storage access and handling file inputs/outputs during function execution
   - Network Contributor: To manage public network configurations for the Azure Function
   - Contributor (on Resource Group): Required for deploying using GitHub Actions or Azure DevOps (CI/CD pipeline setup)

Purpose of Permission Update & Deployment Configuration:
   - Azure Function Deployment: Deploy the Python-based AI application to Azure Functions to leverage serverless architecture for scalable execution.
   - Public Network Access Testing: Ensure the application is publicly accessible in the development and staging environments for testing and validation of AI-related workflows.
   - CI/CD Integration: Set up a CI/CD pipeline using Azure DevOps or GitHub Actions for automated deployment and testing, allowing rapid iteration and deployment in the development stage.

Estimated Monthly Cost:
   - FREE: Permissions for Azure AD app registration and Azure Function deployment do not incur additional costs.
   - Azure Function Costs: Costs will depend on the execution time and resource usage of the Azure Functions, but will be minimal in development and testing phases.

Additional Notes:
   - In-Development Phase: The application is still in development, with no production deployment involved at this stage.
   - Public Network Access: The Azure Function will be publicly accessible for testing and validation purposes, ensuring the AI workflows can be fully evaluated.
   - CI/CD Pipeline Integration: Set up to enable automated testing and deployment, helping streamline the development process.
