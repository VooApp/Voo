using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace VooApi.Models
{
    public class Sala
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string? Id { get; set; }

        public string HostId { get; set; } = string.Empty;      // FK → Usuario (host)
        public string Nombre { get; set; } = string.Empty;
        public string Contexto { get; set; } = string.Empty;    // "pool party", "cena formal"...
        public int Aforo { get; set; }
        public string Direccion { get; set; } = string.Empty;
        public int CodigoPostal { get; set; }
        public List<string> Premios { get; set; } = new();      // FK → Premio
        public int Invitados { get; set; } = 0;
        public int Baneados { get; set; } = 0;
        public string? Incidencias { get; set; }
        public DateTime FechaHoraInicio { get; set; } = DateTime.UtcNow;
        public DateTime? FechaHoraFin { get; set; }
    }
}