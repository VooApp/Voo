using MongoDB.Driver;
using VooApi.Database;
using VooApi.Models;

namespace VooApi.Data
{
    public class ChatRepository
    {
        private readonly IMongoCollection<Chat> _collection;

        public ChatRepository(MongoDbContext context)
        {
            _collection = context.GetCollection<Chat>("chats");
        }

        public async Task InsertarAsync(Chat chat)
        {
            await _collection.InsertOneAsync(chat);
        }

        public async Task<Chat?> ObtenerPorIdAsync(string id)
        {
            return await _collection.Find(c => c.Id == id).FirstOrDefaultAsync();
        }

        // Obtener el chat entre dos usuarios concretos
        public async Task<Chat?> ObtenerPorParticipantesAsync(string emisorId, string receptorId)
        {
            return await _collection.Find(c =>
                (c.EmisorId == emisorId && c.ReceptorId == receptorId) ||
                (c.EmisorId == receptorId && c.ReceptorId == emisorId)
            ).FirstOrDefaultAsync();
        }

        // Obtener todos los chats de un usuario
        public async Task<List<Chat>> ObtenerPorUsuarioAsync(string usuarioId)
        {
            return await _collection.Find(c =>
                c.EmisorId == usuarioId || c.ReceptorId == usuarioId
            ).ToListAsync();
        }

        // Desactivar un chat
        public async Task DesactivarAsync(string id)
        {
            var update = Builders<Chat>.Update.Set(c => c.Activo, false);
            await _collection.UpdateOneAsync(c => c.Id == id, update);
        }
    }
}