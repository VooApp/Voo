namespace VooApi.Models
{
    public class RegistroInvitadoDto
    {
        // Datos del usuario
        public string Nombre { get; set; } = string.Empty;
        public bool Sexo { get; set; }
        public DateTime FechaNacimiento { get; set; }
        public string Foto { get; set; } = string.Empty;
        public string? Ig { get; set; }
        public string Estado { get; set; } = string.Empty;
        public List<string> Respuestas { get; set; } = new();

        // Verificación facial
        public bool Verificado { get; set; }

        // Código de sala
        public string CodigoSala { get; set; } = string.Empty;

        // Ubicación del invitado
        public double Latitud { get; set; }
        public double Longitud { get; set; }
        public double Accuracy { get; set; }                  // precisión del GPS en metros
    }
}