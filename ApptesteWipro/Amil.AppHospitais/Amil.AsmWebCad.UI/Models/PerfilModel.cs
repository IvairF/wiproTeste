using Amil.AsmWebCad.UI.Resources;
using System.ComponentModel.DataAnnotations;

namespace Amil.AsmWebCad.UI.Models
{
    public class PerfilModel
    {
        public int Id { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(100, ErrorMessageResourceName = "AlertaDescricaoMax100", ErrorMessageResourceType = typeof(Resource))]
        public string Descricao { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource))]
        public int IdSistema { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(50, ErrorMessageResourceName = "AlertaCodigoMax50", ErrorMessageResourceType = typeof(Resource))]
        public string Codigo { get; set; }


        public string PrimeiroAcesso { get; set; } //2804
    }
}