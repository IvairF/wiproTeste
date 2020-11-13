using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;

namespace Amil.AppHospitais.Model
{
    [Table("APPHOSP_CAMBIO")]
    public class Cambio
    {
        [Key, Column("MOEDA")]
        [Required, StringLength(03), Column("MOEDA", TypeName = "varchar2")]
        public string Moeda { get; set; }

        [StringLength(10), Column("DATA_INICIO")]
        public DateTime DataInicio { get; set; }

        [StringLength(10), Column("DATA_FIM")]
        public DateTime  DataFim { get; set; }

    }
}
