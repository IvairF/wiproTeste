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
    public class UsuarioController : BaseController
    {

        #region Actions

        public ActionResult Pesquisa(string limpar = "")
        {
            var UsuarioModel = (UsuarioModel)Session["usuarioModel"];
            if (UsuarioModel == null || limpar == "S")
            {
                UsuarioModel = new UsuarioModel();

                UsuarioModel.Id = 0;
                UsuarioModel.CPF = "";
                UsuarioModel.Nome = "";
                UsuarioModel.Login = "";
                UsuarioModel.Status = "T";
                UsuarioModel.Tipo = "T";
                UsuarioModel.PrimeiroAcesso = "S";
                UsuarioModel.IdConselho = 0;
                UsuarioModel.NumeroDocumento = "";

                Session["usuarioModel"] = null;

            }

            // Carregar Conselho profissional do usuário
            var conselhoClient = new ConselhoClient(Session);
            var lstConselho = conselhoClient.Listar();
            ViewBag.ConselhoBag = new SelectList(lstConselho, "ID", "SIGLA");
            
            return View(UsuarioModel);

        }

        [HttpPost]
        public ActionResult Pesquisa(FormCollection formCollection)
        {
            JsonResult result;

            try
            {
                var cpf = formCollection["cpf"];
                var login = formCollection["login"];
                var nome = formCollection["nome"];
                var tipo = formCollection["tipo"];
                //Conselho profissional
                var conselho = formCollection["conselho"] == "" ? 0 : Convert.ToInt32(formCollection["conselho"]);
                var documento = formCollection["documento"];

                string ativo = null;


                switch (formCollection["ativo"])
                {
                    case "A":
                        ativo = "A";
                        break;
                    case "I":
                        ativo = "I";
                        break;
                    case "B":
                        ativo = "B";
                        break;
                    default:
                        ativo = "T";
                        break;
                }               

                PagedResult<LoginUsuarioDTO> lstUsuarioDTO;
                var paging = formCollection.ToPagingDTO();

                var client = new UsuarioClient(Session);

                LoginUsuarioDTO usuarioDTO = new LoginUsuarioDTO();

                usuarioDTO.CPF = cpf;
                usuarioDTO.Email = login;
                usuarioDTO.Nome = nome;
                usuarioDTO.Status = ativo;
                usuarioDTO.UsuarioTipo = tipo;
                if (tipo != "T") usuarioDTO.FlUsuarioInterno = tipo == "I" ? true : false; 
                usuarioDTO.FK_CONSELHO = conselho;
                usuarioDTO.NO_DOCUMENTO = documento;
               
                var resultado = client.ListarUsuarioComConselho(usuarioDTO);

                lstUsuarioDTO = resultado.ToPagedResult(paging.Offset, paging.Limit, paging.Order);

                switch (formCollection["ativo"])
                {
                    case "A":
                        ViewBag.Ativo = "Ativo";
                        break;
                    case "I":
                        ViewBag.Ativo = "Inativo";
                        break;
                    case "B":
                        ViewBag.Ativo = "Bloqueado";
                        break;
                    default:
                        ViewBag.Ativo = "Todos";
                        break;
                }

                result = JsonFromPagedList(lstUsuarioDTO);

                var usuarioModel = new UsuarioModel();

                usuarioModel.Id = Convert.ToInt32(usuarioDTO.Id);
                usuarioModel.CPF = usuarioDTO.CPF;
                usuarioModel.Nome = usuarioDTO.Nome;
                usuarioModel.Login = usuarioDTO.Email;
                usuarioModel.Status = usuarioDTO.Status;
                usuarioModel.Tipo = usuarioDTO.UsuarioTipo;
                usuarioModel.PrimeiroAcesso = "N";
                usuarioModel.IdConselho = usuarioDTO.FK_CONSELHO;
                usuarioModel.NumeroDocumento = usuarioDTO.NO_DOCUMENTO;
                
                Session["usuarioModel"] = usuarioModel;
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
            var usuarioModel = new UsuarioModel();
            LoginUsuarioDTO usuarioDTO = new LoginUsuarioDTO();
            var idUsuario = DataParser.Parse(parameters["idUsuario"], 0);
            string emailUsuario;
            string tipo;

            var client = new UsuarioClient(Session);
            parameters.TryGetValue("tipo", out tipo);
            parameters.TryGetValue("emailUsuario", out emailUsuario);
            usuarioModel.Id = 0;

            CarregarDadosConselhoProfissional();

            if (idUsuario > 0)
            {
                usuarioDTO.Id = idUsuario;
                usuarioDTO.Email = emailUsuario;
                //List<LoginUsuarioDTO> resultado = client.Listar(usuarioDTO);
                LoginUsuarioDTO resultado = client.Obter(usuarioDTO);

                usuarioModel.Id = Convert.ToInt32(resultado.Id);
                usuarioModel.CPF = resultado.CPF;
                usuarioModel.Nome = resultado.Nome;
                usuarioModel.Login = resultado.Email;
                // usuário externo pelo face não possue data de nascimento
                usuarioModel.DataNascimento = resultado.DataNascimento == DateTime.MinValue ? new DateTime(1910,9,1) : resultado.DataNascimento;
                usuarioModel.Status = resultado.Status;
                usuarioModel.Tipo = tipo;

                ViewBag.StatusUsuarioBag = BuscarAtivoInativo(usuarioModel.Status);
            }
            else
            {
                ViewBag.StatusUsuarioBag = BuscarAtivoInativo(null);
            }

            return View(usuarioModel);
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
                var usuarioModel = JsonConvert.DeserializeObject<UsuarioModel>(json, dateTimeConverter);
                LoginUsuarioDTO usuario = new LoginUsuarioDTO();
                LoginUsuarioDTO usuarioPesquisa = new LoginUsuarioDTO();

                usuario.Id = usuarioModel.Id;
                usuario.CPF = usuarioModel.CPF;
                usuario.Nome = usuarioModel.Nome;
                usuario.Email = usuarioModel.Login;

                // só grava data de nascimento se for usuário interno ou se for externo e alterou a data default
                if ((usuarioModel.Tipo != "Externo") || (usuarioModel.Tipo == "Externo" && !usuarioModel.DataNascimento.Equals(new DateTime(1910,9,1))))
	            {
		            usuario.DataNascimento = usuarioModel.DataNascimento.Value;
	            }
                
                usuario.Status = usuarioModel.Status;
                usuarioPesquisa.CPF = usuarioModel.CPF;
                usuarioPesquisa.Email = usuarioModel.Login;

                // usado para não validar o CPF caso seja usuário externo
                usuarioPesquisa.UsuarioTipo = usuarioModel.Tipo;

                if (!Util.ValidarNome(usuario.Nome))
                {
                    ModelState.AddModelError("", "Nome inválido");
                    return Json(new { Result = 0, Erro = true, Mensagem = "Nome inválido" }, JsonRequestBehavior.AllowGet);
                }

                var usuarioClient = new UsuarioClient(Session);

                if (usuario.Id > 0)
                {
                    var idUsuario = usuarioClient.AlterarUsuario(usuario);
                    result = Json(new { Result = idUsuario, Erro = false }, JsonRequestBehavior.AllowGet);
                }
                else if ((usuarioPesquisa.UsuarioTipo == "Externo") || (!Util.ValidarCPF(usuario.CPF)))
                {
                    result = Json(new { Result = 0, Erro = true, Mensagem = "CPF Inválido !" }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    usuarioPesquisa = usuarioClient.Obter(usuarioPesquisa);
                    if (usuarioPesquisa == null)
                    {
                        var novoUsuario = usuarioClient.CadastrarUsuario(usuario);
                        result = Json(new { Result = novoUsuario, Erro = false }, JsonRequestBehavior.AllowGet);
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


        private void UsuarioValidate(UsuarioDTO usuarioDTO)
        {
            if (!Util.ValidarCPF(usuarioDTO.CPF))
                throw new Exception(Resource.CpfInvalido);
        }

        [HttpPost]
        public ActionResult AdicionarPerfis(FormCollection formCollection)
        {
            JsonResult result = null;
            try
            {

                var email = formCollection["email"];
                var json = formCollection["json"];
                var listaPerfilUsuarioSelecionado = JsonConvert.DeserializeObject<List<PerfilUsuarioDTO>>(json);

                var perfilUsuarioClient = new PerfilUsuarioClient(Session);
                var usuario = new PerfilUsuarioDTO
                {
                    Usuario = new LoginUsuarioDTO
                    {
                        Email = email
                    }

                };

                var listaAntigaPerfilUsuario = perfilUsuarioClient.BuscarUsuarioPerfil(usuario);

                var ListaCadastrar = new List<PerfilUsuarioDTO>(listaPerfilUsuarioSelecionado);
                var listaDeletar = new List<PerfilUsuarioDTO>(listaAntigaPerfilUsuario);

                foreach (var perfilUsuarioNovo in listaPerfilUsuarioSelecionado)
                {
                    foreach (var perfilUsuarioAntigo in listaAntigaPerfilUsuario)
                    {
                        if (perfilUsuarioAntigo.Perfil.Id == perfilUsuarioNovo.Perfil.Id)
                        {
                            ListaCadastrar.Remove(perfilUsuarioNovo);
                            listaDeletar.Remove(perfilUsuarioAntigo);
                            break;
                        }
                    }
                }

                foreach (var perfilUsuarioNovo in ListaCadastrar)
                {
                    perfilUsuarioClient.CadastrarUsuario(perfilUsuarioNovo);
                }

                foreach (var perfilUsuarioAntigo in listaDeletar)
                {
                    perfilUsuarioAntigo.Usuario = new LoginUsuarioDTO
                    {
                        Email = email
                    };
                    perfilUsuarioClient.DeletarUsuarioPerfil(perfilUsuarioAntigo);
                }

                result = Json(new { Result = true, Erro = false }, JsonRequestBehavior.AllowGet);
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


        public ActionResult ConselhoUsuario(FormCollection formCollection)
        {
            JsonResult result = null;
            try
            {
                var idUsuario = Convert.ToInt32(formCollection["idusuario"]);
                var flaginterno = Convert.ToInt32(formCollection["flginterno"]); 
                var client = new UsuarioConselhoClient(Session);

                // Editar Perfil
                if (idUsuario > 0)
                {
                    var conselho = new UsuarioConselhoDTO() { ID_USUARIO = idUsuario, FL_INTERNO = flaginterno };
                    // carrega o perfil 
                    var resultado = client.Listar(conselho);
                    var resultadoModel = new List<UsuarioConselhoModel>();

                    foreach (var item in resultado)
                    {
                        resultadoModel.Add( new UsuarioConselhoModel() { 
                            Conselho = item.CONSELHO.SIGLA + " - " + item.CONSELHO.DESCRICAO,
                            Documento = item.NO_DOCUMENTO,
                            Estado = item.ESTADO.SG_ESTADO,
                            Id = item.ID});
                    }

                    PagedResult<UsuarioConselhoModel> lstConselhoDTO;
                    var paging = formCollection.ToPagingDTO();

                    lstConselhoDTO = resultadoModel.ToPagedResult(paging.Offset, paging.Limit, paging.Order);

                    result = JsonFromPagedList(lstConselhoDTO);
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
        public ActionResult InclusaoConselhoUsuario(FormCollection formCollection)
        {
            JsonResult result = null;
            try
            {
                var idUsuario = Convert.ToInt32(formCollection["idUsuario"]);
                var flgInterno = Convert.ToInt32(formCollection["flgInterno"]);
                var idTipoConselho = Convert.ToInt32(formCollection["idTipoConselho"]);
                var idUFConselho = Convert.ToInt32(formCollection["idUFConselho"]);
                var numeroConselho = formCollection["numeroConselho"];

                var conselhoDTO = new UsuarioConselhoDTO();

                conselhoDTO.FL_INTERNO = Convert.ToInt32(flgInterno);
                conselhoDTO.ID_USUARIO = Convert.ToInt32(idUsuario);
                conselhoDTO.ESTADO = new EstadoDTO() { ID = idUFConselho };
                conselhoDTO.CONSELHO = new ConselhoDTO() { ID = idTipoConselho };
                conselhoDTO.NO_DOCUMENTO = numeroConselho;

                var client = new UsuarioConselhoClient(Session);

                client.CadastrarUsuarioConselho(conselhoDTO);

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }

        [HttpPost]
        public ActionResult ExclusaoConselhoUsuario(FormCollection formCollection)
        {
            JsonResult result = null;

            try
            {
                var idConselho = DataParser.Parse(formCollection["idConselho"], 0);
                var conselho = new UsuarioConselhoDTO() { ID = idConselho };
                var client = new UsuarioConselhoClient(Session);

                client.DeletarUsuarioConselho(conselho);

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


        #region private methods

        private void CarregarDadosConselhoProfissional()
        {
            var clientEstado = new EstadoClient(Session);
            var lstEstados = clientEstado.Listar();

            ViewBag.UF = new SelectList(lstEstados, "ID", "SG_ESTADO");

            // Carregar Conselho profissional 
            var conselhoClient = new ConselhoClient(Session);
            var lstConselho = conselhoClient.Listar();

            // monta o texto do dropdown
            foreach (var conselho in lstConselho) { conselho.SIGLA = conselho.SIGLA + " - " + conselho.DESCRICAO; }

            ViewBag.TipoConselho = new SelectList(lstConselho, "ID", "SIGLA");

        }


        public PartialViewResult CarregarPerfis(int Id, string Email)
        {
            var perfilClient = new PerfilClient(Session);
            var perfilUsuarioClient = new PerfilUsuarioClient(Session);

            var listaTodos = perfilClient.Listar(new PerfilDTO());
            var listaSemSelecionado = new List<PerfilDTO>(listaTodos);
            var usuario = new PerfilUsuarioDTO
            {
                Usuario = new LoginUsuarioDTO
                {
                    Email = Email
                }

            };

            var listaPerfilUsuario = perfilUsuarioClient.BuscarUsuarioPerfil(usuario);
            List<PerfilDTO> listaPerfisSelecionados = new List<PerfilDTO>();
            foreach (var perfilUsuarioSelecionado in listaPerfilUsuario)
            {
                listaPerfisSelecionados.Add(perfilUsuarioSelecionado.Perfil);
                foreach (var perfilUsuario in listaTodos)
                {
                    if (perfilUsuario.Codigo == perfilUsuarioSelecionado.Perfil.Codigo)
                    {
                        listaSemSelecionado.Remove(perfilUsuario);
                        break;
                    }
                }
            }

            ViewBag.ListaPerfisSelecionados = new MultiSelectList(listaPerfisSelecionados, "Id", "Descricao");
            ViewBag.ListaPerfisTodos = new MultiSelectList(listaSemSelecionado, "Id", "Descricao");

            return PartialView("_vinculoPerfis");
        }

        #endregion

    }
}