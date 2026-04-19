using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace VooApi.Models;

public class Sala
{
    [BsonId]
    [BsonRepresentation(BsonType.ObjectId)]
    public string? Id { get; set; }
    public string HostId { get; set; } = string.Empty;
    public string Nombre { get; set; } = string.Empty;
    public string Contexto { get; set; } = string.Empty; // "Pool Party", "Cena formal", "Reunión informal"
    public string Aforo { get; set; } = string.Empty; // "15-30", "30-50", "+50"
    public string Direccion { get; set; } = string.Empty;
    public string CodigoPostal { get; set; } = string.Empty;
    public List<string> Premios { get; set; } = new();
    public string CodigoSala { get; set; } = string.Empty; // código único generado
    public string? Incidencias { get; set; } // referencia al usuario host
    public List<string> InvitadosIds { get; set; } = new();
    public bool Activa { get; set; } = true; // TEMPORAL PARA FUNCIONALIDAD
}