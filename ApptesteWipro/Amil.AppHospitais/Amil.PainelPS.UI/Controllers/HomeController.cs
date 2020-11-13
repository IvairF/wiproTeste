using Amil.AppHospitais.APIClient;
using Amil.AppHospitais.DTO;
using Amil.PainelPS.UI.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Amil.PainelPS.UI.Controllers
{
    public class HomeController : Controller
    {

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Detail(int id = 0)
        {
            var painelPSClient = new PainelPSClient();
            PainelConfiguracaoDTO config = painelPSClient.Obter(id);

            if (config == null || !config.isAtivo)
            {
                return RedirectToAction("Index");
            }


            var tempoEspecialidades = painelPSClient.ObterEspecialidadesUnidadeTempoEspera(config.Unidade.Identificador);

            PainelViewModel painel = new PainelViewModel();
            painel.TempoRefresh = config.TempoRefresh;
            painel.Especialidade = new List<EspecialidadeViewModel>();
            foreach (var especialidade in config.Especialidades)
            {
                var espec = new EspecialidadeViewModel();
                espec.Nome = especialidade.Especialidade.nome;
                foreach (var tempoEspec in tempoEspecialidades)
                {
                    if (tempoEspec.id == especialidade.IdEspecialidade)
                    {
                        espec.tempoEspera = tempoEspec.tempoEspera;
                        break;
                    }
                }
                painel.Especialidade.Add(espec);
            }
            if (config.Ordenacao.Equals(1))
                painel.Especialidade = painel.Especialidade.OrderBy(i => i.Nome).ToList();
            else if(config.Ordenacao.Equals(2))
                painel.Especialidade = painel.Especialidade.OrderBy(i => i.tempoEspera).ToList();

            return View(painel);
        }
	}
}