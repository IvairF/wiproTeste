using Amil.AsmWebCad.UI.Resources;
using Amil.AsmWebCad.Utils;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Amil.AsmWebCad.UI.Models
{
    public class EsqueciSenhaModel
    {
        [Display(Name = "CPF"), Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
      StringLength(14, ErrorMessageResourceName = "AlertaLoginMax50", ErrorMessageResourceType = typeof(Resource))]
        public string Cpf { get; set; }

        public string Email { get; set; }

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            if (!Util.ValidarCPF(Cpf))
                yield return new ValidationResult(Resource.CpfInvalido);
        }
    }
}