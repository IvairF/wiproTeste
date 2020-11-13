using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace Amil.AppHospitais.API.Controllers
{

    [EnableCors("*", "*", "*")]
    public class IntegrarRedeSocialController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET api/<controller>/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/<controller>
        public HttpResponseMessage Post([FromBody]DTO.UsuarioDTO value)
        {
            HttpResponseMessage mensagem = new HttpResponseMessage();

            BLL.UsuarioBLL usuarioBLL = new BLL.UsuarioBLL();

            try
            {
                mensagem = Request.CreateResponse(HttpStatusCode.OK, usuarioBLL.IntegrarRedeSocial(value));
            }
            catch (Exception ex)
            {
                Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }

            return mensagem;
        }

        // PUT api/<controller>/5
        [HttpPut]
        public HttpResponseMessage Put(int id, [FromBody]DTO.UsuarioDTO value)
        {
            HttpResponseMessage mensagem = new HttpResponseMessage();

            value.Id = id;
            
            BLL.UsuarioBLL usuarioBLL = new BLL.UsuarioBLL();

            try
            {
                mensagem = Request.CreateResponse(HttpStatusCode.OK, usuarioBLL.IntegrarRedeSocial(value));
            }
            catch (Exception ex)
            {
                Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }

            return mensagem;
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}