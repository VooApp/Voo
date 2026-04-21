namespace VooApi.Models
{
    public class RegistroHostDto
    {
        // Datos del usuario
        public string Nombre { get; set; } = string.Empty;
        public DateTime FechaNacimiento { get; set; }
        public string Foto { get; set; } = string.Empty;      // URL de la imagen
        public string? Ig { get; set; }
        public string Estado { get; set; } = string.Empty;    // "verde", "amarillo", "rojo"
        public List<string> Respuestas { get; set; } = new();

        // Datos de la sala
        public string NombreSala { get; set; } = string.Empty;
        public string Contexto { get; set; } = string.Empty;
        public int Aforo { get; set; } = 30;                  // demo: solo 30
        public string Direccion { get; set; } = string.Empty;
        public int CodigoPostal { get; set; }
        public double LatitudSala { get; set; }               // coordenadas de la sala
        public double LongitudSala { get; set; }
        public string PremioMayor { get; set; } = string.Empty;
        public List<string> PremiosFlash { get; set; } = new();
    }
}