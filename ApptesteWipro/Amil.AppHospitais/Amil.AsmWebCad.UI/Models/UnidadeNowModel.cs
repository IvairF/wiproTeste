using System;
using Amil.AsmWebCad.UI.Resources;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;

namespace Amil.AsmWebCad.UI.Models
{
    public class UnidadeNowModel
    {
        public UnidadeNowModel()
        {
            this.grafico = new GraficoUnidadeNowModel();
        }

        public int Id { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(60, ErrorMessageResourceName = "AlertaNomeMax60", ErrorMessageResourceType = typeof(Resource))]
        public string Nome { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource))]
        public string UF { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(15, ErrorMessageResourceName = "AlertaCodigoIntegracaoMax", ErrorMessageResourceType = typeof(Resource))]
        public string CodigoCorporativo { get; set; }
              
        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource))]
        public int? Ativo { get; set; }

        public string Status { get; set; }

        public string Regional { get; set; }

        public string EscalaRisco { get; set; }

        public string BaseWPD { get; set; }

        public string Descricaoativo { get; set; }

        public string Tipo { get; set; }

        public string PrimeiroAcesso { get; set; }

        public GraficoUnidadeNowModel grafico { get; set; }
        
    }
}
