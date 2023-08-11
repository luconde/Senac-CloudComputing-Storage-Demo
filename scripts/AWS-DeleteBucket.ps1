# O módulo do AWS Powershell é necessário que esteja instalado no computador
# Também é necessário que as configurações seja executadas anteriormente
# Link de instalação: https://docs.aws.amazon.com/powershell/latest/userguide/pstools-welcome.html

# Valores padrões
$defaultBucketName = "<Insira o nome bucket>"                           # Substitua pelo bucket desejado
$defaultProfile = "<Insira o nome do perfil configuracao no AWS CLI>"   # Substitua pelo perfil desejado

# Input dos parâmetros para processar
$bucketName = Read-Host "Entre com o Bucket Name: [$($defaultBucketName)]"
$bucketName = ($defaultBucketName, $bucketName)[[bool]$bucketName]
$profile = Read-Host "Entre com o Profile: [$($defaultProfile)]"
$profile = ($defaultProfile, $profile)[[bool]$profile]

# Configure a política de acesso público para o bucket
Write-Host "Apagando o Bucket"
Remove-S3Bucket -BucketName $bucketName -DeleteBucketContent -ProfileName $profile -Force

# Finalizacao
Write-Host "Bucket foi removido com sucesso!"
