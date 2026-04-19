using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;
using VooApi.Models;

namespace VooApi.Controllers;

[ApiController]
[Route("[controller]")]
public class SalaController : ControllerBase
{
    private readonly IMongoCollection<Sala> _salas;
    private readonly IMongoCollection<Usuario> _usuarios;

    public SalaController(IConfiguration config)
    {
        var client = new MongoClient(config["MongoDB:ConnectionString"]);
        var db = client.GetDatabase(config["MongoDB:DatabaseName"]);
        _salas = db.GetCollection<Sala>("salas");
        _usuarios = db.GetCollection<Usuario>("usuarios");
    }

    // Crear sala
    [HttpPost]
    public async Task<IActionResult> CrearSala([FromBody] Sala sala)
    {
        // Generar código único de 6 caracteres
        sala.CodigoSala = GenerarCodigo();
        sala.Activa = true;

        await _salas.InsertOneAsync(sala);

        // Marcar al host como EsHost y asignarle la sala
        var update = Builders<Usuario>.Update
            .Set(u => u.SalaId, sala.Id)
            .Set(u => u.EsHost, true);
        await _usuarios.UpdateOneAsync(u => u.Id == sala.HostId, update);

        return Ok(sala);
    }

    // Unirse a sala por código
    [HttpPost("{codigo}/unirse")]
    public async Task<IActionResult> UnirseSala(string codigo, [FromBody] string usuarioId)
    {
        var sala = await _salas.Find(s => s.CodigoSala == codigo && s.Activa).FirstOrDefaultAsync();
        if (sala == null) return NotFound(new { mensaje = "Sala no encontrada o inactiva" });

        // Añadir invitado a la sala
        var updateSala = Builders<Sala>.Update.AddToSet(s => s.InvitadosIds, usuarioId);
        await _salas.UpdateOneAsync(s => s.Id == sala.Id, updateSala);

        // Asignar salaId al usuario
        var updateUsuario = Builders<Usuario>.Update.Set(u => u.SalaId, sala.Id);
        await _usuarios.UpdateOneAsync(u => u.Id == usuarioId, updateUsuario);

        return Ok(sala);
    }

    // Obtener sala por código
    [HttpGet("{codigo}")]
    public async Task<IActionResult> GetByCodigo(string codigo)
    {
        var sala = await _salas.Find(s => s.CodigoSala == codigo).FirstOrDefaultAsync();
        if (sala == null) return NotFound();
        return Ok(sala);
    }

    // Cerrar sala (elimina sala y todos sus usuarios)
    [HttpDelete("{id}")]
    public async Task<IActionResult> CerrarSala(string id)
    {
        var sala = await _salas.Find(s => s.Id == id).FirstOrDefaultAsync();
        if (sala == null) return NotFound();

        // Eliminar todos los usuarios de la sala
        await _usuarios.DeleteManyAsync(u => u.SalaId == id);

        // Eliminar la sala
        await _salas.DeleteOneAsync(s => s.Id == id);

        return Ok(new { mensaje = "Sala cerrada y datos eliminados" });
    }

    private static string GenerarCodigo()
    {
        const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        var random = new Random();
        return new string(Enumerable.Repeat(chars, 6)
            .Select(s => s[random.Next(s.Length)]).ToArray());
    }
}