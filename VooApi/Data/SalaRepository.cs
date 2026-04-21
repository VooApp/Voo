using MongoDB.Driver;
using VooApi.Database;
using VooApi.Models;

namespace VooApi.Data
{
    public class SalaRepository
    {
        private readonly IMongoCollection<Sala> _collection;

        public SalaRepository(MongoDbContext context)
        {
            _collection = context.GetCollection<Sala>("salas");
        }

        public async Task InsertarAsync(Sala sala)
        {
            await _collection.InsertOneAsync(sala);
        }

        public async Task<Sala?> ObtenerPorIdAsync(string id)
        {
            return await _collection.Find(s => s.Id == id).FirstOrDefaultAsync();
        }

        public async Task<List<Sala>> ObtenerTodosAsync()
        {
            return await _collection.Find(_ => true).ToListAsync();
        }

        // Obtener la sala de un host concreto
        public async Task<Sala?> ObtenerPorHostAsync(string hostId)
        {
            return await _collection.Find(s => s.HostId == hostId).FirstOrDefaultAsync();
        }

        public async Task ActualizarAsync(string id, Sala sala)
        {
            await _collection.ReplaceOneAsync(s => s.Id == id, sala);
        }

        // Cerrar sala (establecer fecha de fin)
        public async Task CerrarSalaAsync(string id)
        {
            var update = Builders<Sala>.Update.Set(s => s.FechaHoraFin, DateTime.UtcNow);
            await _collection.UpdateOneAsync(s => s.Id == id, update);
        }

        public async Task EliminarAsync(string id)
        {
            await _collection.DeleteOneAsync(s => s.Id == id);
        }
    }
}