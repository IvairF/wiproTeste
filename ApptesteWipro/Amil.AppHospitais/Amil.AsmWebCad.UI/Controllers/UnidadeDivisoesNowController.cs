using Amil.AppHospitais.DTO;
using Amil.AsmWebCad.UI.Models;
using Amil.AsmWebCad.UI.Resources;
using Amil.AsmWebCad.Utils;
using Amil.AsmWebCad.UI.Helpers;
using System.Collections.Generic;
using Newtonsoft.Json;
using System;
using System.Linq;
using System.ServiceModel;
using System.Web.Mvc;
using Amil.AppHospitais.APIClient;
using Amil.AsmWebCad.UI.Helpers;
using Microsoft.Ajax.Utilities;
using System.Net;
using Newtonsoft.Json.Converters;

namespace Amil.AsmWebCad.UI.Controllers
{
    [SessionTimeout]
    public class UnidadeDivisoesNowController : BaseController
    {

        public ActionResult Pesquisa(string limpar = "", string modal = "")
        {
            var unidadeNowModel = (UnidadeNowModel)Session["unidadeNowModel"];
            if (modal == "S")
            {

                unidadeNowModel.Id = 1;
                unidadeNowModel.Nome = "TESTE";            

            }
            else if (unidadeNowModel == null || limpar == "S")
            {

                var UnidadeNowModel = new UnidadeNowModel();
                unidadeNowModel.Id = 0;
                unidadeNowModel.Nome = "";
                unidadeNowModel.PrimeiroAcesso = "S";

                Session["unidadeNowModel"] = null;


            }

            return View(unidadeNowModel);
        }

        [HttpPost]
        public ActionResult Pesquisa(FormCollection formCollection)
        {
            JsonResult result;

            try
            {
                var nome = formCollection["nome"];
                var codigoCorporativo = formCollection["codigoCorporativo"];
                int? ativo = null;


                switch (formCollection["ativo"])
                {
                    case "1":
                        ativo = 1;
                        break;
                    case "0":
                        ativo = 0;
                        break;
                    case "2":
                        ativo = 2;
                        break;
                }

                PagedResult<UnidadeAppNowDTO> lstUnidadeDTO;
                var paging = formCollection.ToPagingDTO();

                var client = new UnidadeNowClient(Session);

                UnidadeAppNowDTO unidadeDTO = new UnidadeAppNowDTO();
                UnidadeAppNowDTO unidadeAuxDTO = new UnidadeAppNowDTO();
                
                unidadeDTO.Nome = nome;
                unidadeDTO.CodigoCorporativo = codigoCorporativo;

                List<UnidadeAppNowDTO> Lista = new List<UnidadeAppNowDTO>();          
                

                unidadeAuxDTO.Descricao = "Hospital Geral Santa Gertudes";
                unidadeAuxDTO.Id = 1;
                unidadeAuxDTO.UF = "SP";
                unidadeAuxDTO.Base = "Moema";
                unidadeAuxDTO.CodigoCorporativo = "234567890";
                unidadeAuxDTO.CodigoBase = "1234";
                unidadeAuxDTO.Ativo = ativo;       

                //Lista.Add(new { Nome = "Hospital Geral Santa Gertudes", ID = 1, UF = "SP", CodigoBase = 1234 });
                Lista.Add(unidadeAuxDTO);

                var resultado = Lista;
                              
               // var resultado = client.Listar(unidadeDTO);
                lstUnidadeDTO = resultado.ToPagedResult(paging.Offset, paging.Limit, paging.Order);
                          

                result = JsonFromPagedList(lstUnidadeDTO);

                var unidadeNowModel = new UnidadeNowModel();

                unidadeNowModel.Id = 0;
                unidadeNowModel.Nome = unidadeDTO.Nome;
                unidadeNowModel.CodigoCorporativo = unidadeDTO.CodigoCorporativo;
                unidadeNowModel.Status = "T";
                unidadeNowModel.PrimeiroAcesso = "N";

                Session["unidadeNowModel"] = unidadeNowModel;
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
            var parameters = SecurityHelper.GetRequestParams();
            var unidadeNowModel = new UnidadeNowModel();
            UnidadeAppNowDTO unidadeDTO = new UnidadeAppNowDTO();
            var idUnidade = DataParser.Parse(parameters["idUnidade"], 0);
            string emailUsuario;
            string tipo;

            var client = new UnidadeNowClient(Session);
            unidadeNowModel.Id = 0;

            //List<UnidadeAppNowDTO> LstUF = client.CarregarUF();
            //ViewBag.UFBag = new SelectList(LstUF, "UF");

            //List<UnidadeAppNowDTO> LstRegional = client.Regional();
            //ViewBag.ReginalBag = new SelectList(LstRegional, "Regional");

            //List<UnidadeAppNowDTO> LstEscalaRisco = client.CarregaEscalaRisco();
            //ViewBag.ReginalBag = new SelectList(LstEscalaRisco, "EscalaRisco");  

            //List<UnidadeAppNowDTO> LstBase = client.CarregaBase();
            //ViewBag.ReginalBag = new SelectList(LstBase, "Regional");
           // ViewBag.StatusUsuarioBag = BuscarAtivoInativo(null);
           

            if (idUnidade > 0)
            {
                unidadeDTO.Id = idUnidade;
               
             
                //UnidadeAppNowDTO resultado = client.Obter(idUnidade);
                //unidadeNowModel.Nome = resultado.Nome;
                //unidadeNowModel.UF = "";
                //unidadeNowModel.Regional = "";
                //unidadeNowModel.EscalaRisco = "";
                //unidadeNowModel.Base = "";
                //unidadeNowModel.CodigoCorporativo = resultado.CodigoCorporativo;
                //unidadeNowModel.Status = "";
                //unidadeNowModel.Id = Convert.ToInt32(resultado.Id);



                unidadeNowModel.Nome = "Hospital Geral Santa Gertudes";
                unidadeNowModel.UF = "SP";
                unidadeNowModel.Regional = "WFP MOEMA";
                unidadeNowModel.EscalaRisco = "ESI Emergency severity index";
                unidadeNowModel.BaseWPD = "Hospital Geral Santa Gertudes - São Paulo";
                unidadeNowModel.CodigoCorporativo = "1234567890";
                unidadeNowModel.Status = "1";
                unidadeNowModel.Id = 1;
               

                var item1 = new SelectListItem { Text = "SP", Value = "SP", Selected = true };
                var itens = new List<SelectListItem> { item1 };
                ViewBag.UFBag = new SelectList(itens, "Value", "Text");

                var item2 = new SelectListItem { Text = "WFP MOEMA", Value = "WFP MOEMA", Selected = true };
                var itens2 = new List<SelectListItem> { item2 };
                ViewBag.RegionalBag = new SelectList(itens2, "Value", "Text");              
                
                
                ViewBag.StatusUsuarioBag = BuscarAtivoInativo(null);

               // ViewBag.UFBag = BuscarAtivoInativo(unidadeNowModel.Status);
            }
            else
            {

                var item1 = new SelectListItem { Text = "SP", Value = "0", Selected = true };
                var itens = new List<SelectListItem> { item1 };
                ViewBag.UFBag = new SelectList(itens, "Value", "Text");

                var item2 = new SelectListItem { Text = "WFP MOEMA", Value = "0", Selected = true };
                var itens2 = new List<SelectListItem> { item2 };
                ViewBag.RegionalBag = new SelectList(itens2, "Value", "Text");

                ViewBag.StatusUsuarioBag = BuscarAtivoInativo(null);
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

        
       
        private void UsuarioValidate(UsuarioDTO usuarioDTO)
        {
            if (!Util.ValidarCPF(usuarioDTO.CPF))
                throw new Exception(Resource.CpfInvalido);
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

        public PartialViewResult CarregarPesquisa(string Nome, string CodigoCorporativo)

        {        
            var UnidadeNowModel = (UnidadeNowModel)Session["unidadeNowModel"];
           //if (UnidadeNowModel == null)
            //{
            //    UnidadeNowModel = new UnidadeNowModel();

            UnidadeNowModel = new UnidadeNowModel();

            UnidadeNowModel.Id = 1;
            UnidadeNowModel.Nome = Nome;
            UnidadeNowModel.CodigoCorporativo = CodigoCorporativo;
            UnidadeNowModel.Status = "T";
            ViewBag.NomeBag = "TESTE";
            ViewBag.CodigoCorporativoBag = "1234567";

            //}



            return PartialView("_PesquisaModal");
        }
        
    }
}