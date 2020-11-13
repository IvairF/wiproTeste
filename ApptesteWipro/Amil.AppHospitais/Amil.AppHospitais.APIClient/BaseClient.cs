using Amil.AppHospitais.DTO;
using Newtonsoft.Json;
using RestSharp;
using RestSharp.Deserializers;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Web;

namespace Amil.AppHospitais.APIClient
{
    public class BaseClient
    {
        private RestClient _client;
        protected RestClient Client
        {
            get
            {
                if (_client == null)
                {
                    _client = new RestClient(UrlBase);
                    _client.AddHandler("*", new JsonDeserializer());
                    _client.AddHandler("text/html", new JsonDeserializer());
                }

                return _client;
            }
        }

        protected readonly string UrlBase;
        protected readonly HttpSessionStateBase Session;

        public BaseClient()
            : this(ConfigurationManager.AppSettings["CaminhoAppHospitaisApi"], null)
        {

        }

        public BaseClient(string urlBase)
            : this(urlBase, null)
        {

        }

        public BaseClient(HttpSessionStateBase session)
            : this(ConfigurationManager.AppSettings["CaminhoAppHospitaisApi"], session)
        {

        }

        public BaseClient(string urlBase, HttpSessionStateBase session)
        {
            UrlBase = urlBase;
            Session = session;
        }

        protected TResult Get<TResult>(object parametros = null)
            where TResult : new()
        {
            return Get<TResult>(string.Empty, parametros);
        }

        protected TResult Get<TResult>(string nomeRecurso, object parametros = null)
            where TResult : new()
        {
            var request = new RestRequest(nomeRecurso, Method.GET);
            AddParameters(request, parametros);

            return CallApi<TResult>(request);
        }

        protected TResult Post<TResult>(object parametroBody, object parametrosUrl = null)
            where TResult : new()
        {
            return Post<TResult>(string.Empty, parametroBody, parametrosUrl);
        }

        protected TResult Post<TResult>(string nomeRecurso, object parametroBody, object parametrosUrl = null)
            where TResult : new()
        {
            var request = new RestRequest(nomeRecurso, Method.POST) { RequestFormat = DataFormat.Json };

            if (parametroBody != null)
            {
                request.AddParameter("application/json", JsonConvert.SerializeObject(parametroBody), ParameterType.RequestBody);
            }

            AddUrlSegments(request, parametrosUrl);

            return CallApi<TResult>(request);
        }

        protected TResult Delete<TResult>(object parametros = null)
            where TResult : new()
        {
            return Delete<TResult>(string.Empty, parametros);
        }

        protected TResult Delete<TResult>(string nomeRecurso, object parametros = null)
            where TResult : new()
        {
            var request = new RestRequest(nomeRecurso, Method.DELETE);
            AddParameters(request, parametros);

            return CallApi<TResult>(request);
        }

        private TResult CallApi<TResult>(RestRequest request)
            where TResult : new()
        {
            request.AddHeader("Accept", "application/json");
            request.AddHeader("Content-Type", "application/json");
            if(Session != null)
                request.AddHeader("Authorization", (string)Session["Token"]);

            var response = Client.Execute<TResult>(request);
            TResult parsedResponse = new TResult();

            if (response.StatusCode == HttpStatusCode.Unauthorized)
            {
                throw new UnauthorizedAccessException(" Acesso Negado, seu Perfil não possui acesso a essa ação !");
            }
            else if (response.StatusCode != HttpStatusCode.OK)
            {
                Exception ex = null;

                if (((response.Data as Amil.AppHospitais.DTO.BaseDTO) != null) && ((response.Data as Amil.AppHospitais.DTO.BaseDTO).Mensagem != ""))
                {
                    ex = new Exception((response.Data as Amil.AppHospitais.DTO.BaseDTO).Mensagem);    
                } 
                else ex = new Exception(response.StatusDescription, new Exception(response.Content));

                throw ex;
            }
            else
            {
                if ((response.Data == null || response.Data.Equals(0)) && !string.IsNullOrWhiteSpace(response.Content))
                {
                    var deserialized = JsonConvert.DeserializeObject<TResult>(response.Content);
                    parsedResponse = deserialized;
                }
                else if (response.Content == "true" || response.Content == "false")
                {
                    var deserialized = JsonConvert.DeserializeObject<TResult>(response.Content);
                    parsedResponse = deserialized;
                }
                else
                {
                    parsedResponse = response.Data;
                }
            }

            /*if (parsedResponse.Erro)
            {
                var responseEx = JsonConvert.DeserializeObject<Exception>(response.Data.SerializedException);
                var ex = new Exception(response.Data.Mensagem, responseEx);
                throw ex;
            }*/

            return parsedResponse;
        }

        private void AddUrlSegments(IRestRequest request, object parametros)
        {
            if (request == null)
                throw new ArgumentNullException("request");

            var paramDic = ExpandoToDictionary(parametros);
            foreach (var param in paramDic)
            {
                request.AddUrlSegment(param.Key, param.Value.ToString());
            }
        }

        private void AddParameters(IRestRequest request, object parametros, ParameterType paramType = ParameterType.QueryString)
        {
            if (request == null)
                throw new ArgumentNullException("request");

            var paramDic = ExpandoToDictionary(parametros);
            foreach (var param in paramDic)
            {
                var valueType = param.Value != null ? param.Value.GetType() : null;
                if (request.Method == Method.GET && valueType != null && (valueType.IsArray || valueType.Equals(typeof(IEnumerable))))
                {
                    var asList = (IList)param.Value;
                    if (asList != null)
                    {
                        foreach (var arrayParam in asList)
                        {
                            request.AddParameter(param.Key, arrayParam, paramType);
                        }
                    }
                }
                else
                    request.AddParameter(param.Key, param.Value, paramType);
            }
        }


        private IDictionary<string, object> ExpandoToDictionary(object parametros)
        {
            var result = new Dictionary<string, object>();

            if (parametros != null)
            {
                result = ExpandoTo<Dictionary<string, object>>(parametros, props =>
                {
                    return props.ToDictionary(x => x.Name, x => x.GetValue(parametros, null));
                });
            }

            return result;
        }

        private T ExpandoTo<T>(object expando, Func<PropertyInfo[], T> funcResult)
        {
            var type = expando.GetType();
            var props = type.GetProperties();

            return funcResult(props);
        }
    }
}
