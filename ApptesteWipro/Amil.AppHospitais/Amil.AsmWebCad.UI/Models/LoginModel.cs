using Amil.AsmWebCad.UI.Resources;
using System.ComponentModel.DataAnnotations;

namespace Amil.AsmWebCad.UI.Models
{
    public class LoginModel
    {
        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
         StringLength(50, ErrorMessageResourceName = "AlertaLoginMax50", ErrorMessageResourceType = typeof(Resource))]
        public string Login { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(50, ErrorMessageResourceName = "AlertaSenhaMax10", ErrorMessageResourceType = typeof(Resource))]
        public string Senha { get; set; }

        public string Sistema { get; set; }
    }

}