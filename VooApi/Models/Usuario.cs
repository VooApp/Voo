using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace VooApi.Models;

public class Usuario
{
    [BsonId]
    [BsonRepresentation(BsonType.ObjectId)]
    public string? Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public DateTime FechaNacimiento { get; set; }
    public string FotoPerfil { get; set; } = string.Empty; // base64 o URL
    public string? Instagram { get; set; }
    public bool Verificado { get; set; } = false; // Amazon Rekognition (por ahora siempre true)
    public bool DentroRadio { get; set; } = true;
    public DateTime? UltimaVerificacion { get; set; }   
    public string Estado { get; set; } = string.Empty; // "verde", "amarillo", "rojo"
    public List<string> Respuestas { get; set; } = new();
    public bool EsHost { get; set; } = false;
    public string? SalaId { get; set; } // referencia a la sala
    public int Puntos { get; set; } = 0;
    public int Match { get; set; } = 0;
    public string? NivelId { get; set; }                    // FK → Poder
    public List<string> RetosCumplidos { get; set; } = new(); // FK → Reto
    public List<string> Premios { get; set; } = new();      // FK → Premio
    public bool Baneado { get; set; } = false;
}