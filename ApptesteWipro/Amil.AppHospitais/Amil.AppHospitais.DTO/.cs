using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Amil.AppHospitais.DTO
{
    public class UsuarioConselhoDTO : BaseDTO
    {
        public int ID { get; set; }

        public int ID_USUARIO { get; set; }

        public EstadoDTO ESTADO { get; set; }

        public ConselhoDTO CONSELHO { get; set; }

        public string NO_DOCUMENTO { get; set; }

        public int FL_INTERNO { get; set; }

    }
}
