using Amil.AppHospitais.DTO;
using Amil.AsmWebCad.UI.Models;
using Amil.AsmWebCad.Utils;
using Amil.AsmWebCad.UI.Helpers;
using System.Collections.Generic;
using Newtonsoft.Json;
using System;
using System.Web.Mvc;
using Amil.AppHospitais.APIClient;
using Newtonsoft.Json.Converters;
using Amil.AsmWebCad.UI.NowWCF;


namespace Amil.AsmWebCad.UI.Controllers
{
    [SessionTimeout]
    //[ValidaTokenFilter("WEBCAD_P2121")]
    public class UnidadeNowController : BaseController
    {
        #region Unidades

        public ActionResult Pesquisa(string limpar = "")
        {
            var UnidadeNowModel = (UnidadeNowModel)Session["unidadeNowModel"];
            if (UnidadeNowModel == null || limpar == "S")
            {
                UnidadeNowModel = new UnidadeNowModel();

                UnidadeNowModel.Id = 0;
                UnidadeNowModel.Nome = "";
                UnidadeNowModel.CodigoCorporativo = "";
                UnidadeNowModel.PrimeiroAcesso = "S";

                Session["UnidadeNowModel"] = null;

            }

            return View(UnidadeNowModel);

        }

        [HttpPost]
        public ActionResult Pesquisa(FormCollection formCollection)
        {

            JsonResult result = null;

            try
            {
                var nome = formCollection["nome"];
                var tipo = formCollection["tipo"];

                var lstSpec = new List<NOW_UNIDADE>();
                var paging = formCollection.ToPagingDTO();
                PagedResult<NOW_UNIDADE> lstSpecDTO;

                var client = new ServiceClient();

                if (tipo == "0")
                {
                    lstSpec = client.UnidadeDadosNome(nome);
                }
                else
                {
                    lstSpec = client.UnidadeDadosCd(nome);
                }


                paging.Order = "NM_UNIDADE";
                lstSpecDTO = lstSpec.ToPagedResult(paging.Offset, paging.Limit, paging.Order);

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

            var unidadeNowModel = new UnidadeNowModel();

            unidadeNowModel.Id = 0;
            unidadeNowModel.Nome = "";// unidadeDTO.Nome;
            unidadeNowModel.CodigoCorporativo = "";// unidadeDTO.CodigoCorporativo;
            unidadeNowModel.Status = "T";
            unidadeNowModel.PrimeiroAcesso = "N";

            Session["unidadeNowModel"] = unidadeNowModel;

            return result;

        }


        public ActionResult Manutencao()
        {
            var graficoUnidade = new GraficoUnidadeNowModel();
            var parameters = SecurityHelper.GetRequestParams();
            var unidadeNowModel = new UnidadeNowModel();
            UnidadeAppNowDTO unidadeDTO = new UnidadeAppNowDTO();
            var idUnidade = DataParser.Parse(parameters["idUnidade"], 0);
            var serviceNow = new ServiceClient();

            //ViewBag.SistemaBag = new SelectList(lstSistemaDTO, "Id", "Descricao");
            var lstEstados = serviceNow.Estado(); // ID_UF, DESCRICAO
            ViewBag.UF = new SelectList(lstEstados, "ID_UF", "ID_UF");

            var lstRegional = serviceNow.Regional();
            ViewBag.Regional = new SelectList(lstRegional, "ID_REGIONAL", "NM_REGIONAL");

            var lstRisco = serviceNow.EscalaRisco();
            ViewBag.EscalaRisco = new SelectList(lstRisco, "ID_ESCALA_RISCO", "NM_ESCALA_RISCO");

            var lstBase = serviceNow.BaseWpd();
            ViewBag.Base = new SelectList(lstBase, "ID_BASE_DADOS", "NOME");

            ViewBag.StatusBag = BuscarAtivoInativo(null);

            if (idUnidade > 0)
            {
                var unidade = serviceNow.UnidadeDadosId(idUnidade);
                ViewBag.RegionalUF = serviceNow.RegionalUF(unidade.CM_REGIONAL.CM_FILIAL_UF.ID_UF);

                unidadeNowModel.Nome = unidade.NM_UNIDADE;
                unidadeNowModel.UF = unidade.CM_REGIONAL.CM_FILIAL_UF.ID_UF;
                unidadeNowModel.Regional = unidade.CM_REGIONAL.ID_REGIONAL.ToString();
                unidadeNowModel.EscalaRisco = unidade.CM_ESCALA_RISCO.ID_ESCALA_RISCO.ToString();
                unidadeNowModel.BaseWPD = unidade.CM_BASE_DADOS_WPD.ID_BASE_DADOS.ToString();
                unidadeNowModel.CodigoCorporativo = unidade.CD_UNIDADE;
                unidadeNowModel.Status = unidade.FL_ATIVA.ToString();
                unidadeNowModel.Id = (int)unidade.ID_UNIDADE; ;

                //ddlBase.SelectedValue = _unity.CM_BASE_DADOS_WPD == null
                //    ? "0"
                //    : _unity.CM_BASE_DADOS_WPD.ID_BASE_DADOS.ToString();


            }

            return View(unidadeNowModel);
        }

        [HttpPost]
        public ActionResult Manutencao(FormCollection formCollection)
        {
            JsonResult result;

            try
            {
                var json = formCollection["json"];
                var format = "dd/MM/yyyy";
                var dateTimeConverter = new IsoDateTimeConverter { DateTimeFormat = format };
                var unidadeNowModel = JsonConvert.DeserializeObject<UnidadeNowModel>(json, dateTimeConverter);
                UnidadeAppNowDTO unidade = new UnidadeAppNowDTO();
                UnidadeAppNowDTO unidadePesquisa = new UnidadeAppNowDTO();

                unidade.Id = unidadeNowModel.Id;
                unidade.Nome = unidadeNowModel.Nome;
                unidade.UF = unidadeNowModel.UF;
                unidade.Regional = unidadeNowModel.Regional;
                unidade.EscalaRisco = unidadeNowModel.EscalaRisco;
                unidade.Base = unidadeNowModel.BaseWPD;
                unidade.CodigoCorporativo = unidadeNowModel.CodigoCorporativo;
                unidade.Ativo = unidadeNowModel.Ativo;
                unidade.Id = unidadeNowModel.Id;


                if (!Util.ValidarNome(unidade.Nome))
                {
                    ModelState.AddModelError("", "Nome inválido");
                    return Json(new { Result = 0, Erro = true, Mensagem = "Nome inválido" }, JsonRequestBehavior.AllowGet);
                }

                var unidadeNowClient = new UnidadeNowClient(Session);

                if (unidade.Id > 0)
                {
                    var idUnidade = unidadeNowClient.AlterarUnidade(unidade);
                    result = Json(new { Result = idUnidade, Erro = false }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    unidadePesquisa = unidadeNowClient.Obter(unidade.Id);
                    if (unidadePesquisa == null)
                    {
                        var novaUnidade = unidadeNowClient.CadastrarUnidade(unidade);
                        result = Json(new { Result = novaUnidade, Erro = false }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {

                        result = Json(new { Result = 0, Erro = true, Mensagem = "Usuário já cadastrado" }, JsonRequestBehavior.AllowGet);
                    }
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }

        [HttpPost]
        public ActionResult Exclusao(FormCollection formCollection)
        {
            JsonResult result;

            try
            {
                var idUnidade = DataParser.Parse(formCollection["idUnidade"], 0);

                var unidadeNowClient = new UnidadeNowClient(Session);

                unidadeNowClient.Excluir(idUnidade);

                result = Json(new { Result = 1, Erro = false }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }


        public ActionResult ValidarAcessoPesquisa()
        {
            JsonResult result;

            try
            {
                var client = new ServiceClient();

                var lstSpec = new List<NOW_UNIDADE>();
                PagedResult<NOW_UNIDADE> lstSpecDTO;

                lstSpec = client.UnidadeDadosNome("IVAN");

                result = Json(new { Result = "true", Erro = false, Mensagem = "Acesso OK" }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }

        #endregion


        #region Especialidades

        public ActionResult ListarEspecialidades(FormCollection formCollection)
        {
            var idUnidade = string.IsNullOrEmpty(formCollection["IdUnidade"]) ? 0 : Convert.ToInt32(formCollection["IdUnidade"]);
            JsonResult result = null;

            try
            {
                var lstSpec = new List<EspecialidadeDTO>();
                var paging = formCollection.ToPagingDTO();
                PagedResult<EspecialidadeDTO> lstSpecDTO;

                lstSpec = new ServiceClient().UnidadeEspecialidade(idUnidade);

                paging.Order = "ESPECIALIDADE";
                lstSpecDTO = lstSpec.ToPagedResult(paging.Offset, paging.Limit, paging.Order);

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

        [HttpPost]
        public ActionResult IncluirEspecialidadeUnidade(FormCollection formCollection)
        {
            JsonResult result;
            try
            {
                var idUnidade = DataParser.Parse(formCollection["idUnidade"], 0);

                var idEspecialidade = DataParser.Parse(formCollection["idEspecialidade"], 0);

                var codigoBase = DataParser.Parse(formCollection["codigoBase"], "");

                var entity = new NOW_UNIDADE_ESPECIALIDADE();

                entity.ID_CHAVE_ESPECIALIDADE = idEspecialidade;
                entity.ID_UNIDADE = idUnidade;
                entity.CD_ESPEC_UNIDADE = codigoBase;
                //  result  = new ServiceClient().EspecialidadeIncluir(entity, (int)Session["LoginUsuarioID"]);  

                result = Json(new { Result = 1, Erro = false }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }



        [HttpPost]
        public ActionResult ExclusaoEspecialidades(FormCollection formCollection)
        {
            JsonResult result = null;
            var client = new ServiceClient();
            NOW_UNIDADE_ESPECIALIDADE especialidade = new NOW_UNIDADE_ESPECIALIDADE();
            try
            {
                var idEspecialidade = DataParser.Parse(formCollection["idEspecialidade"], 0);

                especialidade = client.EspecialidadeId(idEspecialidade);

                client.EspecialidadeExcluir(especialidade, 11);

                result = Json(new { Result = 1, Erro = false }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }

        #endregion


        #region Divisão

        public ActionResult ListarDivisoes(FormCollection formCollection)
        {
            var idUnidade = string.IsNullOrEmpty(formCollection["IdUnidade"]) ? 0 : Convert.ToInt32(formCollection["IdUnidade"]);
            JsonResult result = null;

            try
            {
                var lstDiv = new List<NOW_UNIDADE_DIVISAO>();
                var paging = formCollection.ToPagingDTO();
                PagedResult<NOW_UNIDADE_DIVISAO> lstSpecDTO;

                lstDiv = new ServiceClient().GetFacilityDivisions(idUnidade);

                paging.Order = "NM_DIVISAO";
                lstSpecDTO = lstDiv.ToPagedResult(paging.Offset, paging.Limit, paging.Order);

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

        [HttpPost]
        public ActionResult ExclusaoDivisao(FormCollection formCollection)
        {
            JsonResult result = null;
            var client = new ServiceClient();
            NOW_UNIDADE_DIVISAO divisao = new NOW_UNIDADE_DIVISAO();
            try
            {
                var idDivisao = DataParser.Parse(formCollection["idDivisao"], 0);
                divisao = client.GetFacilityDivision(idDivisao);

                client.DeleteFacilityDivision(divisao, 11);

                result = Json(new { Result = 1, Erro = false }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }

        // DIVISÃO
        [HttpPost]
        public ActionResult InclusaoDivisao(FormCollection formCollection)
        {
            JsonResult result = null;
            try
            {
                var idUnidade = Convert.ToInt32(formCollection["idUnidade"]);
                var nomeDivisao = formCollection["divisao"];

                var divisao = new NOW_UNIDADE_DIVISAO();

                divisao.ID_UNIDADE = idUnidade;
                divisao.NM_DIVISAO = nomeDivisao;

                new ServiceClient().CreateFacilityDivision(divisao, 11);

                result = Json(new { Result = 1, Erro = false }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }

        [HttpPost]
        public PartialViewResult CarregarDivisao(FormCollection formCollection)
        {

            PartialViewResult result = null;

            var lstSpecUnidade = new List<EspecialidadeDTO>();
            var lstSpecDivisao = new List<EspecialidadeDTO>();
            var lstSpecUnidadeR = new List<EspecialidadeNowModel>();
          
        
            
          

            var client = new ServiceClient();



            var idUnidade = DataParser.Parse(formCollection["idunidade"], 0);
            lstSpecUnidade = new ServiceClient().UnidadeEspecialidade(idUnidade);
            EspecialidadeNowModel especialidade = new EspecialidadeNowModel();
            foreach (var a in lstSpecUnidade)
            {
                 especialidade.IdEspecialidade = a.ID_CHAVE_ESPECIALIDADE;
                 especialidade.Descricao = a.ESPECIALIDADE;
                 lstSpecUnidadeR.Add(especialidade);            
                
            }

            var idDivisao = DataParser.Parse(formCollection["idDivisao"], 0);
            lstSpecDivisao = new ServiceClient().SpecialtiesFromDivision(idUnidade, idDivisao);

            ViewBag.ListaEspecilidadesUnidade = new MultiSelectList(lstSpecUnidadeR);
            ViewBag.ListaEspecilidadesDivisao = new MultiSelectList(lstSpecDivisao, "ESPECIALIDADE");

            result = PartialView("_vinculoEspecialidadeUnidadeDivisaoModal");

            return result;

        }


        #endregion


        #region Graficos / Fases

        public ActionResult ListarGraficos(FormCollection formCollection)
        {
            var idUnidade = string.IsNullOrEmpty(formCollection["IdUnidade"]) ? 0 : Convert.ToInt32(formCollection["IdUnidade"]);
            JsonResult result = null;

            try
            {
                var lstGraficos = new List<NOW_UNIDADE_FASE>();
                var paging = formCollection.ToPagingDTO();
                PagedResult<NOW_UNIDADE_FASE> lstSpecDTO;

                lstGraficos = new ServiceClient().FaseListaUnidade(idUnidade);

                paging.Order = "NR_ORDEM";
                lstSpecDTO = lstGraficos.ToPagedResult(paging.Offset, paging.Limit, paging.Order);

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

        [HttpPost]
        public ActionResult ExclusaoGrafico(FormCollection formCollection)
        {
            JsonResult result = null;
            var client = new ServiceClient();
            NOW_UNIDADE_FASE fase = new NOW_UNIDADE_FASE();
            try
            {
                var idGrafico = DataParser.Parse(formCollection["idGrafico"], 0);

                // _serviceNow.FaseExculir(_serviceNow.FaseUnidade(int.Parse(hdnID.Value)), (int) Session["LoginUsuarioID"]);
                fase = client.FaseUnidade(idGrafico);

                client.FaseExculir(fase, 11);

                result = Json(new { Result = 1, Erro = false }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }

        [HttpPost]
        public ActionResult InclusaoGrafico(FormCollection formCollection)
        {
            JsonResult result = null;
            try
            {
                var idUnidade = Convert.ToInt32(formCollection["idUnidade"]);
                var nomeDivisao = formCollection["divisao"];

                var divisao = new NOW_UNIDADE_DIVISAO();

                divisao.ID_UNIDADE = idUnidade;
                divisao.NM_DIVISAO = nomeDivisao;

                new ServiceClient().CreateFacilityDivision(divisao, 11);

                result = Json(new { Result = 1, Erro = false }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }


        public ActionResult CarregarFase(FormCollection formCollection)
        {
            JsonResult result = null;

            try
            {
                var lstFase = new ServiceClient().FaseListar();
                ViewBag.Fase = new SelectList(lstFase, "ID_FASE", "NM_FASE");

                result = Json(new { Result = "Ok", Erro = false }, JsonRequestBehavior.AllowGet);
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


        /* 
           _serviceNow.FaseAlterar(fase, (int) Session["LoginUsuarioID"]);

        *  _serviceNow.FaseIncluir(fase, (int) Session["LoginUsuarioID"]);

        */

        #endregion


        #region Private

        private SelectList BuscarAtivoInativo(string ativo)
        {
            var vativo = false;
            var vinativo = false;

            switch (ativo)
            {
                case "1":
                    vativo = true;
                    break;
                case "0":
                    vinativo = true;
                    break;
            }


            var itemAtivo = new SelectListItem { Text = Resources.Resource.Ativo, Value = "1", Selected = vativo == true };
            var itemInativo = new SelectListItem { Text = Resources.Resource.Inativo, Value = "0", Selected = vinativo == true };
            var itens = new List<SelectListItem> { itemAtivo, itemInativo };

            return new SelectList(itens, "Value", "Text");
        }

        #endregion
        public PartialViewResult CarregarPesquisa(string Nome)
        {
            var especialidadeNowModel = (EspecialidadeNowModel)Session["EspecialidadeNowModel"];
            //if (UnidadeNowModel == null)
            //{
            //    UnidadeNowModel = new UnidadeNowModel();

            especialidadeNowModel = new EspecialidadeNowModel();

            especialidadeNowModel.IdEspecialidade = 1;
            especialidadeNowModel.Descricao = Nome;

            ViewBag.NomeBag = Nome;
            //}

            return PartialView("_PesquisaModal", especialidadeNowModel);
        }

        public PartialViewResult CodigoBaseModal(int? idEspecialidade, string nome = "")
        {
            PartialViewResult result = null;
            try
            {
                var especialidadeNowModel = (EspecialidadeNowModel)Session["EspecialidadeNowModel"];
                //if (UnidadeNowModel == null)
                //{
                //    UnidadeNowModel = new UnidadeNowModel();

                especialidadeNowModel = new EspecialidadeNowModel();

                especialidadeNowModel.IdEspecialidade = idEspecialidade;
                especialidadeNowModel.Descricao = nome;



                result = PartialView("_CodigoBaseModal", especialidadeNowModel);

            }

            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);

            }

            return result;
        }





    }
}