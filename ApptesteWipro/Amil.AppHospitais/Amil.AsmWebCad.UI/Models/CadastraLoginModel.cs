using Amil.AsmWebCad.UI.Resources;
using Amil.AsmWebCad.Utils;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Amil.AsmWebCad.UI.Models
{
    public class CadastraLoginModel
    {
        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
      StringLength(60, ErrorMessageResourceName = "AlertaLoginMax50", ErrorMessageResourceType = typeof(Resource))]
        public string Nome { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(50, ErrorMessageResourceName = "AlertaLoginMax50", ErrorMessageResourceType = typeof(Resource))]
        public string Email { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(50, ErrorMessageResourceName = "AlertaLoginMax50", ErrorMessageResourceType = typeof(Resource))]
        public string ConfirmaEmail { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(50, ErrorMessageResourceName = "AlertaSenhaMax10", ErrorMessageResourceType = typeof(Resource))]
        public string Senha { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(50, ErrorMessageResourceName = "AlertaSenhaMax10", ErrorMessageResourceType = typeof(Resource))]
        public string ConfirmaSenha { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(50, ErrorMessageResourceName = "AlertaSenhaMax10", ErrorMessageResourceType = typeof(Resource))]
        public string Conselho { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource))]
        public string UF { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource))]
        public string TipoConselho { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(14, ErrorMessageResourceName = "AlertaSenhaMax10", ErrorMessageResourceType = typeof(Resource))]
        public string CPF { get; set; }

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            if (Senha != ConfirmaSenha)
                yield return new ValidationResult(Resource.SenhaDigitadasNaoConferem);

            int senha, confirmaSenha;

            int.TryParse(Senha, out senha);
            int.TryParse(ConfirmaSenha, out confirmaSenha);

            if (Email != ConfirmaEmail)
                yield return new ValidationResult(Resource.EmailsNaoConferem);

            if (!Util.ValidarCPF(CPF))
                yield return new ValidationResult(Resource.CpfInvalido);

            if (!Util.ValidarEmail(Email))
                yield return new ValidationResult("E-mail inválido");

            if (!Util.ValidarNome(Nome))
                yield return new ValidationResult("Nome inválido");

        }
    }
}