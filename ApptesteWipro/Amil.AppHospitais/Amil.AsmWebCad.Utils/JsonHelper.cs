using Amil.Framework.Security.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Configuration;
using System.IO;
using System.Net;
using System.Text;

namespace Amil.AsmWebCad.Utils
{
    /// <summary>
    /// Classe de comunicação via JSON
    /// Possui métodos para envio e recebimento de requisições e 
    /// expõe métodos de serialização/desserialização de objetos    
    /// </summary>
    public sealed class JsonHelper
    {
        private readonly string _endpointName;
        private readonly string _systemName;
        private readonly string _systemVersion;
        private const string SystemVersionHttpHeader = "X-AMIL-SYSTEM-VERSION";
        private const string SystemIdHttpHeader = "X-AMIL-SYSTEM-ID";

        /// <summary>
        /// Construtor da classe
        /// </summary>
        /// <param name="endpointName">Nome do endpoint configurado no App.Config ou Web.Config</param>
        /// <param name="systemName"></param>
        /// <param name="systemVersion"></param>
        public JsonHelper(string endpointName, string systemName, string systemVersion)
        {
            _endpointName = endpointName;
            _systemName = systemName;
            _systemVersion = systemVersion;
        }

        /// <summary>
        /// Envia a requisição JSON para o servidor configurado no endpoint
        /// </summary>
        /// <param name="jsonData">String JSON a ser enviada</param>
        /// <param name="timeout">Tempo de espera do retorno (em milissegundos). 
        /// Configurável pelo App.Config ou Web.Config (Chave: "JSONRequest.Timeout").
        /// Default = 8000</param>
        /// <returns>Retorna a requisição</returns>
        public HttpWebRequest SendRequest(string jsonData, int timeout = 0)
        {

            if (timeout == 0)
            {
                if (!int.TryParse(ConfigurationManager.AppSettings["JSONRequest.Timeout"], out timeout))
                {
                    timeout = 8000;
                }
            }

            var endpoint = ConfigurationManager.AppSettings[_endpointName];
            var webRequest = (HttpWebRequest)WebRequest.Create(new Uri(endpoint));

            try
            {

                webRequest.Method = WebRequestMethods.Http.Post;
                webRequest.ContentLength = jsonData.Length;
                webRequest.Timeout = timeout;
                webRequest.ContentType = "application/x-www-form-urlencoded";

                webRequest.Headers[SystemIdHttpHeader] = _systemName;
                webRequest.Headers[SystemVersionHttpHeader] = _systemVersion;

                var writer = new StreamWriter(webRequest.GetRequestStream());
                writer.Write(jsonData);
                writer.Close();
                return webRequest;
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        /// <summary>
        /// Recebe resposta JSON da requisição enviada pelo SendRequest
        /// </summary>
        /// <param name="webRequest">Requisição JSON enviada para o servidor</param>
        /// <returns>Retorna a string JSON devolvida pelo servidor</returns>
        public string GetResponse(HttpWebRequest webRequest)
        {
            long iCaracter;
            var sBuilder = new StringBuilder();

            var webResponse = (HttpWebResponse)webRequest.GetResponse();
            var reader = new StreamReader(webResponse.GetResponseStream(), Encoding.Default);

            while ((iCaracter = reader.Read()) != -1) {
                var caracter = (char)iCaracter;
                sBuilder.Append(caracter);
            }

            var jsonResponse = sBuilder.ToString().Normalize().SanitizerJsonInput();
            webResponse.Close();
            return jsonResponse;
        }

        /// <summary>
        /// Recebe resposta JSON da requisição enviada pelo SendRequest já desserializada para a classe T
        /// </summary>
        /// <typeparam name="T">Classe do objeto devolvido pelo servidor</typeparam>
        /// <param name="webRequest">Requisição JSON enviada para o servidor</param>
        /// <returns>Retorna o objeto devolvido pelo servidor na classe T</returns>
        public T GetResponse<T>(HttpWebRequest webRequest)
        {
            return JsonConvert.DeserializeObject<T>(GetResponse(webRequest));
        }

        /// <summary>
        /// Desserializa objeto JSON
        /// </summary>
        /// <param name="value">String JSON do objeto</param>
        /// <returns>Retorna o objeto desserializado</returns>
        public static object DeserializeObject(string value)
        {
            return JsonConvert.DeserializeObject(value.SanitizerJsonInput());
        }

        /// <summary>
        /// Desserializa objeto JSON para a classe T
        /// </summary>
        /// <typeparam name="T">Classe do objeto</typeparam>
        /// <param name="value">String JSON do objeto</param>
        /// <returns>Retorna o objeto desserializado na classe T</returns>
        public static T DeserializeObject<T>(string value)
        {
            return JsonConvert.DeserializeObject<T>(value.SanitizerJsonInput());
        }

        /// <summary>
        /// Serializa o objeto JSON        
        /// </summary>
        /// <param name="value">Objeto a ser serializado</param>
        /// <returns>Retorna string JSON referente ao objeto</returns>
        public static string SerializeObject(object value)
        {
            var serSettings = new JsonSerializerSettings {StringEscapeHandling = StringEscapeHandling.EscapeHtml};
            return JsonConvert.SerializeObject(value, serSettings);
        }

        public static string SerializeObjectWithCamelCase(object value)
        {
            var jsonSerializerSettings = new JsonSerializerSettings { ContractResolver = new CamelCasePropertyNamesContractResolver() };
            return JsonConvert.SerializeObject(value, jsonSerializerSettings);
        }
    }
}
