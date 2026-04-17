using MongoDB.Driver;
using VooApi.Database;
using VooApi.Models;

namespace VooApi.Data 
{
    public class MensajeRepository
    {
        private readonly IMongoCollection<Mensaje> _collection;

        public MensajeRepository(MongoDbContext context, IConfiguration config)
        {
            var collectionName = config["MongoDB:CollectionName"] ?? "mensajes";
            _collection = context.GetCollection<Mensaje>(collectionName);
        }

        public async Task InsertarAsync(Mensaje mensaje)
        {
            await _collection.InsertOneAsync(mensaje);
        }

        public async Task<List<Mensaje>> ObtenerTodosAsync()
        {
            return await _collection.Find(_ => true).ToListAsync();
        }
    }
}