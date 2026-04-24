using VooApi.Models;
using VooApi.Data;

namespace VooApi.Services
{
    public class RegistroService
    {
        private readonly UsuarioRepository _usuarioRepository;
        private readonly SalaRepository _salaRepository;
        private readonly PremioRepository _premioRepository;

        public RegistroService(
            UsuarioRepository usuarioRepository,
            SalaRepository salaRepository,
            PremioRepository premioRepository)
        {
            _usuarioRepository = usuarioRepository;
            _salaRepository = salaRepository;
            _premioRepository = premioRepository;
        }

        // ─── REGISTRO HOST ───────────────────────────────────────────
        public async Task<RegistroResultado> RegistrarHostAsync(RegistroHostDto dto)
        {
            // 1. Validar aforo — demo solo permite hasta 30
            if (dto.Aforo > 30)
            {
                return new RegistroResultado
                {
                    Exito = false,
                    Mensaje = "El aforo máximo en la versión gratuita es 30 personas"
                };
            }

            // 2. Crear el premio mayor en MongoDB
            var premioMayor = new Premio
            {
                Nombre = dto.PremioMayor,
                Tipo = "creado",
                Motivo = "ranking"
            };
            await _premioRepository.InsertarAsync(premioMayor);

            // 3. Crear premios flash si los hay
            var idsFlash = new List<string>();
            foreach (var nombreFlash in dto.PremiosFlash)
            {
                var flash = new Premio
                {
                    Nombre = nombreFlash,
                    Tipo = "creado",
                    Motivo = "reto"
                };
                await _premioRepository.InsertarAsync(flash);
                if (flash.Id != null) idsFlash.Add(flash.Id);
            }

            // 4. Generar código único de 6 caracteres para la sala
            var codigoSala = GenerarCodigoUnico();

            // 5. Crear la sala
            var sala = new Sala
            {
                Nombre = dto.NombreSala,
                Contexto = dto.Contexto,
                Aforo = dto.Aforo,
                Direccion = dto.Direccion,
                CodigoPostal = dto.CodigoPostal,
                Latitud = dto.LatitudSala,
                Longitud = dto.LongitudSala,
                CodigoSala = codigoSala,
                Premios = premioMayor.Id != null
                    ? new List<string> { premioMayor.Id }.Concat(idsFlash).ToList()
                    : idsFlash,
                Invitados = 1  // el host cuenta como invitado
            };
            await _salaRepository.InsertarAsync(sala);

            // 6. Crear el usuario host
            var usuario = new Usuario
            {
                Tipo = "host",
                Nombre = dto.Nombre,
                Sexo = dto.Sexo,
                FechaNacimiento = dto.FechaNacimiento,
                Foto = dto.Foto,
                Ig = dto.Ig,
                Estado = dto.Estado,
                Respuestas = dto.Respuestas,
                Verificado = true,   // el host no necesita verificación facial
                DentroRadio = true,  // el host está en la sala por definición
                SalaId = sala.Id,
                Puntos = 0,
                Baneado = false
            };
            await _usuarioRepository.InsertarAsync(usuario);

            // 7. Asignar el host a la sala
            sala.HostId = usuario.Id!;
            await _salaRepository.ActualizarAsync(sala.Id!, sala);

            return new RegistroResultado
            {
                Exito = true,
                Usuario = usuario,
                Sala = sala,
                Mensaje = $"Sala creada correctamente. Código: {codigoSala}"
            };
        }

        // ─── REGISTRO INVITADO ───────────────────────────────────────
        public async Task<RegistroResultado> RegistrarInvitadoAsync(RegistroInvitadoDto dto)
        {
            // 1. Comprobar verificación facial
            if (!dto.Verificado)
            {
                return new RegistroResultado
                {
                    Exito = false,
                    Mensaje = "La verificación facial no fue exitosa"
                };
            }

            // 2. Comprobar precisión del GPS
            // Si accuracy es mayor de 50 metros, la ubicación no es fiable
            if (dto.Accuracy > 50)
            {
                return new RegistroResultado
                {
                    Exito = false,
                    Mensaje = "La ubicación no es suficientemente precisa. Intenta en otro lugar"
                };
            }

            // 3. Buscar la sala por el código
            var sala = await _salaRepository.ObtenerPorCodigoAsync(dto.CodigoSala);
            if (sala == null)
            {
                return new RegistroResultado
                {
                    Exito = false,
                    Mensaje = "Código de sala inválido"
                };
            }

            // 4. Comprobar que la sala no está llena
            if (sala.Invitados >= sala.Aforo)
            {
                return new RegistroResultado
                {
                    Exito = false,
                    Mensaje = "La sala está llena"
                };
            }

            // 5. Calcular distancia entre invitado y sala
            var distanciaKm = CalcularDistanciaKm(
                dto.Latitud, dto.Longitud,
                sala.Latitud, sala.Longitud
            );

            if (distanciaKm > 1.0)
            {
                return new RegistroResultado
                {
                    Exito = false,
                    Mensaje = $"Estás demasiado lejos de la sala ({distanciaKm:F2} km). Debes estar a menos de 1km"
                };
            }

            // 6. Crear el usuario invitado
            var usuario = new Usuario
            {
                Tipo = "invited",
                Nombre = dto.Nombre,
                Sexo = dto.Sexo,
                FechaNacimiento = dto.FechaNacimiento,
                Foto = dto.Foto,
                Ig = dto.Ig,
                Estado = dto.Estado,
                Respuestas = dto.Respuestas,
                Verificado = dto.Verificado,
                DentroRadio = true,
                UltimaVerificacion = DateTime.UtcNow,
                SalaId = sala.Id,
                Puntos = 0,
                Baneado = false
            };
            await _usuarioRepository.InsertarAsync(usuario);

            // 7. Incrementar el contador de invitados en la sala
            sala.Invitados += 1;
            await _salaRepository.ActualizarAsync(sala.Id!, sala);

            return new RegistroResultado
            {
                Exito = true,
                Usuario = usuario,
                Sala = sala,
                Mensaje = "Te has unido a la sala correctamente"
            };
        }

        // ─── HELPERS ─────────────────────────────────────────────────

        // Genera un código único de 6 caracteres alfanumérico
        // Ejemplo: "CV7624"
        private string GenerarCodigoUnico()
        {
            const string caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var random = new Random();
            return new string(Enumerable.Range(0, 6)
                .Select(_ => caracteres[random.Next(caracteres.Length)])
                .ToArray());
        }

        // Calcula la distancia en km entre dos coordenadas GPS
        // Usa la fórmula de Haversine, que tiene en cuenta la curvatura de la Tierra
        private double CalcularDistanciaKm(double lat1, double lon1, double lat2, double lon2)
        {
            const double radioTierra = 6371; // km

            var dLat = ToRad(lat2 - lat1);
            var dLon = ToRad(lon2 - lon1);

            var a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
                    Math.Cos(ToRad(lat1)) * Math.Cos(ToRad(lat2)) *
                    Math.Sin(dLon / 2) * Math.Sin(dLon / 2);

            var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));

            return radioTierra * c;
        }

        private double ToRad(double grados) => grados * Math.PI / 180;
    }
}