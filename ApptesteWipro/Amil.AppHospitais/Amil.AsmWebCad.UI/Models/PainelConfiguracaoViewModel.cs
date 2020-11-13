using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Amil.AsmWebCad.UI.Models
{
    public class PainelConfiguracaoViewModel
    {
        [Display(Name = "Código do Painel")]
        public int Id { get; set; }

        [Required(ErrorMessage = "O campo Unidade de Atendimento é obrigatório.")]
        [Display(Name = "Unidade de Atendimento")]
        public int IdUnidade { get; set; }

        public string DescUnidade { get; set; }

        [StringLength(20, MinimumLength = 3, ErrorMessage = "O Local na Unidade deve ter de 3 a 20 caracteres.")]
        [Required(ErrorMessage = "O campo Local na Unidade é obrigatório.")]
        [Display(Name = "Local na Unidade")]
        public string Local { get; set; }

        [Display(Name = "Ordenação do Painel")]
        public int IdOrdenacao { get; set; }

        public string DescOrdenacao { get; set; }

        [Required(ErrorMessage = "O campo Tempo de Refresh do Painel é obrigatório.")]
        [Range(3, 15, ErrorMessage = "Tempo de refresh deve ser entre 3 e 15 minutos.")]
        [Display(Name = "Tempo de Refresh do Painel")]
        public int TempoRefresh { get; set; }

        [Display(Name = "Status")]
        public bool isAtivo { get; set; }

        public List<SelectListItem> Unidades { get; set; }

        public List<SelectListItem> Ordenacoes { get; set; }

        public virtual List<PainelConfigEspecViewModel> Especialidades { get; set; }

        public PainelConfiguracaoViewModel()
        {
            this.Especialidades = new List<PainelConfigEspecViewModel>();
        }
    }
}