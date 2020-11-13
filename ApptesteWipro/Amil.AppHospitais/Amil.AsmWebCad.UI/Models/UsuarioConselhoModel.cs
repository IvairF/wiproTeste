using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Amil.AsmWebCad.UI.Models
{
    public class UsuarioConselhoModel
    {
        public int Id { get; set; }

        [Required]
        public string Conselho { get; set; }

        [Required]
        public string Estado { get; set; }

        [Required]
        public string Documento { get; set; }


        public int IdUsuario { get; set; }


        public bool FlgInterno { get; set; }
        
    }
}