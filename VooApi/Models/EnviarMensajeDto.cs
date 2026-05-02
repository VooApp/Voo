namespace VooApi.Models
{
    // Lo que Flutter manda cuando el usuario escribe un mensaje
    public class EnviarMensajeDto
    {
        public string ChatId { get; set; } = string.Empty;
        public string EmisorId { get; set; } = string.Empty;
        public string ReceptorId { get; set; } = string.Empty;
        public string Contenido { get; set; } = string.Empty;
    }
}