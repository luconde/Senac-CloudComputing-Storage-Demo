# O módulo do AWS Powershell é necessário que esteja instalado no computador
# Também é necessário que as configurações seja executadas anteriormente
# Link de instalação: https://docs.aws.amazon.com/powershell/latest/userguide/pstools-welcome.html

# Valores padrões
$defaultBucketName = "<Insira o nome bucket>"                           # Substitua pelo bucket desejado
$defaultRegion = "<Insira o nome da regiao>"                            # Substitua pela região desejada
$defaultProfile = "<Insira o nome do perfil configuracao no AWS CLI>"   # Substitua pelo perfil desejado

# Input dos parâmetros para processar
$bucketName = Read-Host "Entre com o Bucket Name: [$($defaultBucketName)]"
$bucketName = ($defaultBucketName, $bucketName)[[bool]$bucketName]
$region = Read-Host "Entre com o Region: [$($defaultRegion)]"
$region = ($defaultRegion, $region)[[bool]$region]
$profile = Read-Host "Entre com o Profile: [$($defaultProfile)]"
$profile = ($defaultProfile, $profile)[[bool]$profile]

# Crie o bucket com as configurações apropriadas
Write-Host "Criando o Bucket"
New-S3Bucket -BucketName $bucketName -Region $region -CannedACLName bucket-owner-full-control -ProfileName $profile -Force

# Remova o parametro padrão que impede que o Bucket seja publico
Write-Host "Removendo o padrão de configuração para que o Bucket não seja público"
Remove-S3PublicAccessBlock -BucketName $bucketName -ProfileName $profile -Force

# Configure a política de acesso público para o bucket
$policy = @{
    Version = "2012-10-17"
    Statement = @(
        @{
            Effect = "Allow"
            Principal = "*"
            Action = "s3:GetObject"
            Resource = "arn:aws:s3:::$bucketName/*"
        }
    )
} | ConvertTo-Json

# Aplique a política de acesso público ao bucket
Write-Host "Configurando para o acesso ser publico"
Write-S3BucketPolicy -BucketName $bucketName -Policy $policy -ProfileName $profile

# Finalizacao
Write-Host "Bucket foi criado com sucesso!"
