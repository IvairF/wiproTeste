using Amil.AppHospitais.API.CustomController;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Http.Dispatcher;
using System.Web.Routing;

namespace Amil.AppHospitais.Api
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            GlobalConfiguration.Configuration.Services.Replace(typeof(IAssembliesResolver), new AssemblyControllers());
            GlobalConfiguration.Configure(WebApiConfig.Register);
        }
    }
}
