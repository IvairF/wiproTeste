
namespace Amil.AsmWebCad.Utils
{
    public static class CentralNotificacoes
    {
        /*    /// <summary>
            /// Método que envia E-mail ou SMS ao Barramento da central de notificações de forma assincrona.
            /// </summary>
            /// <param name="headerDTO">Header da requisição</param>
            /// <param name="bodyDTO">Body da Requisição</param>
            /// <returns>Código da mensagem gerado pelo barramento</returns>
            public static async Task<int> EnviarNotificacaoAsync(HeaderDTO headerDTO, BodyDTO bodyDTO)
            {
                var mensagemId = 0;
                try
                {
                    var pathUri = ConfigurationManager.AppSettings["UriCentralNotificacao"];
                    var resource = ConfigurationManager.AppSettings["ResourceEmail"];

                    var client = new HttpClient { BaseAddress = new Uri(pathUri) };
                    client.DefaultRequestHeaders.Accept.Clear();
                    client.DefaultRequestHeaders.Add("x-msg-priority", headerDTO.Prioridade.ToString());
                    client.DefaultRequestHeaders.Add("Token", headerDTO.Token);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                    var response = await client.PostAsJsonAsync(resource, bodyDTO);

                    if (response.IsSuccessStatusCode)
                    {
                        var contents = await response.Content.ReadAsStringAsync();
                        dynamic dados = JObject.Parse(contents);
                        mensagemId = Convert.ToInt32(dados.mensagem_ID);
                    }
                }
                catch (ArgumentNullException ex)
                {
                    string erro = ex.Message;
                }
                catch (Exception ex)
                {
                    string erro = ex.Message;
                }

                return mensagemId;
            }

            public static async Task<int> LinkIntegracaoAsync<T>(string codigoIntegracao, string resource, T body)
                where T : class
            {
                if (string.IsNullOrWhiteSpace(codigoIntegracao))
                    throw new ArgumentNullException("codigoIntegracao");

                var codigo = 0;

                try
                {

                    var pathUri = ConfigurationManager.AppSettings["UriItegracao"];

                    System.Net.ServicePointManager.ServerCertificateValidationCallback += delegate { return true; };

                    var url = pathUri + codigoIntegracao + resource;

                    var httpWebRequest = (HttpWebRequest)WebRequest.Create(url);
                    httpWebRequest.ContentType = "text/json";
                    httpWebRequest.Method = "POST";

                    using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
                    {
                        streamWriter.Write(body);
                    }

                    var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

                    return (int)httpResponse.StatusCode;
 
                }
                catch (ArgumentNullException ex)
                {
                    string erro = ex.Message;
                }
                catch (Exception ex)
                {
                    string erro = ex.Message;
                }

                return codigo;
            }

            /// <summary>
            /// Método que envia E-mail ou SMS ao Barramento da central de notificações.
            /// </summary>
            /// <param name="headerDTO">Header</param>
            /// <param name="bodyDTO">Body</param>
            /// <returns>Código da mensagem enviado pelo barramento</returns>
            public static int EnviarNotificacao(HeaderDTO headerDTO, BodyDTO bodyDTO)
            {
                var mensagemId = EnviarNotificacaoAsync(headerDTO, bodyDTO).Result;
                return mensagemId;
            }

            public static int LinkIntegracao<T>(string codigoIntegracao, string resource, T body)
                where T : class
            {
                return LinkIntegracaoAsync(codigoIntegracao, resource, body).Result;
            }*/
    }
}
