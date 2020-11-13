using Amil.AppHospitais.Model;
using System;

namespace Amil.AppHospitais.DAL
{
    public class BaseDAO : IDisposable
    {
        protected Context Context = new Context();
        internal bool disposed;

        public BaseDAO()
        {
            Context.Configuration.ValidateOnSaveEnabled = false;
            Context.Configuration.LazyLoadingEnabled = false;            
        }

        internal virtual void Dispose(bool disposing)
        {
            if (disposed) return;
            if (disposing)
                Context.Dispose();
            
            disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
