using Amil.AppHospitais.Servicos.Serv_Beneficiarios;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Amil.AppHospitais.Servicos
{
    public static class Beneficiario
    {
        public static DTO.Paciente RecuperarDadosMarcaOtica(string MarcaOtica)
        {
            Serv_Beneficiarios.IServiceClient serv = new IServiceClient();

            var dadosSol = new DadosSolicitacao();

            ItemsChoiceType1[] choType1 = new ItemsChoiceType1[1];
            dadosSol.Items = new string[1] { MarcaOtica };
            choType1[0] = ItemsChoiceType1.marcaOtica;
            dadosSol.ItemsElementName = choType1;

            var resultado  = ( from a in serv.BuscaDadosBeneficiario(dadosSol) 
                select new DTO.Paciente()
                {
                     CPF = a.cpf.ToString(), 
                     DataCriacao = a.dataInclusao,
                     DataNascimento = a.dataNascimento,                     
                     Nome = a.nomeBeneficiario, 
                     NumeroMatricula = a.marcaOtica, 
                     Telefone = a.numeroCelular

                }).SingleOrDefault();

            //Campo não foi encontrado, então mandar um objeto vazio para não dar pau, e mandar uma mensagem no DTO
            if (resultado == null)
            {
                resultado = new DTO.Paciente();
                resultado.MensagemProcessamento = "Paciente não encontrado";
                resultado.DataNascimento = DateTime.Now;
            }

            return resultado;

        }

    }
}
