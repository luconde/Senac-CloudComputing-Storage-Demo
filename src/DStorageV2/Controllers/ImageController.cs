using DStorageV2.Library;

using Microsoft.AspNetCore.Mvc;

using Google.Cloud.Storage.V1;
using Google.Api;

using Azure.Storage.Blobs;
using Azure.Data.Tables;

using Oci.Common;
using Oci.Common.Auth;
using Oci.Common.Utils;
using System.Security;
using Org.BouncyCastle.Crypto.Parameters;
using Oci.ObjectstorageService;
using Oci.ObjectstorageService.Models;
using Oci.ObjectstorageService.Requests;
using Oci.ObjectstorageService.Responses;

using AWSSDK;


namespace DStorageV2.Controllers
{
    public class ImageController : Controller
    {
        private readonly IConfiguration pobjConfiguration;
        private readonly IWebHostEnvironment pobjWebHostingConfiguration;

        private string RandomizeFileName(string StudentName, string FileName)
        {
            //Gera um numero randomico para evitar conflito de nomes
            Random objR = new Random();
            int intRandomNumber = objR.Next();

            //Une o Arquivo com o Nome do Estudante e o numero randomico do momento
            string strResult = StudentName + "-" + intRandomNumber.ToString() + "-" + FileName;

            return strResult;
        }

        public ImageController(IConfiguration objConfiguration, IWebHostEnvironment env)
        {
            pobjConfiguration = objConfiguration;
            pobjWebHostingConfiguration = env;
        }

        public IActionResult Listar()
        {                    
            
            // Captura a string de conexao
            string AzureTableName = pobjConfiguration.GetValue<string>("AzureTable:TableName");
            string AzureTableStorageConnectionString = pobjConfiguration.GetValue<string>("AzureTable:ConnectionString");

            var serviceClient = new TableClient(AzureTableStorageConnectionString, AzureTableName);

            var lista = serviceClient.Query<FileEntity>().ToList();

            return View(lista);
        }

        public async Task<IActionResult> Upload(List<IFormFile> files, string destination, string studentname)
        {

            //Pega o Arquivo
            var objFile = files.FirstOrDefault();

            // Se alguem passou algum arquivo
            if(objFile != null & destination != null & studentname != null)
            {
                string strFileName = RandomizeFileName(studentname, objFile.FileName);
                //Armaze na para uso na View
                ViewBag.OK = true;
                ViewBag.FileName = strFileName;
                ViewBag.Size = objFile.Length;
                ViewBag.Destination = destination;

                if (objFile.Length > 0)
                {

                    // Faz o upload em conformidade com o destino
                    switch (destination)
                    {
                        // Enviando para o Google Cloud
                        case "gcp":
                            //
                            //Caso o destino seja o GCP

                            //Cria o cliente para acessar o Bucket/Repositorio no GCP
                            //As Credenciais estão armazenadas no appsettings.json
                            Google.Apis.Auth.OAuth2.GoogleCredential objGCPCredential = Google.Apis.Auth.OAuth2.GoogleCredential.FromJson(pobjConfiguration.GetValue<string>("GCPBucket:ConnectionString"));

                            //Cria o cliente para acessar o local onde o arquivo sera armazenado
                            var objGCPStorage = StorageClient.Create(objGCPCredential);

                            using (var stream = objFile.OpenReadStream())
                            {
                                //Upload do arquivo
                                await objGCPStorage.UploadObjectAsync(pobjConfiguration.GetValue<string>("GCPBucket:Repository"), strFileName, null, stream);
                            }

                            break;
                        case "azure":
                            //
                            //Caso o destino seja Azure
                            //

                            // Cria o cliente para acessar o Container/Repositorio no Azure 
                            // As credenciais estão armazenados no appsettings.json
                            var objAzureClient = new BlobContainerClient(pobjConfiguration.GetValue<string>("AzureBlob:ConnectionString"), pobjConfiguration.GetValue<string>("AzureBlob:Repository"));
                            
                            // Cria o cliente para acessar o local onde o arquivo será armazenado
                            var objAzureBlob = objAzureClient.GetBlobClient(strFileName);

                            using (var stream = objFile.OpenReadStream())
                            {
                                //Upload do arquivo
                                await objAzureBlob.UploadAsync(stream);
                            }

                            break;
                        case "oci":
                            //
                            //Caso o destino seja OCI
                            //

                            // Cria o cliente para acessar o Container/Repositorio no OCI 
                            // As credenciais estão armazenados no appsettings.json
                            var provider = new SimpleAuthenticationDetailsProvider();
                            provider.UserId = pobjConfiguration.GetValue<string>("OCIBucket:UserId");
                            provider.Fingerprint = pobjConfiguration.GetValue<string>("OCIBucket:Fingerprint");
                            provider.TenantId = pobjConfiguration.GetValue<string>("OCIBucket:TenantId");
                            provider.Region = Region.FromRegionId(pobjConfiguration.GetValue<string>("OCIBucket:RegionId"));
                            SecureString passPhrase = StringUtils.StringToSecureString(pobjConfiguration.GetValue<string>("OCIBucket:PassPhrase"));
                            provider.PrivateKeySupplier = new FilePrivateKeySupplier(pobjWebHostingConfiguration.ContentRootPath + "/" + pobjConfiguration.GetValue<string>("OCIBucket:PrivateKeyFile"), passPhrase);

                            // Cria o cliente para o Object Storage
                            var osClient = new ObjectStorageClient(provider, new ClientConfiguration());
                            var getNamespaceRequest = new GetNamespaceRequest();
                            var namespaceRsp = await osClient.GetNamespace(getNamespaceRequest);
                            var ns = namespaceRsp.Value;


                            using (var stream = objFile.OpenReadStream())
                            {
                                // Estabelece informações do upload (nome, local)
                                var putObjectRequest = new PutObjectRequest()
                                {
                                    BucketName = pobjConfiguration.GetValue<string>("OCIBucket:Repository"),
                                    NamespaceName = ns,
                                    ObjectName = strFileName,
                                    PutObjectBody = stream
                                };

                                //Upload do Arquivo
                                var putObjectRsp = await osClient.PutObject(putObjectRequest);
                            }

                            break;
                        case "aws":
                            //
                            //Caso o destino seja a AWS
                            //

                            // Cria o cliente para acessar o Container/Repositorio na AWS
                            // As credenciais estão armazenados no appsettings.json
                            using (Amazon.S3.IAmazonS3 objAWSClient = new Amazon.S3.AmazonS3Client(pobjConfiguration.GetValue<string>("AWSContainer:AccessKey"), pobjConfiguration.GetValue<string>("AWSContainer:SecretKey"), Amazon.RegionEndpoint.SAEast1))
                            {
                                using (var stream = objFile.OpenReadStream())
                                {
                                    var objAWSFileTrans = new Amazon.S3.Transfer.TransferUtility(objAWSClient);

                                    //Upload do arquivo
                                    await objAWSFileTrans.UploadAsync(stream, pobjConfiguration.GetValue<string>("AWSContainer:Repository"), strFileName);

                                }
                            }
                                
                            
                            break;
                        default:
                            break;
                    }

                    //
                    // Armazena no Azure Table os dados que foram enviados
                    //

                    // Captura a string de conexao
                    string AzureTableName = pobjConfiguration.GetValue<string>("AzureTable:TableName");
                    string AzureTableStorageConnectionString = pobjConfiguration.GetValue<string>("AzureTable:ConnectionString");

                    var serviceClient = new TableClient(AzureTableStorageConnectionString, AzureTableName);
                    // Registra na Tabela qual arquivo foi inserido
                    var objArquivo = new FileEntity()
                    {
                        PartitionKey = studentname,
                        RowKey = strFileName,
                        FileName = objFile.FileName,
                        Destino = destination
                    };

                    await serviceClient.AddEntityAsync(objArquivo);
                }
            }
            else
            {
                //Sinaliza que não há arquivo
                ViewBag.OK = false;
            }

            return View();
        }

    }
}
