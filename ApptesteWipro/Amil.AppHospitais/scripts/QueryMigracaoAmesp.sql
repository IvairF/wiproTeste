-- Amesp
create user AMESP
  default tablespace TBSASM_DATA
  temporary tablespace TEMP
  profile DEFAULT
  identified by "AMESP#2018"
  account lock;

grant create any table to AMESP;
grant drop any table to AMESP;
grant unlimited tablespace to AMESP; 

---------------------------------------------------
-- Export file for user AMESP                    --
---------------------------------------------------
---------------------------------------------------
-- Export file for user AMESP                    --
-- Created by amleoratti on 22/03/2018, 09:52:37 --
---------------------------------------------------

/*set define off
spool EXPORT_OBJECTS_AMESP_NOW.log
*/
--PROMPT
--PROMPT Creating table AA_ESPECIALIDADES
--PROMPT ================================
--PROMPT
create table AMESP.AA_ESPECIALIDADES
(
  codigo                    CHAR(3) not null,
  especialidade             VARCHAR2(70),
  status_registro           CHAR(1),
  tipo                      CHAR(1) not null,
  correspondente            CHAR(3),
  correspondente_internacao CHAR(3),
  limite_solicit            NUMBER(4,2),
  limite_ch_por_cons        NUMBER(3) default 0 not null,
  correspondente_espec      CHAR(3),
  marcacao_mpv              CHAR(1),
  referencia                CHAR(1),
  encaminhamento            CHAR(1),
  tipo_sip                  CHAR(1),
  id_ocupacao               VARCHAR2(5),
  id_amb_especialidade      VARCHAR2(8),
  id_amb_medial             VARCHAR2(8),
  id_tipo_cr                CHAR(1),
  id_evento_especialidade   NUMBER(12),
  id_efoccus                VARCHAR2(5),
  id_sisagenda              VARCHAR2(5),
  fl_total_care             NUMBER default 0,
  id_chave                  NUMBER(5) not null,
  tp_exame                  VARCHAR2(2),
  fl_distribuidor           NUMBER(1) default 1,
  id_evento_conduta         NUMBER(12),
  id_clinica                NUMBER(5),
  id_cbos                   NUMBER(12),
  id_tiss                   NUMBER(12),
  id_espec_grupo_bi         NUMBER(12),
  id_espec_classificacao_bi NUMBER(12),
  fl_atende_pa              INTEGER default (0),
  fl_classificavel          NUMBER(1) default 0,
  fl_tipo_equipe            NUMBER(1) default 0,
  fl_hab_ated_grupo         NUMBER(1) default 0
)
;
comment on table AMESP.AA_ESPECIALIDADES
  is 'Tabela de especialidades, procedimentos e exames realizados na rede própria.';
comment on column AMESP.AA_ESPECIALIDADES.status_registro
  is 'Este campo e utilizado pelo CMC. ''A'' indica especialidade ativa e ''I'' indica espec. inativa.';
comment on column AMESP.AA_ESPECIALIDADES.tipo
  is 'P - Procedimento/Exame; E - Consulta; X - Outros';
comment on column AMESP.AA_ESPECIALIDADES.limite_solicit
  is '% permitida de solicitações de exames por consulta';
comment on column AMESP.AA_ESPECIALIDADES.limite_ch_por_cons
  is 'Limite de CHs solicitados por consulta.';
comment on column AMESP.AA_ESPECIALIDADES.marcacao_mpv
  is 'NULL - Disponível para todos; ''S'' - Apenas usuarios da Preventiva;';
comment on column AMESP.AA_ESPECIALIDADES.referencia
  is 'S - especialidade de referência, primeira consulta';
comment on column AMESP.AA_ESPECIALIDADES.encaminhamento
  is 'S=Indica que o sistema PEP utilizará esta especialidade para ser carregada na lista de especialidades na conduta.';
comment on column AMESP.AA_ESPECIALIDADES.id_ocupacao
  is 'Chave da tabela classificacao_ocupacoes';
comment on column AMESP.AA_ESPECIALIDADES.id_amb_especialidade
  is 'Código AMB para lançamendo da solicitção quando for encaminhado para esta especialidade';
comment on column AMESP.AA_ESPECIALIDADES.id_evento_especialidade
  is 'Campo que faz o De Para entre esta tabela e a glb_evento_especialidade';
comment on column AMESP.AA_ESPECIALIDADES.fl_total_care
  is '1 - para indicar especialidade com atendimento Total Care';
comment on column AMESP.AA_ESPECIALIDADES.id_chave
  is 'Chave de log da tabela';
comment on column AMESP.AA_ESPECIALIDADES.tp_exame
  is 'L = Exame Laboratorial, I = Exame de Imagem';
comment on column AMESP.AA_ESPECIALIDADES.fl_distribuidor
  is 'Determina se a especialidade será mostrada ou não no Distribuidor ( 0-Não / 1-Sim )';
comment on column AMESP.AA_ESPECIALIDADES.id_evento_conduta
  is 'ID do evento da conduta que deverá ser lançada no PEP quando o médico encaminha o paciente para uma determinada especialidade';
comment on column AMESP.AA_ESPECIALIDADES.id_clinica
  is 'Código da clínica associada à especialidade';
comment on column AMESP.AA_ESPECIALIDADES.id_espec_grupo_bi
  is 'Id do Grupo da especialidade, utilizado pelo B.I., FK aa_espec_grupo_bi';
comment on column AMESP.AA_ESPECIALIDADES.id_espec_classificacao_bi
  is 'Id da Classificação da especialidade, utilizado pelo B.I., FK aa_espec_classificacao_bi';
comment on column AMESP.AA_ESPECIALIDADES.fl_classificavel
  is 'Determinar se a especialidade pode ser utilizada na tela de ClassificaÃ§Ã£o do Protocolo';
comment on column AMESP.AA_ESPECIALIDADES.fl_tipo_equipe
  is 'Tipo de equipe que faz uso da especialidade. 0-Todas 1-Especialidades Medicas 2-Equipe Multiprofissional';
comment on column AMESP.AA_ESPECIALIDADES.fl_hab_ated_grupo
  is 'Habilita atendimento em grupo no PEP';
create index AMESP.AA_ESPECIALIDADES_CLASS_BI_IX on AMESP.AA_ESPECIALIDADES (ID_ESPEC_CLASSIFICACAO_BI);
create index AMESP.AA_ESPECIALIDADES_DIST on AMESP.AA_ESPECIALIDADES (FL_DISTRIBUIDOR);
create index AMESP.AA_ESPECIALIDADES_GRP_BI_IX on AMESP.AA_ESPECIALIDADES (ID_ESPEC_GRUPO_BI);
create index AMESP.AA_ESPECIALIDADES_IX01 on AMESP.AA_ESPECIALIDADES (ENCAMINHAMENTO);
create index AMESP.SCM_CLASSIF_OCUPACOES_FK on AMESP.AA_ESPECIALIDADES (ID_OCUPACAO);

--PROMPT
--PROMPT Creating table ACESSO_LOGIN
--PROMPT ===========================
--PROMPT
create table AMESP.ACESSO_LOGIN
(
  id_usuario                 NUMBER(5) not null,
  nome                       VARCHAR2(15),
  nome_completo              VARCHAR2(60) not null,
  usuario_inativo            VARCHAR2(1),
  id_unidade                 CHAR(3),
  id_depto                   CHAR(4),
  email_externo              VARCHAR2(60),
  email_interno              VARCHAR2(60),
  data_ultimo_acesso         DATE,
  cpf                        NUMBER(11),
  tx_senha                   VARCHAR2(32),
  fl_senha_cripto            NUMBER(1) default 0 not null,
  dt_validade_senha          DATE,
  data_hora_ultima_tentativa TIMESTAMP(6),
  trocar_senha               NUMBER(1) default 1 not null,
  qtd_tentativa              NUMBER(1) default 0 not null,
  dt_ultima_troca_senha      DATE,
  fl_primeiro_acesso         NUMBER(1) default 1,
  usuario_bloqueado          VARCHAR2(1)
)
;
comment on column AMESP.ACESSO_LOGIN.usuario_inativo
  is 'Null -> Ativo; S-> Inativo (mas pode ser reativado);  * -> Inativo (e não pode ser reativado)';
comment on column AMESP.ACESSO_LOGIN.data_ultimo_acesso
  is 'Ultimo acesso do usuario ao banco de dados.';
comment on column AMESP.ACESSO_LOGIN.tx_senha
  is 'Senha criptografada';
comment on column AMESP.ACESSO_LOGIN.fl_senha_cripto
  is 'Indica que o usuário possui uma senha criptografa gravada no banco. 1.Sim / 0.Não';
comment on column AMESP.ACESSO_LOGIN.dt_validade_senha
  is 'Data de validade da senha';
comment on column AMESP.ACESSO_LOGIN.data_hora_ultima_tentativa
  is 'Data hora da última tentativa errada de login';
comment on column AMESP.ACESSO_LOGIN.trocar_senha
  is 'Indica se é para o usuário trocar a senha no primeiro login';
comment on column AMESP.ACESSO_LOGIN.qtd_tentativa
  is 'Indica a quantidade de tentativas de login';
comment on column AMESP.ACESSO_LOGIN.fl_primeiro_acesso
  is 'Flag do projeto "Remoção AD". 1=Indica que o 1º acesso do usuário será autenticado no AD. 0=Indica que já foi feita a autenticação do 1º acesso no AD';
comment on column AMESP.ACESSO_LOGIN.usuario_bloqueado
  is 'S=Bloqueado / Null=Desbloqueado';
create index AMESP.ACS_LOG_HD_DEP_FK on AMESP.ACESSO_LOGIN (ID_DEPTO, ID_UNIDADE);
create index AMESP.ACS_LOG_HD_UNI_FK on AMESP.ACESSO_LOGIN (ID_UNIDADE);

--PROMPT
--PROMPT Creating table ACESSO_CHAVE_ATIVACAO
--PROMPT ====================================
--PROMPT
create table AMESP.ACESSO_CHAVE_ATIVACAO
(
  cd_chave        VARCHAR2(6) not null,
  id_usuario      NUMBER(5) not null,
  id_sistema      VARCHAR2(4) not null,
  dt_hr_geracao   DATE default sysdate not null,
  dt_validade     DATE not null,
  fl_ativada      NUMBER(1) default 0 not null,
  cd_contra_chave VARCHAR2(6)
)
;

--PROMPT
--PROMPT Creating table ACESSO_SISTEMA_VERSOES
--PROMPT =====================================
--PROMPT
create table AMESP.ACESSO_SISTEMA_VERSOES
(
  id_sistema    VARCHAR2(4),
  versao        VARCHAR2(15) not null,
  id_chave      NUMBER(4),
  data_versao   DATE,
  ativo         NUMBER(1) not null,
  data_termino  DATE,
  id_executavel NUMBER(7),
  tx_hash       VARCHAR2(32),
  de_sistemas   VARCHAR2(150)
)
;
comment on column AMESP.ACESSO_SISTEMA_VERSOES.id_executavel
  is 'identificação do executável';
comment on column AMESP.ACESSO_SISTEMA_VERSOES.tx_hash
  is 'hash da versão do executável';
comment on column AMESP.ACESSO_SISTEMA_VERSOES.de_sistemas
  is 'Nomes dos Sistemas';
create unique index AMESP.ACESSO_SISTEMAS_VERSOES_UK on AMESP.ACESSO_SISTEMA_VERSOES (ID_SISTEMA, VERSAO);
create unique index AMESP.ACSSISVRS_IDEXE_VRS_UK on AMESP.ACESSO_SISTEMA_VERSOES (ID_EXECUTAVEL, VERSAO, ID_SISTEMA);
create unique index AMESP.ACSSISVRS_IDSIS_VRS_UK on AMESP.ACESSO_SISTEMA_VERSOES (ID_SISTEMA, VERSAO, ID_EXECUTAVEL);

--PROMPT
--PROMPT Creating table CM_BASE_DADOS_WPD
--PROMPT ================================
--PROMPT
create table AMESP.CM_BASE_DADOS_WPD
(
  id_base_dados              NUMBER not null,
  nome                       VARCHAR2(50) not null,
  alias                      VARCHAR2(30) not null,
  fl_especialidade_totalcare NUMBER(1) default 0
)
;
comment on column AMESP.CM_BASE_DADOS_WPD.id_base_dados
  is 'PK da tabela';
comment on column AMESP.CM_BASE_DADOS_WPD.nome
  is 'Nome da base de dados';
comment on column AMESP.CM_BASE_DADOS_WPD.alias
  is 'Alias da base de dados';
comment on column AMESP.CM_BASE_DADOS_WPD.fl_especialidade_totalcare
  is 'Determina se será enviado o código "CLTC" para especialidade/atendimento TotalCare, config view --> base 1-Medial e 4-Amil-SP=1';

--PROMPT
--PROMPT Creating table CM_ESCALA_RISCO
--PROMPT ==============================
--PROMPT
create table AMESP.CM_ESCALA_RISCO
(
  id_escala_risco NUMBER(12) not null,
  nm_escala_risco VARCHAR2(40) not null
)
;
comment on table AMESP.CM_ESCALA_RISCO
  is 'Cadastro de escalas de risco utilizadas pelas unidades';
comment on column AMESP.CM_ESCALA_RISCO.id_escala_risco
  is 'Identificador sequencial do registro';
comment on column AMESP.CM_ESCALA_RISCO.nm_escala_risco
  is 'Nome da escala de risco';

--PROMPT
--PROMPT Creating table CM_ESTRATIFICACAO_RISCO
--PROMPT ======================================
--PROMPT
create table AMESP.CM_ESTRATIFICACAO_RISCO
(
  id_risco        NUMBER(12) not null,
  cd_risco        CHAR(1) not null,
  nm_risco        VARCHAR2(15) not null,
  id_escala_risco NUMBER(12) not null,
  nr_risco        NUMBER(2) not null
)
;
create unique index AMESP.CM_ESTRATRISCO_CD_RISCO_UK on AMESP.CM_ESTRATIFICACAO_RISCO (CD_RISCO);

--PROMPT
--PROMPT Creating table CM_FILIAL
--PROMPT ========================
--PROMPT
create table AMESP.CM_FILIAL
(
  id_filial NUMBER(12) not null,
  nm_filial VARCHAR2(20) not null,
  fl_ativo  NUMBER(1) not null
)
;
comment on table AMESP.CM_FILIAL
  is 'Tabela de Filiais';
comment on column AMESP.CM_FILIAL.id_filial
  is 'Identificador sequencial único do registro de Filial';
comment on column AMESP.CM_FILIAL.nm_filial
  is 'Nome da Filial';
comment on column AMESP.CM_FILIAL.fl_ativo
  is 'Indica se Filial está ativa (1) ou inativa (0)';

--PROMPT
--PROMPT Creating table ESTADOS
--PROMPT ======================
--PROMPT
create table AMESP.ESTADOS
(
  id_uf          CHAR(2) not null,
  descricao      VARCHAR2(30) not null,
  cd_cep_inicio  VARCHAR2(5),
  cd_cep_termino VARCHAR2(5),
  id_regiao      CHAR(2)
)
;
comment on column AMESP.ESTADOS.cd_cep_inicio
  is 'Obsoleto.';
comment on column AMESP.ESTADOS.cd_cep_termino
  is 'Obsoleto.';
comment on column AMESP.ESTADOS.id_regiao
  is 'Obsoleto.';
create index AMESP.ESTADOS_REGIAO_FK on AMESP.ESTADOS (ID_REGIAO);

--PROMPT
--PROMPT Creating table GLB_FUSO_HORARIO
--PROMPT ===============================
--PROMPT
create table AMESP.GLB_FUSO_HORARIO
(
  id_fuso_horario NUMBER(3) not null,
  nm_fuso_horario VARCHAR2(30) not null,
  tp_time_zone    VARCHAR2(40) not null
)
;
comment on table AMESP.GLB_FUSO_HORARIO
  is 'Tabela de Fusos-Horários do SisMed.';
comment on column AMESP.GLB_FUSO_HORARIO.id_fuso_horario
  is 'Chave da tabela';
comment on column AMESP.GLB_FUSO_HORARIO.nm_fuso_horario
  is 'Nome do fuso horário';
comment on column AMESP.GLB_FUSO_HORARIO.tp_time_zone
  is 'String de Time Zone do Oracle (para ser utilizada com ALTER SESSION SET TIME_ZONE)';

--PROMPT
--PROMPT Creating table CM_FILIAL_UF
--PROMPT ===========================
--PROMPT
create table AMESP.CM_FILIAL_UF
(
  id_filial_uf             NUMBER(12) not null,
  id_filial                NUMBER(12) not null,
  id_uf                    CHAR(2) not null,
  fl_ativo                 NUMBER(1) not null,
  id_fuso_horario          NUMBER(3) default 1 not null,
  fl_imprime_prontuario    NUMBER default 1,
  fl_data_guia_tiss        NUMBER default 1,
  fl_exibe_encaixe         NUMBER default 1,
  fl_agenda_online_receita NUMBER default 0,
  idade_crianca            NUMBER(12) default 12,
  fl_envia_retorno_wpd     NUMBER(1) default 1,
  fl_fluxo_franqueados     NUMBER(1),
  fl_msg_totem             NUMBER(1) default 1,
  msg_divug_pat            VARCHAR2(730),
  fl_hab_msg_total_care    NUMBER(1) default 1 not null
)
;
comment on table AMESP.CM_FILIAL_UF
  is 'Tabela de UFs pertencentes às Filiais';
comment on column AMESP.CM_FILIAL_UF.id_filial_uf
  is 'Identificador sequencial único do registro de UF da Filial';
comment on column AMESP.CM_FILIAL_UF.id_filial
  is 'Identificador da Filial à qual pertence a UF';
comment on column AMESP.CM_FILIAL_UF.id_uf
  is 'Identificador da UF';
comment on column AMESP.CM_FILIAL_UF.fl_ativo
  is 'Indica se UF está ativa (1) ou inativa (0)';
comment on column AMESP.CM_FILIAL_UF.id_fuso_horario
  is 'Fuso horário que deve ser assumido pela unidade';
comment on column AMESP.CM_FILIAL_UF.fl_imprime_prontuario
  is 'Indica se a filial imprime o prontuário ao finalizar o atendimento';
comment on column AMESP.CM_FILIAL_UF.fl_data_guia_tiss
  is 'Indica se a filial imprime data de emissão na guia TISS';
comment on column AMESP.CM_FILIAL_UF.fl_exibe_encaixe
  is 'Indica se a filial destaca os encaixes e exibe as consultas agendadas no workflow do Médico';
comment on column AMESP.CM_FILIAL_UF.idade_crianca
  is 'Determina até qual idade (<=) que o sistema irá considerar como criança.';
comment on column AMESP.CM_FILIAL_UF.fl_envia_retorno_wpd
  is 'Indica se a filial ira faturar ou não atendimento de retorno (enviar para o wpd) ';
comment on column AMESP.CM_FILIAL_UF.fl_fluxo_franqueados
  is 'Indica se a filial utiliza ou não o conceito/fluxo de plano fraqueado';
comment on column AMESP.CM_FILIAL_UF.fl_msg_totem
  is 'Indica se a filial irá exibir uma mensagem na tela do totem ';
comment on column AMESP.CM_FILIAL_UF.msg_divug_pat
  is 'Mensagem de divulgação do PAT (Programa de Adesão ao Tratamento) nas receitas.';
comment on column AMESP.CM_FILIAL_UF.fl_hab_msg_total_care
  is 'Habilita mensagem de encaminhamento para total care (PEP)';

--PROMPT
--PROMPT Creating table CM_REGIONAL
--PROMPT ==========================
--PROMPT
create table AMESP.CM_REGIONAL
(
  id_regional  NUMBER(12) not null,
  nm_regional  VARCHAR2(20) not null,
  id_filial_uf NUMBER(12) not null,
  fl_ativo     NUMBER(1) not null
)
;
comment on table AMESP.CM_REGIONAL
  is 'Tabela de Regionais pertencentes às Filiais';
comment on column AMESP.CM_REGIONAL.id_regional
  is 'Identificador sequencial único do registro de Regional';
comment on column AMESP.CM_REGIONAL.nm_regional
  is 'Nome da Regional';
comment on column AMESP.CM_REGIONAL.id_filial_uf
  is 'Identificador da Filial/UF à qual pertence a Regional';
comment on column AMESP.CM_REGIONAL.fl_ativo
  is 'Indica se Regional está ativa (1) ou inativa (0)';

--PROMPT
--PROMPT Creating table GLB_CONFIG_DATABASE
--PROMPT ==================================
--PROMPT
create table AMESP.GLB_CONFIG_DATABASE
(
  id_config_database NUMBER(12) not null,
  id_database        NUMBER(12) not null,
  conteudo_xml       SYS.XMLTYPE,
  id_config          NUMBER(12) not null
)
;
comment on table AMESP.GLB_CONFIG_DATABASE
  is 'Configurações que dependem do banco de dados ao qual se está conectado (detalhe de glb_config)';

--PROMPT
--PROMPT Creating table INI_CONFIG
--PROMPT =========================
--PROMPT
create table AMESP.INI_CONFIG
(
  id_sistema   VARCHAR2(4) not null,
  id_unidade   CHAR(3),
  id_usuario   NUMBER(5),
  chave        VARCHAR2(80) not null,
  conteudo     VARCHAR2(30) not null,
  id_chave     NUMBER(5) not null,
  conteudo_xml SYS.XMLTYPE
)
;
comment on column AMESP.INI_CONFIG.id_sistema
  is 'Systemcode do NSControl';
comment on column AMESP.INI_CONFIG.chave
  is 'Nome da chave';
comment on column AMESP.INI_CONFIG.conteudo
  is 'valor da chave';
comment on column AMESP.INI_CONFIG.id_chave
  is 'Chave única';
create index AMESP.INI_CONFIG_FK1 on AMESP.INI_CONFIG (ID_USUARIO);
create index AMESP.INI_CONFIG_FK2 on AMESP.INI_CONFIG (ID_UNIDADE);
create index AMESP.INI_CONFIG_IDX1 on AMESP.INI_CONFIG (ID_SISTEMA);
create index AMESP.INI_CONFIG_IDX2 on AMESP.INI_CONFIG (ID_SISTEMA, ID_USUARIO, CHAVE, ID_UNIDADE);
create index AMESP.TEOR_IX13 on AMESP.INI_CONFIG (UPPER(ID_SISTEMA), UPPER(CHAVE));

--PROMPT
--PROMPT Creating table NOW_UNIDADE
--PROMPT ==========================
--PROMPT
create table AMESP.NOW_UNIDADE
(
  id_unidade            NUMBER(12) not null,
  id_base               NUMBER(12) not null,
  nm_unidade            VARCHAR2(60) not null,
  id_regional           NUMBER(12) not null,
  id_escala_risco       NUMBER(12) not null,
  dt_hr_atualizacao     DATE,
  dt_hr_fim_atualizacao DATE,
  cd_unidade            VARCHAR2(10),
  fl_ativa              NUMBER(1) default 0 not null
)
;
comment on table AMESP.NOW_UNIDADE
  is 'Cadastro de unidades que deverão ser monitoradas pelo robô e pela aplicação';
comment on column AMESP.NOW_UNIDADE.id_unidade
  is 'Identificar sequencial único do registro';
comment on column AMESP.NOW_UNIDADE.id_base
  is 'Identificador da base à qual pertence a unidade (FK de cm_base_dados_wpd)';
comment on column AMESP.NOW_UNIDADE.nm_unidade
  is 'Nome da unidade';
comment on column AMESP.NOW_UNIDADE.id_regional
  is 'Identificador da Regional da unidade';
comment on column AMESP.NOW_UNIDADE.id_escala_risco
  is 'Identificador da escala de risco utilizada no PS da unidade';
comment on column AMESP.NOW_UNIDADE.dt_hr_atualizacao
  is 'Data e hora em que INICIOU a última atualização de contagens da unidade. É a informação que deve aparecer para o usuário.';
comment on column AMESP.NOW_UNIDADE.dt_hr_fim_atualizacao
  is 'Data e hora em que TERMINOU a última atualização das contagens da unidade. Deve ser usada pelo robô, para decidir se não é cedo demais para começar nova atualização.';
comment on column AMESP.NOW_UNIDADE.cd_unidade
  is 'Código da unidade no sistema da mesma. Nulo se não se aplica.';
comment on column AMESP.NOW_UNIDADE.fl_ativa
  is 'Indica se coleta de indicadores deve estar ativa para a unidade';

--PROMPT
--PROMPT Creating table NOW_FASE
--PROMPT =======================
--PROMPT
create table AMESP.NOW_FASE
(
  id_fase NUMBER(12) not null,
  nm_fase VARCHAR2(20) not null
)
;
comment on table AMESP.NOW_FASE
  is 'Cadastro de "fases" do atendimento, que são de interesse para a aplicação';
comment on column AMESP.NOW_FASE.id_fase
  is 'Identificador sequencial do registro';
comment on column AMESP.NOW_FASE.nm_fase
  is 'Nome da Fase';
create index AMESP.NOW_FASE_NOME_IX on AMESP.NOW_FASE (NM_FASE);

--PROMPT
--PROMPT Creating table NOW_UNIDADE_FASE
--PROMPT ===============================
--PROMPT
create table AMESP.NOW_UNIDADE_FASE
(
  id_unidade_fase     NUMBER(12) not null,
  id_unidade          NUMBER(12) not null,
  id_fase             NUMBER(12) not null,
  nm_unidade_fase     VARCHAR2(40) not null,
  qt_pacientes_maximo NUMBER(4) not null,
  qt_minutos_maximo   NUMBER(4) not null,
  nr_ordem            NUMBER(2)
)
;
comment on table AMESP.NOW_UNIDADE_FASE
  is 'Cadastro de "agrupamentos de fases" em cada unidade. Cada fase pode ser utilizada mais de uma vez na unidade, por exemplo quando há segregação de filas de espera por especialidades diferentes.';
comment on column AMESP.NOW_UNIDADE_FASE.id_unidade_fase
  is 'Identificador sequencial único do registro';
comment on column AMESP.NOW_UNIDADE_FASE.id_unidade
  is 'Identificador da unidade';
comment on column AMESP.NOW_UNIDADE_FASE.id_fase
  is 'Identificador da Fase';
comment on column AMESP.NOW_UNIDADE_FASE.nm_unidade_fase
  is 'Nome a ser exibido para este agrupamento';
comment on column AMESP.NOW_UNIDADE_FASE.qt_pacientes_maximo
  is 'Fundo de escala para a quantidade de pacientes em espera neste agrupamento';
comment on column AMESP.NOW_UNIDADE_FASE.qt_minutos_maximo
  is 'Fundo de escala para o tempo previsto de espera neste agrupamento';
comment on column AMESP.NOW_UNIDADE_FASE.nr_ordem
  is 'Ordem de exibição da fase';

--PROMPT
--PROMPT Creating table NOW_UNIDADE_FASE_PERIODO
--PROMPT =======================================
--PROMPT
create table AMESP.NOW_UNIDADE_FASE_PERIODO
(
  id_unidade_fase_periodo NUMBER(12) not null,
  id_unidade_fase         NUMBER(12) not null,
  qt_minutos_inferior     NUMBER(3) not null
)
;
comment on table AMESP.NOW_UNIDADE_FASE_PERIODO
  is 'Cadastro de períodos de espera que devem ser utilizados na contagem de pacientes em cada agrupamento de fase da unidade. P.ex. para considerar uma faixa "de 5 a 10min", haverá um registro nesta tabela onde qt_minutos_inferior=5 e outro onde qt_minutos_inferior=11.';
comment on column AMESP.NOW_UNIDADE_FASE_PERIODO.id_unidade_fase_periodo
  is 'Identificador sequencial único do registro';
comment on column AMESP.NOW_UNIDADE_FASE_PERIODO.id_unidade_fase
  is 'Identificador do agrupamento de fase';
comment on column AMESP.NOW_UNIDADE_FASE_PERIODO.qt_minutos_inferior
  is 'Limite inferior do tempo de espera neste período';

--PROMPT
--PROMPT Creating table NOW_CONTAGEM_PACIENTES
--PROMPT =====================================
--PROMPT
create table AMESP.NOW_CONTAGEM_PACIENTES
(
  id_contagem_pacientes   NUMBER(12) not null,
  id_unidade_fase_periodo NUMBER(12) not null,
  id_risco                NUMBER(12),
  qt_pacientes            NUMBER(4) not null
)
;
comment on table AMESP.NOW_CONTAGEM_PACIENTES
  is 'Contagem de pacientes em espera no agrupamento de fase, período e risco indicados. Quando o risco estiver nulo, são os pacientes que não receberam classificação de risco.';
comment on column AMESP.NOW_CONTAGEM_PACIENTES.id_contagem_pacientes
  is 'Identificador sequencial único do registro';
comment on column AMESP.NOW_CONTAGEM_PACIENTES.id_unidade_fase_periodo
  is 'Identificador do registro de período de espera';
comment on column AMESP.NOW_CONTAGEM_PACIENTES.id_risco
  is 'Identificador da classificação de risco';
comment on column AMESP.NOW_CONTAGEM_PACIENTES.qt_pacientes
  is 'Contagem de pacientes neste agrupamento de fase, período e risco';
create index AMESP.NOW_CONTPAC_PERIODO_RISCO_IX on AMESP.NOW_CONTAGEM_PACIENTES (ID_UNIDADE_FASE_PERIODO, NVL(ID_RISCO,0));

--PROMPT
--PROMPT Creating table NOW_ESPECIALIDADES
--PROMPT =================================
--PROMPT
create table AMESP.NOW_ESPECIALIDADES
(
  id_especialidade       NUMBER(12) not null,
  id_chave_especialidade NUMBER(5) not null,
  sg_especialidade       VARCHAR2(5) not null
)
;
comment on table AMESP.NOW_ESPECIALIDADES
  is 'Tabela para padronização de siglas de especialidades';
comment on column AMESP.NOW_ESPECIALIDADES.id_especialidade
  is 'Chave primária da tabela de especialidades.';
comment on column AMESP.NOW_ESPECIALIDADES.id_chave_especialidade
  is 'Chave estrangeira para tabela de AA_ESPECIALIDADES. A chave utiliza o ID_CHAVE para padronização.';
comment on column AMESP.NOW_ESPECIALIDADES.sg_especialidade
  is 'Sigla da especialidade';

--PROMPT
--PROMPT Creating table NOW_UNIDADE_DIVISAO
--PROMPT ==================================
--PROMPT
create table AMESP.NOW_UNIDADE_DIVISAO
(
  id_unidade_divisao NUMBER(12) not null,
  id_unidade         NUMBER(12) not null,
  nm_divisao         VARCHAR2(100) not null
)
;
comment on table AMESP.NOW_UNIDADE_DIVISAO
  is 'Tabela utilizada para armazenar as divisões de uma unidade.';
comment on column AMESP.NOW_UNIDADE_DIVISAO.id_unidade_divisao
  is 'Identificador da divisão de uma unidade.';
comment on column AMESP.NOW_UNIDADE_DIVISAO.id_unidade
  is 'Chave estrangeira para tabela de unidade.';
comment on column AMESP.NOW_UNIDADE_DIVISAO.nm_divisao
  is 'Nome da divisão.';

--PROMPT
--PROMPT Creating table NOW_UNIDADE_ESPECIALIDADE
--PROMPT ========================================
--PROMPT
create table AMESP.NOW_UNIDADE_ESPECIALIDADE
(
  id_unidade_especialidade NUMBER(12) not null,
  id_unidade               NUMBER(12) not null,
  id_chave_especialidade   NUMBER(5) not null,
  cd_espec_unidade         VARCHAR2(10) not null
)
;
comment on table AMESP.NOW_UNIDADE_ESPECIALIDADE
  is 'Cadastro das especialidades atendidas na unidade. Contém também o código que a especialidade recebe no sistema da unidade, para tradução pela aplicação.';
comment on column AMESP.NOW_UNIDADE_ESPECIALIDADE.id_unidade_especialidade
  is 'Identificador sequencial único do registro';
comment on column AMESP.NOW_UNIDADE_ESPECIALIDADE.id_unidade
  is 'Identificador da unidade';
comment on column AMESP.NOW_UNIDADE_ESPECIALIDADE.id_chave_especialidade
  is 'Identificador da especialidade (FK de aa_especialidades.id_chave)';
comment on column AMESP.NOW_UNIDADE_ESPECIALIDADE.cd_espec_unidade
  is 'Código da especialidade no sistema da unidade';
create index AMESP.NOW_UNIDESPEC_ESPEC_IX on AMESP.NOW_UNIDADE_ESPECIALIDADE (ID_CHAVE_ESPECIALIDADE);

--PROMPT
--PROMPT Creating table NOW_ESPECIALIDADE_DIVISAO
--PROMPT ========================================
--PROMPT
create table AMESP.NOW_ESPECIALIDADE_DIVISAO
(
  id_especialidade_divisao NUMBER(12) not null,
  id_unidade_divisao       NUMBER(12) not null,
  id_unidade_especialidade NUMBER(12) not null
)
;
comment on column AMESP.NOW_ESPECIALIDADE_DIVISAO.id_unidade_divisao
  is 'Chave estrangeira para tabela NOW_UNIDADE_DIVISAO';
comment on column AMESP.NOW_ESPECIALIDADE_DIVISAO.id_unidade_especialidade
  is 'Chave estrangeira para tabela de especialidade da unidade.';

--PROMPT
--PROMPT Creating table NOW_FASE_SUMARIO
--PROMPT ===============================
--PROMPT
create table AMESP.NOW_FASE_SUMARIO
(
  id_fase_sumario     NUMBER(12) not null,
  id_unidade_divisao  NUMBER(12) not null,
  id_fase             NUMBER(12) not null,
  fl_aguarda_feedback NUMBER(1),
  qt_pacientes        NUMBER(4),
  qt_minutos_maior    NUMBER(12),
  st_quantidade       NUMBER(1),
  st_tempo            NUMBER(1)
)
;
comment on table AMESP.NOW_FASE_SUMARIO
  is 'Sumarização de pacientes por divisao e fase';
comment on column AMESP.NOW_FASE_SUMARIO.id_fase_sumario
  is 'Chave primária da tabela';
comment on column AMESP.NOW_FASE_SUMARIO.id_unidade_divisao
  is 'Chave estrangeira para tabela de divisões';
comment on column AMESP.NOW_FASE_SUMARIO.id_fase
  is 'Chave estrangeira para tabela de fases';
comment on column AMESP.NOW_FASE_SUMARIO.fl_aguarda_feedback
  is 'Caso o valor seja 1, indica que há um paciente aguardando feedback na fase';
comment on column AMESP.NOW_FASE_SUMARIO.qt_pacientes
  is 'Acumulado da quantidade de pacientes em uma fase que é composta de uma ou mais filas';
comment on column AMESP.NOW_FASE_SUMARIO.qt_minutos_maior
  is 'Tempo que o paciente há mais tempo na fila está aguardando';
comment on column AMESP.NOW_FASE_SUMARIO.st_quantidade
  is 'Situação da fila quanto à quantidade de pacientes. ''1'' indica que a a fila está em um estado bom, ''2'' médio e ''3'' ruim.';
comment on column AMESP.NOW_FASE_SUMARIO.st_tempo
  is 'Situação da fila quanto ao tempo de espera. ''1'' indica que a a fila está em um estado bom, ''2'' médio e ''3'' ruim.';

--PROMPT
--PROMPT Creating table NOW_FEEDBACK_PACIENTE
--PROMPT ====================================
--PROMPT
create table AMESP.NOW_FEEDBACK_PACIENTE
(
  id_feedback_paciente NUMBER(12) not null,
  id_unidade           NUMBER(12) not null,
  id_senha             NUMBER(12) not null,
  dh_solicitacao       DATE,
  dh_feedback          DATE
)
;
comment on table AMESP.NOW_FEEDBACK_PACIENTE
  is 'Feedbacks para os pacientes, já dados ou pendentes';
comment on column AMESP.NOW_FEEDBACK_PACIENTE.id_feedback_paciente
  is 'Identificador do registro de feedback';
comment on column AMESP.NOW_FEEDBACK_PACIENTE.id_unidade
  is 'Chave estrangeira para a unidade';
comment on column AMESP.NOW_FEEDBACK_PACIENTE.id_senha
  is 'Identificador da senha de atendimento, no sistema de origem';
comment on column AMESP.NOW_FEEDBACK_PACIENTE.dh_solicitacao
  is 'Data e hora em que o paciente solicitou um feedback (preenchido somente caso o feedback tenha sido solicitado pelo paciente)';
comment on column AMESP.NOW_FEEDBACK_PACIENTE.dh_feedback
  is 'Data e hora em que o feedback foi dado ao paciente';

--PROMPT
--PROMPT Creating table NOW_GRUPO
--PROMPT ========================
--PROMPT
create table AMESP.NOW_GRUPO
(
  id_grupo NUMBER(12) not null,
  nome     VARCHAR2(72) not null
)
;
comment on column AMESP.NOW_GRUPO.id_grupo
  is 'chave dos grupos de unidades do now';
comment on column AMESP.NOW_GRUPO.nome
  is 'nome do grupo';

--PROMPT
--PROMPT Creating table NOW_GRUPO_UNIDADE
--PROMPT ================================
--PROMPT
create table AMESP.NOW_GRUPO_UNIDADE
(
  id_grupo_unidade NUMBER(12) not null,
  id_grupo         NUMBER(12) not null,
  id_unidade       NUMBER(12) not null
)
;
comment on column AMESP.NOW_GRUPO_UNIDADE.id_grupo_unidade
  is 'codigo da tabela de unidade grupo';
comment on column AMESP.NOW_GRUPO_UNIDADE.id_grupo
  is 'id do grupo tabela now_grupo';
comment on column AMESP.NOW_GRUPO_UNIDADE.id_unidade
  is 'id da unidade now unidade';

--PROMPT
--PROMPT Creating table NOW_TEMPO_ESPEC_RISCO
--PROMPT ====================================
--PROMPT
create table AMESP.NOW_TEMPO_ESPEC_RISCO
(
  id_tempo_espec_risco     NUMBER(12) not null,
  id_unidade_especialidade NUMBER(12) not null,
  id_risco                 NUMBER(12),
  qt_pacientes_maximo      NUMBER(4),
  qt_minutos_maximo        NUMBER(4) not null,
  qt_minutos_estimativa    NUMBER(6)
)
;
comment on table AMESP.NOW_TEMPO_ESPEC_RISCO
  is 'Esta tabela tem dupla função: (1) Cadastro de fundos de escala para qtd pacientes e para tempo de espera estimado na especialidade e risco e (2) Estimativa de tempo de espera para o paciente que chegar agora na unidade e escolha esta especialidade e que seja classificado posteriormente com este risco na triagem';
comment on column AMESP.NOW_TEMPO_ESPEC_RISCO.id_tempo_espec_risco
  is 'Identificador sequencial único do registro';
comment on column AMESP.NOW_TEMPO_ESPEC_RISCO.id_unidade_especialidade
  is 'Identificador da especialidade na unidade';
comment on column AMESP.NOW_TEMPO_ESPEC_RISCO.id_risco
  is 'Identificador da classificação de risco';
comment on column AMESP.NOW_TEMPO_ESPEC_RISCO.qt_pacientes_maximo
  is 'Fundo de escala para a contagem de pacientes em espera nesta especialidade e risco (NÃO UTILIZADO ATUALMENTE)';
comment on column AMESP.NOW_TEMPO_ESPEC_RISCO.qt_minutos_maximo
  is 'Fundo de escala para o tempo de espera nesta especialidade e risco';
comment on column AMESP.NOW_TEMPO_ESPEC_RISCO.qt_minutos_estimativa
  is 'Tempo de espera estimado para o paciente que chegue agora na unidade e escolha esta especialidade e que seja posteriormente classificado com este risco na triagem';
create index AMESP.NOW_TMPOESPRSC_ID_RISCO_IX on AMESP.NOW_TEMPO_ESPEC_RISCO (ID_UNIDADE_ESPECIALIDADE, NVL(ID_RISCO,0));

--PROMPT
--PROMPT Creating table NOW_TEMPO_FASE_RISCO
--PROMPT ===================================
--PROMPT
create table AMESP.NOW_TEMPO_FASE_RISCO
(
  id_tempo_fase_risco   NUMBER(12) not null,
  id_unidade_fase       NUMBER(12) not null,
  id_risco              NUMBER(12),
  qt_pacientes_maximo   NUMBER(4) not null,
  qt_minutos_maximo     NUMBER(4) not null,
  qt_minutos_estimativa NUMBER(6)
)
;
comment on table AMESP.NOW_TEMPO_FASE_RISCO
  is 'Esta tabela tem dupla função: (1) Cadastro de fundos de escala para qtd pacientes e tempo de espera no agrupamento de fase e risco e (2) Estimativa de tempo de espera para o paciente que chegar agora neste agrupamento de fase e risco. ';
comment on column AMESP.NOW_TEMPO_FASE_RISCO.id_tempo_fase_risco
  is 'Identificador sequencial único do registro';
comment on column AMESP.NOW_TEMPO_FASE_RISCO.id_unidade_fase
  is 'Identificador do agrupamento de fase';
comment on column AMESP.NOW_TEMPO_FASE_RISCO.id_risco
  is 'Identificador da classificação de risco';
comment on column AMESP.NOW_TEMPO_FASE_RISCO.qt_pacientes_maximo
  is 'Fundo de escala para a contagem de pacientes neste agrupamento de fase e risco';
comment on column AMESP.NOW_TEMPO_FASE_RISCO.qt_minutos_maximo
  is 'Fundo de escala para o tempo de espera neste agrupamento de fase e risco';
comment on column AMESP.NOW_TEMPO_FASE_RISCO.qt_minutos_estimativa
  is 'Tempo estimado de espera neste agrupamento de fase e risco para um paciente que entre agora nessa fase/risco.';
create unique index AMESP.NOW_TMPFASERISC_FASE_RISCO_IX on AMESP.NOW_TEMPO_FASE_RISCO (ID_UNIDADE_FASE, NVL(ID_RISCO,0));

--PROMPT
--PROMPT Creating table NOW_UNIDADE_FASE_ESPEC
--PROMPT =====================================
--PROMPT
create table AMESP.NOW_UNIDADE_FASE_ESPEC
(
  id_unidade_fase_espec    NUMBER(12) not null,
  id_unidade_fase          NUMBER(12) not null,
  id_unidade_especialidade NUMBER(12) not null
)
;
comment on table AMESP.NOW_UNIDADE_FASE_ESPEC
  is 'Cadastro de especialidades que devem ser consideradas em cada agrupamento de fase da unidade.';
comment on column AMESP.NOW_UNIDADE_FASE_ESPEC.id_unidade_fase_espec
  is 'Identificador sequencial único do registro';
comment on column AMESP.NOW_UNIDADE_FASE_ESPEC.id_unidade_fase
  is 'Identificador do agrupamento de fase';
comment on column AMESP.NOW_UNIDADE_FASE_ESPEC.id_unidade_especialidade
  is 'Identificador da especialidade na unidade';

--PROMPT
--PROMPT Creating table NOW_UNIDADE_FASE_SUMARIO
--PROMPT =======================================
--PROMPT
create table AMESP.NOW_UNIDADE_FASE_SUMARIO
(
  id_unidade_fase_sumario NUMBER(12) not null,
  id_unidade_fase         NUMBER(12) not null,
  fl_aguarda_feedback     NUMBER(1),
  qt_pacientes            NUMBER(4),
  qt_minutos_maior        NUMBER(12),
  st_quantidade           NUMBER(1),
  st_tempo                NUMBER(1)
)
;
comment on table AMESP.NOW_UNIDADE_FASE_SUMARIO
  is 'Sumarização de pacientes por fila';
comment on column AMESP.NOW_UNIDADE_FASE_SUMARIO.id_unidade_fase_sumario
  is 'Chave primária da tabela';
comment on column AMESP.NOW_UNIDADE_FASE_SUMARIO.id_unidade_fase
  is 'Chave estrangeira para tabela de Filas (UNIDADE_FASE)';
comment on column AMESP.NOW_UNIDADE_FASE_SUMARIO.fl_aguarda_feedback
  is 'Caso o valor seja 1, indica que há um paciente aguardando feedback na fase';
comment on column AMESP.NOW_UNIDADE_FASE_SUMARIO.qt_pacientes
  is 'Acumulado da quantidade de pacientes em uma fase que é composta de uma ou mais filas';
comment on column AMESP.NOW_UNIDADE_FASE_SUMARIO.qt_minutos_maior
  is 'Tempo que o paciente há mais tempo na fila está aguardando';
comment on column AMESP.NOW_UNIDADE_FASE_SUMARIO.st_quantidade
  is 'Situação da fila quanto à quantidade de pacientes. ''1'' indica que a a fila está em um estado bom, ''2'' médio e ''3'' ruim.';
comment on column AMESP.NOW_UNIDADE_FASE_SUMARIO.st_tempo
  is 'Situação da fila quanto ao tempo de espera. ''1'' indica que a a fila está em um estado bom, ''2'' médio e ''3'' ruim.';


--PROMPT
--PROMPT Creating table NOW_UNIDADE_USUARIO
--PROMPT ==================================
--PROMPT
create table AMESP.NOW_UNIDADE_USUARIO
(
  id_unidade_usuario NUMBER(12) not null,
  id_unidade         NUMBER(12),
  id_usuario         NUMBER(5) not null,
  id_grupo           NUMBER(12)
)
;
comment on table AMESP.NOW_UNIDADE_USUARIO
  is 'Cadastro de usuários autorizados por unidade (hoje só para o aplicativo do Google Glass).';
comment on column AMESP.NOW_UNIDADE_USUARIO.id_unidade_usuario
  is 'Identificador do registro.';
comment on column AMESP.NOW_UNIDADE_USUARIO.id_unidade
  is 'Chave estrangeira para tabela acesso_login.';

--PROMPT
--PROMPT Creating table WF_HISTORICO
--PROMPT ==================================
--PROMPT
create table AMESP.WF_HISTORICO
(
  id_chave      NUMBER(10) not null,
  modulo        VARCHAR2(3) not null,
  id_usuario    NUMBER(5),
  id_status     VARCHAR2(3) not null,
  data_inclusao DATE not null,
  observacoes   VARCHAR2(2000),
  id_local      NUMBER(5),
  id_auxiliar   VARCHAR2(10),
  tempo_exec    NUMBER(10),
  tempo_prev    NUMBER(10),
  id_unico      NUMBER(12),
  id_ocorrencia NUMBER(12)
)
;
comment on table AMESP.WF_HISTORICO
  is 'Registra histórico de solução de inconformidades.';
comment on column AMESP.WF_HISTORICO.id_chave
  is 'chave única da tabela';
comment on column AMESP.WF_HISTORICO.modulo
  is 'Modulo do workFlow';
comment on column AMESP.WF_HISTORICO.id_usuario
  is 'Usuário que solucionou ou deu retorno ao cliente sobre a inconformidade';
comment on column AMESP.WF_HISTORICO.id_status
  is 'Status da solução, relac. a tab wf_status Modulo = CRE';
comment on column AMESP.WF_HISTORICO.data_inclusao
  is 'data que foi registrado o histórico';
comment on column AMESP.WF_HISTORICO.id_local
  is 'Identifica o local da ocorrência';
comment on column AMESP.WF_HISTORICO.id_auxiliar
  is 'Se Modulo:SOS => id_auxiliar=id_departamento(se Status:Transferência ou Solic. Autorização=> O Depto é de destino)';
comment on column AMESP.WF_HISTORICO.tempo_exec
  is 'Tempo de execução deste status, ou seja, o tempo em que permaneceu neste status, se for finalizado este campo estará nulo.';
comment on column AMESP.WF_HISTORICO.tempo_prev
  is 'Tempo calculado do status anterior até este, será usado no Help Desk';
create unique index AMESP.IND_WF_HISTORICO_ID_UNICO on AMESP.WF_HISTORICO (ID_UNICO);
create index AMESP.TEOR_IX06 on AMESP.WF_HISTORICO (DATA_INCLUSAO, MODULO, ID_LOCAL, ID_STATUS, ID_CHAVE);
create index AMESP.TEOR_IX07 on AMESP.WF_HISTORICO (ID_UNICO, MODULO, ID_STATUS, ID_CHAVE);
create index AMESP.WF_HISTORICO_FK2 on AMESP.WF_HISTORICO (ID_STATUS);
create index AMESP.WF_HISTORICO_FK3 on AMESP.WF_HISTORICO (ID_USUARIO);
create index AMESP.WF_HISTORICO_IDX on AMESP.WF_HISTORICO (ID_CHAVE, MODULO);
create index AMESP.WF_HISTORICO_IDX1 on AMESP.WF_HISTORICO (ID_CHAVE);
create index AMESP.WF_HISTORICO_IDX2 on AMESP.WF_HISTORICO (DATA_INCLUSAO);
create index AMESP.WF_HISTORICO_IDX3 on AMESP.WF_HISTORICO (MODULO, ID_STATUS);  


--PROMPT
--PROMPT Creating table PROFISSIONAL_SAUDE_PROPRIO
--PROMPT =========================================
--PROMPT
create table AMESP.PROFISSIONAL_SAUDE_PROPRIO
(
  id_profissional INTEGER not null,
  id_tipo_pagto   INTEGER,
  id_status       CHAR(1) not null,
  data_cadastro   DATE,
  data_deslgto    DATE,
  data_transf     DATE,
  observacoes     VARCHAR2(20),
  coringa         CHAR(1),
  referencia      CHAR(1),
  id_credenciado  CHAR(5)
)
;
comment on column AMESP.PROFISSIONAL_SAUDE_PROPRIO.id_tipo_pagto
  is 'FK da tabela CM_TIPO_PAGTO_MEDICO';



--spool off
