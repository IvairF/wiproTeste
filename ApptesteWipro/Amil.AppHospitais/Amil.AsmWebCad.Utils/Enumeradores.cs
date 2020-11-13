using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;

namespace Amil.AsmWebCad.Utils
{
    public static class Enumeradores
    {
        ///// <summary>
        ///// 
        ///// </summary>
        //public enum ModulosWebAPI
        //{
        //    AMERICA_LOGIN_ALTERAR_SENHA = "AlterarSenha",
        //    AMERICA_LOGIN_ATUALIZAR_USUARIO = "AtualizarUsuario",
        //    AMERICA_LOGIN_BUSCAR_MODULO_POR_SISTEMA = "BuscarModuloPorSistema",
        //    AMERICA_LOGIN_BUSCAR_SISTEMA = "BuscarSistema",
        //    AMERICA_LOGIN_BUSCAR_USUARIO = "BuscarUsuario",
        //    AMERICA_LOGIN_BUSCAR_USUARIO_PERMISSAO = "BuscarUsuarioPermissoes",
        //    AMERICA_LOGIN_BUSCAR_USUARIO_POR_EMAIL = "BuscarUsuarioPorEmail",
        //    AMERICA_LOGIN_CADASTRAR_USUARIO = "CadastrarUsuario",
        //    AMERICA_LOGIN_CADASTRAR_USUARIO_PERFIL = "CadastrarUsuarioPerfil",
        //    AMERICA_LOGIN_ESQUECI_SENHA = "EsqueciSenha",
        //    AMERICA_LOGIN_EXCLUIR_USUARIO = "ExcluirUsuario",
        //    AMERICA_LOGIN_EXCLUIR_USUARIO_PERMISSAO = "ExcluirUsuarioPermissoes",
        //    AMERICA_LOGIN_VALIDAR_LOGIN = "ValidarLogin",
        //    AMERICA_LOGIN_VERSAO = "Versao"


        //}
        public enum WorkFlow
        {

            HABILITACAO = 1,
            APROVACAO = 2
        }

        public enum CNPJTipo
        {
            PROPRIO = 1,
            DETERCEIROS = 0
        }

        public enum SituacaoWorkFlow
        {
            [Description("Pendente de Envio")]
            PENDENTE_DE_ENVIO = 1,
            [Description("Pendente Habilitação")]
            PENDENTE_HABILITACAO = 2,
            [Description("Aprovado Habilitação")]
            APROVADO_HABILITACAO = 3,
            [Description("Reprovado Habilitação")]
            REPROVADO_HABILITACAO = 4,
            [Description("Devolvido Habilitação")]
            DEVOLVIDO_HABILITACAO = 5,
            [Description("Pendente Aprovação")]
            PENDENTE_APROVACAO = 6,
            [Description("Aprovado Aprovação")]
            APROVADO_APROVACAO = 7,
            [Description("Reprovado Aprovação")]
            REPROVADO_APROVACAO = 8,
            [Description("Devolvido Aprovação")]
            DEVOLVIDO_APROVACAO = 9
        }

        public enum TipoConfiguracao
        {
            ALERTA = 1,
            GERAL = 2
        }

        public enum TipoUnidade
        {
            HOSPITAL = 1,
            UNIDADE_AVANCADA = 2
        }

        public enum TipoTelefone
        {
            FIXO = 1,
            MOVEL = 2
        }

        public enum ExtensaoArquivo
        {
            PDF = 1,
            JPEG = 2,
            JPG = 3
        }

        public enum SituacaoProfissionaCFM
        {

            [Description("Afastado")]
            AFASTADO = 1,
            [Description("Ativo")]
            ATIVO = 2,
            [Description("Aposentado")]
            APOSENTADO = 3,
            [Description("Cancelado")]
            CANCELADO = 4,
            [Description("Cassado")]
            CASSADO = 5,
            [Description("Falecido")]
            FALECIDO = 6,
            [Description("Inoperante")]
            INOPERANTE = 7,
            [Description("Interditado Cautelarmente")]
            INTERDITADO_CAUTELARMENTE = 8,
            [Description("Interditado Parcialmente")]
            INTERDITADO_PARCIALMENTE = 9,
            [Description("Não Informado")]
            NAO_INFORMADO = 10,
            [Description("Suspenso")]
            SUSPENSO = 11,
            [Description("Susp. Ordem Judicial")]
            SUSP_ORDEM_JUDICIAL = 12,
            [Description("Transferido")]
            TRANSFERIDO = 13
        }

        public enum SituacaoDocumento
        {
            [Description("Pendente")]
            PENDENTE = 1,

            [Description("Aprovado")]
            APROVADO = 2,

            [Description("Reprovado")]
            REPROVADO = 3,
        }

        public enum EstadoCivil
        {
            CASADO = 1,
            SOLTEIRO = 2,
            SEPARADO_JUDICIALMENTE = 3,
            VIUVO = 4,
            UNIAO_CONSENSUAL = 5,
            IGNORADO = 6
        }

        public enum Conselho
        {
            CRM = 1,
            COREN = 2,
            CRAS = 3,
            CRF = 4,
            CRFA = 5,
            CREFITO = 6,
            CRN = 7,
            CRO = 8,
            CRP = 9
        }

        public enum GrauInscricao
        {
            PRIMARIA = 1,
            SECUNDARIA = 2
        }

        public enum Funcionalidade
        {
            CONSULTA_UNIDADE = 1,
            CADASTRO_UNIDADE = 2,
            CONSULTA_TIPO_DOCUMENTO = 3,
            CADASTRO_TIPO_DOCUMENTO = 4,
            CONSULTA_CURSO = 5,
            CADASTRO_CURSO = 6,
            IMPORTACAO_CFM = 7,
            WORKFLOW_HABILITACAO = 8,
            WORKFLOW_APROVACAO = 9,
            CONFIGURACAO_ALERTAS = 10,
            CONFIGURACOES_GERAIS = 11,
            CONSULTA_QUADRO_AVISOS = 12,
            CADASTRO_QUADRO_AVISOS = 13,
            CONSULTA_GRUPO = 14,
            CADASTRO_GRUPO = 15,
            CONSULTA_USUARIO = 16,
            CADASTRO_USUARIO = 17,
            CONSULTA_PROFISSIONAL = 18,
            CADASTRO_PROFISSIONAL = 19
        }

        public enum Configuracao
        {
            ENVIAR_EMAIL_AO_PROFISSIONAL_ANTES_VENC_DOC = 1,
            ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC = 2,
            ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_VENC_DOC = 3,
            ENVIAR_EMAIL_AOS_RESPONSAVEIS_APOS_VENC_DOC = 4,
            ENVIAR_SMS_AO_PROFISSIONAL_ANTES_VENC_DOC = 5,
            ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC = 6,
            ENVIAR_SMS_AO_PROFISSIONAL_APOS_VENC_DOC = 7,
            ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO = 8,
            ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO = 9,
            ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO = 10,
            ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO = 11,
            TEXTO_TELA_CADASTRO_PROFISSIONAL = 12,
            TEXTO_TELA_CONVITE_PROFISSIONAL = 13,
            TEXTO_TELA_CRIACAO_PROFISSIONAL_CFM_INATIVO = 14,
        }

        public enum UF
        {
            ACRE = 1,
            ALAGOAS = 2,
            AMAPA = 3,
            AMAZONAS = 4,
            BAHIA = 5,
            CEARA = 6,
            DISTRITO_FEDERAL = 7,
            ESPIRITO_SANTO = 8,
            GOIAS = 9,
            MARANHAO = 10,
            MATO_GROSSO = 11,
            MATO_GROSSO_DO_SUL = 12,
            MINAS_GERAIS = 13,
            PARANA = 14,
            PARAIBA = 15,
            PARA = 16,
            PERNAMBUCO = 17,
            PIAUI = 18,
            RIO_DE_JANEIRO = 19,
            RIO_GRANDE_DO_NORTE = 20,
            RIO_GRANDE_DO_SUL = 21,
            RONDONIA = 22,
            RORAIMA = 23,
            SANTA_CATARINA = 24,
            SERGIPE = 25,
            SAO_PAULO = 26,
            TOCANTINS = 27
        }

        public enum AbaProfissional
        {
            NENHUM = 0,
            DADOS_PROFISSIONAL = 1,
            REGISTROS_PROFISSIONAL = 2,
            TELEFONES_PROFISSIONAL = 3,
            EMAILS_PROFISSIONAL = 4,
            AREAS_ATUACAO_PROFISSIONAL = 5,
            ESPECIALIDADES_PROFISSIONAL = 6,
            UNIDADES_PROFISSIONAL = 7,
            CURSOS_PROFISSIONAL = 8,
            FILIACOES_PROFISSIONAL = 9,
            REFERENCIAS_PROFISSIONAL = 10,
            DOCUMENTACAO_PROFISSIONAL = 11
        }

        public enum Download
        {
            PDF,
            Excel
        }

        public enum StatusDocumentacaoProfissional
        {
            [Description("Sem Documentos")]
            SEM_DOCUMENTOS = 0,
            [Description("Com Pendências")]
            POSSUI_PENDENCIAS = 1,
            [Description("Sem Pendências")]
            DOCUMENTOS_APROVADOS = 2
        }

        public enum Especialidade
        {
            ACUPUNTURA = 1,
            ALERGIA_E_IMUNOLOGIA = 2,
            ANESTESIOLOGIA = 3,
            ANGIOLOGIA = 4,
            CANCEROLOGIA = 5,
            CARDIOLOGIA = 6,
            CIRURGIA_CARDIOVASCILAR = 7,
            CIRURGIA_DA_MAO = 8,
            CIRURGIA_DE_CABECAO_E_PESCOÇO = 9,
            CIRURGIA_DO_APARELHO_DIGESTIVO = 10,
            CIRURGIA_GERAL = 11,
            CIRURGIA_PEDIATRICA = 12,
            CIRURGIA_PLASTICA = 13,
            CIRURGIA_TORACICA = 14,
            CIRURGIA_VASCULAR = 15,
            CIRURGIA_MEDICA = 16,
            COLOPROCTOLOGIA = 17,
            DERMATOLOGIA = 18,
            ENDOCRINOLOGIA_E_METABOLOGIA = 19,
            ENDOSCOPIA = 20,
            GASTROENTEROLOGIA = 21,
            GENETICA_MEDICA = 22,
            GERIATRIA = 23,
            GINECOLOGIA_E_OBSTETRICIA = 24,
            HEMATOLOGIA_E_HEMOTERAPIA = 25,
            HEMOTERAPIA = 26,
            INFECTOLOGIA = 27,
            MASTOLOGIA = 28,
            MEDICINA_DE_FAMILIA_E_COMUNIDADE = 29,
            MEDICINA_DO_TRABALHO = 30,
            MEDICINA_DE_TRAFEGO = 31,
            MEDICINA_ESPORTIVA = 32,
            MEDICINA_FISICA_E_REABILITACAO = 33,
            MEDICINA_INTENSIVA = 34,
            MEDICINA_LEGAL_E_PERICICA_MEDICA = 35,
            MEDICINA_NUCLEAR = 36,
            MEDICINA_PREVENTIVA_E_SOCIAL = 37,
            NEFROLOGIA = 38,
            NEOUROCIRURGIA = 39,
            NEUROLOGIA = 40,
            NUTROLOGIA = 41,
            OFTALMOLOGIA = 42,
            ORTOPEDIA_E_TRAUMOTOLOGIA = 43,
            OTORRINOLARINGOLOGIA = 44,
            PATOLOGIA = 45,
            PATOLOGIA_CLINICA_MEDICINA_LABORATORIAL = 46,
            PEDIATRIA = 47,
            PNEUMOLOGIA = 48,
            PSIQUIATRIA = 49,
            RADIOLOGIA_E_DIAGNOSTICO_POR_IMAGEM = 50,
            RADIOTERAPIA = 51,
            REUMATOLOGIA = 52,
            UROLOGIA = 53
        }

        public enum CamposArquivoImportacao
        {
            [Description("CRM")]
            CRM = 0,
            [Description("UF")]
            UF = 1,
            [Description("NOME")]
            NOME = 2,
            [Description("GRAU DE INSTRUÇÃO")]
            GRAU_INSTRUCAO = 3,
            [Description("STATUS DO CRM")]
            SITUACAO = 4
        }
    }

    /// <summary>
    /// Pega um Enumerador e transforma num List of T
    /// Dar um ToList() após acessar o método
    /// </summary>
    public static class EnumHelper
    {
        public static IEnumerable<ListaPadrao> ListarEnum<TEnum>()
            where TEnum : struct, IConvertible, IComparable, IFormattable
        {
            if (!typeof(TEnum).IsEnum)
                throw new ArgumentException("TEnum ser um tipo de Enum");

            var res = from e in Enum.GetValues(typeof(TEnum)).Cast<TEnum>()
                      select new ListaPadrao { Id = Convert.ToInt32(e), Descricao = e.ToDescription() };

            return res;
        }

        public static string ToDescription<TEnum>(this TEnum enumValue) where TEnum : struct
        {
            return PegarDescricao((Enum)(object)enumValue);
        }

        public static string PegarDescricao(Enum value)
        {
            var fi = value.GetType().GetField(value.ToString());
            var attributes =
                (DescriptionAttribute[])fi.GetCustomAttributes(
                    typeof(DescriptionAttribute),
                    false);
            return attributes.Length > 0 ? attributes[0].Description : value.ToString();
        }
    }

    public struct ListaPadrao
    {
        public int Id { get; set; }
        public string Descricao { get; set; }
    }
}