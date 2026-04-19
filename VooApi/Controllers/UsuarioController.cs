using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;
using VooApi.Models;

namespace VooApi.Controllers;

[ApiController]
[Route("[controller]")]
public class UsuarioController : ControllerBase
{
    private readonly IMongoCollection<Usuario> _usuarios;

    public UsuarioController(IConfiguration config)
    {
        var client = new MongoClient(config["MongoDB:ConnectionString"]);
        var db = client.GetDatabase(config["MongoDB:DatabaseName"]);
        _usuarios = db.GetCollection<Usuario>("usuarios");
    }

    // Registrar usuario (host o invitado)
    [HttpPost]
    public async Task<IActionResult> Registrar([FromBody] Usuario usuario)
    {
        // Amazon Rekognition: por ahora lo marcamos como verificado directamente
        usuario.Verificado = true;

        await _usuarios.InsertOneAsync(usuario);
        return Ok(usuario);
    }

    // Obtener usuario por id
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(string id)
    {
        var usuario = await _usuarios.Find(u => u.Id == id).FirstOrDefaultAsync();
        if (usuario == null) return NotFound();
        return Ok(usuario);
    }

    // Obtener todos los usuarios de una sala
    [HttpGet("sala/{salaId}")]
    public async Task<IActionResult> GetBySala(string salaId)
    {
        var usuarios = await _usuarios.Find(u => u.SalaId == salaId && !u.Baneado).ToListAsync();
        return Ok(usuarios);
    }

    // Banear usuario
    [HttpPatch("{id}/banear")]
    public async Task<IActionResult> Banear(string id)
    {
        var update = Builders<Usuario>.Update.Set(u => u.Baneado, true);
        await _usuarios.UpdateOneAsync(u => u.Id == id, update);
        return Ok(new { mensaje = "Usuario baneado" });
    }

    // Sumar puntos
    [HttpPatch("{id}/puntos")]
    public async Task<IActionResult> SumarPuntos(string id, [FromBody] int puntos)
    {
        var update = Builders<Usuario>.Update.Inc(u => u.Puntos, puntos);
        await _usuarios.UpdateOneAsync(u => u.Id == id, update);
        return Ok(new { mensaje = "Puntos actualizados" });
    }

    // Eliminar usuario (al salir de sala)
    [HttpDelete("{id}")]
    public async Task<IActionResult> Eliminar(string id)
    {
        await _usuarios.DeleteOneAsync(u => u.Id == id);
        return Ok(new { mensaje = "Usuario eliminado" });
    }
}