param proxy string = 'http://<proxy-url>:<port>'
param azureURLs string = '.file.${environment().suffixes.storage},.blob.${environment().suffixes.storage},.afs.azure.net,.azurewebsites.net,.${environment().suffixes.sqlServerHostname},.documents.azure.com,.eventgrid.azure.net,.mariadb.database.azure.com,.mongo.cosmos.azure.com,.mysql.database.azure.com,.northeurope.batch.azure.com,.postgres.database.azure.com,.servicebus.windows.net,.table.core.windows.net,.vaultcore.azure.net,.westeurope.batch.azure.com,.redis.cache.windows.net,.azconfig.io'
param internalURLs string = '127.0.0.1,127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.appserviceenvironment.net'

param appSettings array = [
  {
    name: 'HTTP_PROXY'
    value: proxy
  }   
  {
    name: 'HTTPS_PROXY'
    value: proxy
  }   
  {
    name: 'NO_PROXY'
    value: '${internalURLs},${azureURLs}'
  }
]

output defaultAppSettings array = appSettings
