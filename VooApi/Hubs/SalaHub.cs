using Microsoft.AspNetCore.SignalR;

namespace VooApi.Hubs
{
    public class SalaHub : Hub
    {
        public async Task JoinSala(string salaId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, salaId);
        }

        public async Task LeaveSala(string salaId)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, salaId);
        }

        public async Task JoinUsuario(string userId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, userId);
        }

        public async Task EnviarSolicitud(
            string fromUserId,
            string fromUserName,
            string targetUserId,
            string type,
            string content)
        {
            await Clients.Group(targetUserId).SendAsync("SolicitudRecibida", new
            {
                fromUserId,
                fromUserName,
                type,
                content
            });
        }
    }
}