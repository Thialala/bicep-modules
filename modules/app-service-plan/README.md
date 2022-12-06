# Azure App Service Plan Bicep module

This template allows you to create an [Azure App Service Plan](https://docs.microsoft.com/en-us/azure/app-service/overview-hosting-plans)

## Parameters
| Name               | Description                                   | Value                                          |
|--------------------|-----------------------------------------------|------------------------------------------------|
| aspName            | ASP name                                      | string (required)<br><br>Character limit: 2-60 |
| operatingSystem    | ASP operating system                          | 'windows'<br>'linux'                           |
| appServicePlanSize | ASP size                                      | 'I1v2'<br>'I2v2'<br>'I3v2'                     |
| aseEnvironment     | To choose the ASE NonProduction or Production | 'NonProduction'<br>'Production'                |
| location           | Resource location                             | string                                         |
| tags               | Resource tags                                 | Dictionary of tag names and values.            |

