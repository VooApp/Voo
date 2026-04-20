using VooApi.Models;
using VooApi.Data;

namespace VooApi.Services
{
    public class ChatService
    {
        private readonly ChatRepository _repository;

        public ChatService(ChatRepository repository)
        {
            _repository = repository;
        }

        public async Task<Chat> CrearAsync(Chat chat)
        {
            await _repository.InsertarAsync(chat);
            return chat;
        }

        public async Task<Chat?> ObtenerPorParticipantesAsync(string emisorId, string receptorId)
        {
            return await _repository.ObtenerPorParticipantesAsync(emisorId, receptorId);
        }

        public async Task<List<Chat>> ObtenerPorUsuarioAsync(string usuarioId)
        {
            return await _repository.ObtenerPorUsuarioAsync(usuarioId);
        }

        public async Task DesactivarAsync(string id)
        {
            await _repository.DesactivarAsync(id);
        }
    }
}