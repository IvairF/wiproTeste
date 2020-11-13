using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Http.Dispatcher;

namespace Amil.AppHospitais.API.CustomController
{
    public class AssemblyControllers : IAssembliesResolver
    {
        public ICollection<Assembly> GetAssemblies()
        {
            List<Assembly> baseAssemblies = AppDomain.CurrentDomain.GetAssemblies().ToList();
            //var controllersAssembly = Assembly.LoadFrom(@"Americas.Framework.Login.Controllers.dll");
            //baseAssemblies.Add(controllersAssembly);
            return baseAssemblies;
        }
    }
}