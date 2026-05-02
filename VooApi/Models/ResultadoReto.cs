namespace VooApi.Models
{
    public class ResultadoReto
    {
        public bool Exito { get; set; }
        public string Mensaje { get; set; } = string.Empty;
        public int PuntosGanados { get; set; }
        public string? RetoId { get; set; }
    }
}