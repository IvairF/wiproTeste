using System.Web;
using System.Web.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Amil.AsmWebCad.UI
{
    public class SessionTimeoutAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            HttpContext ctx = HttpContext.Current;
            if (HttpContext.Current.Session["Email"] == null || HttpContext.Current.Session["Token"] == null)
            {
                filterContext.Result = new RedirectResult("~/Login/Login");
                return;
            }
            base.OnActionExecuting(filterContext);
        }
    }
}