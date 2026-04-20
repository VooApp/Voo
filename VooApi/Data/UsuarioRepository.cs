using MongoDB.Driver;
using VooApi.Database;
using VooApi.Models;

namespace VooApi.Data
{
    public class UsuarioRepository
    {
        private readonly IMongoCollection<Usuario> _collection;

        public UsuarioRepository(MongoDbContext context)
        {
            _collection = context.GetCollection<Usuario>("usuarios");
        }

        public async Task InsertarAsync(Usuario usuario)
        {
            await _collection.InsertOneAsync(usuario);
        }

        public async Task<Usuario?> ObtenerPorIdAsync(string id)
        {
            return await _collection.Find(u => u.Id == id).FirstOrDefaultAsync();
        }

        public async Task<List<Usuario>> ObtenerTodosAsync()
        {
            return await _collection.Find(_ => true).ToListAsync();
        }

        // Obtener todos los usuarios de una sala
        public async Task<List<Usuario>> ObtenerPorSalaAsync(string salaId)
        {
            return await _collection.Find(u => u.SalaId == salaId).ToListAsync();
        }

        public async Task ActualizarAsync(string id, Usuario usuario)
        {
            await _collection.ReplaceOneAsync(u => u.Id == id, usuario);
        }

        // Actualizar solo puntos y nivel (para la lógica de poderes)
        public async Task ActualizarPuntosAsync(string id, int puntos, string nivelId)
        {
            var update = Builders<Usuario>.Update
                .Set(u => u.Puntos, puntos)
                .Set(u => u.NivelId, nivelId);
            await _collection.UpdateOneAsync(u => u.Id == id, update);
        }

        // Banear un usuario
        public async Task BanearAsync(string id)
        {
            var update = Builders<Usuario>.Update.Set(u => u.Baneado, true);
            await _collection.UpdateOneAsync(u => u.Id == id, update);
        }

        public async Task EliminarAsync(string id)
        {
            await _collection.DeleteOneAsync(u => u.Id == id);
        }
    }
}