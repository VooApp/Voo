using VooApi.Models;
using VooApi.Data;

namespace VooApi.Services
{
    public class UsuarioService
    {
        private readonly UsuarioRepository _repository;

        public UsuarioService(UsuarioRepository repository)
        {
            _repository = repository;
        }

        public async Task<SumarPuntosResultado?> SumarPuntosAsync(string id, int puntosASumar)
        {
            var usuario = await _repository.ObtenerPorIdAsync(id);
            if (usuario == null) return null;

            var poderAnterior = usuario.NivelId ?? "ninguno";

            usuario.Puntos += puntosASumar;

            var poderNuevo = usuario.Puntos switch
            {
                >= 200 => "rey",
                >= 100 => "cupido",
                >= 50  => "chismoso",
                _      => "ninguno"
            };

            usuario.NivelId = poderNuevo;

            var esPoderNuevo = poderAnterior != poderNuevo;

            await _repository.ActualizarPuntosAsync(id, usuario.Puntos, usuario.NivelId);

            return new SumarPuntosResultado
            {
                Usuario = usuario,
                PoderDesbloqueado = esPoderNuevo,
                NuevoPoder = esPoderNuevo ? poderNuevo : null
            };
        }

        public async Task<Usuario> CrearAsync(Usuario usuario)
        {
            await _repository.InsertarAsync(usuario);
            return usuario;
        }

        public async Task<List<Usuario>> ObtenerTodosAsync()
        {
            return await _repository.ObtenerTodosAsync();
        }

        public async Task<Usuario?> ObtenerPorIdAsync(string id)
        {
            return await _repository.ObtenerPorIdAsync(id);
        }

        public async Task<List<Usuario>> ObtenerPorSalaAsync(string salaId)
        {
            return await _repository.ObtenerPorSalaAsync(salaId);
        }

        public async Task BanearAsync(string id)
        {
            await _repository.BanearAsync(id);
        }

        public async Task ActualizarAsync(string id, Usuario usuario)
        {
            await _repository.ActualizarAsync(id, usuario);
        }
    }
}