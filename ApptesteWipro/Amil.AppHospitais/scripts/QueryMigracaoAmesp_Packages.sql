
--------------------------------------------------------
--  DDL for Package INI_CONFIG_PG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "AMESP"."INI_CONFIG_PG" is
   function getchave(
      psistema      varchar2,
      pchave        varchar2,
      pparametro    varchar2,
      pvalordefault varchar2 default '',
      pcentromedico varchar2 default null,
      pusuario      pls_integer default null)
      return varchar2;
end;


/
--------------------------------------------------------
--  DDL for Package PAC_DADOS_GUIA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "AMESP"."PAC_DADOS_GUIA" IS
/*
|| Autor: Vitor Bellot
|| Data de criacao: 21/07/2014
*/
  PROCEDURE P_OBTER_DADOS_GUIA(
    pNumGuia IN        VARCHAR2,
    pIdGuia IN      NUMBER,
    pNumLote IN    NUMBER,
    pIdLote IN      NUMBER,
    pIdUnidade IN    VARCHAR2,
    pNomePessoa IN     VARCHAR2,
    pIdOperadora IN   VARCHAR2,
    pNrCarteirinha IN   VARCHAR2,
    pIdEspecialidade IN  VARCHAR2,
    pTpFaturamentoPlano IN  VARCHAR2,
    pNomeOperadora IN  VARCHAR2,
    pGuiasSemLote IN  VARCHAR2,
    pDataEntregaInicio IN  DATE,
    pDataEntregaFim IN    DATE,
    pDataVencimentoInicio IN  DATE,
    pDataVencimentoFim IN  DATE,
    pGuiasSemComanda IN  VARCHAR2,
    pClassifAtend IN  VARCHAR2,
    pGuiaDuplicada IN  VARCHAR2,
    pFlGuiasMarcadasFaturar IN  NUMBER,
    pTipoGuia IN        VARCHAR2,
    pDataIni IN DATE,
    pDataFim IN DATE
    );

    PROCEDURE P_OBTER_DADOS_GUIA_TELE(
    pNumGuia IN        VARCHAR2,
    pIdGuia IN      NUMBER,
    pNumLote IN    NUMBER,
    pIdLote IN      NUMBER,
    pIdUnidade IN    VARCHAR2,
    pNomePessoa IN     VARCHAR2,
    pIdOperadora IN   VARCHAR2,
    pNrCarteirinha IN   VARCHAR2,
    pIdEspecialidade IN  VARCHAR2,
    pTpFaturamentoPlano IN  VARCHAR2,
    pNomeOperadora IN  VARCHAR2,
    pGuiasSemLote IN  VARCHAR2,
    pDataEntregaInicio IN  DATE,
    pDataEntregaFim IN    DATE,
    pDataVencimentoInicio IN  DATE,
    pDataVencimentoFim IN  DATE,
    pGuiasSemComanda IN  VARCHAR2,
    pClassifAtend IN  VARCHAR2,
    pGuiaDuplicada IN  VARCHAR2,
    pFlGuiasMarcadasFaturar IN  NUMBER,
    pTipoGuia IN        VARCHAR2,
    pDataIni IN DATE,
    pDataFim IN DATE
    );

END PAC_DADOS_GUIA;


/
--------------------------------------------------------
--  DDL for Package PKG_CONFIG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "AMESP"."PKG_CONFIG" IS
   FUNCTION getsmtp_host RETURN VARCHAR2;
   FUNCTION getsmtp_port RETURN PLS_INTEGER;
   FUNCTION getid_email_padrao RETURN PLS_INTEGER;
END;


/
--------------------------------------------------------
--  DDL for Package PKGDEFS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "AMESP"."PKGDEFS" as
   guser          acesso_login.id_usuario%type;
   gosuser        v$session.osuser%type;
   gmachine       v$session.machine%type;
   gregistrarlog  boolean                        := true;

   type rrowid is record(
      numrowid rowid
   );

   type tlistarowid is table of rrowid;

   glistarowid01  tlistarowid;
   gtabelatexto01 ttstring100;

/* procedure CONECTA_INICIO inclui nome do usuario e audsid em acesso_audit */
   procedure conecta_inicio(rlogin in varchar2);

/* procedure CONECTA_FIM exclui registro de acesso_audit para a sessao atual (audsid) */
   procedure conecta_fim;

/* procedure ZERA_LISTA reinicia variavel gListaRowid01, utilizada genericamente nas triggers */
   procedure zera_lista(rlista in out tlistarowid);

/* procedure ADICIONA_LISTA adiciona elemento na variavel gListaRowid01 */
   procedure adiciona_lista(rlista in out tlistarowid, rrowid in rowid);

/* procedure ZERA_TABELA reinicia table object rLista, utilizada genericamente nas triggers */
   procedure zera_tabela(rlista in out nocopy ttstring100);

/* procedure ADICIONA_TABELA adiciona elemento na table object rLista */
   procedure adiciona_tabela(rlista in out nocopy ttstring100, rtexto in varchar2);

/* func?o TABELA_MUTANTE retorna True se a tabel rOwner.rTabela e 'mutating' durante a execuc?o da trigger */
   function tabela_mutante(rowner in varchar2, rtabela in varchar2)
      return boolean;

/* func?o NOVA_CHAVE_LOG - retorna nextval da sequence registrada em historicos.log_tabela para a tabela rOwner.rTabela */
/*   function nova_chave_log(rowner in varchar2, rtabela in varchar2)
      return number;*/

/* func?o IGUAL - compara dois valores, inclusive nulos */
   function igual(r1 in varchar2, r2 in varchar2)
      return boolean;

   function igual(r1 in date, r2 in date)
      return boolean;

   function igual(r1 in number, r2 in number)
      return boolean;

   function igual(r1 in clob, r2 in clob)
      return boolean;

   function igual(r1 in blob, r2 in blob)
      return boolean;

   pragma restrict_references(igual, wnds);

/* func?o IDENTIFICADOR_TABELA - retorna id_tabela cadastrado em historicos.log_tabela para rOwner.rTabela */
/*   function identificador_tabela(rowner in varchar2, rtabela in varchar2)
      return historicos.log_tabela%rowtype;
*/
/* para uso das aplicações, para informarem qual o usuário da sessão */
   procedure setar_usuario(p_i_id_usuario in integer);

/* seta variaveis privadas da package com a identificac?o do usuario */
   procedure identifica_usuario(rmutante in boolean default false);

/* procedure REGISTRA_INCLUSAO - registra inclusao de registro em historicos.log_alteracao */
/*   procedure registra_inclusao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rownerhist in varchar2 default 'historicos');
*/
/* procedure REGISTRA_DELECAO - registra delecao de registro na tabela correspondente */
   procedure registra_delecao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rownerlog  in varchar2,
      rtabelalog in varchar2,
      rrowid     in rowid);

/* procedure REGISTRA_ALTERACAO - compara valores e se diferentes registra em historicos.log_alteracao */
/*   procedure registra_alteracao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rcoluna    in varchar2,
      roriginal  in varchar2,
      rnovo      in varchar2,
      rownerhist in varchar2 default 'historicos');

   procedure registra_alteracao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rcoluna    in varchar2,
      roriginal  in date,
      rnovo      in date,
      rownerhist in varchar2 default 'historicos');

   procedure registra_alteracao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rcoluna    in varchar2,
      roriginal  in number,
      rnovo      in number,
      rownerhist in varchar2 default 'historicos');

   procedure registra_alteracao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rcoluna    in varchar2,
      roriginal  in clob,
      rnovo      in clob,
      rownerhist in varchar2 default 'historicos');

   procedure registra_alteracao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rcoluna    in varchar2,
      roriginal  in blob,
      rnovo      in blob,
      rownerhist in varchar2 default 'historicos');

   procedure registra_alteracao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rcoluna    in varchar2,
      roriginal  in xmltype,
      rnovo      in xmltype,
      rownerhist in varchar2 default 'historicos');
*/
/* procedure DROPA - elimina tables e sequences */
   procedure dropa(rtipo in varchar2, rowner in varchar2, robjeto in varchar2);

/* procedure geraSenPadrao - gera uma senha inicial randômica */
   procedure gerasenpadrao;

/* function getIDUsuario - retorna id_usuario do usuário da sessão */
   function getidusuario
      return integer;

/* function getSenPadrao - retorna a senha inicial de usuários */
   function getsenpadrao
      return varchar2;

end;

/
--------------------------------------------------------
--  DDL for Package PKG_LOCK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "AMESP"."PKG_LOCK" is
   trsuccess        constant integer := 0;
   trtimeout        constant integer := 1;
   trdeadlock       constant integer := 2;
   trparametererror constant integer := 3;
   trowner          constant integer := 4;
   trillegalhandle  constant integer := 5;

   /*function obter_travamento(
      rcodigo     in     varchar2,
      rresult     out    integer,
      rtipolock   in     integer default sys.dbms_lock.x_mode,
      rmaxtempo   in     integer default 1,
      rcommit     in     boolean default false,
      rexpiration in     integer default null)
      return boolean;*/

   function liberar_travamento(rcodigo in varchar2, rresult out integer)
      return boolean;

   function existe_travamento(rcodigo in varchar2, rlogin in varchar2 default null)
      return boolean;

   function tem_travamento(rcodigo in varchar2, rlogin in varchar2 default null)
      return varchar2;

   function detalhar_travamento(
      rcodigo           in     varchar2,
      rlogin            out    varchar2,
      rnome             out    varchar2,
      rsegundos_lock    out    pls_integer,
      rsegundos_inativa out    pls_integer,
      rmaquina          out    varchar2)
      return boolean;
end;

/
--------------------------------------------------------
--  DDL for Package PKG_MAIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "AMESP"."PKG_MAIL" IS

  ----------------------- Customizable Section -----------------------

  -- Customize the SMTP host, port and your domain name below.
  smtp_host   VARCHAR2(256);
  smtp_port   PLS_INTEGER;

  -- Customize the signature that will appear in the email's MIME header.
  -- Useful for versioning.
  MAILER_ID CONSTANT VARCHAR2(256) := 'Mailer by Oracle UTL_SMTP';

  --------------------- End Customizable Section ---------------------

  -- A unique string that demarcates boundaries of parts in a multi-part email
  -- The string should not appear inside the body of any part of the email.
  -- Customize this if needed or generate this randomly dynamically.
  BOUNDARY CONSTANT VARCHAR2(256) := '-----7D81B75CCC90D2974F7A1CBD';

  FIRST_BOUNDARY CONSTANT VARCHAR2(256) := '--' || BOUNDARY || utl_tcp.CRLF;
  LAST_BOUNDARY  CONSTANT VARCHAR2(256) := '--' || BOUNDARY || '--' ||
                                           utl_tcp.CRLF;

  -- A MIME type that denotes multi-part email (MIME) messages.
  MULTIPART_MIME_TYPE   CONSTANT VARCHAR2(256) := 'multipart/mixed; boundary="' ||
                                                  BOUNDARY || '"';
  MAX_BASE64_LINE_WIDTH CONSTANT PLS_INTEGER := 76 / 4 * 3;

  -- A simple email API for sending email in plain text in a single call.
  -- The format of an email address is one of these:
  --   someone@some-domain
  --   "Someone at some domain" <someone@some-domain>
  --   Someone at some domain <someone@some-domain>
  -- The recipients is a list of email addresses  separated by
  -- either a "," or a ";"
  PROCEDURE mail(sender     IN VARCHAR2,
                 recipients IN VARCHAR2,
                 subject    IN VARCHAR2,
                 message    IN VARCHAR2);

  -- Extended email API to send email in HTML or plain text with no size limit.
  -- First, begin the email by begin_mail(). Then, call write_text() repeatedly
  -- to send email in ASCII piece-by-piece. Or, call write_mb_text() to send
  -- email in non-ASCII or multi-byte character set. End the email with
  -- end_mail().
  FUNCTION begin_mail(sender     IN VARCHAR2,
                      recipients IN VARCHAR2,
                      subject    IN VARCHAR2,
                      mime_type  IN VARCHAR2 DEFAULT 'text/plain',
                      priority   IN PLS_INTEGER DEFAULT NULL)
    RETURN utl_smtp.connection;

  -- Write email body in ASCII
  PROCEDURE write_text(conn    IN OUT NOCOPY utl_smtp.connection,
                       message IN VARCHAR2);

  -- Write email body in non-ASCII (including multi-byte). The email body
  -- will be sent in the database character set.
  PROCEDURE write_mb_text(conn    IN OUT NOCOPY utl_smtp.connection,
                          message IN VARCHAR2);

  -- Write email body in binary
  PROCEDURE write_raw(conn    IN OUT NOCOPY utl_smtp.connection,
                      message IN RAW);

  -- APIs to send email with attachments. Attachments are sent by sending
  -- emails in "multipart/mixed" MIME format. Specify that MIME format when
  -- beginning an email with begin_mail().

  -- Send a single text attachment.
  PROCEDURE attach_text(conn      IN OUT NOCOPY utl_smtp.connection,
                        data      IN VARCHAR2,
                        mime_type IN VARCHAR2 DEFAULT 'text/plain',
                        inline    IN BOOLEAN DEFAULT TRUE,
                        filename  IN VARCHAR2 DEFAULT NULL,
                        last      IN BOOLEAN DEFAULT FALSE);

  -- Send a binary attachment. The attachment will be encoded in Base-64
  -- encoding format.
  PROCEDURE attach_base64(conn      IN OUT NOCOPY utl_smtp.connection,
                          data      IN RAW,
                          mime_type IN VARCHAR2 DEFAULT 'application/octet',
                          inline    IN BOOLEAN DEFAULT TRUE,
                          filename  IN VARCHAR2 DEFAULT NULL,
                          last      IN BOOLEAN DEFAULT FALSE);

  -- Send an attachment with no size limit. First, begin the attachment
  -- with begin_attachment(). Then, call write_text repeatedly to send
  -- the attachment piece-by-piece. If the attachment is text-based but
  -- in non-ASCII or multi-byte character set, use write_mb_text() instead.
  -- To send binary attachment, the binary content should first be
  -- encoded in Base-64 encoding format using the demo package for 8i,
  -- or the native one in 9i. End the attachment with end_attachment.
  PROCEDURE begin_attachment(conn         IN OUT NOCOPY utl_smtp.connection,
                             mime_type    IN VARCHAR2 DEFAULT 'text/plain',
                             inline       IN BOOLEAN DEFAULT TRUE,
                             filename     IN VARCHAR2 DEFAULT NULL,
                             transfer_enc IN VARCHAR2 DEFAULT NULL);

  -- End the attachment.
  PROCEDURE end_attachment(conn IN OUT NOCOPY utl_smtp.connection,
                           last IN BOOLEAN DEFAULT FALSE);

  -- End the email.
  PROCEDURE end_mail(conn IN OUT NOCOPY utl_smtp.connection,
                     last IN BOOLEAN DEFAULT FALSE);

  -- Extended email API to send multiple emails in a session for better
  -- performance. First, begin an email session with begin_session.
  -- Then, begin each email with a session by calling begin_mail_in_session
  -- instead of begin_mail. End the email with end_mail_in_session instead
  -- of end_mail. End the email session by end_session.
  FUNCTION begin_session RETURN utl_smtp.connection;

  -- Begin an email in a session.
  PROCEDURE begin_mail_in_session(conn       IN OUT NOCOPY utl_smtp.connection,
                                  sender     IN VARCHAR2,
                                  recipients IN VARCHAR2,
                                  subject    IN VARCHAR2,
                                  mime_type  IN VARCHAR2 DEFAULT 'text/plain',
                                  priority   IN PLS_INTEGER DEFAULT NULL);

  -- End an email in a session.
  PROCEDURE end_mail_in_session(conn IN OUT NOCOPY utl_smtp.connection);

  -- End an email session.
  PROCEDURE end_session(conn IN OUT NOCOPY utl_smtp.connection);

END;

/
--------------------------------------------------------
--  DDL for Package PKG_PEP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "AMESP"."PKG_PEP" is
   procedure atendimento(
      pid_pessoa        in     number,
      pid_especialidade in     varchar2 default null,
      registros         in out pkg_cm_defs.cur_def_extrato);

   procedure atendimentoretorno(
      pid_pessoa in     number,
      registros  in out pkg_cm_defs.cur_def_extrato);

   procedure atendimentomedicamento(
      pid_empresa    in     varchar2,
      pid_titular    in     varchar2,
      pid_dependente in     varchar2,
      registros      in out pkg_cm_defs.cur_def_extrato);

   procedure pesquisacidcodigo(
      ppesquisa in     varchar2 default null,
      registro  in out pkg_cm_defs.cur_def_extrato);

   procedure pesquisaciddescricao(
      ppesquisa         in     varchar2 default null,
      pid_especialidade in     varchar2,
      registros         in out pkg_cm_defs.cur_def_extrato);

   procedure pesquisamedicamentocodigo(
      ppesquisa in     varchar2 default null,
      registro  in out pkg_cm_defs.cur_def_extrato);

   procedure pesquisamedicamentodescricao(
      ppesquisa in     varchar2 default null,
      registros in out pkg_cm_defs.cur_def_extrato);

   procedure pesquisacidalergiacodigo(
      ppesquisa in     varchar2 default null,
      registro  in out pkg_cm_defs.cur_def_extrato);

   procedure pesquisacidalergiadescricao(
      ppesquisa in     varchar2 default null,
      registros in out pkg_cm_defs.cur_def_extrato);

   procedure pesquisaprocedimentoenfermaria(
      ptipopesquisa in     char default 'C',
      ppesquisa     in     varchar2 default null,
      registros     in out pkg_cm_defs.cur_def_extrato);

   procedure getprontuario(
      pid_pessoa        in     number,
      pid_especialidade in     varchar2,
      registros         in out pkg_cm_defs.cur_def_extrato);

   function getresposta(pid_aa in char, ptopico in varchar2, pquestao in varchar2)
      return varchar;

   procedure excluirreceituario(pid_aa in varchar2, pid_receituario in number);

   procedure gravabinario(pbinario in blob);

   procedure gravabinario_nw(pbinario in blob);
end;   -- Package spec


/
--------------------------------------------------------
--  DDL for Package SMC_UTILS_PKG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "AMESP"."SMC_UTILS_PKG" is
   function getmotivo_ura
      return amesp.mc_motivo.id_motivo%type;

   function getoperador_ura
      return amesp.acesso_login.id_usuario%type;

   function getsolicitante_ura
      return amesp.mc_mot_agenda_cancelada.solicitante%type;

   function getunidade_ura
      return amesp.mc_mot_agenda_cancelada.unidade%type;

   function consulta_em_fila_espera(p_n_id_agenda in amesp.mc_agenda.id_agenda%type)
      return number;

   function dados_consulta(p_n_id_agenda in amesp.mc_agenda.id_agenda%type)
      return varchar2;

   function confirma_consulta(
      p_n_id_agenda  in amesp.mc_agenda.id_agenda%type,
      p_n_id_usuario in amesp.acesso_login.id_usuario%type)
      return number;

   function verifica_e_cancela_consulta(
      p_n_id_agenda   in amesp.mc_agenda.id_agenda%type,
      p_n_id_motivo   in amesp.mc_motivo.id_motivo%type,
      p_n_id_usuario  in amesp.acesso_login.id_usuario%type,
      p_s_solicitante in amesp.mc_mot_agenda_cancelada.solicitante%type,
      p_s_unidade     in amesp.mc_mot_agenda_cancelada.unidade%type default '043',
      p_c_commit      in char default 'S')   --Willyan 06/11/2007
      return number;

   procedure cancela_consulta(
      p_n_id_agenda   in amesp.mc_agenda.id_agenda%type,
      p_n_id_motivo   in amesp.mc_motivo.id_motivo%type,
      p_n_id_usuario  in amesp.acesso_login.id_usuario%type,
      p_s_solicitante in amesp.mc_mot_agenda_cancelada.solicitante%type,
      p_s_unidade     in amesp.mc_mot_agenda_cancelada.unidade%type,
      p_c_commit      in char default 'S');   --Willyan 06/11/2007

   procedure dados_conexao_dde(
      p_c_servico out varchar2,
      p_c_topico  out varchar2,
      p_c_item    out varchar2);
end;


/
--------------------------------------------------------
--  DDL for Package Body INI_CONFIG_PG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "AMESP"."INI_CONFIG_PG" is
   type cur_ini_config is ref cursor;

   function getchave(
      psistema      varchar2,
      pchave        varchar2,
      pparametro    varchar2,
      pvalordefault varchar2 default '',
      pcentromedico varchar2 default null,
      pusuario      pls_integer default null)
      return varchar2 is
      vretorno varchar2(32767);
      l_cur    cur_ini_config;
      l_sql    varchar2(32767);
   begin
      vretorno := pvalordefault;

      if     (psistema is not null)
         and (pchave is not null)
         and (pparametro is not null) then
         l_sql :=
            'select nvl(extractvalue(conteudo_xml, ''PARAMETROS/' ||
            upper(pparametro)                                     ||
            '''),';
         l_sql := l_sql || '           ''' || upper(pvalordefault) || ''') as retorno';
         l_sql := l_sql || ' from amesp.ini_config';
         l_sql := l_sql || '  where id_sistema = ''' || upper(psistema) || '''';
         l_sql := l_sql || '   and chave = ''' || upper(pchave) || '''';

         if pcentromedico is not null then
            l_sql := l_sql || ' and id_unidade = ' || pcentromedico;
         end if;

         if pusuario is not null then
            l_sql := l_sql || ' and id_usuario = ' || pusuario;
         end if;

         begin
            open l_cur for l_sql;

            fetch l_cur
             into vretorno;

            close l_cur;
         exception
            when others then
               vretorno := pvalordefault;
         end;
      end if;

      return vretorno;
   end;
end;


/
--------------------------------------------------------
--  DDL for Package Body PAC_DADOS_GUIA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "AMESP"."PAC_DADOS_GUIA" IS
 /*
 Metodo ObterDadosGuia migrado do AppServerSisfat
 Importante:

 Parametros:

 Retorno...: Dados gravados na temp table GTT.TMP_DADOS_GUIA
 Utilizac?o:
 Historico.:
 -----------+--------------+--------------------------------------------------------------------
 2014.07.21 | Michel Gabriel | - Criacao
 -----------+--------------+--------------------------------------------------------------------
 */
PROCEDURE P_OBTER_DADOS_GUIA(
    pNumGuia IN        VARCHAR2,
    pIdGuia IN      NUMBER,
    pNumLote IN    NUMBER,
    pIdLote IN      NUMBER,
    pIdUnidade IN    VARCHAR2,
    pNomePessoa IN     VARCHAR2,
    pIdOperadora IN   VARCHAR2,
    pNrCarteirinha IN   VARCHAR2,
    pIdEspecialidade IN  VARCHAR2,
    pTpFaturamentoPlano IN  VARCHAR2,
    pNomeOperadora IN  VARCHAR2,
    pGuiasSemLote IN  VARCHAR2,
    pDataEntregaInicio IN  DATE,
    pDataEntregaFim IN    DATE,
    pDataVencimentoInicio IN  DATE,
    pDataVencimentoFim IN  DATE,
    pGuiasSemComanda IN  VARCHAR2,
    pClassifAtend IN  VARCHAR2,
    pGuiaDuplicada IN  VARCHAR2,
    pFlGuiasMarcadasFaturar IN  NUMBER,
    pTipoGuia IN        VARCHAR2,
    pDataIni IN DATE,
    pDataFim IN DATE
  )IS
  sqlCmd VARCHAR2(32767);

  BEGIN
    --delete from amesp.teste_query;
     Delete from GTT.TMP_DADOS_GUIA;

     sqlCmd :=' Insert into GTT.TMP_DADOS_GUIA
      (id_unidade, id_guia, num_guia, num_guia_operadora, id_tipo_guia,tp_guia,desc_guia,id_lote, nr_lote, id_aa,
       data_emissao, hora_chegada, fl_guia_com_erro, nr_carteirinha, nm_pessoa, id_operadora, nm_operadora, st_guia,
       nomeresumido, id_chave, tipo_atendimento, id_produto_operadora, nm_produto_operadora, especialidade,
       cd_prestador_cpf_cnpj_codigo, qtde_itens, fl_nao_faturar, vl_total
       )
      select id_unidade,id_guia, num_guia, num_guia_operadora, id_tipo_guia,tp_guia,desc_guia, id_lote, nr_lote,id_aa,
             data_emissao, hora_chegada, fl_guia_com_erro, nr_carteirinha, nm_pessoa, id_operadora, nm_operadora,st_guia,
             nomeresumido,id_chave,tipo_atendimento,id_produto_operadora,nm_produto_operadora,especialidade,
             cd_prestador_cpf_cnpj_codigo, count(id_comanda) as qtde_itens,
             case when count(id_aa) = sum(fl_nao_faturar) then 1 else 0 end as fl_nao_faturar,
             nvl(sum(vl_total), 0) as vl_total
        from (select guia.id_guia,
                     guia.num_guia,
                     guia.num_guia_operadora,
                     guia.id_tipo_guia,
                     tipo.tp_guia,
                     tipo.descricao as desc_guia,
                     guia.id_lote,
                     lote.nr_lote,
                     guia.id_aa,
                     aas.data_emissao,
                     aas.hora_chegada,
                     guia.fl_guia_com_erro,
                     p_ope.nr_carteirinha,
                     p_fis.nm_pessoa,
                     ope.id_operadora,
                     ope.nome_fantasia as nm_operadora,
                     decode(nvl(cmd.fl_nao_faturar, 0), 0, cmd.id_comanda, null) id_comanda,
                     cmd.fl_nao_faturar,
                     lote.status as st_guia,
                     cm.nome_resumido as nomeresumido,
                     cm.id_chave,
                     aas.id_unidade,
                     aas.tipo_atendimento,
                     aas.id_produto_operadora,
                     po.nm_produto_operadora,
                     esp.especialidade,
                     CASE
                       WHEN NVL(pre.tp_identificacao, 2) IN (1, 3) THEN
                        ende.nr_cnpj
                       ELSE
                        CAST(pre.cd_prestador AS varchar2(20))
                     END as cd_prestador_cpf_cnpj_codigo,
                     round(case
                             when tb.tp_valor = ''C'' and nvl(cmd.fl_nao_faturar, 0) = 0 then
                              nvl(ot.valor_ch, 0) *
                              (nvl(tc.ch_honor, 0) + nvl(tc.ch_oper, 0)) +
                              nvl(ot.valor_filme, 0) * nvl(tc.m2_filme, 0)
                             when tb.tp_valor = ''R'' and nvl(cmd.fl_nao_faturar, 0) = 0 then
                              nvl(tc.valor, 0) * (1 + nvl(ot.perc_acresc, 0) / 100)
                           end * cmd.qtde_item,
                           2) as vl_total,
                     row_number() over(partition by aas.id_aa, cmd.id_comanda order by ot.id_produto, gu.id_grupo_unidade) as linha
                from cm_aas aas
               inner join cm_guia_fat guia
                  on aas.id_aa = guia.id_aa
               inner
                join glb_tipo_guia tipo
                  on tipo.id_tipo_guia = guia.id_tipo_guia
                left join cm_lote_fat lote
                  on lote.id_lote = guia.id_lote
                left join cm_comanda cmd
                  on cmd.id_guia =
                     guia.id_guia
               inner join glb_pessoa_operadora p_ope
                  on p_ope.id_pessoa_operadora = aas.id_pessoa_operadora
               inner join glb_pessoa_fisica p_fis
                  on p_fis.id_pessoa = p_ope.id_pessoa
               inner join glb_produto_operadora po
                  on po.id_produto_operadora = aas.id_produto_operadora
               inner join operadora ope
                  on ope.id_operadora = po.id_operadora
               inner join glb_operadora_fat opef
                  on opef.id_operadora = ope.id_operadora
               inner join cm_parametros cm
                  on cm.centro_medico = aas.id_unidade
                 and cm.id_prestador = opef.id_prestador
                left join cm_prestador_operadora pre
                  on pre.centro_medico = cm.centro_medico
                 and pre.id_operadora = lote.id_operadora
                left join cm_unidade_endereco ende
                  on ende.id_unidade = cm.centro_medico
                left join aa_especialidades esp
                  on esp.codigo = aas.id_especialidade
                left join sft_grupounid_unidade gu
                  on (cm.id_chave = gu.id_unidade)
				left join amesp.sft_faturado_item_espec ie on (
					  aas.id_especialidade = ie.id_especialidade
					  and (ie.id_grupo_unidade = gu.id_grupo_unidade
						   or ie.id_grupo_unidade is null
								and not exists ( select null
												   from amesp.sft_faturado_item_espec x
												  where x.id_especialidade = ie.id_especialidade
													and x.id_grupo_unidade = gu.id_grupo_unidade
												)
						   )
					 )

                left join sft_faturado_item it
                  on (ie.id_faturado_item = it.id_faturado_item)
                left join amesp.sft_operadora_rede      opr on (    cm.id_prestador = opr.id_prestador
                  and po.id_rede_operadora = opr.id_rede_operadora)
                left join sft_produto pr
                  on (cmd.id_mat_med = pr.id_mat_med or
                     cmd.id_evento = pr.id_evento)
                left join sft_operadora_tabela ot
                  on (cm.id_prestador = ot.id_prestador
                     and opr.id_oper_grupo_rede = ot.id_oper_grupo_rede
                     and pr.id_grupo_produto = ot.id_grupo_produto and
                     (ot.id_produto is null or ot.id_produto = pr.id_produto) and
                     (ot.id_grupo_unidade is null or
                     ot.id_grupo_unidade = gu.id_grupo_unidade) and
                     ot.tp_atendimento =
                     decode(aas.tipo_atendimento, ''PA'', ''U'', ''OP'', ''E'', ''A'') and
                     ot.dt_inicio <= aas.data_emissao and
                     (ot.dt_fim is null or ot.dt_fim >= aas.data_emissao))
                left join sft_tabela_produto tp
                  on (pr.id_produto = tp.id_produto and
                     ot.id_tabela = tp.id_tabela)
                left join sft_tabela_preco tb
                  on (cm.id_prestador = tb.id_prestador and
                     ot.id_tabela = tb.id_tabela)
                left join sft_tab_prod_composicao tc
                  on (tp.id_tabela_produto = tc.id_tabela_produto and
                     tc.dt_inicio <= aas.data_emissao and
                     (tc.dt_fim is null or tc.dt_fim >= aas.data_emissao))
               where (aas.status <> ''E'' or aas.status is null)';

      if((Trim(nvl(pNumGuia,'')) <> '') and (pIdGuia = 0)) then
         sqlCmd := sqlCmd || ' and ((trim(guia.num_guia) = ' || Trim(pNumGuia) || ') or (trim(guia.num_guia_operadora) = '|| Trim(pNumGuia)||'))';
      end if;

      if(pIdGuia <> 0) then
         sqlCmd := sqlCmd || ' and (guia.id_guia = '|| to_char(pIdGuia) || ')';
      end if;

      if(pNumLote <> 0) then
         sqlCmd := sqlCmd || ' and (lote.nr_lote = ' || to_char(pNumLote) || ')';
      end if;

      if(pIdLote <> 0) then
         sqlCmd := sqlCmd || ' and (lote.id_lote = ' || to_char(pIdLote) || ')';
      end if;

      if length(trim(nvl(pTipoGuia,''))) > 0 then
         sqlCmd := sqlCmd || ' and tipo.tp_guia in ( select COLUMN_VALUE from table(cast(amesp.in_list('''|| pTipoGuia || ''', '','') as tabelavarchar2)) )';
      end if;

      if length(trim(nvl(pIdUnidade,''))) > 0 then
         sqlCmd := sqlCmd || ' and aas.id_unidade in ( select COLUMN_VALUE from table(cast(amesp.in_list('''|| pIdUnidade || ''', '','') as tabelavarchar2)) )';
      end if;

      if length(trim(nvl(pNomePessoa,''))) > 0  then
         sqlCmd := sqlCmd || ' and upper(p_fis.nm_pessoa) like ''%''' || upper(pNomePessoa) ||'''%''';
      end if;

      if length(trim(nvl(pIdOperadora,''))) > 0  then
         sqlCmd := sqlCmd || ' and (opef.id_operadora in ( select COLUMN_VALUE from table(cast(amesp.in_list('''|| pIdOperadora || ''', '','') as tabelavarchar2)) )';
         sqlCmd := sqlCmd || ' or opef.id_operadora_lote in ( select COLUMN_VALUE from table(cast(amesp.in_list('''|| pIdOperadora || ''', '','') as tabelavarchar2)) ))';
      end if;

      if length(trim(nvl(pNrCarteirinha,''))) > 0 then
         sqlCmd := sqlCmd || ' and (p_ope.nr_carteirinha = '''|| pNrCarteirinha || ''')';
      end if;

      if length(trim(nvl(pIdEspecialidade,''))) > 0 then
         sqlCmd := sqlCmd || ' and (trim(aas.id_especialidade) = '''||  pIdEspecialidade ||''')';
      end if;

      if length(trim(nvl(pNomeOperadora,''))) > 0 then
        sqlCmd := sqlCmd || ' and upper(ope.nome_fantasia) like ''%''' || upper(pNomeOperadora) || '''%'' ';
      end if;

      if (pGuiasSemLote = '1') then
         sqlCmd := sqlCmd || ' and guia.id_lote is null';
      end if;

      if (pGuiasSemComanda = '1') then
         sqlCmd := sqlCmd || ' and cmd.id_comanda is null';
      end if;

      if (pGuiaDuplicada = '1') then
          sqlCmd := sqlCmd || ' and exists (select null /*+ push_subq */
                                         from amesp.cm_aas xxx
                                         where xxx.id_pessoa_operadora = aas.id_pessoa_operadora
                                         and xxx.id_unidade = aas.id_unidade
                                         and xxx.data_emissao between to_date(''' || to_char(pDataIni,'dd/mm/yyyy') || ''') -1
                                         and to_date(''' || to_char(pDataFim,'dd/mm/yyyy') || ''') +1
                                         and xxx.id_aa <> aas.id_aa
                                         and (xxx.status is null or xxx.status <> ''E'')
                                         and abs((xxx.data_emissao + to_dsinterval(''0 '' || xxx.hora_chegada || '':00'')) -
                                               (aas.data_emissao + to_dsinterval(''0 '' || aas.hora_chegada || '':00''))) <= 0.5)';
        end if;

        if length(trim(nvl(pClassifAtend,''))) > 0 then
           sqlCmd := sqlCmd || ' and
                          case
                           when aas.fl_total_care = 1 then 11
                           when aas.tipo_atendimento = ''PA'' then 12
                           when it.id_faturado_item is not null then it.id_faturado_item
                           when aas.tipo_atendimento = ''OP'' then
                             case
                             when esp.tp_exame = ''I'' then 13
                             when esp.tp_exame = ''L'' then 14
                             when esp.tp_exame = ''O'' then 15
                             else 16
                             end
                           else 17
                          end in
                          (select COLUMN_VALUE from table(cast(amesp.in_list(''' || pClassifAtend || ''', '','') as tabelavarchar2)))
						and (ie.id_grupo_unidade is null
                          or cm.id_chave in(
                          select gruun.id_unidade from amesp.sft_faturado_item it inner join
                          amesp.sft_grupounid_unidade gruun on gruun.id_grupo_unidade = it.id_grupo_unidade
                          where it.id_faturado_item in (' || pClassifAtend || ')))';
          end if;

          if length(trim(nvl(pTpFaturamentoPlano,''))) > 0 then
            sqlCmd := sqlCmd || ' and po.tp_faturamento = ' || pTpFaturamentoPlano;
          end if;

          if(pDataEntregaInicio is not null) then
             sqlCmd := sqlCmd || ' and lote.dt_entrega_remessa >= TO_DATE(''' || to_char(pDataEntregaInicio,'dd/mm/yyyy') || ''')';
          end if;

          if(pDataEntregaFim is not null) then
             sqlCmd := sqlCmd ||' and lote.dt_entrega_remessa >= TO_DATE(''' || to_char(pDataEntregaFim,'dd/mm/yyyy') || ''')';
          end if;

          if(pDataVencimentoInicio is not null) then
             sqlCmd := sqlCmd || ' and lote.dt_vcto_remessa >= TO_DATE(''' || to_char(pDataVencimentoInicio,'dd/mm/yyyy') || ''')';
          end if;

          if(pDataVencimentoFim is not null) then
             sqlCmd := sqlCmd ||' and lote.dt_vcto_remessa >= TO_DATE(''' || to_char(pDataVencimentoFim,'dd/mm/yyyy') || ''')';
          end if;

          sqlCmd := sqlCmd || ' and aas.data_emissao between TO_DATE(''' || to_char(pDataIni,'dd/mm/yyyy') ||''') and ' || 'TO_DATE(''' || to_char(pDataFim,'dd/mm/yyyy') || ''')';

          sqlCmd := sqlCmd || ') where linha = 1';

          if(pFlGuiasMarcadasFaturar <> 0) then
             sqlCmd := sqlCmd ||' and (fl_nao_faturar is null or fl_nao_faturar = 0) ';
          end if;
          sqlCmd := sqlCmd || '
       group by id_guia,
                num_guia,
                num_guia_operadora,
                id_tipo_guia,
                tp_guia,
                desc_guia,
                id_lote,
                nr_lote,
                id_aa,
                data_emissao,
                hora_chegada,
                fl_guia_com_erro,
                nr_carteirinha,
                nm_pessoa,
                id_operadora,
                nm_operadora,
                st_guia,
                nomeresumido,
                id_chave,
                id_unidade,
                tipo_atendimento,
                id_produto_operadora,
                nm_produto_operadora,
                especialidade,
                cd_prestador_cpf_cnpj_codigo';

     EXECUTE IMMEDIATE sqlCmd;

  END P_OBTER_DADOS_GUIA;

  PROCEDURE P_OBTER_DADOS_GUIA_TELE(
    pNumGuia IN        VARCHAR2,
    pIdGuia IN      NUMBER,
    pNumLote IN    NUMBER,
    pIdLote IN      NUMBER,
    pIdUnidade IN    VARCHAR2,
    pNomePessoa IN     VARCHAR2,
    pIdOperadora IN   VARCHAR2,
    pNrCarteirinha IN   VARCHAR2,
    pIdEspecialidade IN  VARCHAR2,
    pTpFaturamentoPlano IN  VARCHAR2,
    pNomeOperadora IN  VARCHAR2,
    pGuiasSemLote IN  VARCHAR2,
    pDataEntregaInicio IN  DATE,
    pDataEntregaFim IN    DATE,
    pDataVencimentoInicio IN  DATE,
    pDataVencimentoFim IN  DATE,
    pGuiasSemComanda IN  VARCHAR2,
    pClassifAtend IN  VARCHAR2,
    pGuiaDuplicada IN  VARCHAR2,
    pFlGuiasMarcadasFaturar IN  NUMBER,
    pTipoGuia IN        VARCHAR2,
    pDataIni IN DATE,
    pDataFim IN DATE
  )IS
  BEGIN
    Delete from GTT.TMP_DADOS_GUIA;

    Insert into GTT.TMP_DADOS_GUIA
      (id_guia,
       num_guia,
       id_tipo_guia,
       tp_guia,
       desc_guia,
       id_lote,
       nr_lote,
       id_aa,
       data_emissao,
       hora_chegada,
       fl_guia_com_erro,
       nr_carteirinha,
       nm_pessoa,
       id_operadora,
       nm_operadora,
       st_guia,
       nomeresumido,
       id_chave,
       id_unidade,
       tipo_atendimento,
       id_produto_operadora,
       nm_produto_operadora,
       especialidade,
       cd_prestador_cpf_cnpj_codigo,
       qtde_itens,
       fl_nao_faturar,
       vl_total
       )
select id_guia,
       num_guia,
       id_tipo_guia,
       tp_guia,
       desc_guia,
       id_lote,
       nr_lote,
       id_aa,
       data_emissao,
       hora_chegada,
       fl_guia_com_erro,
       nr_carteirinha,
       nm_pessoa,
       id_operadora,
       nm_operadora,
       st_guia,
       nomeresumido,
       id_chave,
       id_unidade,
       tipo_atendimento,
       id_produto_operadora,
       nm_produto_operadora,
       especialidade,
       cd_prestador_cpf_cnpj_codigo,
       count(id_comanda) as qtde_itens,
       case
         when count(id_aa) = sum(fl_nao_faturar) then
          1
         else
          0
       end as fl_nao_faturar,
       nvl(sum(vl_total), 0) as vl_total
  from (select guia.id_guia,
               guia.num_guia,
               guia.id_tipo_guia,
               tipo.tp_guia,
               tipo.descricao as desc_guia,
               guia.id_lote,
               lote.nr_lote,
               case
                 when guia.id_aa is null then
                  to_char(guia.id_atendimento)
                 else
                  guia.id_aa
               end id_aa,
               guia.id_atendimento,
               trunc(tele.dt_hr_atendimento) data_emissao,
               to_char(tele.dt_hr_atendimento, 'hh24:mi') hora_chegada,
               guia.fl_guia_com_erro,
               p_ope.nr_carteirinha,
               p_fis.nm_pessoa,
               ope.id_operadora,
               ope.nome_fantasia as nm_operadora,
               decode(nvl(cmd.fl_nao_faturar, 0), 0, cmd.id_comanda, null) id_comanda,
               cmd.fl_nao_faturar,
               lote.status as st_guia,
               cm.nome_resumido as nomeresumido,
               cm.id_chave,
               tele.id_unidade,
               'A' tipo_atendimento,
               tele.id_produto_operadora,
               po.nm_produto_operadora,
               eve.nm_programa especialidade,
               CASE
                 WHEN NVL(pre.tp_identificacao, 2) IN (1, 3) THEN
                  ende.nr_cnpj
                 ELSE
                  CAST(pre.cd_prestador AS varchar2(20))
               END as cd_prestador_cpf_cnpj_codigo,
               round(case
                       when tb.tp_valor = 'C' and nvl(cmd.fl_nao_faturar, 0) = 0 then
                        ot.valor_ch * (tc.ch_honor + tc.ch_oper) +
                        ot.valor_filme * tc.m2_filme
                       when tb.tp_valor = 'R' and nvl(cmd.fl_nao_faturar, 0) = 0 then
                        tc.valor * (1 + nvl(ot.perc_acresc, 0) / 100)
                     end * cmd.qtde_item,
                     2) as vl_total,
               row_number() over(partition by tele.id_atendimento, cmd.id_comanda order by ot.id_produto, gu.id_grupo_unidade) as linha
          from cm_atendimento tele
         inner join cm_guia_fat guia
            on tele.id_atendimento = guia.id_atendimento
         inner /*left*/
          join glb_tipo_guia tipo
            on tipo.id_tipo_guia = guia.id_tipo_guia
          left join cm_lote_fat lote
            on lote.id_lote = guia.id_lote
          left join cm_comanda cmd
            on cmd.id_guia = guia.id_guia
         inner join glb_pessoa_operadora p_ope
            on p_ope.id_pessoa_operadora = tele.id_pessoa_operadora
         inner join glb_pessoa_fisica p_fis
            on p_fis.id_pessoa = p_ope.id_pessoa
         inner join glb_produto_operadora po
            on po.id_produto_operadora = tele.id_produto_operadora
         inner join operadora ope
            on ope.id_operadora = po.id_operadora
         inner join glb_operadora_fat opef
            on opef.id_operadora = ope.id_operadora
         inner join cm_parametros cm
            on cm.centro_medico = tele.id_unidade
           and cm.id_prestador = opef.id_prestador
          left join cm_prestador_operadora pre
            on pre.centro_medico = cm.centro_medico
           and pre.id_operadora = lote.id_operadora
          left join cm_unidade_endereco ende
            on ende.id_unidade = cm.centro_medico
        /* tabelas de preco */
          left join sft_grupounid_unidade gu
            on (cm.id_chave = gu.id_unidade)
          left join amesp.sft_operadora_rede oper
            on (cm.id_prestador = oper.id_prestador and
               po.id_rede_operadora = oper.id_rede_operadora)
          left join sft_produto pr
            on (cmd.id_mat_med = pr.id_mat_med or
               cmd.id_evento = pr.id_evento)
          left join sft_operadora_tabela ot
            on (cm.id_prestador = ot.id_prestador and
               oper.id_oper_grupo_rede = ot.id_oper_grupo_rede and
               pr.id_grupo_produto = ot.id_grupo_produto and
               (ot.id_produto is null or ot.id_produto = pr.id_produto) and
               (ot.id_grupo_unidade is null or
               ot.id_grupo_unidade = gu.id_grupo_unidade) and
               ot.tp_atendimento = 'A' and
               ot.dt_inicio <= trunc(tele.dt_hr_atendimento) and
               (ot.dt_fim is null or
               ot.dt_fim >= trunc(tele.dt_hr_atendimento)))
          left join sft_tabela_produto tp
            on (pr.id_produto = tp.id_produto and
               ot.id_tabela = tp.id_tabela)
          left join sft_tabela_preco tb
            on (cm.id_prestador = tb.id_prestador and
               ot.id_tabela = tb.id_tabela)
          left join sft_tab_prod_composicao tc
            on (tp.id_tabela_produto = tc.id_tabela_produto and
               tc.dt_inicio <= trunc(tele.dt_hr_atendimento) and
               (tc.dt_fim is null or
               tc.dt_fim >= trunc(tele.dt_hr_atendimento)))
         inner join AMESP.Cm_Tele_Atendimento_Programas prog
            on prog.id_atendimento = tele.id_atendimento
         INNER JOIN amesp.cm_programas eve
            ON eve.id_programa = prog.id_programa

         where (pNumGuia is null or
               trim(guia.num_guia) like '%' || pNumGuia || '%')
           and (pIdGuia = 0 or guia.id_guia = pIdGuia)
           and (pNumLote = 0 or lote.nr_lote = pNumLote)
           and (pIdLote = 0 or lote.id_lote = pIdLote)
           and (pTipoGuia is null or tipo.tp_guia in (
                 select COLUMN_VALUE from table(cast(amesp.in_list(pTipoGuia, ',') as tabelavarchar2))))
           and (pIdUnidade is null or tele.id_unidade in (
               select COLUMN_VALUE from table(cast(amesp.in_list(pIdUnidade, ',') as tabelavarchar2))))
           and (pNomePessoa is null or upper(p_fis.nm_pessoa) like '%' || pNomePessoa || '%')
           and (pIdOperadora is null or opef.id_operadora in (
           select COLUMN_VALUE from table(cast(amesp.in_list(pIdOperadora, ',') as tabelavarchar2))
           ) or
               opef.id_operadora_lote in (
               select COLUMN_VALUE from table(cast(amesp.in_list(pIdOperadora, ',') as tabelavarchar2))))
           and (pNrCarteirinha is null or
               p_ope.nr_carteirinha = pNrCarteirinha)
           and (pTpFaturamentoPlano is null or po.tp_faturamento = pTpFaturamentoPlano)
           and upper(ope.nome_fantasia) like '%' || upper(pNomeOperadora) || '%'
           and (pGuiasSemLote is null or guia.id_lote is null)
           and (pDataEntregaInicio is null or lote.dt_entrega_remessa >= TO_DATE(pDataEntregaInicio))
           and (pDataEntregaFim is null or lote.dt_entrega_remessa <= TO_DATE(pDataEntregaFim))
           and (pDataVencimentoInicio is null or lote.dt_vcto_remessa >= TO_DATE(pDataVencimentoInicio))
           and (pDataVencimentoFim is null or lote.dt_vcto_remessa <= TO_DATE(pDataVencimentoFim))
           and (trunc(tele.dt_hr_atendimento) between TO_DATE(pDataIni) and TO_DATE(pDataFim))
           and (pGuiasSemComanda  is null or cmd.id_comanda is null))
           where linha = 1
              and (pFlGuiasMarcadasFaturar = 0 or (fl_nao_faturar is null or fl_nao_faturar = 0))
 group by id_guia,
          num_guia,
          id_tipo_guia,
          tp_guia,
          desc_guia,
          id_lote,
          nr_lote,
          id_aa,
          id_atendimento,
          data_emissao,
          hora_chegada,
          fl_guia_com_erro,
          nr_carteirinha,
          nm_pessoa,
          id_operadora,
          nm_operadora,
          st_guia,
          nomeresumido,
          id_chave,
          id_unidade,
          tipo_atendimento,
          id_produto_operadora,
          nm_produto_operadora,
          especialidade,
          cd_prestador_cpf_cnpj_codigo;


  END P_OBTER_DADOS_GUIA_TELE;

END PAC_DADOS_GUIA;


/
--------------------------------------------------------
--  DDL for Package Body PKG_CONFIG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "AMESP"."PKG_CONFIG" IS

   FUNCTION getsmtp_host RETURN VARCHAR2 IS
   BEGIN
      RETURN NVL (amesp.ini_config_pg.getchave ('INI', 'SMTP', 'SMTP_HOST'),'192.168.104.230');
   END;

   FUNCTION getsmtp_port RETURN PLS_INTEGER IS
   BEGIN
      RETURN NVL (amesp.ini_config_pg.getchave ('INI', 'SMTP', 'SMTP_PORT'),25);
   END;

   FUNCTION getid_email_padrao RETURN PLS_INTEGER IS
   BEGIN
      RETURN 1;
   END;
END;


/
--------------------------------------------------------
--  DDL for Package Body PKGDEFS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "AMESP"."PKGDEFS" as
   -- Senha inicial utilizada para novos usuários. Fábio, 15/01/2007.
   l_vc_sen_padrao varchar2(50);

   -- Variavel do tipo da tabela para receber os valores da func. identificador_tabela
--   vRowTableRet  historicos.log_tabela%rowtype;

/* procedure CONECTA_INICIO inclui nome do usuario e audsid em acesso_audit */
   procedure conecta_inicio(rlogin in varchar2) is
      vid acesso_login.id_usuario%type;
      pragma autonomous_transaction;
   begin
      -- verifica se usuario cadastrado em acesso_login
      --vId:=RETORNA_ID_USUARIO(rLogin,1);
      vid := retorna_id_usuario(rlogin);   -- Removi o segundo param. Fábio, 15/01/2007
      -- registra id_usuario na coluna client_info de v$session
      dbms_application_info.set_client_info(vid);

      -- registra valores nas variáveis públicas desta package
      select vid, s.osuser, s.machine
        into guser, gosuser, gmachine
        from v$session s
       where s.sid = (select sid
                        from v$mystat
                       where rownum = 1);
    /*
     ** Susbstituí a query abaixo conforme orientação do Renato. Fábio, 06/09/2005. **
     SELECT vId, osuser, machine INTO gUser,gOSUser,gMachine
     FROM v$session
     WHERE audsid=SYS_CONTEXT('USERENV','SESSIONID');
   */
   end;

/* procedure CONECTA_FIM exclui registro de acesso_audit para a sessao atual (audsid) */
   procedure conecta_fim is
   /*vSId acesso_audit.audsid%TYPE;*/
   begin
      /* desativado em 30/03/2004 - Zé Luiz
      SELECT USERENV('SESSIONID') INTO vSId FROM dual;
      DELETE FROM acesso_audit WHERE audsid=vSId;
      COMMIT;
      */
      null;
   end;

/* procedure ZERA_LISTA - reinicializa variavel rLista */
   procedure zera_lista(rlista in out tlistarowid) is
   begin
      rlista := tlistarowid();
   end;

/* procedure ADICIONA_LISTA - adiciona registro a rLista */
   procedure adiciona_lista(rlista in out tlistarowid, rrowid in rowid) is
   begin
      rlista.extend;
      rlista(rlista.last).numrowid := rrowid;
   end;

/* procedure ZERA_TABELA - reinicializa table object rLista */
   procedure zera_tabela(rlista in out nocopy ttstring100) is
   begin
      if rlista is null then
         rlista := ttstring100();
      else
         rlista.delete;
      end if;
   end;

/* procedure ADICIONA_TABELA - adiciona registro a rLista */
   procedure adiciona_tabela(rlista in out nocopy ttstring100, rtexto in varchar2) is
   begin
      rlista.extend;
      rlista(rlista.last) := tostring100(rtexto);
   end;

/* func?o TABELA_MUTANTE retorna True se a tabel rOwner.rTabela e 'mutating' durante a execuc?o da trigger */
   function tabela_mutante(rowner in varchar2, rtabela in varchar2)
      return boolean is
      vint           integer;
      vdummy         integer;
      vret           boolean;
      mutating_table exception;
      pragma exception_init(mutating_table, -4091);
   begin
      begin
         vret := false;
         vint := dbms_sql.open_cursor();
         dbms_sql.parse(vint,
                        'SELECT NULL FROM ' || rowner || '.' || rtabela || ' WHERE 0=1',
                        dbms_sql.v7);
         vdummy := dbms_sql.execute(vint);
      exception
         when mutating_table then
            vret := true;
      end;

      if dbms_sql.is_open(vint) then
         dbms_sql.close_cursor(vint);
      end if;

      return vret;
   end;

/* func?o NOVA_CHAVE_LOG - retorna nextval da sequence registrada em historicos.log_tabela para a tabela rOwner.rTabela */
/*   function nova_chave_log(rowner in varchar2, rtabela in varchar2)
      return number is
      vsequence  historicos.log_tabela.sequence%type;
      vcursor    integer;
      vchave     number;
      vdummy     pls_integer;
      e_sequence exception;
      pragma exception_init(e_sequence, -2289);
   begin
      select sequence
        into vsequence
        from historicos.log_tabela
       where owner = upper(rowner)
         and nome = upper(rtabela);

      vcursor := dbms_sql.open_cursor;
      dbms_sql.parse(vcursor,
                     'SELECT ' || vsequence || '.nextval id_chave FROM DUAL',
                     dbms_sql.v7);
      dbms_sql.define_column(vcursor, 1, vchave);
      vdummy := dbms_sql.execute_and_fetch(vcursor);
      dbms_sql.column_value(vcursor, 1, vchave);
      dbms_sql.close_cursor(vcursor);
      return vchave;
   exception
      when no_data_found then
         raise_application_error(-20001,
                                 'Tabela ' || rtabela || ' nao registrada para log');
      when e_sequence then
         dbms_sql.close_cursor(vcursor);
         raise_application_error(-20001,
                                 'Erro '       ||
                                 sqlcode       ||
                                 ': Sequence ' ||
                                 vsequence     ||
                                 ' nao existe');
   end;
*/
/* func?o IGUAL - compara dois valores, inclusive nulos */
   function igual(r1 in varchar2, r2 in varchar2)
      return boolean is
   begin
      return(       r1 is null
                and r2 is null
             or     r1 is not null
                and r2 is not null
                and r1 = r2);
   end;

   function igual(r1 in date, r2 in date)
      return boolean is
   begin
      return(       r1 is null
                and r2 is null
             or     r1 is not null
                and r2 is not null
                and r1 = r2);
   end;

   function igual(r1 in number, r2 in number)
      return boolean is
   begin
      return(       r1 is null
                and r2 is null
             or     r1 is not null
                and r2 is not null
                and r1 = r2);
   end;

   function igual(r1 in clob, r2 in clob)
      return boolean is
   begin
      return(       r1 is null
                and r2 is null
             or     r1 is not null
                and r2 is not null
                and dbms_lob.compare(r1, r2) = 0);
   end;

   function igual(r1 in blob, r2 in blob)
      return boolean is
   begin
      return(       r1 is null
                and r2 is null
             or     r1 is not null
                and r2 is not null
                and dbms_lob.compare(r1, r2) = 0);
   end;

/* funcao IDENTIFICADOR_TABELA - retorna id_tabela cadastrado em historicos.log_tabela para rOwner.rTabela */
/*   function identificador_tabela(rowner in varchar2, rtabela in varchar2)
      return historicos.log_tabela%rowtype is
      vRowTable historicos.log_tabela%rowtype;
   begin
      select *
        into vRowTable
        from historicos.log_tabela
       where owner = upper(rowner)
         and nome = upper(rtabela);

      return vRowTable;
   exception
      when no_data_found then
         raise_application_error(-20001,
                                 'Tabela ' || rtabela || ' nao registrada para log');
   end;
*/
   procedure setar_usuario(p_i_id_usuario in integer) is
   begin
      /*
        Para uso das aplicações, para informarem qual o usuário da sessão.

        (As aplicações devem deixar de setar diretamente o client_info da sessão
         e passar a usar esta procedure. Dessa forma escondemos das aplicações a forma
         como é armazenada a identificação do usuário.)

        (Seria suficiente para os logs se esta procedure somente setasse o valor da
         variável guser. A gravação no client_info foi mantida para compatibilidade
         com as aplicaçõesque ainda gravam diretamente nesse campo.)

        Histórico:
        -----------+--------+--------------------------------------------------------------------
        2011.07.26 | Zé Luiz| Criação.
        -----------+--------+--------------------------------------------------------------------
      */
      guser := p_i_id_usuario;
      dbms_application_info.set_client_info(to_char(p_i_id_usuario));
   end;

/* seta variaveis privadas da package com a identificac?o do usuario */
   procedure identifica_usuario(rmutante in boolean default false) is
      vid v$session.audsid%type;
   begin
      if rmutante then
         guser := -1;
      elsif    guser is null
            or guser < 1 then
         dbms_application_info.read_client_info(guser);
      end if;

      if    gosuser is null
         or gmachine is null then
         select s.osuser, s.machine
           into gosuser, gmachine
           from v$session s
          where s.sid = (select sid
                           from v$mystat
                          where rownum = 1);
       /*
        ** Susbstituí a query abaixo conforme orientação do Renato. Fábio, 06/09/2005. **
        SELECT s.osuser,s.machine INTO gOSUser,gMachine
        FROM v$session s
        WHERE s.audsid=SYS_CONTEXT('USERENV','SESSIONID');
      */
      end if;

      -- Se o OSUser continuar vazio após o bloco acima, assume que a alteração
      -- está sendo feita por um JOB do Oracle.
      -- Fábio, 12/01/2006.
      if gosuser is null then
         gosuser := 'SISTEMA';
         gmachine := 'SERVIDOR';
      end if;
   end;

/* procedure REGISTRA_INCLUSAO - registra inclusao de registro em historicos.log_alteracao */
/*   procedure registra_inclusao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rownerhist in varchar2 default 'historicos') is
   begin

      vRowTableRet := identificador_tabela(rowner, rtabela);
      --Loga somente tabela que estiver como ativa na tabela LOG_TABELA
      if(vRowTableRet.Ativo =0) then
         return;
      end if;

      identifica_usuario;

      execute immediate 'INSERT INTO '                                              ||
                        vRowTableRet.Owner_Log ||'.'|| vRowTableRet.Nome_Log        ||
                        '(data_hora,id_usuario,osuser,machine,id_chave,i_a,data_hora_utc)' ||
                        'VALUES (SYSDATE,:gUser,:gOSUser,:gMachine,:rChave,''I'',localtimestamp at time zone ''UTC'')'
                  using guser, gosuser, gmachine, rchave;
   end;
*/
/* procedure REGISTRA_DELECAO - registra delecao de registro na tabela correspondente */
   procedure registra_delecao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rownerlog  in varchar2,
      rtabelalog in varchar2,
      rrowid     in rowid) is
      vcursor integer;
      vqtd    integer;
   begin
      return;

      identifica_usuario;

      if pkgdefs.tabela_mutante(rowner, rtabela) then
         guser := -1;
      end if;

      vcursor := dbms_sql.open_cursor;
      dbms_sql.parse(vcursor,
                     'INSERT INTO '      ||
                     rownerlog           ||
                     '.'                 ||
                     rtabelalog          ||
                     ' (SELECT SYSDATE,' ||
                     guser               ||
                     ','''               ||
                     gosuser             ||
                     ''','''             ||
                     gmachine            ||
                     ''', a.* FROM '     ||
                     rowner              ||
                     '.'                 ||
                     rtabela             ||
                     ' a WHERE rowid=''' ||
                     rrowid              ||
                     ''')',
                     dbms_sql.v7);
      vqtd := dbms_sql.execute(vcursor);
      dbms_sql.close_cursor(vcursor);

      if vqtd <> 1 then
         raise_application_error(-20000,
                                 '<<Historico de delec?o n?o pode ser registrado.>>');
      end if;
   end;

/* procedure REGISTRA_ALTERACAO - compara valores e se diferentes registra em historicos.log_alteracao */
/*   procedure registra_alteracao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rcoluna    in varchar2,
      roriginal  in varchar2,
      rnovo      in varchar2,
      rownerhist in varchar2 default 'historicos') is
   begin
      vRowTableRet := identificador_tabela(rowner, rtabela);
      --Loga somente tabela que estiver como ativa na tabela LOG_TABELA
      if(vRowTableRet.Ativo =0) then
         return;
      end if;

      if not igual(roriginal, rnovo) then
         execute immediate 'INSERT INTO '                                           ||
                           vRowTableRet.Owner_Log ||'.'|| vRowTableRet.Nome_Log     ||
                           ' (data_hora,id_usuario,osuser,machine,id_chave,i_a,nome_coluna,tipo_coluna,original,novo,data_hora_utc)' ||
                           'VALUES (SYSDATE,:gUser,:gOSUser,:gMachine,:rChave,''A'',:rColuna,''C'',:rOriginal,:rNovo,localtimestamp at time zone ''UTC'')'
                     using guser,
                           gosuser,
                           gmachine,
                           rchave,
                           rcoluna,
                           roriginal,
                           rnovo;
      end if;
   end;
*/
/*   procedure registra_alteracao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rcoluna    in varchar2,
      roriginal  in date,
      rnovo      in date,
      rownerhist in varchar2 default 'historicos') is
   begin
      vRowTableRet := identificador_tabela(rowner, rtabela);
      --Loga somente tabela que estiver como ativa na tabela LOG_TABELA
      if(vRowTableRet.Ativo =0) then
         return;
      end if;

      if not igual(roriginal, rnovo) then
         execute immediate 'INSERT INTO '                                           ||
                           vRowTableRet.Owner_Log ||'.'|| vRowTableRet.Nome_Log     ||
                           ' (data_hora,id_usuario,osuser,machine,id_chave,i_a,nome_coluna,tipo_coluna,original,novo,data_hora_utc)' ||
                           'VALUES (SYSDATE,:gUser,:gOSUser,:gMachine,:rChave,''A'',:rColuna,''D'',:rOriginal,:rNovo,localtimestamp at time zone ''UTC'')'
                     using guser,
                           gosuser,
                           gmachine,
                           rchave,
                           rcoluna,
                           roriginal,
                           rnovo;
      end if;
   end;
*/
/*   procedure registra_alteracao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rcoluna    in varchar2,
      roriginal  in number,
      rnovo      in number,
      rownerhist in varchar2 default 'historicos') is
   begin
      vRowTableRet := identificador_tabela(rowner, rtabela);
      --Loga somente tabela que estiver como ativa na tabela LOG_TABELA
      if(vRowTableRet.Ativo =0) then
         return;
      end if;

      if not igual(roriginal, rnovo) then
         execute immediate 'INSERT INTO '                                           ||
                           vRowTableRet.Owner_Log ||'.'|| vRowTableRet.Nome_Log     ||
                           ' (data_hora,id_usuario,osuser,machine,id_chave,i_a,nome_coluna,tipo_coluna,original,novo,data_hora_utc)' ||
                           'VALUES (SYSDATE,:gUser,:gOSUser,:gMachine,:rChave,''A'',:rColuna,''N'',:rOriginal,:rNovo,localtimestamp at time zone ''UTC'')'
                     using guser,
                           gosuser,
                           gmachine,
                           rchave,
                           rcoluna,
                           roriginal,
                           rnovo;
      end if;
   end;
*/
/*   procedure registra_alteracao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rcoluna    in varchar2,
      roriginal  in clob,
      rnovo      in clob,
      rownerhist in varchar2 default 'historicos') is
   begin
      vRowTableRet := identificador_tabela(rowner, rtabela);
      --Loga somente tabela que estiver como ativa na tabela LOG_TABELA
      if(vRowTableRet.Ativo =0) then
         return;
      end if;

      if not igual(roriginal, rnovo) then
         execute immediate 'INSERT INTO '                                           ||
                           vRowTableRet.Owner_Log ||'.'|| vRowTableRet.Nome_Log     ||
                           ' (data_hora,id_usuario,osuser,machine,id_chave,i_a,nome_coluna,tipo_coluna,original_lob,novo_lob,data_hora_utc)' ||
                           'VALUES (SYSDATE,:gUser,:gOSUser,:gMachine,:rChave,''A'',:rColuna,''L'',:rOriginal,:rNovo,localtimestamp at time zone ''UTC'')'
                     using guser,
                           gosuser,
                           gmachine,
                           rchave,
                           rcoluna,
                           roriginal,
                           rnovo;
      end if;
   end;
*/
/*   procedure registra_alteracao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rcoluna    in varchar2,
      roriginal  in blob,
      rnovo      in blob,
      rownerhist in varchar2 default 'historicos') is
      vclob      clob;

      \* Para conversão de conteúdo blob para clob (Zé Luiz, 07/02/2011) *\
      function blob_para_clob(p_l_blob in blob)
         return clob as
--         l_l_blob        blob := p_l_blob;
         l_l_clob        clob;
         l_n_dest_offset number  := 1;
         l_n_src_offset  number  := 1;
         l_i_amount      integer := dbms_lob.lobmaxsize;
         l_n_blob_csid   number  := dbms_lob.default_csid;
         l_i_lang_ctx    integer := dbms_lob.default_lang_ctx;
         l_i_warning     integer;
      begin
--         dbms_lob.createtemporary(lob_loc => l_l_blob,
--                                  cache   => true,
--                                  dur     => dbms_lob.session);
         if p_l_blob is not null then
            dbms_lob.createtemporary(lob_loc    => l_l_clob,
                                     cache      => true,
                                     dur        => dbms_lob.session);
            dbms_lob.converttoclob(l_l_clob,
                                   p_l_blob,
                                   l_i_amount,
                                   l_n_dest_offset,
                                   l_n_src_offset,
                                   l_n_blob_csid,
                                   l_i_lang_ctx,
                                   l_i_warning);
         end if;

         return l_l_clob;
      end;
   begin
      vRowTableRet := identificador_tabela(rowner, rtabela);
      --Loga somente tabela que estiver como ativa na tabela LOG_TABELA
      if(vRowTableRet.Ativo =0) then
         return;
      end if;

      if not igual(roriginal, rnovo) then

         \*
           Passa a converter o conteúdo blob para clob antes da gravação do log.
           (Sem a conversão estava dando erro, e para evitar a criação de coluna
            blob na tabela log_alteracao.)

           Passa também a gravar somente o conteúdo original da coluna. Fiz assim
           porque o parâmetro rnovo estava sempre chegando vazio, mesmo que a coluna
           tivesse algum conteúdo após a alteração. (Provavelmente a trigger não
           esteja disponibilizando o conteúdo...)

           (Zé Luiz, 07/02/2011)
         *\
         vclob := blob_para_clob(roriginal);

         execute immediate 'INSERT INTO '                                           ||
                           vRowTableRet.Owner_Log ||'.'|| vRowTableRet.Nome_Log     ||
                           ' (data_hora,id_usuario,osuser,machine,id_chave,i_a,nome_coluna,tipo_coluna,original_lob,data_hora_utc)' ||
                           'VALUES (SYSDATE,:gUser,:gOSUser,:gMachine,:rChave,''A'',:rColuna,''B'',:rOriginal,localtimestamp at time zone ''UTC'')'
                     using guser, gosuser, gmachine, rchave, rcoluna, vclob;
      end if;
   end;
*/
/*   procedure registra_alteracao(
      rowner     in varchar2,
      rtabela    in varchar2,
      rchave     in number,
      rcoluna    in varchar2,
      roriginal  in xmltype,
      rnovo      in xmltype,
      rownerhist in varchar2 default 'historicos') is
      vValorOriginal clob;
      vValorNovo clob;
   begin
      vRowTableRet := identificador_tabela(rowner, rtabela);
      --Loga somente tabela que estiver como ativa na tabela LOG_TABELA
      if(vRowTableRet.Ativo =0) then
         return;
      end if;

      if ((roriginal is not null And rnovo is not null
        And not igual(roriginal.getStringVal, rnovo.getStringVal) )
        OR (roriginal is not null And rnovo is null)
        OR (roriginal is null And rnovo is not null)) then

         if (roriginal is not null) then
            vValorOriginal := roriginal.getCLOBVal;
         end if;

         if (rnovo is not null) then
            vValorNovo := rnovo.getCLOBVal;
         end if;

         execute immediate 'INSERT INTO '                                           ||
                           vRowTableRet.Owner_Log ||'.'|| vRowTableRet.Nome_Log     ||
                           ' (data_hora,id_usuario,osuser,machine,id_chave,i_a,nome_coluna,tipo_coluna,original_lob,novo_lob,data_hora_utc)' ||
                           'VALUES (SYSDATE,:gUser,:gOSUser,:gMachine,:rChave,''A'',:rColuna,''X'',:rOriginal,:rNovo,localtimestamp at time zone ''UTC'')'
                     using guser,
                           gosuser,
                           gmachine,
                           rchave,
                           rcoluna,
                           vValorOriginal,
                           vValorNovo;
      end if;
   end;
*/
   procedure dropa(rtipo in varchar2, rowner in varchar2, robjeto in varchar2) is
      vtipo     varchar2(8);
      vretorno  varchar2(100);
      esequence exception;
      etabela   exception;
      pragma exception_init(esequence, -2289);
      pragma exception_init(etabela, -942);
   begin
      vtipo := case upper(rtipo)
                 when 'S' then 'SEQUENCE'
                 when 'T' then 'TABLE'
              end;

      if vtipo is not null then
         begin
            execute immediate 'DROP ' || vtipo || ' ' || rowner || '.' || robjeto;

            vretorno :=
                       vtipo || ' eliminado(a) com sucesso: ' || rowner || '.' || robjeto;
         exception
            when esequence or etabela then
               vretorno := vtipo || ' não existe: ' || rowner || '.' || robjeto;
         end;
      else
         vretorno :=
                    'Parâmetro de tipo inválido para objeto ' || rowner || '.' || robjeto;
      end if;

      dbms_output.put_line(vretorno);
   end;

   function getidusuario
      return integer is
   /*
     Objetivo: retornar o id_usuario de quem está utilizando a sessão

     Histórico:
     -----------+--------+--------------------------------------------------------------------
     2006.12.13 |Zé Luiz | Criação.
     -----------+--------+--------------------------------------------------------------------
   */
   begin
      identifica_usuario;
      return guser;
   end;

   procedure gerasenpadrao is
   /*
     Gera uma senha inicial randômica.

     Atenção: A cada execução desta procedure, uma nova senha padrão é redefinida para a sessão.

     Histórico:
     -----------+--------+--------------------------------------------------------------------
     2007.02.05 | Fábio  | Antes a senha gerada continha números e letras. A pedido da Adilce,
                |        | passei a considerar apenas letras, pois os médicos de CMs se con-
                |        | fundiam muito com 0 e O.
     -----------+--------+--------------------------------------------------------------------
     2007.01.22 | Fábio  | Criação.
     -----------+--------+--------------------------------------------------------------------
   */
   begin
      l_vc_sen_padrao := dbms_random.string('U', 10);
   end;

   function getsenpadrao
      return varchar2 is
   /*
     Retorna a senha a ser utilizada para novos usuários.

     Histórico:
     -----------+--------+--------------------------------------------------------------------
     2007.01.15 | Fábio  | Criação.
     -----------+--------+--------------------------------------------------------------------
   */
   begin
      return l_vc_sen_padrao;
   end;

end;


/
--------------------------------------------------------
--  DDL for Package Body PKG_LOCK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "AMESP"."PKG_LOCK" is
   function obter_handle(rcodigo in varchar2, rexpiration in integer)
      return varchar2 is
      pragma autonomous_transaction;
      vhandle varchar2(128);
   begin
      if nvl(rexpiration, 0) > 0 then
         sys.dbms_lock.allocate_unique(rcodigo, vhandle, rexpiration);
      else
         sys.dbms_lock.allocate_unique(rcodigo, vhandle, 8 * 60 * 60);   -- 8 horas
      end if;

      return vhandle;
   end;

/*   function obter_travamento(
      rcodigo     in     varchar2,
      rresult     out    integer,
      rtipolock   in     integer default sys.dbms_lock.x_mode,
      rmaxtempo   in     integer default 1,
      rcommit     in     boolean default false,
      rexpiration in     integer default null)
      return boolean is
      vhandle  varchar2(128);
      vsucesso integer;
   begin
      vhandle := obter_handle(rcodigo, rexpiration);
      rresult := dbms_lock.request(vhandle, rtipolock, rmaxtempo, rcommit);

      if rresult in(trsuccess, trowner) then
         return true;
      else
         return false;
      end if;
   end; */

   function liberar_travamento(rcodigo in varchar2, rresult out integer)
      return boolean is
      vhandle  varchar2(128);
      vsucesso integer;
   begin
      dbms_lock.allocate_unique(rcodigo, vhandle);
      rresult := dbms_lock.release(vhandle);

      if rresult in(trsuccess, trowner) then
         return true;
      else
         return false;
      end if;
   end;

   function existe_travamento(rcodigo in varchar2, rlogin in varchar2 default null)
      return boolean is
   begin
      return tem_travamento(rcodigo, rlogin) = 'S';
   end;

   function tem_travamento(rcodigo in varchar2, rlogin in varchar2 default null)
      return varchar2 is
      vaux pls_integer;
   begin
      select /*+ ordered */
             1
        into vaux
        from gv$lock l, sys.dbms_lock_allocated d, gv$session s
       where l.id1 = d.lockid
         and l.sid = s.sid
         and l.inst_id = s.inst_id
         and (   rlogin is null
              or s.client_info = rlogin)
         and l.type = 'UL'
         and d.name = rcodigo;

      return 'S';
   exception
      when no_data_found then
         return 'N';
   end;

   function detalhar_travamento(
      rcodigo           in     varchar2,
      rlogin            out    varchar2,
      rnome             out    varchar2,
      rsegundos_lock    out    pls_integer,
      rsegundos_inativa out    pls_integer,
      rmaquina          out    varchar2)
      return boolean is
   begin
      select /*+ ordered */
             a.nome, a.nome_completo, l.ctime, s.last_call_et, s.terminal
        into rlogin, rnome, rsegundos_lock, rsegundos_inativa, rmaquina
        from sys.gv_$lock l, gv$session s, acesso_login a, sys.dbms_lock_allocated d
       where l.sid = s.sid
         and l.type = 'UL'
         and l.lmode = 6
         and l.sid = s.sid
         and l.id1 = d.lockid
         and l.inst_id = s.inst_id
         and s.client_info = to_char(a.id_usuario(+))
         and d.name = rcodigo;

      return true;
   exception
      when no_data_found then
         rlogin := '';
         rnome := '';
         rsegundos_lock := '';
         rsegundos_inativa := '';
         rmaquina := '';
         return false;
   end;
end;

/
--------------------------------------------------------
--  DDL for Package Body PKG_MAIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "AMESP"."PKG_MAIL" IS

  -- Return the next email address in the list of email addresses, separated
  -- by either a "," or a ";".  The format of mailbox may be in one of these:
  --   someone@some-domain
  --   "Someone at some domain" <someone@some-domain>
  --   Someone at some domain <someone@some-domain>
  FUNCTION get_address(addr_list IN OUT VARCHAR2) RETURN VARCHAR2 IS

    addr VARCHAR2(256);
    i    pls_integer;

    FUNCTION lookup_unquoted_char(str IN VARCHAR2, chrs IN VARCHAR2)
      RETURN pls_integer AS
      c            VARCHAR2(5);
      i            pls_integer;
      len          pls_integer;
      inside_quote BOOLEAN;
    BEGIN
      inside_quote := false;
      i            := 1;
      len          := length(str);
      WHILE (i <= len) LOOP

        c := substr(str, i, 1);

        IF (inside_quote) THEN
          IF (c = '"') THEN
            inside_quote := false;
          ELSIF (c = '\') THEN
            i := i + 1; -- Skip the quote character
          END IF;
          GOTO next_char;
        END IF;

        IF (c = '"') THEN
          inside_quote := true;
          GOTO next_char;
        END IF;

        IF (instr(chrs, c) >= 1) THEN
          RETURN i;
        END IF;

        <<next_char>>
        i := i + 1;

      END LOOP;

      RETURN 0;

    END;

  BEGIN

    addr_list := ltrim(addr_list);
    i         := lookup_unquoted_char(addr_list, ',;');
    IF (i >= 1) THEN
      addr      := substr(addr_list, 1, i - 1);
      addr_list := substr(addr_list, i + 1);
    ELSE
      addr      := addr_list;
      addr_list := '';
    END IF;

    i := lookup_unquoted_char(addr, '<');
    IF (i >= 1) THEN
      addr := substr(addr, i + 1);
      i    := instr(addr, '>');
      IF (i >= 1) THEN
        addr := substr(addr, 1, i - 1);
      END IF;
    END IF;

    RETURN addr;
  END;

  -- Write a MIME header
  PROCEDURE write_mime_header(conn  IN OUT NOCOPY utl_smtp.connection,
                              name  IN VARCHAR2,
                              value IN VARCHAR2) IS
  BEGIN
    utl_smtp.write_data(conn, name || ': ' || value || utl_tcp.CRLF);
  END;

  -- Mark a message-part boundary.  Set <last> to TRUE for the last boundary.
  PROCEDURE write_boundary(conn IN OUT NOCOPY utl_smtp.connection,
                           last IN BOOLEAN DEFAULT FALSE) AS
  BEGIN
    IF (last) THEN
      utl_smtp.write_data(conn, LAST_BOUNDARY);
    ELSE
      utl_smtp.write_data(conn, FIRST_BOUNDARY);
    END IF;
  END;

  ------------------------------------------------------------------------
  PROCEDURE mail(sender     IN VARCHAR2,
                 recipients IN VARCHAR2,
                 subject    IN VARCHAR2,
                 message    IN VARCHAR2) IS
    conn utl_smtp.connection;
  BEGIN
    conn := begin_mail(sender, recipients, subject);
    write_text(conn, message);
    end_mail(conn);
  END;

  ------------------------------------------------------------------------
  FUNCTION begin_mail(sender     IN VARCHAR2,
                      recipients IN VARCHAR2,
                      subject    IN VARCHAR2,
                      mime_type  IN VARCHAR2 DEFAULT 'text/plain',
                      priority   IN PLS_INTEGER DEFAULT NULL)
    RETURN utl_smtp.connection IS
    conn utl_smtp.connection;
    v_banco char;
    v_recipients VARCHAR2(32767) := recipients;
  BEGIN
    -- Verifica se é banco de Desenvolvimento/Homoloção para mudar o destinatário
    v_banco := amesp.banco_producao('D');
    if v_banco = 'D' then
       v_recipients := amesp.ini_config_pg.getchave('INI','SMTP', 'EMAIL_D');
    else
      if v_banco = 'H' then
        v_recipients := amesp.ini_config_pg.getchave('INI','SMTP', 'EMAIL_H');
      end if;
    end if;

    conn := begin_session;
    begin_mail_in_session(conn,
                          sender,
                          v_recipients,
                          subject,
                          mime_type,
                          priority);
    RETURN conn;
  END;

  ------------------------------------------------------------------------
  PROCEDURE write_text(conn    IN OUT NOCOPY utl_smtp.connection,
                       message IN VARCHAR2) IS
  BEGIN
    utl_smtp.write_data(conn, message);
  END;

  ------------------------------------------------------------------------
  PROCEDURE write_mb_text(conn    IN OUT NOCOPY utl_smtp.connection,
                          message IN VARCHAR2) IS
  BEGIN
    utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw(message));
  END;

  ------------------------------------------------------------------------
  PROCEDURE write_raw(conn    IN OUT NOCOPY utl_smtp.connection,
                      message IN RAW) IS
  BEGIN
    utl_smtp.write_raw_data(conn, message);
  END;

  ------------------------------------------------------------------------
  PROCEDURE attach_text(conn      IN OUT NOCOPY utl_smtp.connection,
                        data      IN VARCHAR2,
                        mime_type IN VARCHAR2 DEFAULT 'text/plain',
                        inline    IN BOOLEAN DEFAULT TRUE,
                        filename  IN VARCHAR2 DEFAULT NULL,
                        last      IN BOOLEAN DEFAULT FALSE) IS
  BEGIN
    begin_attachment(conn, mime_type, inline, filename);
--    write_text(conn, data);
    write_mb_text(conn, data);

    end_attachment(conn, last);
  END;

  ------------------------------------------------------------------------
  PROCEDURE attach_base64(conn      IN OUT NOCOPY utl_smtp.connection,
                          data      IN RAW,
                          mime_type IN VARCHAR2 DEFAULT 'application/octet',
                          inline    IN BOOLEAN DEFAULT TRUE,
                          filename  IN VARCHAR2 DEFAULT NULL,
                          last      IN BOOLEAN DEFAULT FALSE) IS
    i   PLS_INTEGER;
    len PLS_INTEGER;
  BEGIN

    begin_attachment(conn, mime_type, inline, filename, 'base64');

    -- Split the Base64-encoded attachment into multiple lines
    i   := 1;
    len := utl_raw.length(data);
    WHILE (i < len) LOOP
      IF (i + MAX_BASE64_LINE_WIDTH < len) THEN
        utl_smtp.write_raw_data(conn,
                                utl_encode.base64_encode(utl_raw.substr(data,
                                                                        i,
                                                                        MAX_BASE64_LINE_WIDTH)));
      ELSE
        utl_smtp.write_raw_data(conn,
                                utl_encode.base64_encode(utl_raw.substr(data,
                                                                        i)));
      END IF;
      utl_smtp.write_data(conn, utl_tcp.CRLF);
      i := i + MAX_BASE64_LINE_WIDTH;
    END LOOP;

    end_attachment(conn, last);

  END;

  ------------------------------------------------------------------------
  PROCEDURE begin_attachment(conn         IN OUT NOCOPY utl_smtp.connection,
                             mime_type    IN VARCHAR2 DEFAULT 'text/plain',
                             inline       IN BOOLEAN DEFAULT TRUE,
                             filename     IN VARCHAR2 DEFAULT NULL,
                             transfer_enc IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    write_boundary(conn);
    write_mime_header(conn, 'Content-Type', mime_type);

    IF (filename IS NOT NULL) THEN
      IF (inline) THEN
        write_mime_header(conn,
                          'Content-Disposition',
                          'inline; filename="' || filename || '"');
      ELSE
        write_mime_header(conn,
                          'Content-Disposition',
                          'attachment; filename="' || filename || '"');
      END IF;
    END IF;

    IF (transfer_enc IS NOT NULL) THEN
      write_mime_header(conn, 'Content-Transfer-Encoding', transfer_enc);
    END IF;

    utl_smtp.write_data(conn, utl_tcp.CRLF);
  END;

  ------------------------------------------------------------------------
  PROCEDURE end_attachment(conn IN OUT NOCOPY utl_smtp.connection,
                           last IN BOOLEAN DEFAULT FALSE) IS
  BEGIN
    utl_smtp.write_data(conn, utl_tcp.CRLF);
    IF (last) THEN
      write_boundary(conn, last);
    END IF;
  END;

  ------------------------------------------------------------------------
  PROCEDURE end_mail(conn IN OUT NOCOPY utl_smtp.connection,
                     last IN BOOLEAN DEFAULT FALSE) IS
  BEGIN
    IF (last) THEN
      write_boundary(conn, last);
    END IF;
    end_mail_in_session(conn);
    end_session(conn);
  END;

  ------------------------------------------------------------------------
  FUNCTION begin_session RETURN utl_smtp.connection IS
    conn utl_smtp.connection;
  BEGIN
   smtp_host := amesp.pkg_config.getSMTP_HOST;
   smtp_port := amesp.pkg_config.getSMTP_PORT;
    -- open SMTP connection
    conn := utl_smtp.open_connection(smtp_host, smtp_port);
    utl_smtp.helo(conn, smtp_host);

    RETURN conn;
  END;

  ------------------------------------------------------------------------
  PROCEDURE begin_mail_in_session(conn       IN OUT NOCOPY utl_smtp.connection,
                                  sender     IN VARCHAR2,
                                  recipients IN VARCHAR2,
                                  subject    IN VARCHAR2,
                                  mime_type  IN VARCHAR2 DEFAULT 'text/plain',
                                  priority   IN PLS_INTEGER DEFAULT NULL) IS
    my_recipients VARCHAR2(32767) := recipients;
    my_sender     VARCHAR2(32767) := sender;
  BEGIN

    -- Specify sender's address (our server allows bogus address
    -- as long as it is a full email address (xxx@yyy.com).
    utl_smtp.mail(conn, get_address(my_sender));

    -- Specify recipient(s) of the email.
    WHILE (my_recipients IS NOT NULL) LOOP
      utl_smtp.rcpt(conn, get_address(my_recipients));
    END LOOP;

    -- Start body of email
    utl_smtp.open_data(conn);

    -- Set "From" MIME header
    write_mime_header(conn, 'From', sender);

    -- Set "To" MIME header
    write_mime_header(conn, 'To', recipients);

    -- Set "Subject" MIME header
    --write_mime_header(conn, 'Subject', subject);
    write_mb_text(conn, 'Subject'|| ': ' || subject || utl_tcp.CRLF);

    -- Set "Content-Type" MIME header
    write_mime_header(conn, 'Content-Type', mime_type);

    -- Set "X-Mailer" MIME header
    write_mime_header(conn, 'X-Mailer', MAILER_ID);

    -- Set priority:
    --   High      Normal       Low
    --   1     2     3     4     5
    IF (priority IS NOT NULL) THEN
      write_mime_header(conn, 'X-Priority', priority);
    END IF;

    -- Send an empty line to denotes end of MIME headers and
    -- beginning of message body.
    utl_smtp.write_data(conn, utl_tcp.CRLF);

    IF (mime_type LIKE 'multipart/mixed%') THEN
      write_text(conn,
                 'This is a multi-part message in MIME format.' ||
                 utl_tcp.crlf);
    END IF;

  END;

  ------------------------------------------------------------------------
  PROCEDURE end_mail_in_session(conn IN OUT NOCOPY utl_smtp.connection) IS
  BEGIN
    utl_smtp.close_data(conn);
  END;

  ------------------------------------------------------------------------
  PROCEDURE end_session(conn IN OUT NOCOPY utl_smtp.connection) IS
  BEGIN
    utl_smtp.quit(conn);
  END;

END;


/
--------------------------------------------------------
--  DDL for Package Body PKG_PEP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "AMESP"."PKG_PEP" is
   /*===========================================================================
     Descrição: Esta procedure retorna todos os prontuários do paciente

     Parâmetros:
       pID_Amesp = ID_Amesp do paciente
       pID_Especialidade = Especialidade do médico.
                           Este parâmetro é utilizado pela unit do sistema para
                           ordenar os registros primeiro pela especialidade do
                           médico e depois as outras especialidades.


     Retorno:
       registros = Retorna um cursor com os registros.

     Utilização:
       Utilizado no sistema PEP pela unit uFrameAtendimentos.pas

     Histórico:
     -----------+-----------+---------------------------------------------------
     2008.04.04 | Garrido   | - Adaptação para ID_Profissional
     -----------+-----------+---------------------------------------------------
     2006.09.27 | Parreira  | - Criação
     -----------+-----------+---------------------------------------------------
   */
   procedure atendimento(
      pid_pessoa        in     number,
      pid_especialidade in     varchar2 default null,
      registros         in out pkg_cm_defs.cur_def_extrato) is
   begin
      open registros for
         select atend.id_aa, atend.id_prontuario "Prontuario",
                to_char(atend.data, 'DD/MM/YYYY HH24:MI') || 'hs' "Data",
                espc.especialidade "Especialidade",
                medico.num_conselho || ' - ' || medico.nome "Medico",
                unid.nome_resumido "Unidade", cid.de_cid "CID",
                case
                   when (select distinct pep.id_atendimento_origem
                                    from pep_atendimentos pep
                                   where pep.id_atendimento_origem = atend.id_aa) is not null then 'S'
                   else 'N'
                end retorno,
                evoluc.evolucao, atend.id_aa "id_aa_interno", atend.data "data_interno",
                '0' "Ordem", aa.id_especialidade,
                case
                   when trim(aa.id_especialidade) =
                                            trim(pid_especialidade) then '0'
                   else '1'
                end "ordem_especialidade",
                medico.num_conselho "CRM", atend.stand_by, aa.tipo_atendimento,
                trunc(atend.data) "DataProntuario", medico.nome "MedicoNome",
                medico.id_profissional
           from pep_atendimentos atend,
                cm_aas aa,
                aa_especialidades espc,
                profissional_saude medico,
                cm_parametros unid,
                cmd_cid cid,
                pep_atendimentos_evolucao evoluc
          where atend.id_pessoa = pid_pessoa
            and atend.id_aa = aa.id_aa
            and aa.id_especialidade = espc.codigo
            and aa.id_profissional = medico.id_profissional
            and substr(aa.id_aa, 1, 3) = unid.centro_medico
            -- and unid.centro_medico <> '999'
            and atend.cd_cid_principal = cid.cd_cid(+)
            and atend.id_atendimento_origem is null
            and atend.id_aa = evoluc.id_aa(+);
   --AND Atend.em_edicao = 'N' ;
   end;

   /*===========================================================================
     Descrição: Esta procedure retorna todos os prontuários/retornos do paciente

     Parâmetros:
       pID_Amesp = ID_Amesp do paciente

     Retorno:
       registros = Retorna um cursor com os registros.

     Utilização:
       Utilizado no sistema PEP pela unit uFrameAtendimentos.pas

     Histórico:
     -----------+-----------+---------------------------------------------------
     2008.04.04 | Garrido   | - Adaptação para ID_Profissional
     -----------+-----------+---------------------------------------------------
     2006.09.27 | Parreira  | - Criação
     -----------+-----------+---------------------------------------------------
   */
   procedure atendimentoretorno(
      pid_pessoa in     number,
      registros  in out pkg_cm_defs.cur_def_extrato) is
   begin
      open registros for
         select atend.id_aa, atend.id_prontuario "Prontuario",
                to_char(atend.data, 'DD/MM/YYYY HH24:MI') || 'hs' "Data",
                espc.especialidade "Especialidade",
                medico.num_conselho || ' - ' || medico.nome "Medico",
                unid.nome_resumido "Unidade", cid.de_cid "CID", null retorno,
                evoluc.evolucao, atend.id_atendimento_origem "ID_AA_RETORNO",
                aa.id_especialidade, medico.num_conselho "CRM", atend.stand_by,
                aa.tipo_atendimento, trunc(atend.data) "DataProntuario",
                medico.nome "MedicoNome", medico.id_profissional
           from pep_atendimentos atend,
                cm_aas aa,
                aa_especialidades espc,
                profissional_saude medico,
                cm_parametros unid,
                cmd_cid cid,
                pep_atendimentos_evolucao evoluc
          where atend.id_pessoa = pid_pessoa
            and atend.id_aa = aa.id_aa
            and aa.id_especialidade = espc.codigo
            and aa.id_profissional = medico.id_profissional
            and substr(aa.id_aa, 1, 3) = unid.centro_medico
            and atend.cd_cid_principal = cid.cd_cid(+)
            and atend.id_atendimento_origem is not null
            and atend.id_aa = evoluc.id_aa(+);
   end;

   /*===========================================================================
     Descrição: Esta procedure retorna todos os medicamentos que foram prescritos
                para o paciente.

     Parâmetros:
       pID_Empresa = Código da empresa do paciente
       pID_Titular = Código do titular do paciente
       pID_Dependente = Código de dependente do paciente

     Importante:
       Nesta procedure não está sendo utilizado o ID_AMESP porque a tabela CM_AAS
       não contempla este campo.

     Retorno:
       registros = Retorna um cursor com os registros.

     Utilização:
       Utilizado no sistema PEP pela unit uFrameMedicamentos.pas

     Histórico:
     -----------+-----------+---------------------------------------------------
     2006.09.27 | Parreira  | - Criação
     -----------+-----------+---------------------------------------------------
   */
   procedure atendimentomedicamento(
      pid_empresa    in     varchar2,
      pid_titular    in     varchar2,
      pid_dependente in     varchar2,
      registros      in out pkg_cm_defs.cur_def_extrato) is
   begin
      open registros for
         select nvl(medic.descricao, receituario.nome_medicamento) "Medicamento",
                decode(medic.generico, 'S', 'Sim', 'N', 'Não', '- x -') "Genérico",
                receituario.qtde || ' ' || receituario.desc_qtde "Qtde",
                replace(replace(receituario.posologia, '[', ''), ']', '') "Posologia",
                decode(receituario.prescricao,
                       'L', 'Livre',
                       'A', 'Lista Complementar',
                       'F', 'Flex') "Prescrição",
                receituario.id_aa
           from cm_medicamentos medic,
                (select receit.*
                   from cm_aas aa, cm_receituario_medicamentos receit
                  where aa.id_empresa = pid_empresa
                    and aa.id_titular = pid_titular
                    and aa.id_dependente = pid_dependente
                    and aa.id_aa = receit.id_aa) receituario
          where receituario.id_medicamento = medic.id_medicamento(+);
   end;

   /*===========================================================================
     Descrição: Esta procedure retorna a descrição do CID pesquisado pelo código.

     Parâmetros:
       pPesquisa = o código do CID que se deseja pesquisar.

     Retorno:
       registro = Retorna um cursor do CID pesquisado.

     Utilização:
       Utilizado no sistema PEP na unit uFrameCIDModelo1a.pas

     Histórico:
     -----------+-----------+---------------------------------------------------
     2006.09.29 | Parreira  | - Criação
     -----------+-----------+---------------------------------------------------
   */
   procedure pesquisacidcodigo(
      ppesquisa in     varchar2 default null,
      registro  in out pkg_cm_defs.cur_def_extrato) is
   begin
      open registro for
         select upper(cid.de_cid) "Descrição"
           from cmd_cid cid
          where cid.cd_cid = ppesquisa;
   end;

   /*===========================================================================
     Descrição: Esta procedure retorna os CIDs em um cursor.

     Parâmetros:
       pPesquisa = a descrição do CID que se deseja pesquisar.

     Retorno:
       registros = Retorna um cursor com os registros encontradados.

     Utilização:
       Utilizado no sistema PEP na unit uClassePesquisa.pas

     Histórico:
     -----------+-----------+---------------------------------------------------
     2006.10.02 | Parreira  | - Criação
     -----------+-----------+---------------------------------------------------
   */
   procedure pesquisaciddescricao(
      ppesquisa         in     varchar2 default null,
      pid_especialidade in     varchar2,
      registros         in out pkg_cm_defs.cur_def_extrato) is
   begin
      open registros for
         select distinct upper(cid.de_cid) "Descrição",
                         espec.especialidade "Especialidade",
                         nvl2(favo.cd_cid, 'S', 'N') "Favorito",
                         espec.codigo "ID_Especialidade", cid.cd_cid "Codigo"
                    from cmd_cid cid left join cmd_cid_x_espec favo
                         on(    cid.cd_cid = favo.cd_cid
                            and favo.id_especialidade = pid_especialidade
                            and alergia is null)
                         left join aa_especialidades espec
                         on(favo.id_especialidade = espec.codigo)
                   where upper(retira_acentos(cid.de_cid)) like retira_acentos(ppesquisa)
                order by 1;
   end;

   /*===========================================================================
     Descrição: Esta procedure retorna a descrição do medicamento pesquisado
                pelo código.

     Parâmetros:
       pPesquisa = o código do medicamento que se deseja pesquisar.

     Retorno:
       registro = Retorna um cursor do medicamento pesquisado.

     Utilização:
       Utilizado no sistema PEP na unit uFrameCIDModelo1a.pas

     Histórico:
     -----------+-----------+---------------------------------------------------
     2006.10.03 | Parreira  | - Criação
     -----------+-----------+---------------------------------------------------
   */
   procedure pesquisamedicamentocodigo(
      ppesquisa in     varchar2 default null,
      registro  in out pkg_cm_defs.cur_def_extrato) is
   begin
      open registro for
         select upper(descricao) "Descrição", id_medicamento "Código"
           from cm_medicamentos
          where id_medicamento = ppesquisa;
   end;

   /*===========================================================================
     Descrição: Esta procedure retorna os registros encontrados em um cursor.

     Parâmetros:
       pPesquisa = a descrição do medicamento que se deseja pesquisar.

     Retorno:
       registro = Retorna um cursor dos medicamentos pesquisados.

     Utilização:
       Utilizado no sistema PEP na unit uClassePesquisa.pas

     Histórico:
     -----------+-----------+---------------------------------------------------
     2006.10.03 | Parreira  | - Criação
     -----------+-----------+---------------------------------------------------
   */
   procedure pesquisamedicamentodescricao(
      ppesquisa in     varchar2 default null,
      registros in out pkg_cm_defs.cur_def_extrato) is
   begin
      open registros for
         select   upper(descricao) "Descrição", id_medicamento "Codigo"
             from cm_medicamentos
            where inativo is null
              and upper(retira_acentos(descricao)) like retira_acentos(ppesquisa)
         order by descricao;
   end;

   /*===========================================================================
     Descrição: Esta procedure retorna um registro com a descrição do CID
                pesquisado.

     Parâmetros:
       pPesquisa = o código do CID que se deseja pesquisar.

     Retorno:
       registro = Retorna um cursor com o registro pesquisado.

     Utilização:
       Utilizado no sistema PEP na unit uFrameCidModelo1a.pas

     Histórico:
     -----------+-----------+---------------------------------------------------
     2006.12.04 | Parreira  | - Acrescentado field "Alergia" no select
     -----------+-----------+---------------------------------------------------
     2006.10.24 | Parreira  | - Criação
     -----------+-----------+---------------------------------------------------
   */
   procedure pesquisacidalergiacodigo(
      ppesquisa in     varchar2 default null,
      registro  in out pkg_cm_defs.cur_def_extrato) is
   begin
      open registro for
         select upper(cid.de_cid) "Descrição", upper(alergia) "Alergia"
           from cmd_cid_x_espec alergias, cmd_cid cid
          where alergias.alergia = 'S'
            and alergias.cd_cid = ppesquisa
            and alergias.cd_cid = cid.cd_cid;
   end;

   /*===========================================================================
     Descrição: Esta procedure retorna os registros encontrados em um cursor.

     Parâmetros:
       pPesquisa = a descrição do CID que se deseja pesquisar.

     Retorno:
       registro = Retorna um cursor dos CIDs

     Utilização:
       Utilizado no sistema PEP na unit uClassePesquisa.pas

     Histórico:
     -----------+-----------+---------------------------------------------------
     2006.10.24 | Parreira  | - Criação
     -----------+-----------+---------------------------------------------------
   */
   procedure pesquisacidalergiadescricao(
      ppesquisa in     varchar2 default null,
      registros in out pkg_cm_defs.cur_def_extrato) is
   begin
      open registros for
         select   upper(cid.de_cid) "Descrição", cid.cd_cid "Codigo"
             from cmd_cid cid, cmd_cid_x_espec favo
            where favo.alergia = 'S'
              and favo.cd_cid = cid.cd_cid
              and upper(retira_acentos(cid.de_cid)) like retira_acentos(ppesquisa)
         order by 1;
   end;

   /*===========================================================================
     Descrição: Esta procedure retorna os registros pesquisados em um cursor.

     Parâmetros:
       pTipoPesquisa => 'C' = pesquisa por código
                        'D' = pesquisa por descrição
       pPesquisa = o código/descrição que deseja pesquisar

     Retorno:
       registros = Retorna os registros em um cursor

     Utilização:
       Utilizado no sistema PEP na unit uClassePesquisa.pas

     Histórico:
     -----------+-----------+---------------------------------------------------
     2006.11.09 | Parreira  | - Criação
     -----------+-----------+---------------------------------------------------
   */
   procedure pesquisaprocedimentoenfermaria(
      ptipopesquisa in     char default 'C',
      ppesquisa     in     varchar2 default null,
      registros     in out pkg_cm_defs.cur_def_extrato) is
   begin
      -- pesquisando pelo código
      if upper(ptipopesquisa) = 'C' then
         open registros for
            select upper(descricao) "Descrição"
              from cm_proc_enfermaria
             where id_proc_enfermaria = ppesquisa;
      end if;

      -- pesquisando pela descrição
      if upper(ptipopesquisa) = 'D' then
         open registros for
            select   upper(enf.descricao) "Descrição", enf.id_proc_enfermaria "Codigo"
                from cm_proc_enfermaria enf
               where upper(retira_acentos(enf.descricao)) like retira_acentos(ppesquisa)
            order by 1;
      end if;
   end;

   /*===========================================================================
     Descrição: Esta function retorna o ID do último prontuário naquela
                especialidade

     Parâmetros:
       pID_Amesp => ID_AMESP
       pID_Especialidade => ID da especialidade

     Retorno:
       ID do prontuário

     Utilização:
       Utilizado no sistema PEP na unit uFrmResumoClinico.pas

     Histórico:
     -----------+-----------+---------------------------------------------------
     2006.12.01 | Parreira  | - Criação
     -----------+-----------+---------------------------------------------------
   */
   procedure getprontuario(
      pid_pessoa        in     number,
      pid_especialidade in     varchar2,
      registros         in out pkg_cm_defs.cur_def_extrato) is
   begin
      open registros for
         select *
           from (select   pep.id_prontuario, pep.em_edicao, pep.data,
                          pep.id_atendimento_origem, pep.id_aa
                     from pep_atendimentos pep, cm_aas aa
                    where pep.id_pessoa = pid_pessoa
                      and pep.id_aa = aa.id_aa
                      and aa.id_especialidade = pid_especialidade
                 order by pep.data desc) prontuarios
          where rownum <= 2;
   end;

   /*
     Função para retornar uma resposta de uma questão do PEP

     Parâmetros:
       pid_aa ---> identificação do atendimento (AA)
       ptopico --> nome do tópico (case sensitive)
       pquestao -> nome da questão (case sensitive)

     Retorno...:
       Retorna um varchar contendo a resposta

     Histórico.:
     -----------+-----------+-----------------------------------------------------
     2007.10.25 | Garrido   | - Passou a chamar outra função e movi para a
                |           |   package pkg_pep por ser uma função específica do
                |           |   PEP e não do QUEST
     -----------+-----------+-----------------------------------------------------
     2007.10.05 | Garrido   | - Movi para dentro da package pkg_quest
     -----------+-----------+-----------------------------------------------------
     2007.09.25 | Garrido   | - Criação
     -----------+-----------+-----------------------------------------------------
   */
   function getresposta(pid_aa in char, ptopico in varchar2, pquestao in varchar2)
      return varchar is
      vresumo   number;
      vresposta varchar(2000);
   begin
      select id_prontuario
        into vresumo
        from amesp.pep_atendimentos
       where id_aa = pid_aa;

      vresposta := amesp.pkg_quest.getresposta(vresumo, ptopico, pquestao);
      return vresposta;
   end;

   /*===========================================================================
     Descrição: Esta procedure exclui um receituário e seus medicamentos prescritos

     Parâmetros:
       pID_AA = ID AA do Prontuário

       pID_Receituario = ID do Receituário do Prontuário

     Retorno:
       registros = Retorna um cursor com os registros.

     Utilização:
       Utilizado no sistema PEP pela unit uFrameReceituario.pas

     Histórico:
     -----------+-----------+---------------------------------------------------
     2007.01.04 | Ronaldo F.| - Criação
     -----------+-----------+---------------------------------------------------
   */
   procedure excluirreceituario(pid_aa in varchar2, pid_receituario in number) as
      i_d_data_emissao date;
   begin
      select data_emissao
        into i_d_data_emissao
        from cm_receituarios
       where id_aa = pid_aa
         and id_receituario = pid_receituario;

      if trunc(i_d_data_emissao) = trunc(local_sysdate) then
         delete from cm_receituario_medicamentos
               where id_aa = pid_aa
                 and id_receituario = pid_receituario;

         delete from cm_receituarios
               where id_aa = pid_aa
                 and id_receituario = pid_receituario;
      else
         raise_application_error(-20500,
                                 'Só pode excluir uma receita feita no mesmo dia.');
      end if;
   end;

   /*===========================================================================
     Descrição: Esta procedure recebe os dados no formato binário do PEP, e os
     insere ou altera no banco Oracle.

     Parâmetros:
       pBinario - Dados binários

     Utilização:
       PEP.EXE -> Elimina o tráfego excessivo de dados pelo link.

     LayOut Binário:

      HEADER

      (4 bytes) ID_RESUMO
      (4 bytes) ID_CHAVE

      SEQUENCIA DE RESPOSTAS (PARA CADA RESPOSTA):

      (4 bytes) ID_TOPICO
      (4 bytes) ID_QUESTAO
      (1 byte) True = Inclusão, False = Alteração
      (1 byte) True = Atributo, False = Não atributo
      (1 byte) Tipo:

             0: String
               (4 bytes) Tamanho do texto
               (n bytes) Texto

             1: Inteiro
               (4 bytes) Valor

             2: Float
               (8 bytes) Valor

             3: Data
               (8 bytes) Data

             4: Memo
               (4 bytes) Tamanho do texto
               (n bytes) Texto

             5: Boolean
               (1 byte) Valor

             6: Frames (Será ignorado. É passado apenas para guardá-lo junto com
                        o binário na tabela QUEST_RESUMO)
               (1 byte)  Tamanho da resposta
               (n bytes) Resposta

     Historico.:
     ------------+--------------+-----------------------------------------------
      2008.10.23 | Garrido      | Inclusão do campo TP_Chave para atender
                 |              | pacientes MEDIAL
     ------------+--------------+-----------------------------------------------
      2007.10.08 | Garrido      | Criação do tipo "6 - Frames"
     ------------+--------------+-----------------------------------------------
      2006.12.14 | Renato Rossi | Criação
     ------------+--------------+-----------------------------------------------
   */
   procedure gravabinario(pbinario in blob) as
      type tresposta is record(
         id_resumo    amesp.quest_respostas.id_resumo%type,
         id_questao   amesp.quest_respostas.id_questao%type,
         id_topico    amesp.quest_respostas.id_topico%type,
         id_chave     amesp.quest_respostas.id_chave%type,
         tp_chave     amesp.quest_respostas.tp_chave%type,
         tipo_string  amesp.quest_respostas.tipo_string%type,
         tipo_integer amesp.quest_respostas.tipo_integer%type,
         tipo_float   amesp.quest_respostas.tipo_float%type,
         tipo_data    amesp.quest_respostas.tipo_data%type,
         tipo_boolean amesp.quest_respostas.tipo_boolean%type,
         tipo_obs     amesp.quest_respostas.tipo_obs%type
      );

      type tdata is record(
         dia integer,
         mes integer,
         ano integer,
         hh  integer,
         mm  integer,
         ss  integer
      );

      rresposta  tresposta;
      rdata      tdata;
      blbinario  blob;
      iid_resumo amesp.quest_respostas.id_resumo%type;
      iamount    integer;
      ilimit     integer;
      ioffset    integer                                := 1;
      wraw       raw(10);
      wlraw      raw(4096);
      icomando   integer;
      iatributo  integer;
      itipodados integer;
      itamanho   integer;
      vinsert    varchar2(500)
         := 'INSERT INTO QUEST_RESPOSTAS(ID_RESUMO,ID_QUESTAO,ID_TOPICO,ID_CHAVE,'  ||
            'TIPO_STRING,TIPO_INTEGER,TIPO_FLOAT,TIPO_DATA,TIPO_BOOLEAN,TIPO_OBS,TP_CHAVE)' ||
            ' VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11)';
      vupdate    varchar2(500)
         := 'UPDATE QUEST_RESPOSTAS SET TIPO_STRING = :1,'             ||
            'TIPO_INTEGER = :2,TIPO_FLOAT = :3,TIPO_DATA = :4,'        ||
            'TIPO_BOOLEAN = :5,TIPO_OBS = :7 WHERE ID_RESUMO IS NULL ' ||
            'AND ID_TOPICO = :7 AND ID_QUESTAO = :8 AND ID_CHAVE = :9' ||
            'AND TP_CHAVE = :10';
   begin
      -- Retorma o comprimento total do stream
      dbms_lob.createtemporary(blbinario, true, dbms_lob.session);
      dbms_lob.copy(blbinario, pbinario, dbms_lob.lobmaxsize);
      -- Abre o BLOB
      ilimit := dbms_lob.getlength(blbinario);
      dbms_lob.open(blbinario, dbms_lob.lob_readonly);
      -- Lê o Header
      -- ID_RESUMO
      iamount := 4;
      dbms_lob.read(blbinario, iamount, ioffset, wraw);
      ioffset := ioffset + iamount;
      rresposta.id_resumo := utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
      iid_resumo := rresposta.id_resumo;
      -- ID_CHAVE
      iamount := 4;
      dbms_lob.read(blbinario, iamount, ioffset, wraw);
      rresposta.id_chave :=
         utl_raw.cast_to_binary_integer(utl_raw.bit_and(utl_raw.reverse(wraw),
                                                        hextoraw('0FFFFFFF')));
      rresposta.tp_chave :=
           utl_raw.cast_to_binary_integer(utl_raw.substr(utl_raw.reverse(wraw), 1, 1))
           / 16;
--      rresposta.id_chave := utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
      ioffset := ioffset + iamount;

      while ioffset < ilimit loop
         -- Limpa o Registro
         rresposta.id_resumo := iid_resumo;
         rresposta.id_questao := null;
         rresposta.id_topico := null;
         rresposta.tipo_string := null;
         rresposta.tipo_integer := null;
         rresposta.tipo_float := null;
         rresposta.tipo_data := null;
         rresposta.tipo_boolean := null;
         rresposta.tipo_obs := null;
         -- ID_TOPICO
         iamount := 4;
         dbms_lob.read(blbinario, iamount, ioffset, wraw);
         rresposta.id_topico := utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
         ioffset := ioffset + iamount;
         -- ID_QUESTAO
         iamount := 4;
         dbms_lob.read(blbinario, iamount, ioffset, wraw);
         rresposta.id_questao := utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
         ioffset := ioffset + iamount;
         -- Tipo Atributo
         iamount := 1;
         dbms_lob.read(blbinario, iamount, ioffset, wraw);
         iatributo := utl_raw.cast_to_binary_integer(wraw);
         ioffset := ioffset + iamount;
         -- Tipo Dados
         iamount := 1;
         dbms_lob.read(blbinario, iamount, ioffset, wraw);
         itipodados := utl_raw.cast_to_binary_integer(wraw);
         ioffset := ioffset + iamount;

         -- Tipo String=0 / Memo=4
         if itipodados in(0, 4) then
            -- Tamanho da String
            iamount := 4;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            itamanho := utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
            ioffset := ioffset + iamount;
            iamount := itamanho;
            dbms_lob.read(blbinario, iamount, ioffset, wlraw);
            ioffset := ioffset + iamount;

            if itipodados = 0 then
               -- String
               rresposta.tipo_string := utl_raw.cast_to_varchar2(wlraw);
            elsif itipodados = 4 then
               -- Memo
               rresposta.tipo_obs := utl_raw.cast_to_varchar2(wlraw);
            end if;
         end if;

         -- Tipo 1=Inteiro / 2=Float / 5=Boolean
         if itipodados in(1, 2, 5) then
            -- Bytes a ler
            iamount :=
               case itipodados
                  when 1 then 4   -- Inteiro
                  when 2 then 8   -- Float
                  when 5 then 1   -- Boolean
               end;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            ioffset := ioffset + iamount;

            if itipodados = 1 then
               -- Inteiro
               rresposta.tipo_integer :=
                                    utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
            elsif itipodados = 2 then
               -- Float
               rresposta.tipo_float :=
                                     utl_raw.cast_to_binary_double(utl_raw.reverse(wraw));
            elsif itipodados = 5 then
               -- Boolean
               rresposta.tipo_boolean :=
                  case utl_raw.cast_to_binary_integer(wraw)
                     when 0 then 'N'
                     when 1 then 'S'
                  end;
            end if;
         end if;

         if itipodados = 3 then
            -- Date
            iamount := 1;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            rdata.dia := utl_raw.cast_to_binary_integer(wraw);
            ioffset := ioffset + iamount;
            -- Mes
            iamount := 1;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            rdata.mes := utl_raw.cast_to_binary_integer(wraw);
            ioffset := ioffset + iamount;
            -- Ano
            iamount := 2;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            rdata.ano := utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
            ioffset := ioffset + iamount;
            -- Hora
            iamount := 1;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            rdata.hh := utl_raw.cast_to_binary_integer(wraw);
            ioffset := ioffset + iamount;
            -- Minuto
            iamount := 1;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            rdata.mm := utl_raw.cast_to_binary_integer(wraw);
            ioffset := ioffset + iamount;
            -- Dia
            iamount := 1;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            rdata.ss := utl_raw.cast_to_binary_integer(wraw);
            ioffset := ioffset + iamount;
            rresposta.tipo_data :=
               to_date(to_char(rdata.dia, '00')   ||
                       to_char(rdata.mes, '00')   ||
                       to_char(rdata.ano, '0000') ||
                       to_char(rdata.hh, '00')    ||
                       to_char(rdata.mm, '00')    ||
                       to_char(rdata.ss, '00'),
                       'DDMMYYYYHH24MISS');
         end if;

         -- Tipo Frame=6 (Ignorar)
         if itipodados = 6 then
            -- Tamanho da resposta
            iamount := 4;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            itamanho := utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
            ioffset := ioffset + itamanho;
         else
            -- Executa os comandos
            -- INSERT
            insert into quest_respostas
                        (id_resumo, id_questao, id_topico,
                         id_chave, tipo_string,
                         tipo_integer, tipo_float,
                         tipo_data, tipo_boolean,
                         tipo_obs, tp_chave)
                 values (rresposta.id_resumo, rresposta.id_questao, rresposta.id_topico,
                         rresposta.id_chave, rresposta.tipo_string,
                         rresposta.tipo_integer, rresposta.tipo_float,
                         rresposta.tipo_data, rresposta.tipo_boolean,
                         rresposta.tipo_obs, rresposta.tp_chave);

            if iatributo = 1 then
               begin
                  select 1
                    into icomando
                    from quest_respostas
                   where id_resumo is null
                     and id_questao = rresposta.id_questao
                     and id_topico = rresposta.id_topico
                     and id_chave = rresposta.id_chave
                     and tp_chave = rresposta.tp_chave;

                  update quest_respostas
                     set tipo_string = rresposta.tipo_string,
                         tipo_integer = rresposta.tipo_integer,
                         tipo_float = rresposta.tipo_float,
                         tipo_data = rresposta.tipo_data,
                         tipo_boolean = rresposta.tipo_boolean,
                         tipo_obs = rresposta.tipo_obs
                   where id_resumo is null
                     and id_topico = rresposta.id_topico
                     and id_questao = rresposta.id_questao
                     and id_chave = rresposta.id_chave
                     and tp_chave = rresposta.tp_chave;
               exception
                  when no_data_found then
                     insert into quest_respostas
                                 (id_resumo, id_questao, id_topico,
                                  id_chave, tipo_string,
                                  tipo_integer, tipo_float,
                                  tipo_data, tipo_boolean,
                                  tipo_obs, tp_chave)
                          values (null, rresposta.id_questao, rresposta.id_topico,
                                  rresposta.id_chave, rresposta.tipo_string,
                                  rresposta.tipo_integer, rresposta.tipo_float,
                                  rresposta.tipo_data, rresposta.tipo_boolean,
                                  rresposta.tipo_obs, rresposta.tp_chave);
               end;
            end if;
         end if;
      end loop;

      --
      -- Grava o binário "resposta" na QUEST_RESUMO
      --
      update amesp.quest_resumo
         set respostas = pbinario
       where id_resumo = iid_resumo;

      -- Fecha o Binário
      dbms_lob.close(blbinario);
      dbms_lob.freetemporary(blbinario);
   end;

/*===========================================================================
*/
   procedure gravabinario_nw(pbinario in blob) as
      type tresposta is record(
         id_resumo    amesp.quest_respostas.id_resumo%type,
         id_questao   amesp.quest_respostas.id_questao%type,
         id_topico    amesp.quest_respostas.id_topico%type,
         id_pessoa    amesp.quest_respostas.id_pessoa%type,
         tipo_string  amesp.quest_respostas.tipo_string%type,
         tipo_integer amesp.quest_respostas.tipo_integer%type,
         tipo_float   amesp.quest_respostas.tipo_float%type,
         tipo_data    amesp.quest_respostas.tipo_data%type,
         tipo_boolean amesp.quest_respostas.tipo_boolean%type,
         tipo_obs     amesp.quest_respostas.tipo_obs%type
      );

      type tdata is record(
         dia integer,
         mes integer,
         ano integer,
         hh  integer,
         mm  integer,
         ss  integer
      );

      rresposta  tresposta;
      rdata      tdata;
      blbinario  blob;
      iid_resumo amesp.quest_respostas.id_resumo%type;
      iamount    integer;
      ilimit     integer;
      ioffset    integer                                := 1;
      wraw       raw(10);
      wlraw      raw(4096);
      icomando   integer;
      iatributo  integer;
      itipodados integer;
      itamanho   integer;
   begin
      -- Retorma o comprimento total do stream
      dbms_lob.createtemporary(blbinario, true, dbms_lob.session);
      dbms_lob.copy(blbinario, pbinario, dbms_lob.lobmaxsize);
      -- Abre o BLOB
      ilimit := dbms_lob.getlength(blbinario);
      dbms_lob.open(blbinario, dbms_lob.lob_readonly);
      -- Lê o Header
      -- ID_RESUMO
      iamount := 4;
      dbms_lob.read(blbinario, iamount, ioffset, wraw);
      ioffset := ioffset + iamount;
      rresposta.id_resumo := utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
      iid_resumo := rresposta.id_resumo;
      -- ID_PESSOA
      iamount := 4;
      dbms_lob.read(blbinario, iamount, ioffset, wraw);
      rresposta.id_pessoa :=
         utl_raw.cast_to_binary_integer(utl_raw.bit_and(utl_raw.reverse(wraw),
                                                        hextoraw('0FFFFFFF')));
      ioffset := ioffset + iamount;

      while ioffset < ilimit loop
         -- Limpa o Registro
         rresposta.id_resumo := iid_resumo;
         rresposta.id_questao := null;
         rresposta.id_topico := null;
         rresposta.tipo_string := null;
         rresposta.tipo_integer := null;
         rresposta.tipo_float := null;
         rresposta.tipo_data := null;
         rresposta.tipo_boolean := null;
         rresposta.tipo_obs := null;
         -- ID_TOPICO
         iamount := 4;
         dbms_lob.read(blbinario, iamount, ioffset, wraw);
         rresposta.id_topico := utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
         ioffset := ioffset + iamount;
         -- ID_QUESTAO
         iamount := 4;
         dbms_lob.read(blbinario, iamount, ioffset, wraw);
         rresposta.id_questao := utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
         ioffset := ioffset + iamount;
         -- Tipo Atributo
         iamount := 1;
         dbms_lob.read(blbinario, iamount, ioffset, wraw);
         iatributo := utl_raw.cast_to_binary_integer(wraw);
         ioffset := ioffset + iamount;
         -- Tipo Dados
         iamount := 1;
         dbms_lob.read(blbinario, iamount, ioffset, wraw);
         itipodados := utl_raw.cast_to_binary_integer(wraw);
         ioffset := ioffset + iamount;

         -- Tipo String=0 / Memo=4
         if itipodados in(0, 4) then
            -- Tamanho da String
            iamount := 4;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            itamanho := utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
            ioffset := ioffset + iamount;
            iamount := itamanho;
            dbms_lob.read(blbinario, iamount, ioffset, wlraw);
            ioffset := ioffset + iamount;

            if itipodados = 0 then
               -- String
               rresposta.tipo_string := utl_raw.cast_to_varchar2(wlraw);
            elsif itipodados = 4 then
               -- Memo
               rresposta.tipo_obs := utl_raw.cast_to_varchar2(wlraw);
            end if;
         end if;

         -- Tipo 1=Inteiro / 2=Float / 5=Boolean
         if itipodados in(1, 2, 5) then
            -- Bytes a ler
            iamount :=
               case itipodados
                  when 1 then 4   -- Inteiro
                  when 2 then 8   -- Float
                  when 5 then 1   -- Boolean
               end;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            ioffset := ioffset + iamount;

            if itipodados = 1 then
               -- Inteiro
               rresposta.tipo_integer :=
                                    utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
            elsif itipodados = 2 then
               -- Float
               rresposta.tipo_float :=
                                     utl_raw.cast_to_binary_double(utl_raw.reverse(wraw));
            elsif itipodados = 5 then
               -- Boolean
               rresposta.tipo_boolean :=
                  case utl_raw.cast_to_binary_integer(wraw)
                     when 0 then 'N'
                     when 1 then 'S'
                  end;
            end if;
         end if;

         if itipodados = 3 then
            -- Date
            iamount := 1;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            rdata.dia := utl_raw.cast_to_binary_integer(wraw);
            ioffset := ioffset + iamount;
            -- Mes
            iamount := 1;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            rdata.mes := utl_raw.cast_to_binary_integer(wraw);
            ioffset := ioffset + iamount;
            -- Ano
            iamount := 2;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            rdata.ano := utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
            ioffset := ioffset + iamount;
            -- Hora
            iamount := 1;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            rdata.hh := utl_raw.cast_to_binary_integer(wraw);
            ioffset := ioffset + iamount;
            -- Minuto
            iamount := 1;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            rdata.mm := utl_raw.cast_to_binary_integer(wraw);
            ioffset := ioffset + iamount;
            -- Dia
            iamount := 1;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            rdata.ss := utl_raw.cast_to_binary_integer(wraw);
            ioffset := ioffset + iamount;
            rresposta.tipo_data :=
               to_date(to_char(rdata.dia, '00')   ||
                       to_char(rdata.mes, '00')   ||
                       to_char(rdata.ano, '0000') ||
                       to_char(rdata.hh, '00')    ||
                       to_char(rdata.mm, '00')    ||
                       to_char(rdata.ss, '00'),
                       'DDMMYYYYHH24MISS');
         end if;

         -- Tipo Frame=6 (Ignorar)
         if itipodados = 6 then
            -- Tamanho da resposta
            iamount := 4;
            dbms_lob.read(blbinario, iamount, ioffset, wraw);
            itamanho := utl_raw.cast_to_binary_integer(utl_raw.reverse(wraw));
            ioffset := ioffset + itamanho;
         else
            -- Executa os comandos
            -- INSERT
            insert into quest_respostas
                        (id_resumo, id_questao, id_topico,
                         tipo_string, tipo_integer,
                         tipo_float, tipo_data,
                         tipo_boolean, tipo_obs, id_pessoa)
                 values (rresposta.id_resumo, rresposta.id_questao, rresposta.id_topico,
                         rresposta.tipo_string, rresposta.tipo_integer,
                         rresposta.tipo_float, rresposta.tipo_data,
                         rresposta.tipo_boolean, rresposta.tipo_obs, rresposta.id_pessoa);

            if iatributo = 1 then
               begin
                  select 1
                    into icomando
                    from quest_respostas
                   where id_resumo is null
                     and id_questao = rresposta.id_questao
                     and id_topico = rresposta.id_topico
                     and id_pessoa = rresposta.id_pessoa;

                  update quest_respostas
                     set tipo_string = rresposta.tipo_string,
                         tipo_integer = rresposta.tipo_integer,
                         tipo_float = rresposta.tipo_float,
                         tipo_data = rresposta.tipo_data,
                         tipo_boolean = rresposta.tipo_boolean,
                         tipo_obs = rresposta.tipo_obs
                   where id_resumo is null
                     and id_topico = rresposta.id_topico
                     and id_questao = rresposta.id_questao
                     and id_pessoa = rresposta.id_pessoa;
               exception
                  when no_data_found then
                     insert into quest_respostas
                                 (id_resumo, id_questao, id_topico,
                                  tipo_string, tipo_integer,
                                  tipo_float, tipo_data,
                                  tipo_boolean, tipo_obs,
                                  id_pessoa)
                          values (null, rresposta.id_questao, rresposta.id_topico,
                                  rresposta.tipo_string, rresposta.tipo_integer,
                                  rresposta.tipo_float, rresposta.tipo_data,
                                  rresposta.tipo_boolean, rresposta.tipo_obs,
                                  rresposta.id_pessoa);
               end;
            end if;
         end if;
      end loop;

      --
      -- Grava o binário "resposta" na QUEST_RESUMO
      --
      update amesp.quest_resumo
         set respostas = pbinario
       where id_resumo = iid_resumo;

      -- Fecha o Binário
      dbms_lob.close(blbinario);
      dbms_lob.freetemporary(blbinario);
   end;
end;   -- end package body

/
--------------------------------------------------------
--  DDL for Package Body SMC_UTILS_PKG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "AMESP"."SMC_UTILS_PKG" is
   /* Constantes */
   c_c_st_cons_confirmada constant amesp.mc_agenda.status_consulta%type           := 'CO';   -- Status de consulta confirmada (SMC)
   c_c_st_cons_marcada    constant amesp.mc_agenda.status_consulta%type           := 'OK';   -- Status de consulta marcada (SMC)
   c_c_st_cons_reservada  constant amesp.mc_agenda.status_consulta%type           := 'RE';   -- Status de consulta reservada (SMC)
   c_vc_modulo_smc_wf     constant amesp.wf_historico.modulo%type                := 'CMC';   -- ID do módulo do SMC no WF
   c_vc_modulo_conf_cons  constant varchar2(10)                               := 'WF_MCO';   -- ID do módulo do SMC (Confirmação) no WF
   c_vc_modulo_canc_cons  constant varchar2(10)                           := 'SMC_CANCEL';   -- ID do módulo do SMC (Cancelamento) no WF
   c_n_id_motivo_ura      constant amesp.mc_motivo.id_motivo%type                   := 10;
   c_vc_solicitante_ura   constant amesp.mc_mot_agenda_cancelada.solicitante%type
                                                        := 'Atendimento Automático (URA)';
   c_c_unidade_ura        constant amesp.mc_mot_agenda_cancelada.unidade%type    := '043';

   /* Funcs e Procs */
   function getmotivo_ura
      return amesp.mc_motivo.id_motivo%type is
   begin
      return c_n_id_motivo_ura;
   end;

   function getoperador_ura
      return amesp.acesso_login.id_usuario%type is
      l_i_retorno amesp.acesso_login.id_usuario%type;
   begin
      return amesp.retorna_id_usuario('URACTI');
   end;

   function getsolicitante_ura
      return amesp.mc_mot_agenda_cancelada.solicitante%type is
   begin
      return c_vc_solicitante_ura;
   end;

   function getunidade_ura
      return amesp.mc_mot_agenda_cancelada.unidade%type is
   begin
      return c_c_unidade_ura;
   end;

   function consulta_em_fila_espera(p_n_id_agenda in amesp.mc_agenda.id_agenda%type)
      return number is
      l_i_retorno number;
   begin
      /*
         Verifica se existe uma antecipação disponível para a consulta.

         Parâmetros:
           p_n_id_agenda  - ID_AGENDA da consulta

         Retorno...:
            0          : não há antecipação disponível
            1          : há antecipação disponível

         Utilização:
           Será utilizada pela rotina de URA do Callcenter (integração com a empresa de CTI)

         Histórico.:
         -----------+-----------+------------------------------------------------------------
         2007.06.12 | Faraco    | - Criação
         -----------+-----------+------------------------------------------------------------
      */

      -- Verifica se existe antecipação
      select decode(count(*), 0, 0, 1)
        into l_i_retorno
        from amesp.mc_agenda_espera mc, amesp.wf_status wf
       where mc.id_agenda = p_n_id_agenda
         and mc.id_status = wf.id_status
         and wf.id_tipo_status in(2, 5);

      return l_i_retorno;
   end;   -- consulta_em_fila_espera

   function dados_consulta(p_n_id_agenda in amesp.mc_agenda.id_agenda%type)
      return varchar2 is
      l_vc_dados_cons varchar2(2000);
   begin
      /*
         Retorna os dados de uma consulta agendada.

         Parâmetros:
           p_n_id_agenda  - ID_AGENDA da consulta

         Retorno...:
           String contendo os dados principais da consulta, no seguinte formato:
             Data|Hora|Dia da Semana|Especialidade|Centro Médico

         Utilização:
           Será utilizada pela rotina de URA do Callcenter (integração com a empresa de CTI)

         Histórico.:
         -----------+-----------+-------------------------------------------------------------
         2007.06.19 | Faraco    | - O retorno de centro médico e especialidade agora em código
         -----------+-----------+-------------------------------------------------------------
         2007.06.01 | Fabio     | - Criação
         -----------+-----------+-------------------------------------------------------------
      */

      -- Pesquisa os dados da consulta
      select to_char(agend.data_agenda, 'dd/mm/yyyy')                                ||
             '|'                                                                     ||
             agend.hora_agenda                                                       ||
             '|'                                                                     ||
             trim(to_char(agend.data_agenda, 'day', 'nls_date_language=portuguese')) ||
             '|'                                                                     ||
             agend.id_especialidade                                                  ||
             '|'                                                                     ||
             agend.centro_medico
        into l_vc_dados_cons
        from amesp.mc_agenda agend
       where agend.id_agenda = p_n_id_agenda;

      -- Retorna as informações obtidas
      return l_vc_dados_cons;
   exception
      when no_data_found then
         return '-1';
   end;   -- Function dados_consulta

   function confirma_consulta(
      p_n_id_agenda  in amesp.mc_agenda.id_agenda%type,
      p_n_id_usuario in amesp.acesso_login.id_usuario%type)
      return number is
      l_b_result  boolean;
      l_c_result  char(1);
      l_i_aux     integer;
      l_i_cont    pls_integer;
      l_i_retorno number;
   begin
      /*
         Confirma a consulta informada. Se a consulta já estiver confirmada, nenhuma
         operação será executada.

         Importante:
           Esta rotina executa um COMMIT;

         Parâmetros:
           p_n_id_agenda  - ID_AGENDA da consulta
           p_n_id_usuario - ID do usuário que está fazendo a confirmação (lookup: ACESSO_LOGIN)

         Retorno...:
           -1: Consulta já está confirmada
            0: Consulta NÃO confirmada (ocorreu alguma problema durante a operação)
            1: Consulta confirmada com sucesso

         Utilização:
           Sistema de Marcação de Consultas (SMC)
           Rotina de URA do Callcenter (integração com a empresa de CTI)

         Histórico.:
         -----------+-----------+------------------------------------------------------------
         2007.06.04 | Fabio     | - Criação
         -----------+-----------+------------------------------------------------------------
      */

      -- Verifica se a consulta em questão já não está confirmada
      select decode(count(*), 0, 0, -1)
        into l_i_retorno
        from amesp.mc_agenda
       where id_agenda = p_n_id_agenda
         and status_consulta = c_c_st_cons_confirmada;

      -- Se a consulta ainda não está confirmada, tenta obter um lock no agendamento
      if     (l_i_retorno = 0)
         and (amesp.pkg_lock.obter_travamento(c_vc_modulo_conf_cons  ||
                                              to_char(p_n_id_agenda),
                                              l_i_aux)) then
         -- Muda o status da consulta para confirmada
         update amesp.mc_agenda
            set status_consulta = c_c_st_cons_confirmada
          where id_agenda = p_n_id_agenda;

         -- Verifica se o agendamento está na Ilha de Confirmação
         select count(id_chave)
           into l_i_cont
           from amesp.wf_historico
          where modulo = c_vc_modulo_smc_wf
            and id_chave = p_n_id_agenda
            and rownum = 1;

         if l_i_cont > 0 then
            -- Inclui status de finalizado no WF, se o agendamento estava na Ilha de Confirmação
            l_c_result :=
               amesp.pkg_wfhistorico.incluir_historico(c_vc_modulo_smc_wf,
                                                       p_n_id_agenda,
                                                       36,
                                                       p_n_id_usuario,
                                                       'Finalizado (Pelo SMC) ');

            -- Apaga status futuros do WF (do tipo "ligar novamente em 4 horas")
            delete      amesp.wf_historico
                  where modulo = c_vc_modulo_smc_wf
                    and id_chave = p_n_id_agenda
                    and data_inclusao > sysdate;
         end if;

         commit;
         l_i_retorno := 1;
         -- Libera o lock
         l_b_result :=
            amesp.pkg_lock.liberar_travamento(c_vc_modulo_conf_cons  ||
                                              to_char(p_n_id_agenda),
                                              l_i_aux);
      end if;

      return l_i_retorno;
   exception
      when others then
         rollback;
         -- Libera o lock, caso houver um
         l_b_result :=
            amesp.pkg_lock.liberar_travamento(c_vc_modulo_conf_cons  ||
                                              to_char(p_n_id_agenda),
                                              l_i_aux);
         raise;
   end;   -- Function confirma_consulta;

   function verifica_e_cancela_consulta(
      p_n_id_agenda   in amesp.mc_agenda.id_agenda%type,
      p_n_id_motivo   in amesp.mc_motivo.id_motivo%type,
      p_n_id_usuario  in amesp.acesso_login.id_usuario%type,
      p_s_solicitante in amesp.mc_mot_agenda_cancelada.solicitante%type,
      p_s_unidade     in amesp.mc_mot_agenda_cancelada.unidade%type default '043',
      p_c_commit      in char default 'S')   --Willyan 06/11/2007
      return number is
      l_b_result   boolean;
      l_c_result   char(1);
      l_i_aux      integer;
      l_i_wf_count integer;
      l_i_cont     pls_integer;
      l_i_retorno  number;
   begin
      /*
         Cancela a consulta informada

         Importante:
           Esta rotina executa um COMMIT;

         Parâmetros:
           p_n_id_agenda   - ID_AGENDA da consulta
           p_n_id_motivo   - Motivo do cancelamento
           p_n_id_usuario  - ID do usuário que está fazendo o cancelamento (lookup: ACESSO_LOGIN)
           p_s_solicitante - Solicitante
           p_s_unidade     - Unidade
           p_c_commit      - S ou N. Indica se a transação deve ser finalizada ou não pela
                             própria rotina.

         Retorno...:
           -4: Consulta possui registro no workflow do centro médico (já foi atendida)
           -3: Consulta possui antecipação (não pode ser cancelada)
           -2: Consulta está reservada para antecipação (não pode ser cancelada)
           -1: Consulta já está cancelada
            0: Consulta NÃO cancelada (ocorreu alguma problema durante a operação)
            1: Consulta cancelada com sucesso

         Utilização:
           Rotina de URA do Callcenter (integração com a empresa de CTI)

         Histórico.:
         -----------+-----------+------------------------------------------------------------
         2010.13.12 |  Dereck   |  - Alteração para verificar se a agenda já possui registro
                    |           |    no workflow do centro médico (já foi atendida)
         -----------+-----------+------------------------------------------------------------
         2007.11.07 | Willyan   | - Coloquei o parametro p_c_commit com defalt 'S', para
                    |           |   definir se o commit deve ou não ser executado. Aqui na
                    |           |   Medial, o commit/rollback é executado nas aplicações. Na
                    |           |   Comunika (que também utiliza esta função), o commit/rollback
                    |           |   é realizado na própria função.
         -----------+-----------+------------------------------------------------------------
         2007.06.05 | Faraco    | - Criação
         -----------+-----------+------------------------------------------------------------
      */

      -- Trava o registro para cancelamento
      if (amesp.pkg_lock.obter_travamento(c_vc_modulo_canc_cons || to_char(p_n_id_agenda),
                                          l_i_aux)) then
         -- Verifica se a consulta em questão já não está cancelada
         select decode(count(*), 0, 0, -1)
           into l_i_retorno
           from amesp.mc_agenda_cancelada
          where id_agenda = p_n_id_agenda;

         -- Verifica se a consulta esta reservada
         if l_i_retorno = 0 then
            select decode(status_consulta, c_c_st_cons_reservada, -2, 0)
              into l_i_retorno
              from amesp.mc_agenda
             where id_agenda = p_n_id_agenda;
         end if;

         -- Verifica há antecipação disponível para a consulta
         if     (l_i_retorno = 0)
            and (consulta_em_fila_espera(p_n_id_agenda) = 1) then
            l_i_retorno := -3;
         end if;

         -- Verifica se a agenda já possui registro no workflow do centro médico
         if (l_i_retorno = 0) then
            select decode(count(ag.id_agenda), 0, 0, -4)
              into l_i_retorno
              from amesp.mc_agenda ag,
                   amesp.cm_agenda_aas ag_aa,
                   amesp.cm_procedimento proc,
                   amesp.wf_historico his
             where ag.id_agenda = ag_aa.id_agenda
               and substr(ag_aa.id_aa, 2, 13) = proc.id_procedimento
               and proc.id_chave = his.id_chave
               and his.modulo = 'FCM'
               and ag.id_agenda = p_n_id_agenda;
         end if;

         if l_i_retorno = 0 then
            -- Verfica se existe algum historico
            select count(*)
              into l_i_wf_count
              from amesp.wf_historico
             where modulo = c_vc_modulo_smc_wf
               and id_chave = p_n_id_agenda;

            -- Se existe algum historico, trava o registro no workflow
            -- Prossegue sem travar se não
            if    (l_i_wf_count = 0)
               or (amesp.pkg_lock.obter_travamento(c_vc_modulo_conf_cons  ||
                                                   to_char(p_n_id_agenda),
                                                   l_i_aux)) then
               -- Cancela a agenda
               amesp.smc_utils_pkg.cancela_consulta(p_n_id_agenda,
                                                    p_n_id_motivo,
                                                    p_n_id_usuario,
                                                    p_s_solicitante,
                                                    p_s_unidade,
                                                    p_c_commit);   --Willyan 06/11/2007

               if l_i_wf_count > 0 then
                  if l_i_retorno = 1 then
                     -- Marca o histórico de cancelamento, se cancelado
                     l_c_result :=
                        amesp.pkg_wfhistorico.incluir_historico(c_vc_modulo_smc_wf,
                                                                p_n_id_agenda,
                                                                35,
                                                                p_n_id_usuario,
                                                                'Consulta cancelada');

                     -- Apaga status futuros do WF (do tipo "ligar novamente em 4 horas")
                     delete      amesp.wf_historico
                           where modulo = c_vc_modulo_smc_wf
                             and id_chave = p_n_id_agenda
                             and data_inclusao > sysdate;
                  end if;

                  -- destrava o registro
                  l_b_result :=
                     amesp.pkg_lock.liberar_travamento(c_vc_modulo_conf_cons  ||
                                                       to_char(p_n_id_agenda),
                                                       l_i_aux);
               end if;
            end if;

            commit;
            l_i_retorno := 1;
         end if;

         -- Libera o lock
         l_b_result :=
            amesp.pkg_lock.liberar_travamento(c_vc_modulo_canc_cons  ||
                                              to_char(p_n_id_agenda),
                                              l_i_aux);
      end if;

      return l_i_retorno;
   exception
      when others then
         rollback;
         -- Libera o lock, caso houver um
         l_b_result :=
            amesp.pkg_lock.liberar_travamento(c_vc_modulo_canc_cons  ||
                                              to_char(p_n_id_agenda),
                                              l_i_aux);
         l_b_result :=
            amesp.pkg_lock.liberar_travamento(c_vc_modulo_conf_cons  ||
                                              to_char(p_n_id_agenda),
                                              l_i_aux);
         raise;
   end;   -- Function verifica_e_cancela_consulta;

   procedure cancela_consulta(
      p_n_id_agenda   in amesp.mc_agenda.id_agenda%type,
      p_n_id_motivo   in amesp.mc_motivo.id_motivo%type,
      p_n_id_usuario  in amesp.acesso_login.id_usuario%type,
      p_s_solicitante in amesp.mc_mot_agenda_cancelada.solicitante%type,
      p_s_unidade     in amesp.mc_mot_agenda_cancelada.unidade%type,
      p_c_commit      in char default 'S') is   --Willyan 06/11/2007
      l_c_encaixe   char(1);
      l_s_status    char(2);
      l_d_dt_agenda date;
   begin
      /*
         Cancela a consulta informada.

         Importante:
           * Esta rotina não faz mais nenhuma verificação. Portanto não deve ser utilizada como uma forma
             de cancelamento de agenda completa. Para isso, utilizar a função verifica_e_cancela_consulta.

         Parâmetros:
           p_n_id_agenda   - ID_AGENDA da consulta
           p_n_id_motivo   - Motivo do cancelamento
           p_n_id_usuario  - ID do usuário que está fazendo o cancelamento (lookup: ACESSO_LOGIN)
           p_s_solicitante - Solicitante
           p_s_unidade     - Unidade
           p_c_commit      - S ou N. Indica se a transação deve ser finalizada ou não pela
                             própria rotina.

         Utilização:
           Rotina de URA do Callcenter (integração com a empresa de CTI)

         Histórico.:
         -----------+-----------+------------------------------------------------------------
         2008.02.23 | Fábio     | - Adaptei para executar a rotina mc_lista_espera_NE
         -----------+-----------+------------------------------------------------------------
         2007.11.07 | Willyan   | - Coloquei o parametro p_c_commit com defalt 'S', para
                    |           |   definir se o commit deve ou não ser executado. Aqui na
                    |           |   Medial, o commit/rollback é executado nas aplicações. Na
                    |           |   Comunika (que também utiliza esta função), o commit/rollback
                    |           |   é realizado na própria função.
         -----------+-----------+------------------------------------------------------------
         2007.10.11 | Fabio     | - Conforme solicitação do Sérgio Rago via email
                    |           |   "RES: Alteração SMC", 10/10/2007 15:12, passei a
                    |           |   desconsiderar consultas de encaixe no processo de
                    |           |   antecipação (Ilha de Espera).
         -----------+-----------+------------------------------------------------------------
         2007.09.26 | Fabio     | - Coloquei um COMMIT antes da procedure MC_LISTA_ESPERA,
                    |           |   pois ela utiliza AUTONOMOUS_TRANSACTION.
         -----------+-----------+------------------------------------------------------------
         2007.06.06 | Faraco    | - Criação
         -----------+-----------+------------------------------------------------------------
      */
      begin
         -- seleciona status_consulta e data da mc_agenda
         select status_consulta,
                to_date(data_agenda || ' ' || hora_agenda, 'dd/mm/yyyy hh24:mi'),
                nvl(encaixe_cm, 'N')
           into l_s_status,
                l_d_dt_agenda,
                l_c_encaixe
           from amesp.mc_agenda
          where id_agenda = p_n_id_agenda;
      exception
         when no_data_found then
            raise_application_error
               (-20500,
                'Não foi possível cancelar este agendamento. Provavelmente ele já foi cancelado por outro usuário.');
      end;

      -- exclui agenda (neste caso será incluida pela trigger como cancelada...
      delete from amesp.mc_agenda
            where id_agenda = p_n_id_agenda;

      if l_s_status <> 'RE' then
         -- inclui registro de detalhe...
         insert into amesp.mc_mot_agenda_cancelada
                     (id_agenda, id_motivo, usuario_cancelamento,
                      data_hora_cancelamento, solicitante, unidade)
              values (p_n_id_agenda, p_n_id_motivo, p_n_id_usuario,
                      sysdate, p_s_solicitante, p_s_unidade);
      end if;

/* ------------------------------------------------------------------------------------
    Retirado o Conceito de Lista de Espera (19/04/2010 - adaptação Amil)


      -- Este commit é necessário para que a proc MC_LISTA_ESPERA (que usa AUTONOMOUS TRANS)
      -- enxergue as consultas canceladas e ainda não commitadas. // Fábio, 26/09/2007.
      --commit;

      -- Não ativa a chamada para fila de espera se:
      --  * agendamento for no mesmo dia ou inferior a 12 horas úteis
      --  * agendamento for encaixe de CM


      if     (l_d_dt_agenda > trunc(sysdate))
         and (l_d_dt_agenda > amesp.proxima_hora_util('ESP', sysdate, 720))
         and (l_c_encaixe = 'N') then
--         mc_lista_espera(p_n_id_agenda); // Fábio, 23/02/2008.
         amesp.mc_lista_espera_ne(p_n_id_agenda);
      end if;
 ------------------------------------------------------------------------------------*/
      if (p_c_commit = 'S') then   --Willyan 06/11/2007
         commit;
      end if;
   exception
      when others then
         if (p_c_commit = 'S') then   --Willyan 06/11/2007
            rollback;
         end if;

         raise;
   end;   -- Function cancela_consulta;

   procedure dados_conexao_dde(
      p_c_servico out varchar2,
      p_c_topico  out varchar2,
      p_c_item    out varchar2) is
   begin
      p_c_servico := 'SoftPhoneDDE';
      p_c_topico := 'DDE_SERVICE_AMESP';
      p_c_item := 'ITEM_AMESP';
   end;
end;


/
