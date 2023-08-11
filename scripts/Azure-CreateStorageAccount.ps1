# O módulo do Azure Powershell é necessário que esteja instalado no computador
# Também é necessário que as configurações seja executadas anteriormente
# Link de instalação: https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-10.2.0

# Valores padrões
$defaultTenantId = "<Insira o Tenant Id>"                           # Substitua pelo seu Tenant Id
$defaultResourceGroupName = "<Insira o nome do Resource Group>"     # Substitua pelo seu Resource Group
$defaultStorageAccountName = "<Insira o nome do Storage Account>"   # Substitua pelo seu Storage Account Name
$defaultContainerName = "<Insira o nome do Container>"              # Substitua pelo seu Container Name
$defaultTableName = "<Insira o nome da Tabela>"                     # Substitua pelo seu Table Name
$defaultLocation = "<Insira o nome da Location>"                    # Substitua pela sua Localização desejada, exemplo "Brazil South"

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
$location = Read-Host "Entre com o Location: [$($defaultLocation)]"
$location = ($defaultLocation, $location)[[bool]$location]

# Autenticar na sua conta do Azure
Connect-AzAccount -TenantId $tenantId

# Criar um novo Resource Group
Write-Host "Criando Resource Group"
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Criar um novo Storage Account
Write-Host "Criando Storage Account"
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -Location $location -SkuName Standard_LRS -AllowBlobPublicAccess $true -AllowCrossTenantReplication $false

# Criar um novo container dentro do Storage Account
Write-Host "Criando Container"
$container = New-AzStorageContainer -Name $containerName -Context $storageAccount.Context -Permission Container

# Criar uma tabela dentro do Storage Account
Write-Host "Criando Table Name"
New-AzStorageTable –Name $tableName -Context $storageAccount.Context

# Obter chaves de acesso do Storage Account
Write-Host "Obtendo as chaves de acesso"
$storageKeys = Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName
$storageKey1 = $storageKeys[0].Value
$storageKey2 = $storageKeys[1].Value

# Obter a string de conexão do Storage Account
Write-Host "Obtendo a string de conexao"
$connectionstring =  $storageAccount.Context.ConnectionString

Write-Host "Resource Group, Storage Account, Container e Table criados com sucesso!"
Write-Host "Chave de acesso 1: $storageKey1"
Write-Host "Chave de acesso 2: $storageKey2"
Write-Host "String de Conexao: $connectionstring"