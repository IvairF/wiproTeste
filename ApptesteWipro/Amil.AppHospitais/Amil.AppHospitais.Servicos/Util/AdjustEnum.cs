using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Amil.AppHospitais.Servicos.Util
{
    public class AdjustEnum
    {
        public String adjustEnumCode(String value)
        {
            String retorno = value;

            if (value.ToLower().IndexOf("item") > -1)
                retorno = value.ToLower().Replace("item", "");

            return retorno;
        }
    }
}