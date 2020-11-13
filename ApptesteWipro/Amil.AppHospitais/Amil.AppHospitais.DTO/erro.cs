using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Xml.Serialization;

namespace Amil.AppHospitais.DTO
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "4.6.1067.0")]
    [Serializable]
    [DebuggerStepThrough]
    [DesignerCategory("code")]
    [XmlType(Namespace="http://canonico.amil.com.br/Comum/v1")]
    public class Erro
    {
        
        /// <remarks/>
        public string codigoErro;
        
        /// <remarks/>
        public string mensagemErro;
    }
}
