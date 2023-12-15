import {privateEndpointProperties} from 'types.bicep'

@description('Required. Resource ID of the resource that needs to be connected to the network.')
param serviceResourceId string

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object = {}

param privateEndpoint privateEndpointProperties

resource resPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: privateEndpoint.name
  location: privateEndpoint.location
  tags: tags
  properties: {
    customNetworkInterfaceName: privateEndpoint.customNetworkInterfaceName
    privateLinkServiceConnections: [
      {
        name: privateEndpoint.name
        properties: {
          privateLinkServiceId: serviceResourceId
          groupIds: privateEndpoint.groupIds
        }
      }
    ]
    subnet: {
      id: privateEndpoint.subnetResourceId
    }
  }
}

resource resPrivateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-11-01' = if(!empty(privateEndpoint.privateDnsZoneId)) {
  name: 'default'
  parent: resPrivateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: empty(privateEndpoint.privateDnsZoneId) ? 'default' : last(split(privateEndpoint.privateDnsZoneId, '/'))!
        properties: {
          privateDnsZoneId: privateEndpoint.privateDnsZoneId
        }
      }
    ]
  }
}

@description('The resource ID of the private endpoint.')
output id string = resPrivateEndpoint.id

