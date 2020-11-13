using Amil.AsmWebCad.UI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Amil.AppHospitais.DTO;
using Amil.AsmWebCad.Utils;
using Amil.AsmWebCad.UI.NowWCF;
using System.IO;
using Amil.AsmWebCad.UI.Helpers;
using Amil.AppHospitais.BLL;
using Amil.AppHospitais.APIClient;

namespace Amil.AsmWebCad.UI.Controllers
{
    public class EspecialidadeNowController : BaseController
    {

        public ActionResult ValidarAcesso()
        {
            JsonResult result;

            result = Json(new { Result = "true", Erro = false, Mensagem = "Acesso OK" }, JsonRequestBehavior.AllowGet);

            return result;

        }

        public ActionResult Pesquisa(int idUnidade, string limpar = "", string modal = "")
        {

            //{
            //    var especialidadeNowModel = (EspecialidadeNowModel)Session["especialidadeNowModel"];
            //    if (modal == "S")
            //    {

            //        especialidadeNowModel.Id = 1;
            //        especialidadeNowModel.Descricao = "TESTE";

            //    }
            //    else if (especialidadeNowModel == null || limpar == "S")
            //    {

            //        var especialidadeNowModel = new EspecialidadeNowModel();
            //        unidadeNowModel.Id = 0;
            //        unidadeNowModel.Nome = "";
            //        unidadeNowModel.PrimeiroAcesso = "S";

            //        Session["unidadeNowModel"] = null;


            //    }

            //    return View(unidadeNowModel);
            //}
            return View();
        }

        [HttpPost]
        public ActionResult Pesquisa(FormCollection formCollection)
        {
            JsonResult result = null;

            try
            {
                var nome = formCollection["nome"];
                var tipo = formCollection["tipoConsulta"];
                var lstSpec = new List<NowSpecialtyDTO>();
                 //var lstSpec1 = new List<NOW_ESPECIALIDADES>();
                 //lstSpec1 = new ServiceClient().EspecialidadeId(nome);
               
                var lstSpecFiltradas = new List<NowSpecialtyDTO>();
                
                var paging = formCollection.ToPagingDTO();
                PagedResult<NowSpecialtyDTO> lstSpecDTO;

                //if (tipo == "0")
                //{
                //    lstSpec = new ServiceClient().EspecialidadeNome(nome);
                //}
                //else
                //{
                //    lstSpec = new ServiceClient().EspecialidadeId(nome);
                //}
                
                //TROCAR PELA WEB-API (CONSULTA GENERICA SO SISMED WEBCAD TABELA AA_EPECIALIDADE)
                lstSpec = new ServiceClient().GetNowSpecialties();
                if (tipo == "0")
                {
                     lstSpecFiltradas = lstSpec.Where(l => l.Specialty.Contains(nome)).ToList();
                }
                else {

                    lstSpecFiltradas = lstSpec.Where(l => l.SpecialtyCode == nome).ToList();
                }

                paging.Order = "Specialty";
                lstSpecDTO = lstSpecFiltradas.ToPagedResult(paging.Offset, 15, paging.Order);

                result = JsonFromPagedList(lstSpecDTO);

            }
            catch (TimeoutException ex)
            {
                ModelState.AddModelError("Timeout", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;

        }

        public ActionResult Manutencao()
        {
            var especialidadeViewModel = new EspecialidadeNowModel();

            try
            {
                var parameters = SecurityHelper.GetRequestParams();
                var idEsp = DataParser.Parse(parameters["idEspecialidade"], 0);
                //ucEspecialidade.IdChave = specialty.SpecialtyKeyId;
                //txtSigla.Text = specialty.Acronym;
                //SpecialtyId = specialty.SpecialtyId;

                //var perfilModel = new PerfilModel();
                especialidadeViewModel.IdEspecialidade = 0;

                // Editar
                if (idEsp > 0)
                {
                    // carrega o perfil e popula os campos
                    var Esp = new ServiceClient().GetNowSpecialty(idEsp);

                    especialidadeViewModel.IdEspecialidade = Esp.SpecialtyId;
                    especialidadeViewModel.Sigla = Esp.Acronym;
                    especialidadeViewModel.Descricao = Esp.Specialty;
                }

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
            }

            return View(especialidadeViewModel);

        }

        [HttpPost]
        public ActionResult Manutencao(FormCollection formCollection)
        {
            return View();
        }

        public PartialViewResult CodigoBaseModal(int idEspecialidade, string nome = "")
        {
            var especialidadeNowModel = (EspecialidadeNowModel)Session["EspecialidadeNowModel"];
            //if (UnidadeNowModel == null)
            //{
            //    UnidadeNowModel = new UnidadeNowModel();

            especialidadeNowModel = new EspecialidadeNowModel();

            //especialidadeNowModel.Id = idEspecialidade;
            especialidadeNowModel.Descricao = nome;

            ViewBag.NomeBag = nome;
            //}

            return PartialView("_CodigoBaseModal");
        }

        public ActionResult ValidarAcessoPesquisa()
        {
            JsonResult result;

            try
            {
                var client = new UsuarioClient(Session);

                LoginUsuarioDTO usuarioDTO = new LoginUsuarioDTO();

                usuarioDTO.Nome = "webcad";

                var resultado = client.Listar(usuarioDTO);

                result = Json(new { Result = "true", Erro = false, Mensagem = "Acesso OK" }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }


	}
}