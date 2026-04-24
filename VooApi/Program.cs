using VooApi.Database;
using VooApi.Data;
using VooApi.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
        policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());
});

// Base de datos
builder.Services.AddSingleton<MongoDbContext>();

// Repositories
builder.Services.AddScoped<UsuarioRepository>();
builder.Services.AddScoped<SalaRepository>();
builder.Services.AddScoped<RetoRepository>();
builder.Services.AddScoped<PremioRepository>();
builder.Services.AddScoped<PoderRepository>();
builder.Services.AddScoped<SolicitudRepository>();
builder.Services.AddScoped<ChatRepository>();
builder.Services.AddScoped<MensajeRepository>();

// Services (los crearemos ahora)
builder.Services.AddScoped<UsuarioService>();
builder.Services.AddScoped<SalaService>();
builder.Services.AddScoped<RetoService>();
builder.Services.AddScoped<PremioService>();
builder.Services.AddScoped<PoderService>();
builder.Services.AddScoped<SolicitudService>();
builder.Services.AddScoped<ChatService>();
builder.Services.AddScoped<MensajeService>();
// Después de los otros Services
builder.Services.AddScoped<RegistroService>();
var app = builder.Build();

app.UseCors();
app.UseHttpsRedirection();
app.MapControllers();
app.Run();