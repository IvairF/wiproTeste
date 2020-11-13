using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;
using Devart.Data.Oracle.Entity.Configuration;

namespace Amil.AppHospitais.Model
{
    public class Context : DbContext
    {
        static Context()
        {
            OracleEntityProviderConfig.Instance.CodeFirstOptions.TruncateLongDefaultNames = true;
            OracleEntityProviderConfig.Instance.CodeFirstOptions.UseDateTimeAsDate = true;
        }

        public void Seed(Context Context)
        {
        }

        public Context()
            : base("Name=Context")
        {
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
            modelBuilder.HasDefaultSchema("CAMBIO");
        }

       
        public DbSet<Cambio> Cambio { get; set; }
        
    }
}
