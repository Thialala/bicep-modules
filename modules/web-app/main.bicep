param aspResourceGroupName string = resourceGroup().name
param aspName string
param webAppName string
param managedIdentityName string = ''
param location string = resourceGroup().location
param tags object = {}

@description('application settings in array format: appSettings = [{name: \'settings_name\', value: \'setting_value\'}{...}]')
param appSettings array = []

param runFromPackage bool = false

var shouldUseManagedIdentity =  !empty(managedIdentityName)

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' existing = {
  name: aspName
  scope: resourceGroup(aspResourceGroupName)
}

module settings '../settings.bicep' = {
  name: 'common-settings-${webAppName}'
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if (shouldUseManagedIdentity) {
  name: managedIdentityName
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  tags: tags
  properties:{
    serverFarmId: appServicePlan.id
    siteConfig:{
      alwaysOn: true
      ftpsState: 'Disabled'
      appSettings: runFromPackage ? concat(settings.outputs.defaultAppSettings, appSettings, [{name: 'WEBSITE_RUN_FROM_PACKAGE', value: 1}]) : concat(settings.outputs.defaultAppSettings, appSettings)
      use32BitWorkerProcess: false
      minTlsVersion: '1.2'
    }
    keyVaultReferenceIdentity: shouldUseManagedIdentity ? managedIdentity.id : 'SystemAssigned'
    httpsOnly: true   
  }  
  identity:  {
    type: shouldUseManagedIdentity ? 'UserAssigned' : 'SystemAssigned'
    userAssignedIdentities: shouldUseManagedIdentity ? {
      '${managedIdentity.id}': {}
    }: null
  }
}

resource appLogs 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: webApp
  name: 'logs'
  properties: {
    httpLogs:{
      fileSystem:{
        enabled: true
        retentionInMb: 50
        retentionInDays: 3
      }
    }
    detailedErrorMessages:{
      enabled: true
    }
    failedRequestsTracing:{
      enabled: true
    }  
  }
}

output webappUrl string = webApp.properties.defaultHostName
output identityId string = webApp.identity.principalId
