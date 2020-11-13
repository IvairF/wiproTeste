using System.Web.Mvc;

namespace Amil.AsmWebCad.UI.Controllers
{
    public class SecurityController : BaseController
    {
        public ActionResult Encrypt(string data)
        {
            var encryptedData = Utils.PassEncryption.EncryptData(data, Utils.PassEncryption._encryptionkey);
            //var encryptedData = Utils.PassEncryption.EncryptString(data);
            return Json(encryptedData, JsonRequestBehavior.AllowGet);
        }
    }
}
