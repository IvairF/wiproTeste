using Amil.AppHospitais.APIClient;
using System.Collections.Generic;
using System.Web.Mvc;
using DTO = Amil.AppHospitais.DTO;
using MessagingToolkit.QRCode.Codec;
using System.Drawing;
using System.Drawing.Imaging;
using Amil.AppHospitais.DTO;

namespace Amil.AsmWebCad.UI.Controllers
{
    public class ConfigAppController : Controller
    {
        public ActionResult Index()
        {
            var configuracaoClient = new ConfiguracaoClient(Session);
            var config = configuracaoClient.Obter();
            return View(config);
        }

        [HttpPost]
        public bool Index(DTO.Configuracao configuracao)
        {
            var configuracaoClient = new ConfiguracaoClient(Session);
            return configuracaoClient.Gravar(configuracao);
        }
    }
}
