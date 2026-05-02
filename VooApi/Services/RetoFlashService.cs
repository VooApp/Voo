using VooApi.Models;
using VooApi.Data;

namespace VooApi.Services
{
    public class RetoFlashService
    {
        private readonly UsuarioRepository _usuarioRepository;

        public RetoFlashService(UsuarioRepository usuarioRepository)
        {
            _usuarioRepository = usuarioRepository;
        }

        // Método principal: recibe el progreso y llama al verificador correcto
        public async Task<ResultadoReto> VerificarRetoAsync(ProgresoReto progreso)
        {
            return progreso.TipoReto switch
            {
                "misma_edad_mujer"            => await VerificarMismaEdadMujerAsync(progreso),
                "nombre_a"                    => await VerificarNombreAAsync(progreso),
                "verde_misma_edad"            => await VerificarVerdeMismaEdadAsync(progreso),
                "amarillo_2h_1m"              => await VerificarAmarillo2H1MAsync(progreso),
                "match_0pts"                  => await VerificarMatch0PtsAsync(progreso),
                "misma_edad_mismo_estado"     => await VerificarMismaEdadMismoEstadoAsync(progreso),
                "mismo_estado"                => await VerificarMismoEstadoAsync(progreso),
                "mas_joven"                   => await VerificarMasJovenAsync(progreso),
                "misma_edad_diferente_estado" => await VerificarMismaEdadDiferenteEstadoAsync(progreso),
                "cualquier_escaneo"           => await VerificarCualquierEscaneoAsync(progreso),
                _ => new ResultadoReto { Exito = false, Mensaje = "Tipo de reto desconocido" }
            };
        }

        // RETO 1: Escanea el QR de una chica que tenga tu misma edad
        // Comprueba: escaneado es mujer + misma edad
        private async Task<ResultadoReto> VerificarMismaEdadMujerAsync(ProgresoReto progreso)
        {
            var usuario = await _usuarioRepository.ObtenerPorIdAsync(progreso.UsuarioId);
            if (usuario == null) return Error("Usuario no encontrado");

            var escaneado = await _usuarioRepository.ObtenerPorIdAsync(progreso.EscaneadosIds[0]);
            if (escaneado == null) return Error("Usuario escaneado no encontrado");

            int edadUsuario = CalcularEdad(usuario.FechaNacimiento);
            int edadEscaneado = CalcularEdad(escaneado.FechaNacimiento);

            if (escaneado.Sexo)
                return Error("El usuario escaneado no es mujer");

            if (edadUsuario != edadEscaneado)
                return Error($"Las edades no coinciden. Tú tienes {edadUsuario} años y el escaneado tiene {edadEscaneado}");

            await SumarPuntosFlashAsync(usuario, 30);
            return Exito("¡Reto completado! +30 puntos");
        }

        // RETO 2: Escanea el QR de 3 personas cuyo nombre empiece por A
        // Comprueba: los 3 nombres empiezan por "A"
        private async Task<ResultadoReto> VerificarNombreAAsync(ProgresoReto progreso)
        {
            var usuario = await _usuarioRepository.ObtenerPorIdAsync(progreso.UsuarioId);
            if (usuario == null) return Error("Usuario no encontrado");

            if (progreso.EscaneadosIds.Count != 3)
                return Error("Necesitas escanear exactamente 3 personas");

            foreach (var id in progreso.EscaneadosIds)
            {
                var escaneado = await _usuarioRepository.ObtenerPorIdAsync(id);
                if (escaneado == null) return Error("Uno de los usuarios escaneados no existe");

                if (!escaneado.Nombre.StartsWith("A", StringComparison.OrdinalIgnoreCase))
                    return Error($"{escaneado.Nombre} no empieza por la letra A");
            }

            await SumarPuntosFlashAsync(usuario, 30);
            return Exito("¡Reto completado! +30 puntos");
        }

        // RETO 3: Encuentra el QR de un chico con estado verde que tenga tu edad
        // Comprueba: escaneado es hombre + estado verde + misma edad
        private async Task<ResultadoReto> VerificarVerdeMismaEdadAsync(ProgresoReto progreso)
        {
            var usuario = await _usuarioRepository.ObtenerPorIdAsync(progreso.UsuarioId);
            if (usuario == null) return Error("Usuario no encontrado");

            var escaneado = await _usuarioRepository.ObtenerPorIdAsync(progreso.EscaneadosIds[0]);
            if (escaneado == null) return Error("Usuario escaneado no encontrado");

            if (!escaneado.Sexo)
                return Error("El usuario escaneado no es hombre");

            if (escaneado.Estado != "verde")
                return Error("El usuario escaneado no está en estado verde (soltero)");

            int edadUsuario = CalcularEdad(usuario.FechaNacimiento);
            int edadEscaneado = CalcularEdad(escaneado.FechaNacimiento);

            if (edadUsuario != edadEscaneado)
                return Error($"Las edades no coinciden. Tú tienes {edadUsuario} años y el escaneado tiene {edadEscaneado}");

            await SumarPuntosFlashAsync(usuario, 30);
            return Exito("¡Reto completado! +30 puntos");
        }

        // RETO 4: Escanea el QR de 2 chicos y una chica con estado amarillo
        // Comprueba: 2 hombres + 1 mujer + los 3 en estado amarillo
        private async Task<ResultadoReto> VerificarAmarillo2H1MAsync(ProgresoReto progreso)
        {
            var usuario = await _usuarioRepository.ObtenerPorIdAsync(progreso.UsuarioId);
            if (usuario == null) return Error("Usuario no encontrado");

            if (progreso.EscaneadosIds.Count != 3)
                return Error("Necesitas escanear exactamente 3 personas");

            var escaneados = new List<Usuario>();
            foreach (var id in progreso.EscaneadosIds)
            {
                var escaneado = await _usuarioRepository.ObtenerPorIdAsync(id);
                if (escaneado == null) return Error("Uno de los usuarios escaneados no existe");
                if (escaneado.Estado != "amarillo")
                    return Error($"{escaneado.Nombre} no está en estado amarillo");
                escaneados.Add(escaneado);
            }

            int hombres = escaneados.Count(e => e.Sexo);
            int mujeres = escaneados.Count(e => !e.Sexo);

            if (hombres != 2 || mujeres != 1)
                return Error($"Necesitas 2 chicos y 1 chica. Tienes {hombres} chicos y {mujeres} chicas");

            await SumarPuntosFlashAsync(usuario, 30);
            return Exito("¡Reto completado! +30 puntos");
        }

        // RETO 5: Haz match con alguien que tenga 0 puntos
        // Comprueba: existe solicitud aceptada entre ambos + escaneado tiene 0 puntos
        private async Task<ResultadoReto> VerificarMatch0PtsAsync(ProgresoReto progreso)
        {
            var usuario = await _usuarioRepository.ObtenerPorIdAsync(progreso.UsuarioId);
            if (usuario == null) return Error("Usuario no encontrado");

            var escaneado = await _usuarioRepository.ObtenerPorIdAsync(progreso.EscaneadosIds[0]);
            if (escaneado == null) return Error("Usuario escaneado no encontrado");

            if (escaneado.Puntos != 0)
                return Error($"{escaneado.Nombre} tiene {escaneado.Puntos} puntos, necesita tener 0");

            await SumarPuntosFlashAsync(usuario, 30);
            return Exito("¡Reto completado! +30 puntos");
        }

        // RETO 6: Escanea el QR de alguien con tu misma edad y mismo estado
        // Comprueba: misma edad + mismo estado
        private async Task<ResultadoReto> VerificarMismaEdadMismoEstadoAsync(ProgresoReto progreso)
        {
            var usuario = await _usuarioRepository.ObtenerPorIdAsync(progreso.UsuarioId);
            if (usuario == null) return Error("Usuario no encontrado");

            var escaneado = await _usuarioRepository.ObtenerPorIdAsync(progreso.EscaneadosIds[0]);
            if (escaneado == null) return Error("Usuario escaneado no encontrado");

            int edadUsuario = CalcularEdad(usuario.FechaNacimiento);
            int edadEscaneado = CalcularEdad(escaneado.FechaNacimiento);

            if (edadUsuario != edadEscaneado)
                return Error($"Las edades no coinciden. Tú tienes {edadUsuario} y el escaneado tiene {edadEscaneado}");

            if (usuario.Estado != escaneado.Estado)
                return Error($"Los estados no coinciden. Tú estás en {usuario.Estado} y el escaneado en {escaneado.Estado}");

            await SumarPuntosFlashAsync(usuario, 30);
            return Exito("¡Reto completado! +30 puntos");
        }

        // RETO 7: Escanea el QR de 2 personas con tu mismo estado
        // Comprueba: los 2 escaneados tienen el mismo estado que el usuario
        private async Task<ResultadoReto> VerificarMismoEstadoAsync(ProgresoReto progreso)
        {
            var usuario = await _usuarioRepository.ObtenerPorIdAsync(progreso.UsuarioId);
            if (usuario == null) return Error("Usuario no encontrado");

            if (progreso.EscaneadosIds.Count != 2)
                return Error("Necesitas escanear exactamente 2 personas");

            foreach (var id in progreso.EscaneadosIds)
            {
                var escaneado = await _usuarioRepository.ObtenerPorIdAsync(id);
                if (escaneado == null) return Error("Uno de los usuarios escaneados no existe");

                if (escaneado.Estado != usuario.Estado)
                    return Error($"{escaneado.Nombre} no tiene tu mismo estado");
            }

            await SumarPuntosFlashAsync(usuario, 30);
            return Exito("¡Reto completado! +30 puntos");
        }

        // RETO 8: Escanea el QR de la persona más joven del evento
        // Comprueba: el escaneado tiene la fecha de nacimiento más reciente de la sala
        private async Task<ResultadoReto> VerificarMasJovenAsync(ProgresoReto progreso)
        {
            var usuario = await _usuarioRepository.ObtenerPorIdAsync(progreso.UsuarioId);
            if (usuario == null) return Error("Usuario no encontrado");

            var escaneado = await _usuarioRepository.ObtenerPorIdAsync(progreso.EscaneadosIds[0]);
            if (escaneado == null) return Error("Usuario escaneado no encontrado");

            // Obtenemos todos los usuarios de la sala
            var usuariosSala = await _usuarioRepository.ObtenerPorSalaAsync(progreso.SalaId);

            // La fecha de nacimiento más reciente = la persona más joven
            var fechaMasReciente = usuariosSala.Max(u => u.FechaNacimiento);

            if (escaneado.FechaNacimiento != fechaMasReciente)
                return Error("Este usuario no es el más joven de la sala");

            await SumarPuntosFlashAsync(usuario, 30);
            return Exito("¡Reto completado! +30 puntos");
        }

        // RETO 9: Escanea el QR de alguien con tu misma edad pero estado diferente
        // Comprueba: misma edad + estado diferente
        private async Task<ResultadoReto> VerificarMismaEdadDiferenteEstadoAsync(ProgresoReto progreso)
        {
            var usuario = await _usuarioRepository.ObtenerPorIdAsync(progreso.UsuarioId);
            if (usuario == null) return Error("Usuario no encontrado");

            var escaneado = await _usuarioRepository.ObtenerPorIdAsync(progreso.EscaneadosIds[0]);
            if (escaneado == null) return Error("Usuario escaneado no encontrado");

            int edadUsuario = CalcularEdad(usuario.FechaNacimiento);
            int edadEscaneado = CalcularEdad(escaneado.FechaNacimiento);

            if (edadUsuario != edadEscaneado)
                return Error($"Las edades no coinciden. Tú tienes {edadUsuario} y el escaneado tiene {edadEscaneado}");

            if (usuario.Estado == escaneado.Estado)
                return Error("El estado debe ser diferente al tuyo");

            await SumarPuntosFlashAsync(usuario, 30);
            return Exito("¡Reto completado! +30 puntos");
        }

        // RETO 10: Escanea el QR de un invitado que te guste
        // Acepta cualquier escaneo válido dentro de la sala
        private async Task<ResultadoReto> VerificarCualquierEscaneoAsync(ProgresoReto progreso)
        {
            var usuario = await _usuarioRepository.ObtenerPorIdAsync(progreso.UsuarioId);
            if (usuario == null) return Error("Usuario no encontrado");

            var escaneado = await _usuarioRepository.ObtenerPorIdAsync(progreso.EscaneadosIds[0]);
            if (escaneado == null) return Error("Usuario escaneado no encontrado");

            // Solo comprobamos que el escaneado esté en la misma sala
            if (escaneado.SalaId != progreso.SalaId)
                return Error("El usuario escaneado no está en tu sala");

            await SumarPuntosFlashAsync(usuario, 30);
            return Exito("¡Reto completado! +30 puntos");
        }

        // ─── HELPERS ─────────────────────────────────────────────────

        // Calcula la edad en años a partir de la fecha de nacimiento
        private int CalcularEdad(DateTime fechaNacimiento)
        {
            var hoy = DateTime.UtcNow;
            int edad = hoy.Year - fechaNacimiento.Year;
            if (fechaNacimiento.Date > hoy.AddYears(-edad)) edad--;
            return edad;
        }

        // Suma 30 puntos al usuario y actualiza su poder si corresponde
        private async Task SumarPuntosFlashAsync(Usuario usuario, int puntos)
        {
            usuario.Puntos += puntos;
            usuario.NivelId = usuario.Puntos switch
            {
                >= 150 => "rey",
                >= 100 => "cupido",
                >= 50  => "chismoso",
                _      => "ninguno"
            };
            await _usuarioRepository.ActualizarPuntosAsync(
                usuario.Id!, usuario.Puntos, usuario.NivelId);
        }

        // Helpers para construir respuestas
        private ResultadoReto Exito(string mensaje) =>
            new ResultadoReto { Exito = true, Mensaje = mensaje };

        private ResultadoReto Error(string mensaje) =>
            new ResultadoReto { Exito = false, Mensaje = mensaje };
    }
}