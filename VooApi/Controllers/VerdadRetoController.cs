using Microsoft.AspNetCore.Mvc;
using VooApi.Models;
using VooApi.Services;

namespace VooApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VerdadRetoController : ControllerBase
    {
        private readonly VerdadRetoService _service;

        public VerdadRetoController(VerdadRetoService service)
        {
            _service = service;
        }

        // GET /verdadreto/obtener
        [HttpGet("obtener")]
        public IActionResult ObtenerVerdadYReto()
        {
            var resultado = _service.ObtenerVerdadYReto();
            return Ok(resultado);
        }

        // POST /verdadreto/aceptar/{solicitudId}
        // Acepta la solicitud, crea el chat y manda el primer mensaje
        [HttpPost("aceptar/{solicitudId}")]
        public async Task<IActionResult> Aceptar(string solicitudId)
        {
            var resultado = await _service.AceptarSolicitudAsync(solicitudId);
            if (!resultado.Exito)
                return BadRequest(new { mensaje = resultado.Mensaje });

            return Ok(new
            {
                mensaje = resultado.Mensaje,
                puntosGanados = resultado.PuntosGanados,
                chatId = resultado.ChatId,
                primerMensaje = resultado.PrimerMensaje
            });
        }

        // POST /verdadreto/rechazar/{solicitudId}
        // Rechaza la solicitud
        [HttpPost("rechazar/{solicitudId}")]
        public async Task<IActionResult> Rechazar(string solicitudId)
        {
            var resultado = await _service.RechazarSolicitudAsync(solicitudId);
            if (!resultado.Exito)
                return BadRequest(new { mensaje = resultado.Mensaje });

            return Ok(new { mensaje = resultado.Mensaje });
        }
    }
}