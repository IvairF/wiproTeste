using Amil.AppHospitais.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Amil.AppHospitais.APIClient
{
    public class CambioClient : BaseClient
    {
        public CambioClient()
            : base()
        {
        }

        public CambioClient(string urlFornecedor)
            : base(urlFornecedor)
        {

        }
        public CambioClient(HttpSessionStateBase session)
                : base(session)
        {
        }

        public List<Cambio> Listar()
        {
            return this.Get<List<Cambio>>("CambiosAmsWebCad");
        }

        public Cambio ListarPorId(int id)
        {
            return this.Get<Cambio>(String.Format("Cambio/{0}", id));
        }

        public int Gravar(Cambio Cambio)
        {
            return this.Post<int>("Cambio", Cambio);
        }
    }
}
