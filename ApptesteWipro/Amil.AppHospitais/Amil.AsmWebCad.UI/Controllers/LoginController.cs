using Amil.AsmWebCad.UI.Models;
using Amil.AsmWebCad.UI.Resources;
using Amil.AsmWebCad.Utils;
using Newtonsoft.Json;
using System;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.ServiceModel;
using System.Web.Mvc;
using System.Web.Security;
using Amil.AppHospitais.DTO;
using Amil.AppHospitais.APIClient;

namespace Amil.AsmWebCad.UI.Controllers
{
    [AllowAnonymous]
    public class LoginController : BaseController
    {
        public ActionResult Login()
        {
            if (TempData["ErroAlterarSenha"] != null)
            {
                ViewBag.ErroAlterarSenha = TempData["ErroAlterarSenha"].ToString();
                return View();
            }

            if (Request.IsAjaxRequest())
                return new HttpStatusCodeResult(403);

            if(Session["Token"] != null && Session["Email"] != null)
            {
                var client = new LoginClient();
                Boolean result = client.ValidaToken(Session["Email"].ToString(), Session["Token"].ToString());
                if(result)
                    return RedirectToAction("Manutencao", "TelaPrincipal");

            }

            return View();
        }

        [HttpPost]
        public ActionResult Login(LoginModel loginModel, string returnUrl)//, string token)
        {
            

            var client = new LoginClient();
            LoginAutenticacaoResponse result = client.GetToken(new LoginUsuarioDTO() { Email = loginModel.Login, Senha = loginModel.Senha , SistemaOrigem = "WEBCAD"});

            if (result != null && result.FlUsuarioInterno && result.UsuarioValidado && result.Token != null && string.IsNullOrEmpty(result.FlAlterarSenha))
            {
                TempData["NomeUsuario"] = result.Nome;
                Session["Email"] = result.Email;
                Session["Token"] = result.Token;
                return RedirectToAction("Manutencao", "TelaPrincipal");
            }else if (result != null && result.FlUsuarioInterno && result.UsuarioValidado && result.FlAlterarSenha == "True")
                return RedirectToAction("AlteraSenha", new { email = result.Email });
            else if (result != null && !result.FlUsuarioInterno)
                    ModelState.AddModelError("", Resource.UsuarioSemPerfil);
            else if (result != null && result.Token == null )
                ModelState.AddModelError("", Resource.AcessoNegado);
            else if (result == null  || (result.FlUsuarioInterno && !result.UsuarioValidado))
                ModelState.AddModelError("", Resource.UsuarioSenhaInvalidos);
           

            return View(loginModel);
        }

        public ActionResult LogOut()
        {
            //   LockHelpers.UnlockProfissional();
            FormsAuthentication.SignOut();
            Session["Token"] = null;
            return RedirectToAction("Login", "Login", null);
           
        }

        public ActionResult AlteraSenha(string email)
        {
            return View(new AlterarSenhaModel { Login = email });
        }


        [HttpPost]
        public ActionResult AlteraSenha(AlterarSenhaModel alterarSenhaModel)//, string token)
        {
            try
            {
                //ValidarToken(token);
                //ViewBag.Token = GerarToken();

                if (!Util.ValidaSenha(alterarSenhaModel.NovaSenha))
                    ModelState.AddModelError("", Resource.ControleSenha);
                else if (alterarSenhaModel.Senha == alterarSenhaModel.NovaSenha)
                    ModelState.AddModelError("", Resource.ValidarSenhaAntigaComNova);

                if (!ModelState.IsValid)
                    return View(alterarSenhaModel);


                var client = new LoginClient();
                Boolean result = client.AlterarSenha(alterarSenhaModel.Login, alterarSenhaModel.Senha, alterarSenhaModel.NovaSenha);
                if (result)
                    return Login(new LoginModel { Login = alterarSenhaModel.Login, Senha = alterarSenhaModel.NovaSenha }, null);
                else
                {
                    ModelState.AddModelError("", "Não foi possível alterar a senha. Confira as senhas digitadas.");
                    return this.AlteraSenha(alterarSenhaModel.Login);
                }
                    
            }

            catch (IndexOutOfRangeException ex)
            {
                ModelState.AddModelError("", ex.Message);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
            }
            return View(alterarSenhaModel);
        }

        public ActionResult CadastraLogin()
        {
            //ViewBag.Token = GerarToken();

            CarregaViewBag();

            return View();
        }

        [HttpPost]
        public ActionResult CadastraLogin(CadastraLoginModel cadastraLoginModel)//, string token)
        {
            try
            {
                //ValidarToken(token);
                //ViewBag.Token = GerarToken();

                CarregaViewBag();

                cadastraLoginModel.Nome = cadastraLoginModel.Nome.ToUpper();

                if (!Util.ValidaSenha(cadastraLoginModel.Senha))
                {
                    ModelState.AddModelError("", Resource.ControleSenha);
                    return View(cadastraLoginModel);
                }

                if (!Util.ValidarCPF(cadastraLoginModel.CPF))
                    throw new Exception("");

                if (!ModelState.IsValid)
                    return View(cadastraLoginModel);

                ViewBag.Sucesso = false;

                /*  var profissionalUsuarioDTO = new ProfissionalUsuarioDTO();

                  var usuarioDTO = ModelHelper.FromTo<CadastraLoginModel, UsuarioDTO>(cadastraLoginModel);
                  usuarioDTO.Login = usuarioDTO.Email = cadastraLoginModel.Email;
                  usuarioDTO.Senha = PassEncryption.EncryptString(cadastraLoginModel.Senha);
                  profissionalUsuarioDTO.Usuario = usuarioDTO;
                  profissionalUsuarioDTO.NumeroConselho = cadastraLoginModel.Conselho;
                  profissionalUsuarioDTO.TipoConselho =
                      new TipoConselhoDTO { Id = Convert.ToInt32(cadastraLoginModel.TipoConselho) };
                  List<UFDTO> lstUF;

                  using (var client = new CNPSService.CNPSClient())
                      lstUF = client.ListarUF();

                  var ufSigla = lstUF.FirstOrDefault(a => a.Id == Convert.ToInt32(cadastraLoginModel.UF));
                  if (ufSigla != null)
                      profissionalUsuarioDTO.UFConselho = new UFProfissionalDTO
                      {
                          IdUFConselho = Convert.ToInt32(cadastraLoginModel.UF),
                          SiglaUFConselho = ufSigla.Sigla
                      };

                  long usuarioId;

                  using (var client = new CNPSService.CNPSClient())
                      usuarioId = client.GravarLogin(profissionalUsuarioDTO);

                  if (usuarioId == 0)
                      throw new Exception(Resource.NaoFoiPossivelRealizarOperacao);
                  */
                ViewBag.Sucesso = true;
            }
            catch (IndexOutOfRangeException ex)
            {
                if (string.Equals(ex.Message, "CPF ou Login já cadastrado.", StringComparison.CurrentCultureIgnoreCase))
                {
                    ViewBag.MyErrorMessage = "Erro";
                }
                else
                {
                    ViewBag.MyErrorMessage = null;
                    ModelState.AddModelError("", ex.Message);

                }
            }
            catch (FaultException ex)
            {
                ViewBag.MyErrorMessage = null;
                /*   if (ex is FaultException<ErroDTO>)
                   {
                       var detail = ((FaultException<ErroDTO>)ex).Detail;
                       if (string.Equals(detail.Descricao, "Já existe um cadastro com esse CPF.", StringComparison.CurrentCultureIgnoreCase))
                           ViewBag.MyErrorMessage = "Erro";
                       else
                           ViewBag.MyErrorMessage = null;

                       ModelState.AddModelError("", detail.Descricao);
                   }
                   else
                   {
                       ModelState.AddModelError("", ex.Message);
                   }*/
            }
            catch (Exception ex)
            {
                if (ex.Message.ToUpper() == "CPF ou Login já cadastrado.".ToUpper())
                {
                    ViewBag.MyErrorMessage = "Erro";
                }
                else
                {
                    ViewBag.MyErrorMessage = null;
                    ModelState.AddModelError("", ex.Message);
                }
            }
            return View(cadastraLoginModel);
        }

        public ActionResult EsqueciSenha()
        {
            //ViewBag.Token = GerarToken();
            return View();
        }

        [HttpPost]
        public ActionResult EsqueciSenha(EsqueciSenhaModel esqueciSenhaModel)//, string token)
        {
            try
            {
                var client = new LoginClient();
                LoginAutenticacaoResponse usuario = client.EsqueciSenha(esqueciSenhaModel.Email);
                if (usuario.FlAlterarSenha == "True")
                    ModelState.AddModelError("", string.Format("{0} {1}", Resource.SenhaEnviada, esqueciSenhaModel.Email));
                else
                    ModelState.AddModelError("", string.Format("{0}", Resource.EmailNaoCadastrado));
            }
            catch (IndexOutOfRangeException ex)
            {
                ModelState.AddModelError("", ex.Message);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
            }
            return View(esqueciSenhaModel);
        }

        private void CarregaViewBag()
        {
            /*  List<UFDTO> lstUF;
              List<TipoConselhoDTO> lstTipoConselho;

              using (var client = new CNPSService.CNPSClient())
              {
                  lstUF = client.ListarUF();
                  lstTipoConselho = client.ListarTipoConselho();
              }

              ViewBag.UF = new SelectList(lstUF, "Id", "Descricao");
              ViewBag.TipoConselho = new SelectList(lstTipoConselho, "Id", "Descricao");*/
        }
    }
    public class Teste
    {

    }
}
