using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Html;

namespace Amil.AsmWebCad.UI.Models
{
    //[Bind(Exclude = "Id")]
    
    public class ConvenioViewModel
    {
        [Key]
        public int Id { get; set; }
        [Required(ErrorMessage = "O Campo Nome é obrigatório!")]
        public string Nome { get; set; }
        [Required(ErrorMessage = "O Campo Nome Abreviado é obrigatório!")]
        public string NomeAbreviado { get; set; }
        public int RegistroANS { get; set; }
        public int CodCorporativo { get; set; }
        public bool isElegibilidade { get; set; }
        public bool isAtivo { get; set; }
        public int TipoConvenio { get; set; }
    }
}