import * as types from 'types.bicep'

param name string
param location string
param deployments types.openaiDeployment[]
param privateEndpoints types.privateEndpointProperties[] = []
param roleAssignments types.roleAssignment[] = []

resource openaiAccount 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: name
  location: location
  kind: 'OpenAI'
  properties: {
    customSubDomainName: name
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      defaultAction: 'Deny'
    }
  }
  sku: {
    name: 'S0'
  }
}

//Create the OpenAI account deployments (models) in a batchsize to avoid error
@batchSize(1)
resource resDeployments 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = [for deployment in deployments: {
  parent: openaiAccount
  name: deployment.name
  properties: {
    model: {
      format: 'OpenAI'
      name: deployment.modelName
      version: deployment.modelVersion
    }
  }
  sku: {
    name: deployment.skuName
    capacity: deployment.skuCapacity
  }
}]

module modPrivateEndpoins 'privateEndpoint.bicep' = [for privateEndpoint in privateEndpoints : {
  name: 'deploy-openai-pep-${privateEndpoint.name}'
  params: {
    privateEndpoint: privateEndpoint
    serviceResourceId: openaiAccount.id
  }
}]

var builtInRoles = loadJsonContent('roles.json')
resource resRoleAssignVnet 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for roleAssignment in roleAssignments: {
  scope: openaiAccount
  name: guid(name, roleAssignment.principalId, roleAssignment.principalType, roleAssignment.roleName)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', builtInRoles[roleAssignment.roleName])
    principalId: roleAssignment.principalId
    principalType: roleAssignment.principalType
  }
}]


output endpoint string = openaiAccount.properties.endpoint
output name string = openaiAccount.name
