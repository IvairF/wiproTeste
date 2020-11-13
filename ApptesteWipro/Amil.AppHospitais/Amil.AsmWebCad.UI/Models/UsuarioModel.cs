using System;
using Amil.AsmWebCad.UI.Resources;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;

namespace Amil.AsmWebCad.UI.Models
{
    public class UsuarioModel
    {
        public int Id { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(60, ErrorMessageResourceName = "AlertaNomeMax60", ErrorMessageResourceType = typeof(Resource))]
        public string Nome { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource))]
        public string CPF { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource))]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? DataNascimento { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(50, ErrorMessageResourceName = "AlertaLoginMax50", ErrorMessageResourceType = typeof(Resource))]
        [DataType(DataType.EmailAddress, ErrorMessage = "Formato Invalido."), EmailAddress(ErrorMessage = "O Campo Login deve ter formato de e-mail valido.")]
        public string Login { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource)),
        StringLength(50, ErrorMessageResourceName = "AlertaLoginMax50", ErrorMessageResourceType = typeof(Resource)),
        Compare("Login", ErrorMessageResourceName = "AlertaConfirmacaoDiferente", ErrorMessageResourceType = typeof(Resource))]
        [DataType(DataType.EmailAddress, ErrorMessage = "Formato Invalido."), EmailAddress(ErrorMessage = "O campo deve ter formato de e-mail valido.")]
        public string ConfirmaLogin { get; set; }

        [Required(ErrorMessageResourceName = "CampoObrigatorio", ErrorMessageResourceType = typeof(Resource))]
        public bool? Ativo { get; set; }

        public string Status { get; set; }

        public string Descricaoativo { get; set; }

        public string Tipo { get; set; }

        public string PrimeiroAcesso { get; set; }

        public bool Bloqueado { get; set; }

        public int IdConselho { get; set; }

        public string NumeroDocumento { get; set; }
        
    }
}
