using './main.bicep'

param name = 'openai-demo-dev-fracentral-001'
param location = 'francecentral'

param privateEndpoints = [{
  name: '${name}-pep'
  location: location
  customNetworkInterfaceName: '${name}-pep-nic'
  groupIds: [ 'account' ]
  privateDnsZoneId: '/subscriptions/<subscription_id>/resourceGroups/<privatDnsZones_rg_name>/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com'
  subnetResourceId: '/subscriptions/<subscription_id>/resourceGroups/<vnet_rg_name>/providers/Microsoft.Network/virtualNetworks/<vnet_name>/subnets/<subnet_name>'
}]

param deployments = [
  {
    name: 'gpt4-turbo'
    modelName: 'gpt-4'
    modelVersion: '1106-Preview'
    skuCapacity: 1
    skuName: 'Standard'
  }
  {
    name: 'gpt-35-turbo'
    modelName: 'gpt-35-turbo'
    modelVersion: '1106'
    skuCapacity: 1
    skuName: 'Standard'
  }
]

param roleAssignments = [
  {
    principalId: '00000-0000-000-000-0000'
    principalType: 'User' // Group, Service Principal
    roleName: 'Cognitive Services OpenAI Contributor'
  } ]
