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

        // GET /chat/usuario/{usuarioId}
        // Flutter llama a esto para mostrar la lista de chats
        [HttpGet("usuario/{usuarioId}")]
        public async Task<IActionResult> ObtenerChats(string usuarioId)
        {
            var chats = await _service.ObtenerChatsDeUsuarioAsync(usuarioId);
            return Ok(chats);
        }

        // GET /chat/{chatId}/mensajes/{usuarioId}
        // Flutter llama a esto cuando abre un chat
        // También marca los mensajes como leídos automáticamente
        [HttpGet("{chatId}/mensajes/{usuarioId}")]
        public async Task<IActionResult> ObtenerMensajes(string chatId, string usuarioId)
        {
            var mensajes = await _service.ObtenerMensajesAsync(chatId, usuarioId);
            return Ok(mensajes);
        }

        // POST /chat/mensaje
        // Flutter llama a esto cuando el usuario envía un mensaje
        [HttpPost("mensaje")]
        public async Task<IActionResult> EnviarMensaje([FromBody] EnviarMensajeDto dto)
        {
            var resultado = await _service.EnviarMensajeAsync(dto);
            if (!resultado.Exito)
                return BadRequest(new { mensaje = resultado.Mensaje });

            return Ok(new
            {
                mensaje = resultado.Mensaje,
                mensajeEnviado = resultado.MensajeEnviado
            });
        }

        // PATCH /chat/{chatId}/desactivar
        [HttpPatch("{chatId}/desactivar")]
        public async Task<IActionResult> Desactivar(string chatId)
        {
            await _service.DesactivarChatAsync(chatId);
            return Ok(new { mensaje = "Chat desactivado" });
        }
    }
}