using VooApi.Models;
using VooApi.Data;

namespace VooApi.Services
{
    public class SalaService
    {
        private readonly SalaRepository _repository;

        public SalaService(SalaRepository repository)
        {
            _repository = repository;
        }

        public async Task<Sala> CrearAsync(Sala sala)
        {
            await _repository.InsertarAsync(sala);
            return sala;
        }

        public async Task<Sala?> ObtenerPorIdAsync(string id)
        {
            return await _repository.ObtenerPorIdAsync(id);
        }

        public async Task<Sala?> ObtenerPorHostAsync(string hostId)
        {
            return await _repository.ObtenerPorHostAsync(hostId);
        }

        public async Task CerrarSalaAsync(string id)
        {
            await _repository.CerrarSalaAsync(id);
        }

        public async Task ActualizarAsync(string id, Sala sala)
        {
            await _repository.ActualizarAsync(id, sala);
        }

        public async Task EliminarAsync(string id)
        {
            await _repository.EliminarAsync(id);
        }
    }
}