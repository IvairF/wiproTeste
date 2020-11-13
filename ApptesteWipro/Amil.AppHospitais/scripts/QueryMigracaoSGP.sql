
drop user SGP cascade


-- SGP
create user SGP
  default tablespace TBSASM_DATA
  temporary tablespace TEMP
  profile DEFAULT
  identified by "SGP#2018"
  account lock;

grant create any table to SGP;
grant drop any table to SGP;
grant unlimited tablespace to SGP; 


create table SGP.CONFIGURACAO_SISTEMA_SGP
(
  id_configuracao        NUMBER(10) not null,
  nr_meses_geracao_grade NUMBER(10) not null,
  url_servico_integracao VARCHAR2(1000 CHAR) not null,
  url_servico_login      VARCHAR2(1000 CHAR) not null,
  url_servico_useramil   VARCHAR2(1000 CHAR) not null,
  url_servico_sms        VARCHAR2(1000 CHAR) not null,
  fl_robo_ativo          NUMBER(1) not null,
  fl_enviar_sms          NUMBER(1) not null,
  fl_enviar_email        NUMBER(1) not null,
  nm_data_base           VARCHAR2(1000 CHAR) not null,
  nr_raio_busca          NUMBER(10) not null,
  url_producao           VARCHAR2(1000 CHAR) not null,
  url_aprovacao_producao VARCHAR2(1000 CHAR) not null,
  tempo_bloqueio_senha   NUMBER(10) not null,
  qtde_tentativa_senha   NUMBER(10) not null,
  duracao_token          NUMBER(10) not null
)
;
alter table SGP.CONFIGURACAO_SISTEMA_SGP
  add primary key (ID_CONFIGURACAO);

--PROMPT
--PROMPT Creating table CURSO
--PROMPT ====================
--PROMPT
create table SGP.CURSO
(
  id_curso NUMBER(10) not null,
  de_curso VARCHAR2(500 CHAR) not null,
  fl_ativo NUMBER(1) not null
)
;
alter table SGP.CURSO
  add primary key (ID_CURSO);

--PROMPT
--PROMPT Creating table UNIDADE
--PROMPT ======================
--PROMPT
create table SGP.UNIDADE
(
  id_unidade        NUMBER(10) not null,
  id_unidade_sismed NUMBER(18) not null,
  nm_divulgacao     VARCHAR2(100 CHAR),
  fl_ativo          NUMBER(1) not null
)
;
create unique index SGP.IX_UNIDADE_ID_UNIDADE_SISMED on SGP.UNIDADE (ID_UNIDADE_SISMED);
alter table SGP.UNIDADE
  add primary key (ID_UNIDADE);

--PROMPT
--PROMPT Creating table PROFISSIONAL
--PROMPT ===========================
--PROMPT
create table SGP.PROFISSIONAL
(
  id_profissional        NUMBER(10) not null,
  nm_name                VARCHAR2(60 CHAR),
  nr_cpf                 VARCHAR2(11 CHAR),
  nm_sexo                VARCHAR2(10 CHAR),
  dt_nascimento          DATE,
  nr_cep                 NUMBER(10),
  nm_logradouro          VARCHAR2(200 CHAR),
  nr_endereco            VARCHAR2(20 CHAR),
  nm_bairro              VARCHAR2(50 CHAR),
  nm_cidade              VARCHAR2(50 CHAR),
  sg_uf                  VARCHAR2(2 CHAR),
  nr_cpnj                VARCHAR2(14 CHAR),
  fl_cnpj_proprio        NUMBER(1),
  nr_latitude            NUMBER,
  nr_longitude           NUMBER,
  id_profissional_pessoa NUMBER(10) not null,
  fl_ativo               NUMBER(1) not null,
  id_unidade             NUMBER(10)
)
;
create index SGP.IX_PROFISSIONAL_ID_UNIDADE on SGP.PROFISSIONAL (ID_UNIDADE);
alter table SGP.PROFISSIONAL
  add primary key (ID_PROFISSIONAL);
alter table SGP.PROFISSIONAL
  add constraint FK_1727858241 foreign key (ID_UNIDADE)
  references SGP.UNIDADE (ID_UNIDADE);

--PROMPT
--PROMPT Creating table PROFISSIONAL_SENHA
--PROMPT =================================
--PROMPT
create table SGP.PROFISSIONAL_SENHA
(
  id_prof_senha   NUMBER(10) not null,
  id_profissional NUMBER(10) not null,
  senha           VARCHAR2(200 CHAR) not null,
  dt_alteracao    DATE
)
;
create index SGP.IX_695913587 on SGP.PROFISSIONAL_SENHA (ID_PROFISSIONAL);
alter table SGP.PROFISSIONAL_SENHA
  add primary key (ID_PROF_SENHA);
alter table SGP.PROFISSIONAL_SENHA
  add constraint FK_N547337002 foreign key (ID_PROFISSIONAL)
  references SGP.PROFISSIONAL (ID_PROFISSIONAL) on delete cascade;

--PROMPT
--PROMPT Creating table EMAIL_TOKEN
--PROMPT ==========================
--PROMPT
create table SGP.EMAIL_TOKEN
(
  id_email_token           NUMBER(10) not null,
  id_profissional_password NUMBER(10) not null,
  token                    VARCHAR2(200 CHAR) not null,
  dt_criacao               DATE not null,
  used                     NUMBER(1) not null
)
;
create index SGP.IX_N1561144111 on SGP.EMAIL_TOKEN (ID_PROFISSIONAL_PASSWORD);
alter table SGP.EMAIL_TOKEN
  add primary key (ID_EMAIL_TOKEN);
alter table SGP.EMAIL_TOKEN
  add constraint FK_1912538468 foreign key (ID_PROFISSIONAL_PASSWORD)
  references SGP.PROFISSIONAL_SENHA (ID_PROF_SENHA) on delete cascade;

--PROMPT
--PROMPT Creating table ESPECIALIDADE
--PROMPT ============================
--PROMPT
create table SGP.ESPECIALIDADE
(
  id_especialidade        NUMBER(10) not null,
  id_especialidade_sismed VARCHAR2(3 CHAR) not null,
  fl_ativo                NUMBER(1) not null
)
;
create unique index SGP.IX_440246825 on SGP.ESPECIALIDADE (ID_ESPECIALIDADE_SISMED);
alter table SGP.ESPECIALIDADE
  add primary key (ID_ESPECIALIDADE);

--PROMPT
--PROMPT Creating table SUBSETOR
--PROMPT =======================
--PROMPT
create table SGP.SUBSETOR
(
  id_subsetor NUMBER(10) not null,
  de_subsetor VARCHAR2(100 CHAR) not null
)
;
alter table SGP.SUBSETOR
  add primary key (ID_SUBSETOR);

--PROMPT
--PROMPT Creating table SETOR
--PROMPT ====================
--PROMPT
create table SGP.SETOR
(
  id_setor NUMBER(10) not null,
  de_setor VARCHAR2(100 CHAR) not null,
  fl_ativo NUMBER(1) not null
)
;
alter table SGP.SETOR
  add primary key (ID_SETOR);

--PROMPT
--PROMPT Creating table SETOR_SUBSETOR
--PROMPT =============================
--PROMPT
create table SGP.SETOR_SUBSETOR
(
  id_setor_subsetor NUMBER(10) not null,
  id_setor          NUMBER(10) not null,
  id_subsetor       NUMBER(10) not null,
  fl_ativo          NUMBER(1) not null
)
;
create index SGP.IX_SETOR_SUBSETOR_ID_SETOR on SGP.SETOR_SUBSETOR (ID_SETOR);
create index SGP.IX_SETOR_SUBSETOR_ID_SUBSETOR on SGP.SETOR_SUBSETOR (ID_SUBSETOR);
alter table SGP.SETOR_SUBSETOR
  add primary key (ID_SETOR_SUBSETOR);
alter table SGP.SETOR_SUBSETOR
  add constraint FK_2043545404 foreign key (ID_SUBSETOR)
  references SGP.SUBSETOR (ID_SUBSETOR) on delete cascade;
alter table SGP.SETOR_SUBSETOR
  add constraint FK_N1577445903 foreign key (ID_SETOR)
  references SGP.SETOR (ID_SETOR) on delete cascade;

--PROMPT
--PROMPT Creating table GRUPO_QUALIDADE
--PROMPT ==============================
--PROMPT
create table SGP.GRUPO_QUALIDADE
(
  id_grupo_qualidade NUMBER(10) not null,
  id_setor_subsetor  NUMBER(10) not null,
  de_grupo_qualidade VARCHAR2(100) not null,
  nr_ordem           NUMBER(10) not null,
  fl_ativo           NUMBER(1) not null,
  tx_query           VARCHAR2(4000 CHAR)
)
;
create index SGP.IX_N50856862 on SGP.GRUPO_QUALIDADE (ID_SETOR_SUBSETOR);
alter table SGP.GRUPO_QUALIDADE
  add primary key (ID_GRUPO_QUALIDADE);
alter table SGP.GRUPO_QUALIDADE
  add constraint FK_N4337036 foreign key (ID_SETOR_SUBSETOR)
  references SGP.SETOR_SUBSETOR (ID_SETOR_SUBSETOR) on delete cascade;

--PROMPT
--PROMPT Creating table JUSTIFICATIVA
--PROMPT ============================
--PROMPT
create table SGP.JUSTIFICATIVA
(
  id_justificativa NUMBER(10) not null,
  de_justificativa VARCHAR2(500 CHAR) not null,
  fl_ativo         NUMBER(1) not null
)
;
alter table SGP.JUSTIFICATIVA
  add primary key (ID_JUSTIFICATIVA);

--PROMPT
--PROMPT Creating table TURNO
--PROMPT ====================
--PROMPT
create table SGP.TURNO
(
  id_turno   NUMBER(10) not null,
  nm_turno   VARCHAR2(100 CHAR) not null,
  fl_ativo   NUMBER(1) not null,
  id_unidade NUMBER(10) not null
)
;
create index SGP.IX_TURNO_ID_UNIDADE on SGP.TURNO (ID_UNIDADE);
alter table SGP.TURNO
  add primary key (ID_TURNO);
alter table SGP.TURNO
  add constraint FK_TURNO_UNIDADE_ID_UNIDADE foreign key (ID_UNIDADE)
  references SGP.UNIDADE (ID_UNIDADE) on delete cascade;

--PROMPT
--PROMPT Creating table UNIDADE_CONTATO
--PROMPT ==============================
--PROMPT
create table SGP.UNIDADE_CONTATO
(
  id_unidade_contato NUMBER(10) not null,
  nm_contato         VARCHAR2(200 CHAR) not null,
  id_unidade         NUMBER(10) not null
)
;
create index SGP.IX_UNIDADE_CONTATO_ID_UNIDADE on SGP.UNIDADE_CONTATO (ID_UNIDADE);
alter table SGP.UNIDADE_CONTATO
  add primary key (ID_UNIDADE_CONTATO);
alter table SGP.UNIDADE_CONTATO
  add constraint FK_N538318265 foreign key (ID_UNIDADE)
  references SGP.UNIDADE (ID_UNIDADE) on delete cascade;

--PROMPT
--PROMPT Creating table UNIDADE_ENDERECO_PLANTAO
--PROMPT =======================================
--PROMPT
create table SGP.UNIDADE_ENDERECO_PLANTAO
(
  id_unidade_endereco_plantao NUMBER(10) not null,
  nm_logradouro               VARCHAR2(200 CHAR) not null,
  nr_endereco                 VARCHAR2(10 CHAR) not null,
  de_complemento              VARCHAR2(100 CHAR),
  nm_bairro                   VARCHAR2(50 CHAR) not null,
  nm_cidade                   VARCHAR2(50 CHAR) not null,
  sg_uf                       VARCHAR2(2 CHAR) not null,
  nr_latitude                 NUMBER not null,
  nr_longitude                NUMBER not null,
  fl_ativo                    NUMBER(1) not null,
  id_unidade                  NUMBER(10) not null
)
;
create index SGP.IX_1389197066 on SGP.UNIDADE_ENDERECO_PLANTAO (ID_UNIDADE);
alter table SGP.UNIDADE_ENDERECO_PLANTAO
  add primary key (ID_UNIDADE_ENDERECO_PLANTAO);
alter table SGP.UNIDADE_ENDERECO_PLANTAO
  add constraint FK_N706774786 foreign key (ID_UNIDADE)
  references SGP.UNIDADE (ID_UNIDADE) on delete cascade;

--PROMPT
--PROMPT Creating table PLANTAO
--PROMPT ======================
--PROMPT
create table SGP.PLANTAO
(
  id_plantao                  NUMBER(10) not null,
  id_setor_subsetor           NUMBER(10) not null,
  id_turno                    NUMBER(10) not null,
  id_unidade_endereco_plantao NUMBER(10) not null,
  id_unidade_contato          NUMBER(10),
  fl_ativo                    NUMBER(1) not null,
  dt_inicio                   DATE not null,
  dt_fim                      DATE
)
;
create index SGP.IX_257801183 on SGP.PLANTAO (ID_UNIDADE_ENDERECO_PLANTAO);
create index SGP.IX_PLANTAO_ID_SETOR_SUBSETOR on SGP.PLANTAO (ID_SETOR_SUBSETOR);
create index SGP.IX_PLANTAO_ID_TURNO on SGP.PLANTAO (ID_TURNO);
create index SGP.IX_PLANTAO_ID_UNIDADE_CONTATO on SGP.PLANTAO (ID_UNIDADE_CONTATO);
alter table SGP.PLANTAO
  add primary key (ID_PLANTAO);
alter table SGP.PLANTAO
  add constraint FK_713598313 foreign key (ID_UNIDADE_CONTATO)
  references SGP.UNIDADE_CONTATO (ID_UNIDADE_CONTATO) on delete cascade;
alter table SGP.PLANTAO
  add constraint FK_N107015534 foreign key (ID_UNIDADE_ENDERECO_PLANTAO)
  references SGP.UNIDADE_ENDERECO_PLANTAO (ID_UNIDADE_ENDERECO_PLANTAO) on delete cascade;
alter table SGP.PLANTAO
  add constraint FK_N724636117 foreign key (ID_SETOR_SUBSETOR)
  references SGP.SETOR_SUBSETOR (ID_SETOR_SUBSETOR) on delete cascade;
alter table SGP.PLANTAO
  add constraint FK_PLANTAO_TURNO_ID_TURNO foreign key (ID_TURNO)
  references SGP.TURNO (ID_TURNO) on delete cascade;

--PROMPT
--PROMPT Creating table PLANTAO_OFERTA
--PROMPT =============================
--PROMPT
create table SGP.PLANTAO_OFERTA
(
  id_plantao_oferta NUMBER(10) not null,
  id_plantao        NUMBER(10) not null,
  vl_plantao        NUMBER(18,2) not null,
  dt_oferta         DATE not null,
  dt_enviar_oferta  DATE,
  dt_plantao        DATE not null,
  tx_observacao     VARCHAR2(500 CHAR)
)
;
create index SGP.IX_PLANTAO_OFERTA_ID_PLANTAO on SGP.PLANTAO_OFERTA (ID_PLANTAO);
alter table SGP.PLANTAO_OFERTA
  add primary key (ID_PLANTAO_OFERTA);
alter table SGP.PLANTAO_OFERTA
  add constraint FK_60360777 foreign key (ID_PLANTAO)
  references SGP.PLANTAO (ID_PLANTAO) on delete cascade;

--PROMPT
--PROMPT Creating table PLANTAO_OFERTA_PROFISSIONAL
--PROMPT ==========================================
--PROMPT
create table SGP.PLANTAO_OFERTA_PROFISSIONAL
(
  id_plantao_oferta_profissional NUMBER(10) not null,
  id_plantao_oferta              NUMBER(10) not null,
  id_oferta_grupo                NUMBER(10) not null,
  id_profissional                NUMBER(10) not null,
  dt_visualizou_oferta           DATE,
  fl_aceitou_oferta              NUMBER(1),
  dt_aprovado_plantao            DATE,
  fl_aprovado_plantao            NUMBER(1),
  fl_envio_comunidado            NUMBER(1) not null,
  fl_envio_confirmacao           NUMBER(1) not null,
  fl_envio_aprovacao             NUMBER(1) not null,
  tx_observacao                  VARCHAR2(500 CHAR),
  tx_observacao_profissional     VARCHAR2(500 CHAR)
)
;
create index SGP.IX_N2022538692 on SGP.PLANTAO_OFERTA_PROFISSIONAL (ID_PLANTAO_OFERTA);
create index SGP.IX_N2091809303 on SGP.PLANTAO_OFERTA_PROFISSIONAL (ID_PROFISSIONAL);
alter table SGP.PLANTAO_OFERTA_PROFISSIONAL
  add primary key (ID_PLANTAO_OFERTA_PROFISSIONAL);
alter table SGP.PLANTAO_OFERTA_PROFISSIONAL
  add constraint FK_325171164 foreign key (ID_PLANTAO_OFERTA)
  references SGP.PLANTAO_OFERTA (ID_PLANTAO_OFERTA) on delete cascade;
alter table SGP.PLANTAO_OFERTA_PROFISSIONAL
  add constraint FK_N1284888622 foreign key (ID_PROFISSIONAL)
  references SGP.PROFISSIONAL (ID_PROFISSIONAL) on delete cascade;

--PROMPT
--PROMPT Creating table OFERTA_COMUNICADO
--PROMPT ================================
--PROMPT
create table SGP.OFERTA_COMUNICADO
(
  id_oferta_comunicado           NUMBER(10) not null,
  tp_envio                       NUMBER(10) not null,
  dt_envio                       DATE not null,
  tx_observacao                  VARCHAR2(4000 CHAR),
  id_plantao_oferta_profissional NUMBER(10) not null
)
;
create index SGP.IX_N57497544 on SGP.OFERTA_COMUNICADO (ID_PLANTAO_OFERTA_PROFISSIONAL);
alter table SGP.OFERTA_COMUNICADO
  add primary key (ID_OFERTA_COMUNICADO);
alter table SGP.OFERTA_COMUNICADO
  add constraint FK_N836978247 foreign key (ID_PLANTAO_OFERTA_PROFISSIONAL)
  references SGP.PLANTAO_OFERTA_PROFISSIONAL (ID_PLANTAO_OFERTA_PROFISSIONAL) on delete cascade;

--PROMPT
--PROMPT Creating table PLANTAO_PROFISSIONAL
--PROMPT ===================================
--PROMPT
create table SGP.PLANTAO_PROFISSIONAL
(
  id_plantao_profissional        NUMBER(10) not null,
  id_plantao                     NUMBER(10) not null,
  id_profissional                NUMBER(10) not null,
  fl_fixo                        NUMBER(1) not null,
  fl_ativo                       NUMBER(1) not null,
  id_plantao_oferta_profissional NUMBER(10) not null
)
;
create index SGP.IX_648374853 on SGP.PLANTAO_PROFISSIONAL (ID_PROFISSIONAL);
create index SGP.IX_N886944775 on SGP.PLANTAO_PROFISSIONAL (ID_PLANTAO);
alter table SGP.PLANTAO_PROFISSIONAL
  add primary key (ID_PLANTAO_PROFISSIONAL);
alter table SGP.PLANTAO_PROFISSIONAL
  add constraint FK_N1816195562 foreign key (ID_PROFISSIONAL)
  references SGP.PROFISSIONAL (ID_PROFISSIONAL) on delete cascade;
alter table SGP.PLANTAO_PROFISSIONAL
  add constraint FK_N614016853 foreign key (ID_PLANTAO)
  references SGP.PLANTAO (ID_PLANTAO) on delete cascade;

--PROMPT
--PROMPT Creating table PLANTAO_BLOQUEIO
--PROMPT ===============================
--PROMPT
create table SGP.PLANTAO_BLOQUEIO
(
  id_plantao_bloqueio     NUMBER(10) not null,
  id_plantao              NUMBER(10),
  id_plantao_profissional NUMBER(10),
  id_unidade              NUMBER(10),
  id_profissional         NUMBER(10),
  dt_inicio               DATE not null,
  dt_fim                  DATE not null,
  tx_justificativa        NCLOB,
  id_justificativa        NUMBER(10)
)
;
create index SGP.IX_1120552198 on SGP.PLANTAO_BLOQUEIO (ID_PLANTAO_PROFISSIONAL);
create index SGP.IX_270906349 on SGP.PLANTAO_BLOQUEIO (ID_JUSTIFICATIVA);
create index SGP.IX_PLANTAO_BLOQUEIO_ID_PLANTAO on SGP.PLANTAO_BLOQUEIO (ID_PLANTAO);
alter table SGP.PLANTAO_BLOQUEIO
  add primary key (ID_PLANTAO_BLOQUEIO);
alter table SGP.PLANTAO_BLOQUEIO
  add constraint FK_110745432 foreign key (ID_JUSTIFICATIVA)
  references SGP.JUSTIFICATIVA (ID_JUSTIFICATIVA) on delete cascade;
alter table SGP.PLANTAO_BLOQUEIO
  add constraint FK_1566369961 foreign key (ID_PLANTAO)
  references SGP.PLANTAO (ID_PLANTAO) on delete cascade;
alter table SGP.PLANTAO_BLOQUEIO
  add constraint FK_N2147343593 foreign key (ID_PLANTAO_PROFISSIONAL)
  references SGP.PLANTAO_PROFISSIONAL (ID_PLANTAO_PROFISSIONAL) on delete cascade;

--PROMPT
--PROMPT Creating table PLANTAO_BLOQUEIO_DIA_SEMANA
--PROMPT ==========================================
--PROMPT
create table SGP.PLANTAO_BLOQUEIO_DIA_SEMANA
(
  id_plantao_bloqueio_dia_semana NUMBER(10) not null,
  dia_semana                     NUMBER(10) not null,
  id_plantao_bloqueio            NUMBER(10) not null
)
;
create index SGP.IX_N1295289542 on SGP.PLANTAO_BLOQUEIO_DIA_SEMANA (ID_PLANTAO_BLOQUEIO);
alter table SGP.PLANTAO_BLOQUEIO_DIA_SEMANA
  add primary key (ID_PLANTAO_BLOQUEIO_DIA_SEMANA);
alter table SGP.PLANTAO_BLOQUEIO_DIA_SEMANA
  add constraint FK_N1634492657 foreign key (ID_PLANTAO_BLOQUEIO)
  references SGP.PLANTAO_BLOQUEIO (ID_PLANTAO_BLOQUEIO) on delete cascade;

--PROMPT
--PROMPT Creating table PLANTAO_CONFIGURACAO
--PROMPT ===================================
--PROMPT
create table SGP.PLANTAO_CONFIGURACAO
(
  id_plantao_configuracao NUMBER(10) not null,
  id_plantao              NUMBER(10) not null,
  nr_posicoes             NUMBER(10) not null,
  dt_inicio               DATE not null,
  dt_fim                  DATE,
  fl_principal            NUMBER(1) not null
)
;
create index SGP.IX_1712427792 on SGP.PLANTAO_CONFIGURACAO (ID_PLANTAO);
alter table SGP.PLANTAO_CONFIGURACAO
  add primary key (ID_PLANTAO_CONFIGURACAO);
alter table SGP.PLANTAO_CONFIGURACAO
  add constraint FK_1656743976 foreign key (ID_PLANTAO)
  references SGP.PLANTAO (ID_PLANTAO) on delete cascade;

--PROMPT
--PROMPT Creating table PLANTAO_PROF_DIA_SEMANA
--PROMPT ======================================
--PROMPT
create table SGP.PLANTAO_PROF_DIA_SEMANA
(
  id_plantao_prof_dia_semana NUMBER(10) not null,
  dia_semana                 NUMBER(10) not null,
  dt_inicio                  DATE not null,
  dt_fim                     DATE,
  id_plantao_profissional    NUMBER(10) not null
)
;
create index SGP.IX_51578403 on SGP.PLANTAO_PROF_DIA_SEMANA (ID_PLANTAO_PROFISSIONAL);
alter table SGP.PLANTAO_PROF_DIA_SEMANA
  add primary key (ID_PLANTAO_PROF_DIA_SEMANA);
alter table SGP.PLANTAO_PROF_DIA_SEMANA
  add constraint FK_N1082955737 foreign key (ID_PLANTAO_PROFISSIONAL)
  references SGP.PLANTAO_PROFISSIONAL (ID_PLANTAO_PROFISSIONAL) on delete cascade;

--PROMPT
--PROMPT Creating table PROFISSIONAL_COMENTARIO
--PROMPT ======================================
--PROMPT
create table SGP.PROFISSIONAL_COMENTARIO
(
  id_profissional_comentario NUMBER(10) not null,
  id_profissional            NUMBER(10) not null,
  username                   VARCHAR2(100 CHAR) not null,
  tx_comentario              VARCHAR2(4000 CHAR) not null,
  dt_cadastro                DATE not null
)
;
create index SGP.IX_1343232969 on SGP.PROFISSIONAL_COMENTARIO (ID_PROFISSIONAL);
alter table SGP.PROFISSIONAL_COMENTARIO
  add primary key (ID_PROFISSIONAL_COMENTARIO);
alter table SGP.PROFISSIONAL_COMENTARIO
  add constraint FK_817596495 foreign key (ID_PROFISSIONAL)
  references SGP.PROFISSIONAL (ID_PROFISSIONAL) on delete cascade;

--PROMPT
--PROMPT Creating table PROFISSIONAL_CONSELHO
--PROMPT ====================================
--PROMPT
create table SGP.PROFISSIONAL_CONSELHO
(
  id_profissional_conselho NUMBER(10) not null,
  id_profissional          NUMBER(10) not null,
  num_conselho             VARCHAR2(6) not null,
  uf                       VARCHAR2(2) not null,
  descricao                VARCHAR2(60) not null,
  fl_ativo                 NUMBER(1) not null
)
;
create index SGP.IX_N138154551 on SGP.PROFISSIONAL_CONSELHO (ID_PROFISSIONAL);
alter table SGP.PROFISSIONAL_CONSELHO
  add primary key (ID_PROFISSIONAL_CONSELHO);
alter table SGP.PROFISSIONAL_CONSELHO
  add constraint FK_1818303496 foreign key (ID_PROFISSIONAL)
  references SGP.PROFISSIONAL (ID_PROFISSIONAL) on delete cascade;

--PROMPT
--PROMPT Creating table PROFISSIONAL_CONTATO
--PROMPT ===================================
--PROMPT
create table SGP.PROFISSIONAL_CONTATO
(
  id_profissional_contato NUMBER(10) not null,
  id_profissional         NUMBER(10) not null,
  nr_ddd                  NUMBER(10) not null,
  nr_telefone             VARCHAR2(20 CHAR) not null,
  id_tipo                 NUMBER(10) not null,
  fl_receber_sms          NUMBER(1) not null
)
;
create index SGP.IX_700080580 on SGP.PROFISSIONAL_CONTATO (ID_PROFISSIONAL);
alter table SGP.PROFISSIONAL_CONTATO
  add primary key (ID_PROFISSIONAL_CONTATO);
alter table SGP.PROFISSIONAL_CONTATO
  add constraint FK_N1304535182 foreign key (ID_PROFISSIONAL)
  references SGP.PROFISSIONAL (ID_PROFISSIONAL) on delete cascade;

--PROMPT
--PROMPT Creating table PROFISSIONAL_CURSO
--PROMPT =================================
--PROMPT
create table SGP.PROFISSIONAL_CURSO
(
  id_profissional_curso NUMBER(10) not null,
  id_profissional       NUMBER(10) not null,
  dt_validade           DATE not null,
  id_curso              NUMBER(10) not null
)
;
create index SGP.IX_232361056 on SGP.PROFISSIONAL_CURSO (ID_PROFISSIONAL);
create index SGP.IX_PROFISSIONAL_CURSO_ID_CURSO on SGP.PROFISSIONAL_CURSO (ID_CURSO);
alter table SGP.PROFISSIONAL_CURSO
  add primary key (ID_PROFISSIONAL_CURSO);
alter table SGP.PROFISSIONAL_CURSO
  add constraint FK_1024907781 foreign key (ID_PROFISSIONAL)
  references SGP.PROFISSIONAL (ID_PROFISSIONAL) on delete cascade;
alter table SGP.PROFISSIONAL_CURSO
  add constraint FK_N1563989820 foreign key (ID_CURSO)
  references SGP.CURSO (ID_CURSO) on delete cascade;

--PROMPT
--PROMPT Creating table PROFISSIONAL_EMAIL
--PROMPT =================================
--PROMPT
create table SGP.PROFISSIONAL_EMAIL
(
  id_profissional_email NUMBER(10) not null,
  id_profissional       NUMBER(10) not null,
  de_email              VARCHAR2(100 CHAR) not null
)
;
create index SGP.IX_786948570 on SGP.PROFISSIONAL_EMAIL (ID_PROFISSIONAL);
alter table SGP.PROFISSIONAL_EMAIL
  add primary key (ID_PROFISSIONAL_EMAIL);
alter table SGP.PROFISSIONAL_EMAIL
  add constraint FK_N839713734 foreign key (ID_PROFISSIONAL)
  references SGP.PROFISSIONAL (ID_PROFISSIONAL) on delete cascade;

--PROMPT
--PROMPT Creating table PROFISSIONAL_ESPECIALIDADE
--PROMPT =========================================
--PROMPT
create table SGP.PROFISSIONAL_ESPECIALIDADE
(
  id_profissional_especialidade NUMBER(10) not null,
  id_profissional               NUMBER(10) not null,
  id_especialidade              NUMBER(10) not null,
  fl_possui_residencia          NUMBER(1) not null,
  fl_titulo                     NUMBER(1) not null
)
;
create index SGP.IX_2135203919 on SGP.PROFISSIONAL_ESPECIALIDADE (ID_PROFISSIONAL);
alter table SGP.PROFISSIONAL_ESPECIALIDADE
  add primary key (ID_PROFISSIONAL_ESPECIALIDADE);
alter table SGP.PROFISSIONAL_ESPECIALIDADE
  add constraint FK_N967977062 foreign key (ID_PROFISSIONAL)
  references SGP.PROFISSIONAL (ID_PROFISSIONAL) on delete cascade;

--PROMPT
--PROMPT Creating table PROFISSIONAL_EXCECOES
--PROMPT ====================================
--PROMPT
create table SGP.PROFISSIONAL_EXCECOES
(
  id_profissional_excecao NUMBER(10) not null,
  id_profissional         NUMBER(10) not null,
  id_unidade              NUMBER(10),
  id_setor                NUMBER(10),
  id_subsetor             NUMBER(10),
  tx_observacao           VARCHAR2(4000 CHAR) not null
)
;
create index SGP.IX_399467226 on SGP.PROFISSIONAL_EXCECOES (ID_UNIDADE);
create index SGP.IX_715124799 on SGP.PROFISSIONAL_EXCECOES (ID_SUBSETOR);
create index SGP.IX_N1188359041 on SGP.PROFISSIONAL_EXCECOES (ID_PROFISSIONAL);
create index SGP.IX_N1423279452 on SGP.PROFISSIONAL_EXCECOES (ID_SETOR);
alter table SGP.PROFISSIONAL_EXCECOES
  add primary key (ID_PROFISSIONAL_EXCECAO);
alter table SGP.PROFISSIONAL_EXCECOES
  add constraint FK_1394698772 foreign key (ID_SETOR)
  references SGP.SETOR (ID_SETOR);
alter table SGP.PROFISSIONAL_EXCECOES
  add constraint FK_2124154173 foreign key (ID_UNIDADE)
  references SGP.UNIDADE (ID_UNIDADE);
alter table SGP.PROFISSIONAL_EXCECOES
  add constraint FK_889157126 foreign key (ID_SUBSETOR)
  references SGP.SUBSETOR (ID_SUBSETOR);
alter table SGP.PROFISSIONAL_EXCECOES
  add constraint FK_N2143828812 foreign key (ID_PROFISSIONAL)
  references SGP.PROFISSIONAL (ID_PROFISSIONAL) on delete cascade;

--PROMPT
--PROMPT Creating table PROFISSIONAL_GRUPO_QUALIDADE
--PROMPT ===========================================
--PROMPT
create table SGP.PROFISSIONAL_GRUPO_QUALIDADE
(
  id_prof_grupo_qualidade NUMBER(10) not null,
  id_grupo_qualidade      NUMBER(10) not null,
  id_profissional         NUMBER(10) not null,
  dt_processamento        DATE not null
)
;
create index SGP.IX_132052024 on SGP.PROFISSIONAL_GRUPO_QUALIDADE (ID_PROFISSIONAL);
create index SGP.IX_625523653 on SGP.PROFISSIONAL_GRUPO_QUALIDADE (ID_GRUPO_QUALIDADE);
alter table SGP.PROFISSIONAL_GRUPO_QUALIDADE
  add primary key (ID_PROF_GRUPO_QUALIDADE);
alter table SGP.PROFISSIONAL_GRUPO_QUALIDADE
  add constraint FK_1493254650 foreign key (ID_GRUPO_QUALIDADE)
  references SGP.GRUPO_QUALIDADE (ID_GRUPO_QUALIDADE) on delete cascade;
alter table SGP.PROFISSIONAL_GRUPO_QUALIDADE
  add constraint FK_459211901 foreign key (ID_PROFISSIONAL)
  references SGP.PROFISSIONAL (ID_PROFISSIONAL) on delete cascade;

--PROMPT
--PROMPT Creating table PROF_GRUPO_QUALIDADE_HIST
--PROMPT ========================================
--PROMPT
create table SGP.PROF_GRUPO_QUALIDADE_HIST
(
  id_prof_grupo_qualidade_hist NUMBER(10) not null,
  id_profissional              NUMBER(10) not null,
  id_grupo_qualidade           NUMBER(10) not null,
  dt_processamento             DATE not null,
  nm_user                      VARCHAR2(60 CHAR) not null
)
;
alter table SGP.PROF_GRUPO_QUALIDADE_HIST
  add primary key (ID_PROF_GRUPO_QUALIDADE_HIST);

--PROMPT
--PROMPT Creating table TURNO_CONFIGURACAO
--PROMPT =================================
--PROMPT
create table SGP.TURNO_CONFIGURACAO
(
  id_turno_configuracao NUMBER(10) not null,
  dt_inicio_vigencia    DATE not null,
  dt_fim_vigencia       DATE,
  hr_inicio             DATE not null,
  hr_duracao_turno      DATE not null,
  fl_segunda            NUMBER(1) not null,
  fl_terca              NUMBER(1) not null,
  fl_quarta             NUMBER(1) not null,
  fl_quinta             NUMBER(1) not null,
  fl_sexta              NUMBER(1) not null,
  fl_sabado             NUMBER(1) not null,
  fl_domingo            NUMBER(1) not null,
  id_turno              NUMBER(10) not null
)
;
create index SGP.IX_TURNO_CONFIGURACAO_ID_TURNO on SGP.TURNO_CONFIGURACAO (ID_TURNO);
alter table SGP.TURNO_CONFIGURACAO
  add primary key (ID_TURNO_CONFIGURACAO);
alter table SGP.TURNO_CONFIGURACAO
  add constraint FK_N1123681761 foreign key (ID_TURNO)
  references SGP.TURNO (ID_TURNO) on delete cascade;

--PROMPT
--PROMPT Creating table UNIDADE_CONTATO_TELEFONE
--PROMPT =======================================
--PROMPT
create table SGP.UNIDADE_CONTATO_TELEFONE
(
  id_unidade_contato_telefone NUMBER(10) not null,
  id_unidade_contato          NUMBER(10) not null,
  nr_ddd                      NUMBER(10) not null,
  nr_telefone                 VARCHAR2(20 CHAR) not null,
  id_tipo                     NUMBER(10) not null,
  de_observacao               VARCHAR2(200)
)
;
create index SGP.IX_N1073831958 on SGP.UNIDADE_CONTATO_TELEFONE (ID_UNIDADE_CONTATO);
alter table SGP.UNIDADE_CONTATO_TELEFONE
  add primary key (ID_UNIDADE_CONTATO_TELEFONE);
alter table SGP.UNIDADE_CONTATO_TELEFONE
  add constraint FK_N457403982 foreign key (ID_UNIDADE_CONTATO)
  references SGP.UNIDADE_CONTATO (ID_UNIDADE_CONTATO) on delete cascade;

--PROMPT
--PROMPT Creating table USUARIO_UNIDADE
--PROMPT ==============================
--PROMPT
create table SGP.USUARIO_UNIDADE
(
  id_usuario_unidade NUMBER(10) not null,
  id_usuario         NUMBER(10) not null,
  id_unidade         NUMBER(10) not null
)
;
create index SGP.IX_USUARIO_UNIDADE_ID_UNIDADE on SGP.USUARIO_UNIDADE (ID_UNIDADE);
alter table SGP.USUARIO_UNIDADE
  add primary key (ID_USUARIO_UNIDADE);
alter table SGP.USUARIO_UNIDADE
  add constraint FK_1707607399 foreign key (ID_UNIDADE)
  references SGP.UNIDADE (ID_UNIDADE) on delete cascade;

--PROMPT
--PROMPT Creating sequence CONFIGURACAO_SISTEMA_SGP_SEQ
--PROMPT ==============================================
--PROMPT
create sequence SGP.CONFIGURACAO_SISTEMA_SGP_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 21
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence CURSO_SEQ
--PROMPT ===========================
--PROMPT
create sequence SGP.CURSO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 61
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence EMAIL_TOKEN_SEQ
--PROMPT =================================
--PROMPT
create sequence SGP.EMAIL_TOKEN_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence ESPECIALIDADE_SEQ
--PROMPT ===================================
--PROMPT
create sequence SGP.ESPECIALIDADE_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 41
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence GRUPO_QUALIDADE_SEQ
--PROMPT =====================================
--PROMPT
create sequence SGP.GRUPO_QUALIDADE_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 61
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence JUSTIFICATIVA_SEQ
--PROMPT ===================================
--PROMPT
create sequence SGP.JUSTIFICATIVA_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence OFERTA_COMUNICADO_SEQ
--PROMPT =======================================
--PROMPT
create sequence SGP.OFERTA_COMUNICADO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 81
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PLANTAO_BLOQUEIO_SEQ
--PROMPT ======================================
--PROMPT
create sequence SGP.PLANTAO_BLOQUEIO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PLANTAO_CONFIGURACAO_SEQ
--PROMPT ==========================================
--PROMPT
create sequence SGP.PLANTAO_CONFIGURACAO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 343
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PLANTAO_OFERTA_SEQ
--PROMPT ====================================
--PROMPT
create sequence SGP.PLANTAO_OFERTA_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 81
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PLANTAO_PROFISSIONAL_SEQ
--PROMPT ==========================================
--PROMPT
create sequence SGP.PLANTAO_PROFISSIONAL_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 747
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PLANTAO_PROF_DIA_SEMANA_SEQ
--PROMPT =============================================
--PROMPT
create sequence SGP.PLANTAO_PROF_DIA_SEMANA_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1571
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PLANTAO_SEQ
--PROMPT =============================
--PROMPT
create sequence SGP.PLANTAO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 221
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PROFISSIONAL_COMENTARIO_SEQ
--PROMPT =============================================
--PROMPT
create sequence SGP.PROFISSIONAL_COMENTARIO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PROFISSIONAL_CONSELHO_SEQ
--PROMPT ===========================================
--PROMPT
create sequence SGP.PROFISSIONAL_CONSELHO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1121
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PROFISSIONAL_CONTATO_SEQ
--PROMPT ==========================================
--PROMPT
create sequence SGP.PROFISSIONAL_CONTATO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 961
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PROFISSIONAL_CURSO_SEQ
--PROMPT ========================================
--PROMPT
create sequence SGP.PROFISSIONAL_CURSO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1241
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PROFISSIONAL_EMAIL_SEQ
--PROMPT ========================================
--PROMPT
create sequence SGP.PROFISSIONAL_EMAIL_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1201
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PROFISSIONAL_ESPECIALIDADE_SEQ
--PROMPT ================================================
--PROMPT
create sequence SGP.PROFISSIONAL_ESPECIALIDADE_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1001
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PROFISSIONAL_EXCECOES_SEQ
--PROMPT ===========================================
--PROMPT
create sequence SGP.PROFISSIONAL_EXCECOES_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PROFISSIONAL_SENHA_SEQ
--PROMPT ========================================
--PROMPT
create sequence SGP.PROFISSIONAL_SENHA_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 21
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PROFISSIONAL_SEQ
--PROMPT ==================================
--PROMPT
create sequence SGP.PROFISSIONAL_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1061
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence PROF_GRUPO_QUALIDADE_HIST_SEQ
--PROMPT ===============================================
--PROMPT
create sequence SGP.PROF_GRUPO_QUALIDADE_HIST_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1121
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence SEQ_PLA_BLO_DIA_SEM
--PROMPT =====================================
--PROMPT
create sequence SGP.SEQ_PLA_BLO_DIA_SEM
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence SEQ_PLA_OFE_PRO
--PROMPT =================================
--PROMPT
create sequence SGP.SEQ_PLA_OFE_PRO
minvalue 1
maxvalue 999999999999999999999999999
start with 81
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence SEQ_PRO_GRU_QUA
--PROMPT =================================
--PROMPT
create sequence SGP.SEQ_PRO_GRU_QUA
minvalue 1
maxvalue 999999999999999999999999999
start with 161416
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence SETOR_SEQ
--PROMPT ===========================
--PROMPT
create sequence SGP.SETOR_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 41
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence SETOR_SUBSETOR_SEQ
--PROMPT ====================================
--PROMPT
create sequence SGP.SETOR_SUBSETOR_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 21
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence SUBSETOR_SEQ
--PROMPT ==============================
--PROMPT
create sequence SGP.SUBSETOR_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 21
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence TURNO_CONFIGURACAO_SEQ
--PROMPT ========================================
--PROMPT
create sequence SGP.TURNO_CONFIGURACAO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 161
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence TURNO_SEQ
--PROMPT ===========================
--PROMPT
create sequence SGP.TURNO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 121
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence UNIDADE_CONTATO_SEQ
--PROMPT =====================================
--PROMPT
create sequence SGP.UNIDADE_CONTATO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 41
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence UNIDADE_CONTATO_TELEFONE_SEQ
--PROMPT ==============================================
--PROMPT
create sequence SGP.UNIDADE_CONTATO_TELEFONE_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 41
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence UNIDADE_ENDERECO_PLANTAO_SEQ
--PROMPT ==============================================
--PROMPT
create sequence SGP.UNIDADE_ENDERECO_PLANTAO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 61
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence UNIDADE_SEQ
--PROMPT =============================
--PROMPT
create sequence SGP.UNIDADE_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 121
increment by 1
cache 20;

--PROMPT
--PROMPT Creating sequence USUARIO_UNIDADE_SEQ
--PROMPT =====================================
--PROMPT
create sequence SGP.USUARIO_UNIDADE_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 161
increment by 1
cache 20;

--PROMPT
--PROMPT Creating trigger CURSO_INS_TRG
--PROMPT ==============================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.CURSO_INS_TRG
  BEFORE INSERT ON SGP.CURSO
  FOR EACH ROW
BEGIN
  SELECT SGP.CURSO_SEQ.NEXTVAL INTO :NEW.ID_CURSO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger EMAIL_TOKEN_INS_TRG
--PROMPT ====================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.EMAIL_TOKEN_INS_TRG
  BEFORE INSERT ON SGP.EMAIL_TOKEN
  FOR EACH ROW
BEGIN
  SELECT SGP.EMAIL_TOKEN_SEQ.NEXTVAL INTO :NEW.ID_EMAIL_TOKEN FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger ESPECIALIDADE_INS_TRG
--PROMPT ======================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.ESPECIALIDADE_INS_TRG
  BEFORE INSERT ON SGP.ESPECIALIDADE
  FOR EACH ROW
BEGIN
  SELECT SGP.ESPECIALIDADE_SEQ.NEXTVAL INTO :NEW.ID_ESPECIALIDADE FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger GRUPO_QUALIDADE_INS_TRG
--PROMPT ========================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.GRUPO_QUALIDADE_INS_TRG
  BEFORE INSERT ON SGP.GRUPO_QUALIDADE
  FOR EACH ROW
BEGIN
  SELECT SGP.GRUPO_QUALIDADE_SEQ.NEXTVAL INTO :NEW.ID_GRUPO_QUALIDADE FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger JUSTIFICATIVA_INS_TRG
--PROMPT ======================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.JUSTIFICATIVA_INS_TRG
  BEFORE INSERT ON SGP.JUSTIFICATIVA
  FOR EACH ROW
BEGIN
  SELECT SGP.JUSTIFICATIVA_SEQ.NEXTVAL INTO :NEW.ID_JUSTIFICATIVA FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger OFERTA_COMUNICADO_INS_TRG
--PROMPT ==========================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.OFERTA_COMUNICADO_INS_TRG
  BEFORE INSERT ON SGP.OFERTA_COMUNICADO
  FOR EACH ROW
BEGIN
  SELECT SGP.OFERTA_COMUNICADO_SEQ.NEXTVAL INTO :NEW.ID_OFERTA_COMUNICADO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger PLANTAO_BLOQUEIO_INS_TRG
--PROMPT =========================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.PLANTAO_BLOQUEIO_INS_TRG
  BEFORE INSERT ON SGP.PLANTAO_BLOQUEIO
  FOR EACH ROW
BEGIN
  SELECT SGP.PLANTAO_BLOQUEIO_SEQ.NEXTVAL INTO :NEW.ID_PLANTAO_BLOQUEIO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger PLANTAO_CONFIGURACAO_INS_TRG
--PROMPT =============================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.PLANTAO_CONFIGURACAO_INS_TRG
  BEFORE INSERT ON SGP.PLANTAO_CONFIGURACAO
  FOR EACH ROW
BEGIN
  SELECT SGP.PLANTAO_CONFIGURACAO_SEQ.NEXTVAL INTO :NEW.ID_PLANTAO_CONFIGURACAO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger PLANTAO_INS_TRG
--PROMPT ================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.PLANTAO_INS_TRG
  BEFORE INSERT ON SGP.PLANTAO
  FOR EACH ROW
BEGIN
  SELECT SGP.PLANTAO_SEQ.NEXTVAL INTO :NEW.ID_PLANTAO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger PLANTAO_OFERTA_INS_TRG
--PROMPT =======================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.PLANTAO_OFERTA_INS_TRG
  BEFORE INSERT ON SGP.PLANTAO_OFERTA
  FOR EACH ROW
BEGIN
  SELECT SGP.PLANTAO_OFERTA_SEQ.NEXTVAL INTO :NEW.ID_PLANTAO_OFERTA FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger PLANTAO_PROFISSIONAL_INS_TRG
--PROMPT =============================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.PLANTAO_PROFISSIONAL_INS_TRG
  BEFORE INSERT ON SGP.PLANTAO_PROFISSIONAL
  FOR EACH ROW
BEGIN
  SELECT SGP.PLANTAO_PROFISSIONAL_SEQ.NEXTVAL INTO :NEW.ID_PLANTAO_PROFISSIONAL FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger PROFISSIONAL_CONSELHO_INS_TRG
--PROMPT ==============================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.PROFISSIONAL_CONSELHO_INS_TRG
  BEFORE INSERT ON SGP.PROFISSIONAL_CONSELHO
  FOR EACH ROW
BEGIN
  SELECT SGP.PROFISSIONAL_CONSELHO_SEQ.NEXTVAL INTO :NEW.ID_PROFISSIONAL_CONSELHO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger PROFISSIONAL_CONTATO_INS_TRG
--PROMPT =============================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.PROFISSIONAL_CONTATO_INS_TRG
  BEFORE INSERT ON SGP.PROFISSIONAL_CONTATO
  FOR EACH ROW
BEGIN
  SELECT SGP.PROFISSIONAL_CONTATO_SEQ.NEXTVAL INTO :NEW.ID_PROFISSIONAL_CONTATO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger PROFISSIONAL_CURSO_INS_TRG
--PROMPT ===========================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.PROFISSIONAL_CURSO_INS_TRG
  BEFORE INSERT ON SGP.PROFISSIONAL_CURSO
  FOR EACH ROW
BEGIN
  SELECT SGP.PROFISSIONAL_CURSO_SEQ.NEXTVAL INTO :NEW.ID_PROFISSIONAL_CURSO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger PROFISSIONAL_EMAIL_INS_TRG
--PROMPT ===========================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.PROFISSIONAL_EMAIL_INS_TRG
  BEFORE INSERT ON SGP.PROFISSIONAL_EMAIL
  FOR EACH ROW
BEGIN
  SELECT SGP.PROFISSIONAL_EMAIL_SEQ.NEXTVAL INTO :NEW.ID_PROFISSIONAL_EMAIL FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger PROFISSIONAL_EXCECOES_INS_TRG
--PROMPT ==============================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.PROFISSIONAL_EXCECOES_INS_TRG
  BEFORE INSERT ON SGP.PROFISSIONAL_EXCECOES
  FOR EACH ROW
BEGIN
  SELECT SGP.PROFISSIONAL_EXCECOES_SEQ.NEXTVAL INTO :NEW.ID_PROFISSIONAL_EXCECAO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger PROFISSIONAL_INS_TRG
--PROMPT =====================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.PROFISSIONAL_INS_TRG
  BEFORE INSERT ON SGP.PROFISSIONAL
  FOR EACH ROW
BEGIN
  SELECT SGP.PROFISSIONAL_SEQ.NEXTVAL INTO :NEW.ID_PROFISSIONAL FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger PROFISSIONAL_SENHA_INS_TRG
--PROMPT ===========================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.PROFISSIONAL_SENHA_INS_TRG
  BEFORE INSERT ON SGP.PROFISSIONAL_SENHA
  FOR EACH ROW
BEGIN
  SELECT SGP.PROFISSIONAL_SENHA_SEQ.NEXTVAL INTO :NEW.ID_PROF_SENHA FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger SETOR_INS_TRG
--PROMPT ==============================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.SETOR_INS_TRG
  BEFORE INSERT ON SGP.SETOR
  FOR EACH ROW
BEGIN
  SELECT SGP.SETOR_SEQ.NEXTVAL INTO :NEW.ID_SETOR FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger SETOR_SUBSETOR_INS_TRG
--PROMPT =======================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.SETOR_SUBSETOR_INS_TRG
  BEFORE INSERT ON SGP.SETOR_SUBSETOR
  FOR EACH ROW
BEGIN
  SELECT SGP.SETOR_SUBSETOR_SEQ.NEXTVAL INTO :NEW.ID_SETOR_SUBSETOR FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger SUBSETOR_INS_TRG
--PROMPT =================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.SUBSETOR_INS_TRG
  BEFORE INSERT ON SGP.SUBSETOR
  FOR EACH ROW
BEGIN
  SELECT SGP.SUBSETOR_SEQ.NEXTVAL INTO :NEW.ID_SUBSETOR FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger TRG_1206773342
--PROMPT ===============================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.TRG_1206773342
  BEFORE INSERT ON SGP.PROF_GRUPO_QUALIDADE_HIST
  FOR EACH ROW
BEGIN
  SELECT SGP.PROF_GRUPO_QUALIDADE_HIST_SEQ.NEXTVAL INTO :NEW.ID_PROF_GRUPO_QUALIDADE_HIST FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger TRG_137218437
--PROMPT ==============================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.TRG_137218437
  BEFORE INSERT ON SGP.UNIDADE_CONTATO_TELEFONE
  FOR EACH ROW
BEGIN
  SELECT SGP.UNIDADE_CONTATO_TELEFONE_SEQ.NEXTVAL INTO :NEW.ID_UNIDADE_CONTATO_TELEFONE FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger TRG_853537117
--PROMPT ==============================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.TRG_853537117
  BEFORE INSERT ON SGP.PLANTAO_OFERTA_PROFISSIONAL
  FOR EACH ROW
BEGIN
  SELECT SGP.SEQ_PLA_OFE_PRO.NEXTVAL INTO :NEW.ID_PLANTAO_OFERTA_PROFISSIONAL FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger TRG_N1284405709
--PROMPT ================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.TRG_N1284405709
  BEFORE INSERT ON SGP.UNIDADE_ENDERECO_PLANTAO
  FOR EACH ROW
BEGIN
  SELECT SGP.UNIDADE_ENDERECO_PLANTAO_SEQ.NEXTVAL INTO :NEW.ID_UNIDADE_ENDERECO_PLANTAO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger TRG_N2044673476
--PROMPT ================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.TRG_N2044673476
  BEFORE INSERT ON SGP.CONFIGURACAO_SISTEMA_SGP
  FOR EACH ROW
BEGIN
  SELECT SGP.CONFIGURACAO_SISTEMA_SGP_SEQ.NEXTVAL INTO :NEW.ID_CONFIGURACAO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger TRG_PLA_BLO_DIA_SEM
--PROMPT ====================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.TRG_PLA_BLO_DIA_SEM
  BEFORE INSERT ON SGP.PLANTAO_BLOQUEIO_DIA_SEMANA
  FOR EACH ROW
BEGIN
  SELECT SGP.SEQ_PLA_BLO_DIA_SEM.NEXTVAL INTO :NEW.ID_PLANTAO_BLOQUEIO_DIA_SEMANA FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger TRG_PROF_DIA_SEM_SEQ
--PROMPT =====================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.TRG_PROF_DIA_SEM_SEQ
  BEFORE INSERT ON SGP.PLANTAO_PROF_DIA_SEMANA
  FOR EACH ROW
BEGIN
  SELECT SGP.PLANTAO_PROF_DIA_SEMANA_SEQ.NEXTVAL INTO :NEW.ID_PLANTAO_PROF_DIA_SEMANA FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger TRG_PRO_COM
--PROMPT ============================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.TRG_PRO_COM
  BEFORE INSERT ON SGP.PROFISSIONAL_COMENTARIO
  FOR EACH ROW
BEGIN
  SELECT SGP.PROFISSIONAL_COMENTARIO_SEQ.NEXTVAL INTO :NEW.ID_PROFISSIONAL_COMENTARIO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger TRG_PRO_ESP
--PROMPT ============================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.TRG_PRO_ESP
  BEFORE INSERT ON SGP.PROFISSIONAL_ESPECIALIDADE
  FOR EACH ROW
BEGIN
  SELECT SGP.PROFISSIONAL_ESPECIALIDADE_SEQ.NEXTVAL INTO :NEW.ID_PROFISSIONAL_ESPECIALIDADE FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger TRG_PRO_GRU_QUA
--PROMPT ================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.TRG_PRO_GRU_QUA
  BEFORE INSERT ON SGP.PROFISSIONAL_GRUPO_QUALIDADE
  FOR EACH ROW
BEGIN
  SELECT SGP.SEQ_PRO_GRU_QUA.NEXTVAL INTO :NEW.ID_PROF_GRUPO_QUALIDADE FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger TURNO_CONFIGURACAO_INS_TRG
--PROMPT ===========================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.TURNO_CONFIGURACAO_INS_TRG
  BEFORE INSERT ON SGP.TURNO_CONFIGURACAO
  FOR EACH ROW
BEGIN
  SELECT SGP.TURNO_CONFIGURACAO_SEQ.NEXTVAL INTO :NEW.ID_TURNO_CONFIGURACAO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger TURNO_INS_TRG
--PROMPT ==============================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.TURNO_INS_TRG
  BEFORE INSERT ON SGP.TURNO
  FOR EACH ROW
BEGIN
  SELECT SGP.TURNO_SEQ.NEXTVAL INTO :NEW.ID_TURNO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger UNIDADE_CONTATO_INS_TRG
--PROMPT ========================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.UNIDADE_CONTATO_INS_TRG
  BEFORE INSERT ON SGP.UNIDADE_CONTATO
  FOR EACH ROW
BEGIN
  SELECT SGP.UNIDADE_CONTATO_SEQ.NEXTVAL INTO :NEW.ID_UNIDADE_CONTATO FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger UNIDADE_INS_TRG
--PROMPT ================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.UNIDADE_INS_TRG
  BEFORE INSERT ON SGP.UNIDADE
  FOR EACH ROW
BEGIN
  SELECT SGP.UNIDADE_SEQ.NEXTVAL INTO :NEW.ID_UNIDADE FROM DUAL;
END;
/

--PROMPT
--PROMPT Creating trigger USUARIO_UNIDADE_INS_TRG
--PROMPT ========================================
--PROMPT
CREATE OR REPLACE TRIGGER SGP.USUARIO_UNIDADE_INS_TRG
  BEFORE INSERT ON SGP.USUARIO_UNIDADE
  FOR EACH ROW
BEGIN
  SELECT SGP.USUARIO_UNIDADE_SEQ.NEXTVAL INTO :NEW.ID_USUARIO_UNIDADE FROM DUAL;
END;
/


--spool off
