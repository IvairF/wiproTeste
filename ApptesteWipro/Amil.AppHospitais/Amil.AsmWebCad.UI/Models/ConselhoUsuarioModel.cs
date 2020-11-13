using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Amil.AsmWebCad.UI.Models
{
    public class ConselhoUsuarioModel
    {
        
        public int Id { get; set; }

        [Required]
        public int Conselho { get; set; }

        [Required]
        public int Estado { get; set; }

        [Required]
        public string Documento { get; set; }

        public bool flgInterno { get; set; }

    }
}