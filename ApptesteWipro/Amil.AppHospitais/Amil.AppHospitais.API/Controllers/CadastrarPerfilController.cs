using Amil.AppHospitais.Api.Filters;
using Amil.AppHospitais.BLL;
using Amil.AppHospitais.DTO;
using Amil.AppHospitais.Model;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Http;
using System.Web.Http.Cors;

namespace Amil.AppHospitais.Api.Controllers
{
    [EnableCors("*", "*", "*")]
    public class CadastrarPerfilController : ApiController
    {

        [HttpPost, Route("api/CadastrarPerfil")]
        public HttpResponseMessage Post([FromBody]PerfilDTO perfil)
        {
            HttpResponseMessage response = new HttpResponseMessage();

            try
            {
                using (var client = new HttpClient())
                {
                    var novoperfil = new Dictionary<string, string>
                    {
                        {"Descricao", perfil.Descricao },
                        {"Codigo", perfil.Codigo },
                        {"IdSistema", perfil.IdSistema.ToString() },
                    };

                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["LoginAmericas"]);

                    var resp = client.PostAsync("CadastrarPerfil", new FormUrlEncodedContent(novoperfil));
                    resp.Wait(TimeSpan.FromSeconds(40));

                    if (resp.IsCompleted)
                    {
                        Dictionary<string, string> Details = null;
                        Details = JsonConvert.DeserializeObject<Dictionary<string, string>>(resp.Result.Content.ReadAsStringAsync().Result);
                        return Request.CreateResponse(HttpStatusCode.OK, Details);
                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.BadRequest, resp);
                    }

                }
            }
            catch (IndexOutOfRangeException ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex);
            }
            catch (ArgumentException ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex);
            }
            catch (FormatException ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex);
            }
            catch (TimeoutException ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex);
            }
        }


    }
}