using VooApi.Models;
using VooApi.Data;

namespace VooApi.Services
{
    public class RetoService
    {
        private readonly RetoRepository _repository;

        public RetoService(RetoRepository repository)
        {
            _repository = repository;
        }

        public async Task<Reto> CrearAsync(Reto reto)
        {
            await _repository.InsertarAsync(reto);
            return reto;
        }

        public async Task<List<Reto>> ObtenerTodosAsync()
        {
            return await _repository.ObtenerTodosAsync();
        }

        public async Task<List<Reto>> ObtenerActivosAsync()
        {
            return await _repository.ObtenerActivosAsync();
        }

        public async Task<Reto?> ObtenerPorIdAsync(string id)
        {
            return await _repository.ObtenerPorIdAsync(id);
        }

        public async Task ActivarRetoAsync(string id)
        {
            await _repository.ActualizarEstadoAsync(id, "activo");
        }

        public async Task CompletarRetoAsync(string id)
        {
            await _repository.ActualizarEstadoAsync(id, "completado");
        }
    }
}