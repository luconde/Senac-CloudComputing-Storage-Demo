# O módulo do Azure Powershell é necessário que esteja instalado no computador
# Também é necessário que as configurações seja executadas anteriormente
# Link de instalação: https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-10.2.0

# Valores padrões
$defaultTenantId = "<Insira o Tenant Id>"                           # Substitua pelo seu Tenant Id
$defaultResourceGroupName = "<Insira o nome do Resource Group>"     # Substitua pelo seu Resource Group
$defaultStorageAccountName = "<Insira o nome do Storage Account>"   # Substitua pelo seu Storage Account Name
$defaultContainerName = "<Insira o nome do Container>"              # Substitua pelo seu Container Name
$defaultTableName = "<Insira o nome da Tabela>"                     # Substitua pelo seu Table Name

# Input dos parâmetros para processar
$tenantId = Read-Host "Entre com o Tenant Id: [$($defaultTenantId)]"
$tenantId = ($defaultTenantId, $tenantId)[[bool]$tenantId]
$resourceGroupName = Read-Host "Entre com o Resource Group Name: [$($defaultResourceGroupName)]"
$resourceGroupName = ($defaultResourceGroupName, $resourceGroupName)[[bool]$resourceGroupName]
$storageAccountName = Read-Host "Entre com o Storage Account Name: [$($defaultStorageAccountName)]"
$storageAccountName = ($defaultStorageAccountName, $storageAccountName)[[bool]$storageAccountName]
$containerName = Read-Host "Entre com o Container Name: [$($defaultContainerName)]"
$containerName = ($defaultContainerName, $containerName)[[bool]$containerName]
$tableName = Read-Host "Entre com o Table Name: [$($defaultTableName)]"
$tableName = ($defaultTableName, $tableName)[[bool]$tableName]

# Autenticar na sua conta do Azure
Connect-AzAccount -TenantId $tenantId

# Capturando os dados do Storage Account
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName

# Remover a Table Name
Write-Host "Apagando Table Name"
Remove-AzStorageTable –Name $tableName -Context  $storageAccount.Context -Confirm:$false -Force

# Remover o Container
Write-Host "Apagando Container"
Remove-AzStorageContainer -Name $containerName -Context $storageAccount.Context -Force

# Remover o Storage Account
Write-Host "Apagando Storage Account"
Remove-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -Force

# Remover o Resource Group
Write-Host "Apagando Resource Group"
Remove-AzResourceGroup -Name $resourceGroupName -Force

Write-Host "Table, Container, Storage Account e Resource Group foram excluídos com sucesso!"