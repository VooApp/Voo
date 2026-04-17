using VooApi.Models;
using VooApi.Data;

namespace VooApi.Services
{
    public class MensajeService
    {
        private readonly MensajeRepository _repository;

        public MensajeService(MensajeRepository repository)
        {
            _repository = repository;
        }

        public async Task<Mensaje> GuardarAsync(Mensaje mensaje)
        {
            await _repository.InsertarAsync(mensaje);
            return mensaje;
        }

        public async Task<List<Mensaje>> ObtenerTodosAsync()
        {
            return await _repository.ObtenerTodosAsync();
        }
    }
}