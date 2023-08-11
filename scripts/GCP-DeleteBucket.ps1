# O módulo do Google Cloud Platform Powershell é necessário que esteja instalado no computador
# Também é necessário que as configurações (gcpcloud init) seja executadas anteriormente
# Link de instalação: https://cloud.google.com/powershell

# Valores padrões
$defaultBucketName = "<Insira o nome do Bucket>"    # Substitua pelo nome do Bucket

# Input dos parâmetros para processar
$bucketName = Read-Host "Entre com o Bucket Name: [$($defaultBucketName)]"
$bucketName = ($defaultBucketName, $bucketName)[[bool]$bucketName]

# Criando um Bucket
Write-Host "Apagando o Bucket"
Remove-GcsBucket -Name $bucketName -Force

# Finalizacao
Write-Host "Bucket foi criado com sucesso!"