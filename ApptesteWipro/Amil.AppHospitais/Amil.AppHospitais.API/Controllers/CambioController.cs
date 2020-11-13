
using Amil.Framework.LoginAmericas;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace Amil.AppHospitais.WebApi2.Controllers
{
    [EnableCors("*", "*", "*")]
    [ValidaTokenFilter]
    public class CambioController : ApiController
    {
       
        [HttpGet, Route("api/GetItemFila")]
        public HttpResponseMessage Get(int id)
        {
            var result = BLL.Cambio.ListarPorId(id);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }


        [HttpPost, Route("api/AddItemFila")]
        public HttpResponseMessage Post(List<DTO.Cambio> cambios)          
            
        {

            

            foreach (var cambio in cambios)
            {

                var result = BLL.Cambio.Gravar(cambio);
               
            }
            return Request.CreateResponse(HttpStatusCode.OK);


        }
    }
}
