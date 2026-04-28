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

        public async Task<RegistroResultado> RegistrarHostAsync(RegistroHostDto dto)
        {
            if (dto.Aforo > 30)
            {
                return new RegistroResultado
                {
                    Exito = false,
                    Mensaje = "El aforo máximo en la versión gratuita es 30 personas"
                };
            }

            var premioMayor = new Premio
            {
                Nombre = dto.PremioMayor,
                Tipo = "creado",
                Motivo = "ranking"
            };

            await _premioRepository.InsertarAsync(premioMayor);

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

                if (flash.Id != null)
                {
                    idsFlash.Add(flash.Id);
                }
            }

            var codigoSala = GenerarCodigoUnico();

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
                Invitados = 1
            };

            await _salaRepository.InsertarAsync(sala);

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
                Verificado = true,
                DentroRadio = true,
                SalaId = sala.Id,
                Puntos = 0,
                Baneado = false
            };

            await _usuarioRepository.InsertarAsync(usuario);

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

        public async Task<RegistroResultado> RegistrarInvitadoAsync(RegistroInvitadoDto dto)
        {
            if (!dto.Verificado)
            {
                return new RegistroResultado
                {
                    Exito = false,
                    Mensaje = "La verificación facial no fue exitosa"
                };
            }

            var sala = await _salaRepository.ObtenerPorCodigoAsync(dto.CodigoSala);

            if (sala == null)
            {
                return new RegistroResultado
                {
                    Exito = false,
                    Mensaje = "Código de sala inválido"
                };
            }

            if (sala.Invitados >= sala.Aforo)
            {
                return new RegistroResultado
                {
                    Exito = false,
                    Mensaje = "La sala está llena"
                };
            }

            var distanciaKm = CalcularDistanciaKm(
                dto.Latitud,
                dto.Longitud,
                sala.Latitud,
                sala.Longitud
            );

            if (distanciaKm > 1.0)
            {
                return new RegistroResultado
                {
                    Exito = false,
                    Mensaje = $"Estás demasiado lejos de la sala ({distanciaKm:F2} km). Debes estar a menos de 1km"
                };
            }

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

                // Ya no bloqueamos por accuracy.
                // Si es <= 200m lo consideramos dentro de una precisión aceptable.
                Verificado = dto.Verificado,
                DentroRadio = dto.Accuracy <= 200,

                UltimaVerificacion = DateTime.UtcNow,
                SalaId = sala.Id,
                Puntos = 0,
                Baneado = false
            };

            await _usuarioRepository.InsertarAsync(usuario);

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

        private string GenerarCodigoUnico()
        {
            const string caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var random = new Random();

            return new string(
                Enumerable.Range(0, 6)
                    .Select(_ => caracteres[random.Next(caracteres.Length)])
                    .ToArray()
            );
        }

        private double CalcularDistanciaKm(
            double lat1,
            double lon1,
            double lat2,
            double lon2)
        {
            const double radioTierra = 6371;

            var dLat = ToRad(lat2 - lat1);
            var dLon = ToRad(lon2 - lon1);

            var a =
                Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
                Math.Cos(ToRad(lat1)) *
                Math.Cos(ToRad(lat2)) *
                Math.Sin(dLon / 2) *
                Math.Sin(dLon / 2);

            var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));

            return radioTierra * c;
        }

        private double ToRad(double grados)
        {
            return grados * Math.PI / 180;
        }
    }
}