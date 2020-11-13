using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Xml.Serialization;

namespace Amil.AppHospitais.DTO
{
    /// <remarks/>
    //[GeneratedCode("System.Xml", "4.6.1067.0")]
    //[Serializable]
    //[DebuggerStepThrough]
    //[DesignerCategory("code")]
    //[XmlType(Namespace = "http://canonico.amil.com.br/Hospital/v1")]
    public class Foto
    {

        /// <remarks/>
        public int identificador { get; set; }

        /// <remarks/>
        public string foto { get; set; }

        /// <remarks/>
       // [XmlIgnore]
        public bool fotoSpecified;

       // [XmlIgnore]
        public byte[] fotoByte
        {
            set { foto = Convert.ToBase64String(value); }
            get { return foto != null ? Convert.FromBase64String(foto) : null ; }
        }

        public bool Excluir { get; set; }
    }


}
