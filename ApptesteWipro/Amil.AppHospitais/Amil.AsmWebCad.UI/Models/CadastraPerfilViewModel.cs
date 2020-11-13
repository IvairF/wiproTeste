using Amil.AsmWebCad.UI.Resources;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;


namespace Amil.AsmWebCad.UI.Models
{
    public class CadastraPerfilViewModel
    {

        public int Id { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(100, ErrorMessageResourceName = "AlertaPerfilMax100", ErrorMessageResourceType = typeof(Resource))]
        public string Descricao { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource))]
        public int? IdSistema { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(50, ErrorMessageResourceName = "AlertaCodigoMax50", ErrorMessageResourceType = typeof(Resource))]
        public string Codigo { get; set; }

        public List<SelectListItem> Modulos { get; set; }

        public CadastraPerfilViewModel()
        {
            Modulos = new List<SelectListItem>();
        }
    }}