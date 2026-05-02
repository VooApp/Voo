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
    }
}