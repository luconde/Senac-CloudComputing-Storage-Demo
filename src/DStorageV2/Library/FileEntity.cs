using Azure;
using Azure.Data.Tables;

namespace DStorageV2.Library
{
    public class FileEntity : ITableEntity
    {
        public string PartitionKey {  get; set; }
        public string RowKey { get; set; }
        public string FileName { get; set; }    
        public string Destino { get; set; }
        public string Context {  get; set; }
        public DateTimeOffset? Timestamp { get; set; }  
        public ETag ETag { get; set;  }


    }
}
