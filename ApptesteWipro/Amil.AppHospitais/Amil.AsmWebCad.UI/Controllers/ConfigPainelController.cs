using Amil.AppHospitais.APIClient;
using Amil.AppHospitais.DTO;
using Amil.AsmWebCad.UI.Models;
using Amil.AsmWebCad.Utils;
using PagedList;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DTO = Amil.AppHospitais.DTO;

namespace Amil.AsmWebCad.UI.Controllers
{
	public class ConfigPainelController : Controller
	{
		//
		// GET: /ConfigPainel/
		public ActionResult Index()
		{
			var vm = new PesquisaPainelConfigViewModel();
            var unidadeClient = new UnidadeClient(Session);
			var unidades = unidadeClient.Listar();

			foreach (var unidade in unidades)
			{
				vm.Unidades.Add(new SelectListItem { Value = unidade.Identificador.ToString(), Text = unidade.Descricao });
			}
			return View(vm);
		}
		
		public ActionResult Detail(int id)
		{
            var painelConfiguracaoClient = new PainelConfiguracaoClient(Session);
            var painelConfiguracaoDTO = painelConfiguracaoClient.Obter(id);
			var vm = toPainelConfiguracaoViewModel(painelConfiguracaoDTO);

			return View(vm);
		}

		public ActionResult Edit(int id = 0)
		{
			var vm = new PainelConfiguracaoViewModel();
			if (id > 0)
			{
                var painelConfiguracaoClient = new PainelConfiguracaoClient(Session);
                var painelConfiguracaoDTO = painelConfiguracaoClient.Obter(id);
				vm = toPainelConfiguracaoViewModel(painelConfiguracaoDTO);
			}
			else
			{
				vm.isAtivo = true;
			}

            var unidadeClient = new UnidadeClient(Session);
			var unidades = unidadeClient.Listar();
			vm.Unidades = new List<SelectListItem>();
			foreach (var unidade in unidades)
				vm.Unidades.Add(new SelectListItem { Value = unidade.Identificador.ToString(), Text = unidade.Descricao });

			var ordenacao = EnumHelper.ListarEnum<OrdenacaoEnum>();
			vm.Ordenacoes = new List<SelectListItem>();
			foreach (var item in ordenacao)
				vm.Ordenacoes.Add(new SelectListItem { Value = item.Id.ToString(), Text = item.Descricao });

			if (TempData["Notificacao"] != null)
				ViewBag.Notificacao = TempData["Notificacao"].ToString();

			return View(vm);
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Edit(PainelConfiguracaoViewModel vm)
		{
			PainelConfiguracaoDTO painelConfiguracaoDTO = new PainelConfiguracaoDTO();
			painelConfiguracaoDTO.Id = vm.Id;
			painelConfiguracaoDTO.IdUnidade = vm.IdUnidade;
			painelConfiguracaoDTO.Local = vm.Local;
			painelConfiguracaoDTO.Ordenacao = vm.IdOrdenacao;
			painelConfiguracaoDTO.TempoRefresh = vm.TempoRefresh;
			painelConfiguracaoDTO.isAtivo = vm.isAtivo;
			
			var notificacao="";
			if (vm.Id > 0)
				TempData["Notificacao"] = "Alteração efetuada com sucesso!";
			else
				TempData["Notificacao"] = "Cadastrado efetuado com sucesso!";

            var painelConfiguracaoClient = new PainelConfiguracaoClient(Session);
            var id = painelConfiguracaoClient.Gravar(painelConfiguracaoDTO);
			return RedirectToAction("Edit", new { id = id, notificacao = notificacao });
		}

		public ActionResult Delete(int id)
		{
            var painelConfigEspecialidadesClient = new PainelConfigEspecialidadesClient(Session);
            painelConfigEspecialidadesClient.Excluir(id);
			return Json(new { status = "Success" });
		}

		[HttpPost]
		public ActionResult AddPainelConfigEspec(PainelConfiguracaoViewModel painelConfig)
		{
			List<PainelConfigEspecialidadeDTO> listEspecialidades = new List<PainelConfigEspecialidadeDTO>();
			foreach(PainelConfigEspecViewModel painelEspec in painelConfig.Especialidades)
			{
				PainelConfigEspecialidadeDTO especialidade = new PainelConfigEspecialidadeDTO();
				especialidade.IdEspecialidade = painelEspec.IdEspecialidade;
				especialidade.IdPainelConfiguracao = painelEspec.IdPainelConfiguracao;
				listEspecialidades.Add(especialidade);
            }
            var painelConfigEspecialidadesClient = new PainelConfigEspecialidadesClient(Session);
            foreach (PainelConfigEspecialidadeDTO especialidadeConfig in listEspecialidades)
                painelConfigEspecialidadesClient.GravarEspecialidades(especialidadeConfig);
			return Json(new { status = "Success", url = Url.Action("GridConfigEspec", new { id = painelConfig.Id }) });
		}

		public PartialViewResult GridConfigEspec(int id)
        {
            var painelConfiguracaoClient = new PainelConfiguracaoClient(Session);
            var painelConfiguracaoDTO = painelConfiguracaoClient.Obter(id);
			var vm = toPainelConfiguracaoViewModel(painelConfiguracaoDTO);
			return PartialView("_GridConfigEspec", vm.Especialidades);
		}

		public PartialViewResult GridPaineis(int? pagina)
        {
            var painelConfiguracaoClient = new PainelConfiguracaoClient(Session);
            var listaPaineis = painelConfiguracaoClient.Listar();
			int paginaTamanho = 10;
			int paginaNumero = (pagina ?? 1);

			var listaVM = new List<PainelConfiguracaoViewModel>();
			foreach (PainelConfiguracaoDTO painelConfigDTO in listaPaineis)
			{
				listaVM.Add(toPainelConfiguracaoViewModel(painelConfigDTO));
			}

			return PartialView("_GridPainel", listaVM.ToPagedList(paginaNumero, paginaTamanho));
		}





		public PartialViewResult GridEspecialidades(int id)
		{
            var especialidadeClient = new EspecialidadeClient(Session);
			var lista = especialidadeClient.ListarPorUnidade(id);
			return PartialView("_GridEspecialidades", lista);
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Filter(PesquisaPainelConfigViewModel pesquisa)
		{
			PesquisaPainelConfigDTO pesquisaDTO = new PesquisaPainelConfigDTO();
			pesquisaDTO.Codigo = pesquisa.Codigo;
			pesquisaDTO.IdUnidade = pesquisa.IdUnidade;
			pesquisaDTO.Status = pesquisa.Status;

            var vm = new List<PainelConfiguracaoViewModel>();
            var painelConfiguracaoClient = new PainelConfiguracaoClient(Session);
            var result = painelConfiguracaoClient.ListarPorFiltro(pesquisaDTO);
			foreach (PainelConfiguracaoDTO painelConfigDTO in result)
			{
				vm.Add(toPainelConfiguracaoViewModel(painelConfigDTO));
			}
            return PartialView("_GridPainel", vm.ToPagedList(1, 10));
		}

		public PainelConfiguracaoViewModel toPainelConfiguracaoViewModel(PainelConfiguracaoDTO painelConfiguracaoDTO)
		{
			var vm = new PainelConfiguracaoViewModel();
			vm.Id = painelConfiguracaoDTO.Id;
			vm.IdUnidade = painelConfiguracaoDTO.IdUnidade;
			vm.DescUnidade = painelConfiguracaoDTO.Unidade.Descricao;
			vm.Local = painelConfiguracaoDTO.Local;
			vm.IdOrdenacao = painelConfiguracaoDTO.Ordenacao;
			vm.DescOrdenacao = painelConfiguracaoDTO.Ordenacao == 1 ? "Nome da Especialidade" : (painelConfiguracaoDTO.Ordenacao == 2 ? "Tempo de Espera" : "Nenhuma");
			vm.TempoRefresh = painelConfiguracaoDTO.TempoRefresh;
			vm.isAtivo = painelConfiguracaoDTO.isAtivo;
			vm.Especialidades = new List<PainelConfigEspecViewModel>();
			if (painelConfiguracaoDTO.Especialidades != null)
				foreach (PainelConfigEspecialidadeDTO painelConfigEspecialidadeDTO in painelConfiguracaoDTO.Especialidades)
				{
					PainelConfigEspecViewModel painelConfigEspecViewModel = new PainelConfigEspecViewModel();
					painelConfigEspecViewModel.Id = painelConfigEspecialidadeDTO.Id;
					painelConfigEspecViewModel.IdEspecialidade = painelConfigEspecialidadeDTO.IdEspecialidade;
					painelConfigEspecViewModel.IdPainelConfiguracao = painelConfigEspecialidadeDTO.IdPainelConfiguracao;
					painelConfigEspecViewModel.Nome = painelConfigEspecialidadeDTO.Especialidade.nome;
					vm.Especialidades.Add(painelConfigEspecViewModel);
				}
			return vm;
		}

	}
}