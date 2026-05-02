namespace VooApi.Models
{
    // Lo que Flutter manda cuando el usuario confirma su ubicación
    public class ConfirmarPresenciaDto
    {
        public string UsuarioId { get; set; } = string.Empty;
        public double Latitud { get; set; }
        public double Longitud { get; set; }
        public double Accuracy { get; set; } // precisión del GPS en metros
    }
}