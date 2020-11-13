using System.Collections.Generic;
using System.Linq;
using System.Web;
using Amil.AsmWebCad.Utils;

namespace Amil.AsmWebCad.UI.Helpers
{
    public static class SecurityHelper
    {
        public static Dictionary<string, string> GetRefersParams()
        {
            var paramList = new Dictionary<string, string>();
            if (HttpContext.Current.Request.UrlReferrer == null) return paramList;
            var request = HttpContext.Current.Request.UrlReferrer.ToString();
            request = request.Substring(request.IndexOf('?') + 1);
            request = Utils.PassEncryption.DecryptData(request, Utils.PassEncryption._encryptionkey);
            //request = Utils.PassEncryption.DecryptString(request);
            if (request.Equals("")) return paramList;
            var items = request.Split('&')
                .Select(s => s.Split('='));
            foreach (var item in items)
            {
                paramList.Add(item[0], item[1]);
            }
            return paramList;;
        }

        public static Dictionary<string, string> GetRequestParams()
        {
            var paramList = new Dictionary<string, string>();
            var request = HttpContext.Current.Request.RawUrl;
            request = request.Substring(request.IndexOf('?') + 1);
            request = Utils.PassEncryption.DecryptData(request, Utils.PassEncryption._encryptionkey);
            //request = Utils.PassEncryption.DecryptString(request);
            if (request.Equals("")) return paramList;
            var items = request.Split('&')
                .Select(s => s.Split('='));
            foreach (var item in items)
            {
                paramList.Add(item[0], item[1]);
            }
            return paramList;
        }
    }
}