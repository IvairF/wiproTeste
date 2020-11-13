using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Amil.PainelPS.UI.Models
{
    public class PainelViewModel
    {
        public string Nome { get; set; }

        public int TempoRefresh { get; set; }

        public virtual List<EspecialidadeViewModel> Especialidade { get; set; }
    }
}