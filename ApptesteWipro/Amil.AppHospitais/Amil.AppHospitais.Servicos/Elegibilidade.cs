using Amil.AppHospitais.DTO;
using Amil.AppHospitais.Servicos.tissVerificaElegibilidade;
using Amil.AppHospitais.Servicos.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Amil.AppHospitais.Servicos
{
    public class Elegibilidade
    {


        public static string VerificarElegibilidade(ElegibilidadeDTO elegibilidade, DTO.Convenio convenio, DTO.UnidadeDTO unidade)
        {
           
            //var unidade = new DTO.UnidadeDTO();
            //UnidadeDAO daoConv = new UnidadeDAO();
            //unidade = daoConv.Recuperar(Convert.ToInt32(elegibilidade.IdConvenio));


            ////DTO.Convenio convenio = DAL.ConvenioDAO.(Convert.ToInt32(elegibilidade.IdConvenio));  //tirar quando QA
            ////DTO.UnidadeDTO unidade = BLL.Unidade.Recuperar(Convert.ToInt32(elegibilidade.IdUnidade));     //tirar quando QA
            //var convenio = new DTO.Convenio();
            //ConvenioDAO dao = new ConvenioDAO();
            //convenio = dao.ListarPorId(Convert.ToInt32(elegibilidade.IdConvenio));



            pedidoElegibilidadeWS pedidoEleg = new pedidoElegibilidadeWS();

            pedidoEleg.cabecalho = new cabecalhoTransacao();
            pedidoEleg.cabecalho.identificacaoTransacao = new cabecalhoTransacaoIdentificacaoTransacao();

            pedidoEleg.cabecalho.identificacaoTransacao.tipoTransacao = dm_tipoTransacao.VERIFICA_ELEGIBILIDADE;
            pedidoEleg.cabecalho.identificacaoTransacao.sequencialTransacao = "1";
            pedidoEleg.cabecalho.identificacaoTransacao.dataRegistroTransacao = DateTime.Now.Date;
            pedidoEleg.cabecalho.identificacaoTransacao.horaRegistroTransacao = DateTime.Now;

            cabecalhoTransacaoOrigem cabecalhoTransOrigem = new cabecalhoTransacaoOrigem();
            cabecalhoTransacaoOrigemIdentificacaoPrestador identificacaoPrestador = new cabecalhoTransacaoOrigemIdentificacaoPrestador();
            identificacaoPrestador.ItemElementName = ItemChoiceType.codigoPrestadorNaOperadora;

            // codigoPrestadorNaOperadora 
            identificacaoPrestador.Item = unidade.CodCorpUnidade;
            // identificacaoPrestador.Item = "10401768"; // ALTERAR, RETIRAR O HARDCODE.... 
            cabecalhoTransOrigem.Item = identificacaoPrestador;
            pedidoEleg.cabecalho.origem = cabecalhoTransOrigem;

            cabecalhoTransacaoDestino destino = new cabecalhoTransacaoDestino();
            // registroANS

            destino.Item = convenio.RegistroANS.ToString(); // elegibilidade.IdConvenio; 
            // destino.Item = "326305"; // elegibilidade.IdConvenio; // ALTERAR, RETIRAR O HARDCODE.... 
            pedidoEleg.cabecalho.destino = destino;
            pedidoEleg.cabecalho.versaoPadrao = pedidoEleg.cabecalho.versaoPadrao = dm_versao.Item30200;

            ct_contratadoDados contratadoDados = new ct_contratadoDados();
            contratadoDados.ItemElementName = ItemChoiceType1.codigoPrestadorNaOperadora;
            //identificacaoPrestador.Item = unidade.CodCorpUnidade;
            contratadoDados.Item = unidade.CodCorpUnidade;
            contratadoDados.nomeContratado = unidade.Descricao;

            pedidoEleg.pedidoElegibilidade = new ct_elegibilidadeVerifica();
            pedidoEleg.pedidoElegibilidade.dadosPrestador = contratadoDados;
            pedidoEleg.pedidoElegibilidade.numeroCarteira = elegibilidade.NumeroMatricula;
            // pedidoEleg.pedidoElegibilidade.numeroCarteira = "874039274"; //elegibilidade.NumeroMatricula;
            pedidoEleg.pedidoElegibilidade.nomeBeneficiario = "SIMPLIFICADO"; // elegibilidade.NomePaciente; // HARDCODE "SIMPLIFICADO" CONFORME ORIENTAÇÃO.
            pedidoEleg.pedidoElegibilidade.nomeBeneficiario = elegibilidade.NomePaciente;  // elegibilidade.NomePaciente; // HARDCODE "SIMPLIFICADO" CONFORME ORIENTAÇÃO.

            pedidoEleg.hash = "HASHCODEXMLSANSPADRAO";

            ClassTiss30 cl = new ClassTiss30();
            cl.RemoveSpecialCharactersInObject(ref pedidoEleg);

            pedidoEleg.hash = SerializaMensagemTiss.GetNodeValue(SerializaMensagemTiss.ToXmlString(pedidoEleg, System.Xml.Formatting.Indented, "ISO-8859-1"), "hash").Replace("<hash>", "").Replace("</hash>", "");
            pedidoEleg.hash = pedidoEleg.hash.Substring(pedidoEleg.hash.IndexOf('>') + 1);

            tissVerificaElegibilidade_BindingClient eleg = new tissVerificaElegibilidade_BindingClient();
            ct_elegibilidadeRecibo reciboEleg;
            try
            {
                respostaElegibilidadeWS response = eleg.tissVerificaElegibilidade_Operation(pedidoEleg);
                AdjustEnum adjustEnumCode = new AdjustEnum();


                if (response.respostaElegibilidade.Item.GetType() == typeof(ct_motivoGlosa))
                {
                    ct_motivoGlosa motivoGlosa = (ct_motivoGlosa)response.respostaElegibilidade.Item;
                    return "(" + adjustEnumCode.adjustEnumCode(motivoGlosa.codigoGlosa.ToString()) + ")" + motivoGlosa.descricaoGlosa;
                }
                else
                {
                     reciboEleg = (ct_elegibilidadeRecibo)response.respostaElegibilidade.Item;
                    if (reciboEleg.respostaSolicitacao.Equals(dm_simNao.N))
                    {
                        string descricaoGlosa = "Ocorreu um desconhecido ao efetuar a elegibilidade";
                        foreach (ct_motivoGlosa glosa in reciboEleg.motivosNegativa)
                        {
                            if (descricaoGlosa.Equals("Ocorreu um desconhecido ao efetuar a elegibilidade"))
                                descricaoGlosa = "(" + adjustEnumCode.adjustEnumCode(glosa.codigoGlosa.ToString()) + ") " + glosa.descricaoGlosa;
                            else
                                descricaoGlosa += "\n(" + adjustEnumCode.adjustEnumCode(glosa.codigoGlosa.ToString()) + ") " + glosa.descricaoGlosa;
                        }

                        return descricaoGlosa.ToString();
                    } else {
                        return reciboEleg.respostaSolicitacao.ToString();
                    }
                }

                return reciboEleg.respostaSolicitacao.ToString();


            }
            catch (Exception e)
            {
                return "ERRO: " + e.InnerException + e.Message;
            }

        }



        //public HttpResponseMessage Post([FromBody] ElegibilidadeDTO elegibilidade)
        //{
        //    HttpResponseMessage mensagem = new HttpResponseMessage();

        //    pedidoElegibilidadeWS pedidoEleg = new pedidoElegibilidadeWS();

        //    pedidoEleg.cabecalho = new cabecalhoTransacao();
        //    pedidoEleg.cabecalho.identificacaoTransacao = new cabecalhoTransacaoIdentificacaoTransacao();

        //    pedidoEleg.cabecalho.identificacaoTransacao.tipoTransacao = dm_tipoTransacao.VERIFICA_ELEGIBILIDADE;
        //    pedidoEleg.cabecalho.identificacaoTransacao.sequencialTransacao = "1";
        //    pedidoEleg.cabecalho.identificacaoTransacao.dataRegistroTransacao = DateTime.Now.Date;
        //    pedidoEleg.cabecalho.identificacaoTransacao.horaRegistroTransacao = DateTime.Now;

        //    cabecalhoTransacaoOrigem cabecalhoTransOrigem = new cabecalhoTransacaoOrigem();
        //    cabecalhoTransacaoOrigemIdentificacaoPrestador identificacaoPrestador = new cabecalhoTransacaoOrigemIdentificacaoPrestador();
        //    identificacaoPrestador.ItemElementName = ItemChoiceType.codigoPrestadorNaOperadora;

        //    //DTO.Convenio convenio = BLL.Convenio.ListarPorId(Convert.ToInt32(elegibilidade.IdConvenio));  //tirar quando QA
        //    //DTO.UnidadeDTO unidade = BLL.Unidade.Recuperar(Convert.ToInt32(elegibilidade.IdUnidade));     //tirar quando QA
        //    //
        //    // codigoPrestadorNaOperadora 
        //    //identificacaoPrestador.Item = unidade.CodCorpUnidade; 
        //    identificacaoPrestador.Item = "10401768"; // ALTERAR, RETIRAR O HARDCODE.... 
        //    cabecalhoTransOrigem.Item = identificacaoPrestador;
        //    pedidoEleg.cabecalho.origem = cabecalhoTransOrigem;

        //    cabecalhoTransacaoDestino destino = new cabecalhoTransacaoDestino();
        //    // registroANS

        //    //destino.Item = convenio.RegistroANS.ToString(); // elegibilidade.IdConvenio; 
        //    destino.Item = "326305"; // elegibilidade.IdConvenio; // ALTERAR, RETIRAR O HARDCODE.... 
        //    pedidoEleg.cabecalho.destino = destino;
        //    pedidoEleg.cabecalho.versaoPadrao = pedidoEleg.cabecalho.versaoPadrao = dm_versao.Item30200;

        //    ct_contratadoDados contratadoDados = new ct_contratadoDados();
        //    contratadoDados.ItemElementName = ItemChoiceType1.codigoPrestadorNaOperadora;
        //    //identificacaoPrestador.Item = unidade.CodCorpUnidade;
        //    contratadoDados.Item = "10401768";
        //    contratadoDados.nomeContratado = "AMICO SAUDE LTDA";

        //    pedidoEleg.pedidoElegibilidade = new ct_elegibilidadeVerifica();
        //    pedidoEleg.pedidoElegibilidade.dadosPrestador = contratadoDados;
        //    //pedidoEleg.pedidoElegibilidade.numeroCarteira = elegibilidade.NumeroMatricula;
        //    pedidoEleg.pedidoElegibilidade.numeroCarteira = "874039274"; //elegibilidade.NumeroMatricula;
        //    pedidoEleg.pedidoElegibilidade.nomeBeneficiario = "SIMPLIFICADO"; // elegibilidade.NomePaciente; // HARDCODE "SIMPLIFICADO" CONFORME ORIENTAÇÃO.

        //    pedidoEleg.hash = "HASHCODEXMLSANSPADRAO";

        //    ClassTiss30 cl = new ClassTiss30();
        //    cl.RemoveSpecialCharactersInObject(ref pedidoEleg);

        //    pedidoEleg.hash = SerializaMensagemTiss.GetNodeValue(SerializaMensagemTiss.ToXmlString(pedidoEleg, System.Xml.Formatting.Indented, "ISO-8859-1"), "hash").Replace("<hash>", "").Replace("</hash>", "");
        //    pedidoEleg.hash = pedidoEleg.hash.Substring(pedidoEleg.hash.IndexOf('>') + 1);

        //    tissVerificaElegibilidade_BindingClient eleg = new tissVerificaElegibilidade_BindingClient();

        //    try
        //    {
        //        respostaElegibilidadeWS response = eleg.tissVerificaElegibilidade_Operation(pedidoEleg);
        //        AdjustEnum adjustEnumCode = new AdjustEnum();


        //        if (response.respostaElegibilidade.Item.GetType() == typeof(ct_motivoGlosa))
        //        {
        //            ct_motivoGlosa motivoGlosa = (ct_motivoGlosa)response.respostaElegibilidade.Item;
        //            return Request.CreateResponse(HttpStatusCode.OK, "(" + adjustEnumCode.adjustEnumCode(motivoGlosa.codigoGlosa.ToString()) + ")" + motivoGlosa.descricaoGlosa);
        //        }
        //        else
        //        {
        //            ct_elegibilidadeRecibo reciboEleg = (ct_elegibilidadeRecibo)response.respostaElegibilidade.Item;
        //            if (reciboEleg.respostaSolicitacao.Equals(dm_simNao.N))
        //            {
        //                string descricaoGlosa = "Ocorreu um desconhecido ao efetuar a elegibilidade";
        //                foreach (ct_motivoGlosa glosa in reciboEleg.motivosNegativa)
        //                {
        //                    if (descricaoGlosa.Equals("Ocorreu um desconhecido ao efetuar a elegibilidade"))
        //                        descricaoGlosa = "(" + adjustEnumCode.adjustEnumCode(glosa.codigoGlosa.ToString()) + ") " + glosa.descricaoGlosa;
        //                    else
        //                        descricaoGlosa += "\n(" + adjustEnumCode.adjustEnumCode(glosa.codigoGlosa.ToString()) + ") " + glosa.descricaoGlosa;
        //                }

        //                return Request.CreateResponse(HttpStatusCode.OK, descricaoGlosa.ToString());
        //            }
        //        }

        //        mensagem = Request.CreateResponse(HttpStatusCode.OK, response.respostaElegibilidade.ToString());

        //        return mensagem;
        //    }
        //    catch (Exception e)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.BadRequest, "ERRO: " + e.InnerException + e.Message);
        //    }
        //}


    }
}