using Amil.AppHospitais.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Amil.AsmWebCad.UI.Models
{
    public class PainelConfigEspecViewModel
    {
        public int Id { get; set; }

        public string Nome { get; set; }

        public int IdPainelConfiguracao { get; set; }

        public int IdEspecialidade { get; set; }
    }
}