using Amil.AppHospitais.Model;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Amil.AppHospitais.DAL
{
    public class CambioDAO : BaseDAO
    {
             

        public DTO.Cambio bucascarUltimoId()
        {
            try
            {               

                return (from a in Context.Cambio                        
                        select new DTO.Cambio
                        {
                            moeda = a.Moeda,
                            data_inicio = a.DataInicio,
                            data_fim = a.DataFim,
                          
                           
                        }).OrderBy(a => a.moeda).OrderByDescending(x => x.moeda).Take(1).Single();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Gravar novo convênio.
        /// </summary>
        /// <param name="Cambio"></param>
        /// <returns></returns>
        public string Gravar(DTO.Cambio Cambio)
        {
            var model = new Cambio()
            {
                Moeda = Cambio.moeda,
                DataInicio = Cambio.data_inicio,
                DataFim = Cambio.data_fim,
            };
            Context.Cambio.Add(model);
            Context.SaveChanges();
            return model.Moeda;
        }

        public string delete(DTO.Cambio Cambio)
        {
            var model = new Cambio()
            {
                Moeda = Cambio.moeda,
                DataInicio = Cambio.data_inicio,
                DataFim = Cambio.data_fim,
            };
            Context.Cambio.Remove(model);
            Context.SaveChanges();
            return model.Moeda;

        };
           
        }

        /// <summary>
        /// Atualizar registro do do convênio.
        /// </summary>
        /// <param name="Cambio"></param>
        /// <returns></returns>
        
}
