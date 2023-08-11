# O módulo do OCI Powershell é necessário que esteja instalado no computador
# Também é necessário que as configurações seja executadas anteriormente
# Link de instalação: https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/powershellgettingstarted.htm

# Defina as variáveis necessárias
$defaultCompartmentId = "<Insira o OCI Id para o Compartment>"  # Substitua pelo OCI Id do Compartment
$defaultBucketName = "<Insira o nome do Bucket>"                # Substitua pelo nome do Bucket
$profileName = "<Insira o nome do perfil>"                      # Substitua pelo nome do perfil

# Input dos parâmetros para processar
$bucketName = Read-Host "Entre com o Bucket Name: [$($defaultBucketName)]"
$bucketName = ($defaultBucketName, $bucketName)[[bool]$bucketName]
$compartmentId = Read-Host "Entre com o Compartment Id: [$($defaultCompartmentId)]"
$compartmentId = ($defaultCompartmentId, $compartmentId)[[bool]$compartmentId]

# Obtem o NameSpace do Compartment
Write-Host "Obtem o NameSpace do Compartment"
$NamespaceName = Get-OCIObjectStorageNamespace -CompartmentId $compartmentId -Profile $profileName

# Cria o bucket
Write-Host "Apagando o Bucket"
Remove-OCIObjectstorageBucket -NamespaceName $NamespaceName -BucketName $bucketName  -Force -Profile $profileName

# Finalizacao
Write-Host "Bucket foi apagado com sucesso!"