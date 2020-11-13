using System.Web.Mvc;
using Amil.AsmWebCad.UI.Models;

namespace Amil.AsmWebCad.UI.Controllers
{
    public class TelaPrincipalController : Controller
    {
        //
        // GET: /TelaPrincipal/
        [SessionTimeout]
        public ActionResult Index()
        {
            return View();
        }

        [SessionTimeout]
        public ActionResult Manutencao()
        {
            
            return View();
        }

    }
}
