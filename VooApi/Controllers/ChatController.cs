using Microsoft.AspNetCore.Mvc;
using VooApi.Models;
using VooApi.Services;

namespace VooApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ChatController : ControllerBase
    {
        private readonly ChatService _service;

        public ChatController(ChatService service)
        {
            _service = service;
        }

        [HttpPost]
        public async Task<IActionResult> Crear([FromBody] Chat chat)
        {
            var creado = await _service.CrearAsync(chat);
            return Ok(creado);
        }

        [HttpGet("usuario/{usuarioId}")]
        public async Task<IActionResult> ObtenerPorUsuario(string usuarioId)
        {
            var lista = await _service.ObtenerPorUsuarioAsync(usuarioId);
            return Ok(lista);
        }

        [HttpGet("participantes/{emisorId}/{receptorId}")]
        public async Task<IActionResult> ObtenerPorParticipantes(string emisorId, string receptorId)
        {
            var chat = await _service.ObtenerPorParticipantesAsync(emisorId, receptorId);
            if (chat == null) return NotFound();
            return Ok(chat);
        }

        [HttpPatch("{id}/desactivar")]
        public async Task<IActionResult> Desactivar(string id)
        {
            await _service.DesactivarAsync(id);
            return Ok(new { mensaje = "Chat desactivado" });
        }
    }
}