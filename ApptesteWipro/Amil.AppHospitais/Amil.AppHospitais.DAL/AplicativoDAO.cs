using System.Linq;
using Amil.AppHospitais.Model;
using Aplicativo = Amil.AppHospitais.DTO.Aplicativo;

namespace Amil.AppHospitais.DAL
{
    public class AplicativoDAO : BaseDAO
    {
        /// <summary>
        /// Atualiza um aplicativo
        /// </summary>
        /// <param name="aplicativo"></param>
        /// <returns></returns>
        public bool Atualizar(Aplicativo aplicativo)
        {
            var retorno = false;
            var app = (from a in Context.Aplicativo
                              where a.Sistema.Equals(aplicativo.Sistema.ToString())
                              select a).FirstOrDefault();

            if (app != null && app.Id > 0)
            {
                app.UrlLoja = aplicativo.UrlLoja;
                app.VersaoMinima = aplicativo.VersaoMinima;
                app.VersaoAtual = aplicativo.VersaoAtual;

                Context.SaveChanges();
                retorno = true;
            }

            return retorno;
        }
        /// <summary>
        /// Remove todos os aplicativos
        /// </summary>
        /// <returns></returns>
        public bool Excluir()
        {
            var listaAplicativo = (from a in Context.Aplicativo
                                   select a).ToList();

            foreach (var item in listaAplicativo)
            {
                Context.Aplicativo.Attach(item);
                Context.Aplicativo.Remove(item);
            }

            Context.SaveChanges();
            return true;
        }
    }
}
