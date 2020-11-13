using System;
using System.Web.Mvc;
using System.Linq;
using Amil.AppHospitais.DTO;
using Amil.AppHospitais.APIClient;
using Amil.AsmWebCad.UI.Models;
using Amil.AsmWebCad.UI.Resources;
using Amil.AsmWebCad.Utils;
using System.Collections.Generic;
using Newtonsoft.Json;
using Amil.AsmWebCad.UI.Helpers;

namespace Amil.AsmWebCad.UI.Controllers
{
    public class PerfilController : BaseController
    {
        [SessionTimeout]
        public ActionResult Pesquisa(string limpar = "")
        {
            var perfilModel = (PerfilModel)Session["perfilModel"];
            JsonResult result;

            try
            {
                var client = new PerfilClient(Session);
                var lstSistemaDTO = new List<SistemaDTO>();
                var sistemaClient = new SistemaClient(Session);
                var sistema = new SistemaDTO();

                lstSistemaDTO = sistemaClient.Listar(sistema);

                ViewBag.SistemaBag = new SelectList(lstSistemaDTO, "Id", "Descricao");

                if (perfilModel == null || limpar == "S")
                {
                    var novoPerfilModel = new PerfilModel()
                    {
                        Id = 0,
                        Codigo = "",
                        Descricao = "",
                        IdSistema = 0,
                        PrimeiroAcesso = "S" //2804

                    };

                    return View(novoPerfilModel);
                }

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return View(perfilModel);

        }

        [SessionTimeout]
        [HttpPost]
        public ActionResult Pesquisa(FormCollection formCollection)
        {
            JsonResult result;

            try
            {
                var descricao = string.IsNullOrEmpty(formCollection["descricao"]) ? string.Empty : formCollection["descricao"];
                var codigo = string.IsNullOrEmpty(formCollection["codigo"]) ? string.Empty : formCollection["codigo"];
                var sistema = string.IsNullOrEmpty(formCollection["sistema"]) ? "0" : formCollection["sistema"]; 

                PerfilDTO filtroPerfil = new PerfilDTO()
                {
                    IdSistema = Convert.ToInt32(sistema),
                    Codigo = codigo,
                    Descricao = descricao
                };

                PagedResult<PerfilDTO> lstPerfilDTO;

                var client = new PerfilClient(Session);
                var lista = client.Listar(filtroPerfil);
                var paging = formCollection.ToPagingDTO();

                foreach (var perfil in lista)
                {
                    perfil.Sistema = new SistemaClient(Session).Obter(new SistemaDTO() { Id = perfil.IdSistema }).Descricao;
                }

                lstPerfilDTO = lista.ToPagedResult(paging.Offset, paging.Limit, paging.Order);

                result = JsonFromPagedList(lstPerfilDTO);

                var perfilModel = new PerfilModel()
                {
                    Id = filtroPerfil.Id,
                    Codigo = filtroPerfil.Codigo,
                    Descricao = filtroPerfil.Descricao,
                    IdSistema = filtroPerfil.IdSistema,
                    PrimeiroAcesso = "N"   //2804
                };

                Session["perfilModel"] = perfilModel;
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }

        [SessionTimeout]
        [HttpPost]
        public ActionResult Manutencao(FormCollection formCollection)
        {
            JsonResult result;

            try
            {
                var json = formCollection["json"];
                var perfilModel = JsonConvert.DeserializeObject<PerfilModel>(json);
                var client = new PerfilClient(Session);

                var perfilPesquisa = new PerfilDTO
                {
                    Codigo = perfilModel.Codigo
                };

                var perfilExiste = client.ValidarNovo(perfilPesquisa);

                var perfilDTO = new PerfilDTO();

                perfilDTO.Id = perfilModel.Id;
                perfilDTO.Codigo = perfilModel.Codigo;
                perfilDTO.Descricao = perfilModel.Descricao;
                perfilDTO.IdSistema = perfilModel.IdSistema;

                if (perfilExiste && perfilModel.Id == 0)
                {
                    result = Json(new { Result = 0, Erro = true, Mensagem = "Código de Perfil (" + perfilModel.Codigo + ") já cadastrado." }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    var novoPerfil = client.Gravar(perfilDTO);

                    result = Json(new { Result = novoPerfil, Erro = false }, JsonRequestBehavior.AllowGet);
                }

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }
 
            return result;
        }

        [SessionTimeout]
        public ActionResult Manutencao()
        {
            var perfilViewModel = new CadastraPerfilViewModel();

            try
            {
                var parameters = SecurityHelper.GetRequestParams();
                var idPerfil = DataParser.Parse(parameters["idPerfil"], 0);
                var client = new PerfilClient(Session);

                //var perfilModel = new PerfilModel();
                perfilViewModel.Id = 0;

                // Editar Perfil
                if (idPerfil > 0)
                {
                    // carrega o perfil e popula os campos
                    var perfilClient = new PerfilClient(Session);
                    var perfilDTO = perfilClient.Obter(new PerfilDTO(){ Id = idPerfil});

                    perfilViewModel.Id = perfilDTO.Id;
                    perfilViewModel.IdSistema = perfilDTO.IdSistema;
                    perfilViewModel.Descricao = perfilDTO.Descricao;
                    perfilViewModel.Codigo = perfilDTO.Codigo;
                }

                ViewBag.SistemaBag = CarregarSistemas(perfilViewModel.Id);

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
            }

            return View(perfilViewModel);
        }


        private SelectList CarregarSistemas(int valorSelecionado)
        {
            var itens = new List<SelectListItem>();
            var lstSistemaDTO = new List<SistemaDTO>();
            var sistemaClient = new SistemaClient(Session);
            var sistema = new SistemaDTO();

            lstSistemaDTO = sistemaClient.Listar(sistema);

            foreach (var sistemaDTO in lstSistemaDTO)
            {
                itens.Add(new SelectListItem
                {
                    Value = sistemaDTO.Id.ToString(),
                    Text = sistemaDTO.Descricao,
                    Selected = sistemaDTO.Id == valorSelecionado
                });
            }

            return new SelectList(itens, "Value", "Text", valorSelecionado);
        }

        [HttpPost]
        public ActionResult Exclusao(FormCollection formCollection)
        {
            JsonResult result;

            try
            {
                var idPerfil = DataParser.Parse(formCollection["idPerfil"], 0);
                var perfil = new PerfilDTO() { Id = idPerfil };
                var client = new PerfilClient(Session);
                var perfilModulo = new PerfilClient(Session).Obter(new PerfilDTO() { Id = idPerfil });

                var perfilModuloClient = new PerfilModuloSistemaClient(Session);
                var listaSelecionados = perfilModuloClient.ListarPorPerfil(new PerfilModuloSistemaDTO() { Perfil = perfilModulo });

                if (listaSelecionados.Count == 0)
                {
                    client.Excluir(perfil);

                    result = Json(new { Result = 1, Erro = false }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    result = Json(new { Result = 0, Erro = true, Mensagem = "Não foi possivel excluir, Existem Modulos associados a este perfil." }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }

        [SessionTimeout]
        public PartialViewResult CarregarModulos(int Id)
        {
            var perfilModulo = new PerfilClient(Session).Obter(new PerfilDTO() { Id = Id });

            int idSistema = perfilModulo.IdSistema;
            // listar os modulos do sistema
            var moduloClient = new ModuloSistemaClient(Session);
            var listaTodos = moduloClient.Listar(idSistema);

            // todos os modulos do perfil
            var perfilModuloClient = new PerfilModuloSistemaClient(Session);
            var listaSelecionados = perfilModuloClient.ListarPorPerfil(new PerfilModuloSistemaDTO() { Perfil = perfilModulo });

            if (listaTodos == null) listaTodos = new List<ModuloDTO>();

            var listaNaoSelecionado = new List<ModuloDTO>(listaTodos);

            List<ModuloDTO> listaModuloSelecionados = new List<ModuloDTO>();

            foreach (var moduloSelecionado in listaSelecionados)
            {
                listaModuloSelecionados.Add(moduloSelecionado.ModuloSistema);
                foreach (var modulo in listaTodos)
                {
                    if (modulo.Id == moduloSelecionado.ModuloSistema.Id)
                    {
                        listaNaoSelecionado.Remove(modulo);
                        break;
                    }
                }
            }

            ViewBag.ListaModulosTodos = new MultiSelectList(listaNaoSelecionado, "Id", "Descricao");
            ViewBag.ListaModulosSelecionados = new MultiSelectList(listaSelecionados, "ModuloSistema.Id", "ModuloSistema.Descricao");

            return PartialView("_vinculoModulos");
        }

        [SessionTimeout]
        [HttpPost]
        public ActionResult SalvarModulos(FormCollection formCollection)
        {
            JsonResult result;

            try
            {
                var IdSistema = formCollection["idsistema"];
                var IdPerfil = formCollection["idperfil"];

                var modulosNaoSelecionados = string.IsNullOrEmpty(formCollection["modulos"])
                    ? string.Empty
                    : formCollection["modulos"];//.SanitizerHtmlInput();

                var modulosSelecionados = string.IsNullOrEmpty(formCollection["modulosSelecionados"])
                    ? string.Empty
                    : formCollection["modulosSelecionados"];//.SanitizerHtmlInput();

                var listaSelecionados = JsonConvert.DeserializeObject<List<ModuloDTO>>(modulosSelecionados);
                var listaCadastrar = new List<ModuloDTO>(listaSelecionados);

                var perfilModulo = new PerfilModuloSistemaDTO() { Perfil = new PerfilDTO() { Id = Convert.ToInt32(IdPerfil) } };

                // todos os modulos do sistema do perfil
                var perfilModuloClient = new PerfilModuloSistemaClient(Session);
                var listaAntigaSelecionados = perfilModuloClient.ListarPorPerfil(perfilModulo);
                var listaDeletar = new List<PerfilModuloSistemaDTO>(listaAntigaSelecionados);

                foreach (var moduloNovo in listaSelecionados)
                {
                    foreach (var moduloAntigo in listaAntigaSelecionados)
                    {
                        if (moduloAntigo.ModuloSistema.Id == moduloNovo.Id)
                        {
                            listaCadastrar.Remove(moduloNovo);
                            listaDeletar.Remove(moduloAntigo);
                            break;
                        }
                    }
                }

                // inclue os novos modulos
                foreach (var modulo in listaCadastrar)
                {
                    PerfilModuloSistemaDTO moduloPerfil = new PerfilModuloSistemaDTO()
                    {
                        ModuloSistema = new ModuloDTO() { Id = modulo.Id },
                        Perfil = new PerfilDTO() { Id = Convert.ToInt32(IdPerfil) }
                    };

                    perfilModuloClient.Inserir(moduloPerfil);

                }

                // Exclui os modulos que estavam selecionados
                var excluiuComSucesso = true;
                foreach (var perfilModuloSistema in listaDeletar)
                {
                    if (!perfilModuloClient.Excluir(perfilModuloSistema))
                        excluiuComSucesso = false;
                }

                result =  Json(new { Result = excluiuComSucesso, Erro = false }, JsonRequestBehavior.AllowGet); ;
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;

        }

        [SessionTimeout]
        public ActionResult ValidarAcesso()
        {
            JsonResult result;

            try
            {
                PerfilDTO filtroPerfil = new PerfilDTO()
                {
                    IdSistema = 1,
                    Codigo = "a",
                    Descricao = "b"
                };

                var client = new PerfilClient(Session);
                var lista = client.Listar(filtroPerfil);

                result = Json(new { Result = "true", Erro = false, Mensagem = "Acesso OK" }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }


        [SessionTimeout]
        public ActionResult UsuariosPerfil(FormCollection formCollection)
        {
            JsonResult result;
            UsuarioPerfilModel usuariosPerfil = new UsuarioPerfilModel();
            try
            {
                var parameters = SecurityHelper.GetRequestParams();
                var idPerfil = DataParser.Parse(parameters["idperfil"], 0);
                var client = new PerfilClient(Session);


                // Editar Perfil
                if (idPerfil > 0)
                {
                    // carrega o perfil 
                    var perfilDTO = client.Obter(new PerfilDTO() { Id = Convert.ToInt32(idPerfil) });
                    var sistemaClient = new SistemaClient(Session);
                    var sistema = new SistemaDTO();
                    sistema.Id = perfilDTO.IdSistema;
                    sistema = sistemaClient.Obter(sistema);

                    usuariosPerfil.Id = perfilDTO.Id;
                    usuariosPerfil.CodigoPerfil = perfilDTO.Codigo;
                    usuariosPerfil.DescricaoPerfil = perfilDTO.Descricao;
                    usuariosPerfil.Sistema = sistema.Descricao;
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
            }

            return View(usuariosPerfil);
        }

        [SessionTimeout]
        public ActionResult PesquisaUsuarioPerfil(FormCollection formCollection)
        {
            JsonResult result;

            try
            {
                var idperfil = string.IsNullOrEmpty(formCollection["idperfil"]) ? string.Empty : formCollection["idperfil"];

                PerfilDTO filtroPerfil = new PerfilDTO()
                {
                    Id = Convert.ToInt32(idperfil),
                };

                PagedResult<LoginUsuarioDTO> lstUsuarioDTO;
                var paging = formCollection.ToPagingDTO();
                var client = new UsuarioClient(Session);
                var resultado = client.ListarPorPerfil(filtroPerfil);

                lstUsuarioDTO = resultado.ToPagedResult(paging.Offset, 10, paging.Order);

                result = JsonFromPagedList(lstUsuarioDTO);

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;
        }

        [SessionTimeout]
        [HttpPost]
        public ActionResult ExclusaoUsuario(FormCollection formCollection)
        {
            var idUsuario = DataParser.Parse(formCollection["idUsuario"], 0);
            var idPerfil = DataParser.Parse(formCollection["idPerfil"], 0);
            JsonResult result;
            result = Json(new { Result = 0, Erro = true, Mensagem = "ex.Message" }, JsonRequestBehavior.AllowGet);
            try
            {

                var client = new PerfilUsuarioClient(Session);

                var perfilUsuarioDTO = new PerfilUsuarioDTO()
                {
                    Perfil = new PerfilDTO()
                    {
                        Id = idPerfil
                    },
                    Usuario = new LoginUsuarioDTO()
                    {
                        Id = idUsuario
                    }
                };

                perfilUsuarioDTO = client.Obter(perfilUsuarioDTO);

                client.DeletarUsuarioPerfil(perfilUsuarioDTO);

                result = Json(new { Result = 1, Erro = false }, JsonRequestBehavior.AllowGet);

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