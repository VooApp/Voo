using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace VooApi.Models
{
    public class Mensaje
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string? Id { get; set; }

        public string? Texto { get; set; }

        public DateTime FechaCreacion { get; set; } = DateTime.UtcNow;
    }
}