using System.Data.Entity.Migrations;
using Devart.Data.Oracle.Entity.Migrations;

namespace Amil.AppHospitais.Model.Migrations
{
    internal sealed class Configuration : DbMigrationsConfiguration<Context>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
            SetSqlGenerator(OracleConnectionInfo.InvariantName, new OracleEntityMigrationSqlGenerator());
        }
    }
}
