using Amil.AsmWebCad.UI.Resources;
using System.ComponentModel.DataAnnotations;

namespace Amil.AsmWebCad.UI.Models.Login
{
    public class UnidadeViewModel
    {
        [Required(ErrorMessageResourceName = "Login_UnidadeObrigatorio", ErrorMessageResourceType = typeof(Resource))]
        public int Id { get; set; }
        public string Nome { get; set; }
    }
}