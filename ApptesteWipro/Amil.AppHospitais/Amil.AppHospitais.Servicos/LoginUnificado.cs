using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;
using System.Net.Http.Formatting;
using Amil.AppHospitais.DTO;
using System.Configuration;

namespace Amil.AppHospitais.Servicos
{
    public class LoginUnificado : _BaseServicos
    {
        public LoginAutenticacaoResponse ValidarLogin(string email, string senha)
        {
            var postData = new { Email = email, Senha = senha };
            LoginAutenticacaoResponse result;
            using (var client = new HttpClient())
            {
                string baseUrl = ConfigurationManager.AppSettings["AMERICA_LOGIN_VALIDAR_LOGIN"];
                //baseUrl = "http://localhost/Americas.Login/api/ValidarLogin";
                client.BaseAddress = new Uri(baseUrl);
                //result = client.PostAsync("/AmericasLogin/api/ValidarLogin",
                result = client.PostAsync("/AmericasMedClientes/api/gettoken",
                                              postData,
                                              new JsonMediaTypeFormatter())
                                    .Result
                                    .Content
                                    .ReadAsAsync<LoginAutenticacaoResponse>()
                                    .Result;

            }
            return result;
        }

        public LoginAutenticacaoResponse EsqueciSenha(string email)
        {
            var postData = new { Email = email };
            LoginAutenticacaoResponse result;
            using (var client = new HttpClient())
            {
                string baseUrl = ConfigurationManager.AppSettings["AMERICA_LOGIN_ESQUECI_SENHA"];
                client.BaseAddress = new Uri(baseUrl);
                result = client.PostAsync("/AmericasLogin/api/EsqueciSenha",
                                              postData,
                                              new JsonMediaTypeFormatter())
                                    .Result
                                    .Content
                                    .ReadAsAsync<LoginAutenticacaoResponse>()
                                    .Result;
            }
            return result;
        }

        //AL - Alterar Senha
        public LoginAutenticacaoResponse AlterarSenha(string email, string nome, string senhaAntiga, string senhaNova)
        {
            var postData = new { Email = email, senhaAntiga = senhaAntiga, senhaNova = senhaNova };
            LoginAutenticacaoResponse result;
            using (var client = new HttpClient())
            {
                string baseUrl = ConfigurationManager.AppSettings["AMERICA_LOGIN_ALTERAR_SENHA"];
                client.BaseAddress = new Uri(baseUrl);
                var a = client.PostAsync(baseUrl,
                                              postData,
                                              new JsonMediaTypeFormatter()
                                          )
                                    .Result
                                    .Content
                                    .ReadAsAsync<bool>()
                                    ;

                result = new LoginAutenticacaoResponse { UsuarioValidado = (a.Exception == null ? true : false) };
            }
            return result;
        }

        public void Teste(object teste)
        {
            
        }

    }
}
