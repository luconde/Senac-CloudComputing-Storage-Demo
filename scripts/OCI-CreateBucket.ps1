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

# Criando os detalhes para o Bucket
$a = New-Object Oci.ObjectstorageService.Models.CreateBucketDetails
$a.CompartmentId = $compartmentId
$a.Name = $bucketName
$a.PublicAccessType = "ObjectRead"

# Cria o bucket
Write-Host "Criando o Bucket"
New-OCIObjectStorageBucket -NamespaceName $NamespaceName -CreateBucketDetails $a -Profile $profileName

# Finalizacao
Write-Host "Bucket foi criado com sucesso!"