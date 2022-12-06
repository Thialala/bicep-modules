@minLength(2)
@maxLength(60)
param aspName string

@allowed([
  'windows'
  'linux'
])
param operatingSystem string

@allowed([
  'I1v2'
  'I2v2'
  'I3v2'
])
param appServicePlanSize string = 'I1v2'

@allowed([
  'Production'
  'NonProduction'
])
param aseEnvironment string

param location string = resourceGroup().location
param tags object = {}

var aseEnvironmentConfigurationMap = {
  Production: {
    name: 'ase-prod-001'
    resourceGroup : 'rg-ases'
  }
  NonProduction: {
    name: 'ase-nonprod-001'
    resourceGroup : 'rg-ases'
  }
}

var aseSuscriptionId = '<subscriptionId_of_the_shared_subscription_containing_ASEs'
  
resource hostingEnvironment 'Microsoft.Web/hostingEnvironments@2021-03-01' existing = {
  name: aseEnvironmentConfigurationMap[aseEnvironment].name
  scope: resourceGroup(aseSuscriptionId, aseEnvironmentConfigurationMap[aseEnvironment].resourceGroup)
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: aspName
  location: location
  tags: tags
  sku: {
    name: appServicePlanSize
    tier: 'IsolatedV2'
    capacity: aseEnvironment == 'NonProduction' ? 1 : 3
  }
  properties: {
    hostingEnvironmentProfile: {
       id: hostingEnvironment.id
    }
    perSiteScaling: true
    reserved: operatingSystem == 'windows' ? false : true 
  }
}

output id string = appServicePlan.id
