@export()
type openaiDeployment = {
  name: string
  modelName: string
  modelVersion: string
  skuName: string
  skuCapacity: int
}

@export()
type privateEndpointProperties = {
  @description('Required. Name of the private endpoint resource to create.')
  name: string

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Required. Subtype(s) of the connection to be created. The allowed values depend on the type serviceResourceId refers to.')
  groupIds: array

  @description('Optional. Location for all Resources.')
  location: string

  @description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string

  @description('Optional. Resource ID of the private DNS zone to link to the private endpoint.')
  privateDnsZoneId: string
}

@export()
type roleAssignment = {
  roleName: string
  principalId: string
  principalType: 'ServicePrincipal' | 'Group' | 'User'
}
