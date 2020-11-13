using Amil.AppHospitais.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Amil.AsmWebCad.UI.Models
{
    public class PesquisaPainelConfigViewModel
    {
        [Display(Name = "Código do Painel")]
        public int? Codigo { get; set; }

        [Display(Name = "Unidade de Atendimento")]
        public List<SelectListItem> Unidades { get; set; }

        [Display(Name = "Id Unidade")]
        public int? IdUnidade { get; set; }

        [Display(Name = "Status")]
        public int? Status { get; set; }

        //public PainelConfiguracaoDTO PainelConfiguracaoDTO { get; set; }

        //public List<EspecialidadeMedica> EspecialidadeMedica { get; set; }

        public PesquisaPainelConfigViewModel()
        {
            Unidades = new List<SelectListItem>();
        }
    }
}