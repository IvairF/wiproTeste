using Amil.AppHospitais.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.ServiceModel.Web;
using System.Text;
using System.Threading.Tasks;

namespace Amil.AppHospitais.BLL
{
    public class Cambio
    {
        
        public static DTO.Cambio ListarPorId(int idCambio)
        {
            var retorno = new DTO.Cambio();
            try
            {
                CambioDAO dao = new CambioDAO();
                retorno = dao.bucascarUltimoId();
            }
            catch (Exception ex)
            {
                // throw ex;

                WebOperationContext.Current.OutgoingResponse.StatusCode = HttpStatusCode.InternalServerError;
                throw new WebFaultException<DTO.Erro>(new DTO.Erro { codigoErro = "3", mensagemErro = "Erro ao listar os Cambio " + ex.Message }, HttpStatusCode.InternalServerError);
            }

            return retorno;

        }

        public static int Gravar(DTO.Cambio Cambio)
        {
            int retorno;
            try
            {

                CambioDAO dao = new CambioDAO();
                retorno = dao.Gravar(Cambio);
                  
            }
            catch (Exception ex)
            {
                WebOperationContext.Current.OutgoingResponse.StatusCode = HttpStatusCode.InternalServerError;
                throw new WebFaultException<DTO.Erro>(new DTO.Erro { codigoErro = "4", mensagemErro = "Erro ao gravar novo Cambio: " + ex.Message }, HttpStatusCode.InternalServerError);
            }
            return retorno;
        }
    }
}
    