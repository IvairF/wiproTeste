using Amil.AsmWebCad.UI.Resources;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Amil.AsmWebCad.UI.Models
{
    public class UsuarioPerfilModel
    {
        public int Id { get; set; }

        public string DescricaoPerfil { get; set; }

        public string Sistema { get; set; }

        public string CodigoPerfil { get; set; }

        public IList<UsuarioModel> ListaUsuarios { get; set; }

    }
}