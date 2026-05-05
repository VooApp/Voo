using VooApi.Models;
using VooApi.Data;

namespace VooApi.Services
{
    public class RetoService
    {
        private readonly RetoRepository _repository;
        private readonly RetoCompletadoRepository _completadoRepository;
        private readonly UsuarioRepository _usuarioRepository;

        public RetoService(
            RetoRepository repository,
            RetoCompletadoRepository completadoRepository,
            UsuarioRepository usuarioRepository)
        {
            _repository = repository;
            _completadoRepository = completadoRepository;
            _usuarioRepository = usuarioRepository;
        }

        public async Task<Reto> CrearAsync(Reto reto)
        {
            await _repository.InsertarAsync(reto);
            return reto;
        }

        public async Task<List<Reto>> ObtenerTodosAsync()
        {
            return await _repository.ObtenerTodosAsync();
        }

        public async Task<List<Reto>> ObtenerActivosAsync()
        {
            return await _repository.ObtenerActivosAsync();
        }

        public async Task<Reto?> ObtenerPorIdAsync(string id)
        {
            return await _repository.ObtenerPorIdAsync(id);
        }

        public async Task ActivarRetoAsync(string id)
        {
            await _repository.ActualizarEstadoAsync(id, "activo");
        }

        public async Task CompletarRetoAsync(string id)
        {
            await _repository.ActualizarEstadoAsync(id, "completado");
        }

        public async Task<object> ObtenerTimelineAsync(string usuarioId)
        {
            var retos = await _repository.ObtenerTodosAsync();
            var ahora = DateTime.UtcNow;

            var ordenados = retos
                .Where(r => r.HoraActivacion != null)
                .OrderBy(r => r.HoraActivacion)
                .ToList();

            Reto? activo = ordenados.FirstOrDefault(r =>
            {
                var inicio = r.HoraActivacion!.Value;
                var duracion = r.Duracion ?? TimeSpan.FromMinutes(30);
                return ahora >= inicio && ahora < inicio.Add(duracion);
            });

            Reto? anterior = ordenados
                .Where(r => r.HoraActivacion!.Value < ahora)
                .LastOrDefault(r => activo == null || r.Id != activo.Id);

            Reto? proximo = ordenados
                .Where(r => r.HoraActivacion!.Value > ahora)
                .FirstOrDefault();

            return new
            {
                anterior,
                activo,
                proximo,
                ahora
            };
        }

        public async Task<object> CompletarRetoActivoAsync(
            string usuarioId,
            string usuarioEscaneadoId)
        {
            if (usuarioId == usuarioEscaneadoId)
            {
                return new
                {
                    exito = false,
                    mensaje = "No puedes completar un reto escaneando tu propio QR."
                };
            }

            var timeline = await _repository.ObtenerTodosAsync();
            var ahora = DateTime.UtcNow;

            var retoActivo = timeline
                .Where(r => r.HoraActivacion != null)
                .FirstOrDefault(r =>
                {
                    var inicio = r.HoraActivacion!.Value;
                    var duracion = r.Duracion ?? TimeSpan.FromMinutes(30);
                    return ahora >= inicio && ahora < inicio.Add(duracion);
                });

            if (retoActivo == null || retoActivo.Id == null)
            {
                return new
                {
                    exito = false,
                    mensaje = "Ahora mismo no hay ningún reto activo."
                };
            }

            var yaCompletado = await _completadoRepository.YaCompletadoAsync(
                retoActivo.Id,
                usuarioId
            );

            if (yaCompletado)
            {
                return new
                {
                    exito = false,
                    mensaje = "Ya has completado el reto actual."
                };
            }

            await _completadoRepository.InsertarAsync(new RetoCompletado
            {
                RetoId = retoActivo.Id,
                UsuarioId = usuarioId,
                UsuarioEscaneadoId = usuarioEscaneadoId,
                FechaCompletado = DateTime.UtcNow
            });

            var usuario = await _usuarioRepository.ObtenerPorIdAsync(usuarioId);

            if (usuario != null)
            {
                usuario.Puntos += retoActivo.Puntos;

                usuario.NivelId = usuario.Puntos switch
                {
                    >= 150 => "rey",
                    >= 100 => "cupido",
                    >= 50 => "chismoso",
                    _ => "ninguno"
                };

                await _usuarioRepository.ActualizarPuntosAsync(
                    usuario.Id!,
                    usuario.Puntos,
                    usuario.NivelId
                );
            }

            return new
            {
                exito = true,
                mensaje = $"Reto completado. Has ganado +{retoActivo.Puntos} puntos.",
                puntosGanados = retoActivo.Puntos,
                reto = retoActivo
            };
        }
    }
}