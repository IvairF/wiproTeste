using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Amil.AsmWebCad.UI.Models
{
    public class EspecialidadeNowModel
    {
        public int? IdEspecialidade { get; set; }

        public string Sigla { get; set; }

        public string Descricao { get; set; }

        public string CodigoBase { get; set; }

        public string PrimeiroAcesso { get; set; }
    }
}