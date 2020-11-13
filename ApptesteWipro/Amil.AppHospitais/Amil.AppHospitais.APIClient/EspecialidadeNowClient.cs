using Amil.AppHospitais.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Amil.AppHospitais.APIClient
{
    public class EspecialidadeNowClient : BaseClient
    {
        public EspecialidadeNowClient()
            : base()
        {
        }

        public EspecialidadeNowClient(string urlFornecedor)
            : base(urlFornecedor)
        {

        }

        public EspecialidadeNowClient(HttpSessionStateBase session)
                : base(session)
        {
        }

        public List<EspecialidadeNowDTO> Listar()
        {
            return this.Get<List<EspecialidadeNowDTO>>("EspecialidadesNow");
        }

    }
}
