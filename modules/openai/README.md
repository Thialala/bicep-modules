# Bicep Azure OpenAI Module

## Overview

This Bicep module is designed to set up and configure an Azure OpenAI environment. The module includes various Bicep files and a JSON file defining roles, which together facilitate the deployment and management of OpenAI resources on Azure.

## Files Description

1. **main.bicep**: The entry point of the module, importing types from `types.bicep` and defining key parameters. It creates a resource for the OpenAI account with specific configurations.

2. **main.bicepparam**: Includes parameter definitions for the main Bicep file, specifying values like `name`, `location`, and `privateEndpoints`.

3. **privateEndpoint.bicep**: Imports `privateEndpointProperties` from `types.bicep` for creating a private endpoint with specified properties.

4. **roles.json**: A JSON file defining two roles: "Cognitive Services OpenAI Contributor" and "Cognitive Services OpenAI User".

5. **types.bicep**: Exports custom types used in the module, such as `openaiDeployment` and `privateEndpointProperties`.

## Usage

Adapt `main.bicep` depending on your needs and configure `main.bicepparam` with appropriate values. Utilize `privateEndpoint.bicep` for setting up private endpoints and refer to `roles.json` for role assignments.

## Requirements

- Azure CLI or PowerShell for deployment.
- Knowledge of Bicep and Azure resource configurations.

## Deployment

### Deploying with Azure CLI

1. **Login to Azure**:

   ```bash
   az login
   ```

2. **Create a Resource Group (if not already existing):**

   ```bash
   az group create --name <ResourceGroupName> --location <Location>
   ```

3. **Deploy the module:**

   ```bash
    az deployment group create --name <DeploymentName> --resource-group <ResourceGroupName> --template-file ./main.bicep --parameters ./main.bicepparam

**Notes:**

- Replace <ResourceGroupName>, <Location>, and <DeploymentName> with your specific values.
- Ensure file paths are correct based on your directory structure.
- Update main.bicepparam as per your deployment needs before executing the deployment commands.
