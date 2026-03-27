using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;

namespace VooApi.Controllers;

public class Mensaje
{
    public string? Id { get; set; }
    public string? Texto { get; set; }
    public DateTime FechaCreacion { get; set; } = DateTime.UtcNow;
}

[ApiController]
[Route("[controller]")]
public class MensajeController : ControllerBase
{
    private readonly IMongoCollection<Mensaje> _mensajes;

    public MensajeController(IConfiguration config)
    {
        var client = new MongoClient(config["MongoDB:ConnectionString"]);
        var db = client.GetDatabase(config["MongoDB:DatabaseName"]);
        _mensajes = db.GetCollection<Mensaje>(config["MongoDB:CollectionName"]);
    }

    [HttpPost]
    public async Task<IActionResult> Post([FromBody] Mensaje mensaje)
    {
        await _mensajes.InsertOneAsync(mensaje);
        return Ok(new { mensaje = "Guardado correctamente", data = mensaje });
    }

    [HttpGet]
    public async Task<IActionResult> Get()
    {
        var lista = await _mensajes.Find(_ => true).ToListAsync();
        return Ok(lista);
    }
}