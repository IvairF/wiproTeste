-- SOAP PATTERN
--drop user HISTORICOS cascade


-- SGP
create user HISTORICOS
  default tablespace TBSASM_DATA
  temporary tablespace TEMP
  profile DEFAULT
  identified by "HISTORICOS#2018"
  account lock;

grant create any table to HISTORICOS;
grant drop any table to HISTORICOS;
grant unlimited tablespace to HISTORICOS; 



DECLARE
	status NUMBER(10,0);
BEGIN
	SELECT count(*)
	  INTO status
	  FROM dba_tablespaces
	 WHERE tablespace_name = 'HISTORICOS';
	IF status = 0 THEN
		EXECUTE IMMEDIATE 'CREATE TABLESPACE HISTORICOS';
	END IF;
END;
/
DECLARE
	status NUMBER(10,0);
BEGIN
	SELECT count(*)
	  INTO status
	  FROM dba_tablespaces
	 WHERE tablespace_name = 'INDICES';
	IF status = 0 THEN
		EXECUTE IMMEDIATE 'CREATE TABLESPACE INDICES';
	END IF;
END;
/






/*set define off
spool EXPORT_OBJECTS_HISTORICOS.log*/

--PROMPT
--PROMPT Creating table NOW_ESPECIALIDADES_DEL
--PROMPT =====================================
--PROMPT
create table HISTORICOS.NOW_ESPECIALIDADES_DEL
(
  data_hora_utc_del      TIMESTAMP(6) WITH TIME ZONE,
  id_usuario_del         NUMBER(10),
  osuser_del             VARCHAR2(256),
  machine_del            VARCHAR2(64),
  id_especialidade       NUMBER(12) not null,
  id_chave_especialidade NUMBER(5) not null,
  sg_especialidade       VARCHAR2(5) not null
)
;

--PROMPT
--PROMPT Creating table NOW_ESPECIALIDADES_LG
--PROMPT ====================================
--PROMPT
create table HISTORICOS.NOW_ESPECIALIDADES_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_ESPECIALIDADES_I1 on HISTORICOS.NOW_ESPECIALIDADES_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_ESPECIALIDADES_I2 on HISTORICOS.NOW_ESPECIALIDADES_LG (DATA_HORA);

--PROMPT
--PROMPT Creating table NOW_ESPECIALIDADE_DIVISAO_DEL
--PROMPT ============================================
--PROMPT
create table HISTORICOS.NOW_ESPECIALIDADE_DIVISAO_DEL
(
  data_hora_utc_del        TIMESTAMP(6) WITH TIME ZONE,
  id_usuario_del           NUMBER(10),
  osuser_del               VARCHAR2(256),
  machine_del              VARCHAR2(64),
  id_especialidade_divisao NUMBER(12) not null,
  id_unidade_divisao       NUMBER(12) not null,
  id_unidade_especialidade NUMBER(12) not null
)
;

--PROMPT
--PROMPT Creating table NOW_ESPECIALIDADE_DIVISAO_LG
--PROMPT ===========================================
--PROMPT
create table HISTORICOS.NOW_ESPECIALIDADE_DIVISAO_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_ESPECIALIDADE_DIVISAO_I1 on HISTORICOS.NOW_ESPECIALIDADE_DIVISAO_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_ESPECIALIDADE_DIVISAO_I2 on HISTORICOS.NOW_ESPECIALIDADE_DIVISAO_LG (DATA_HORA);

--PROMPT
--PROMPT Creating table NOW_FEEDBACK_PACIENTE_DEL
--PROMPT ========================================
--PROMPT
create table HISTORICOS.NOW_FEEDBACK_PACIENTE_DEL
(
  data_hora_utc_del    TIMESTAMP(6) WITH TIME ZONE,
  id_usuario_del       NUMBER(10),
  osuser_del           VARCHAR2(256),
  machine_del          VARCHAR2(64),
  id_feedback_paciente NUMBER(12) not null,
  id_unidade           NUMBER(12) not null,
  id_senha             NUMBER(12) not null,
  dh_solicitacao       DATE,
  dh_feedback          DATE
)
;

--PROMPT
--PROMPT Creating table NOW_FEEDBACK_PACIENTE_LG
--PROMPT =======================================
--PROMPT
create table HISTORICOS.NOW_FEEDBACK_PACIENTE_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_FEEDBACK_PACIENTE_I1 on HISTORICOS.NOW_FEEDBACK_PACIENTE_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_FEEDBACK_PACIENTE_I2 on HISTORICOS.NOW_FEEDBACK_PACIENTE_LG (DATA_HORA);

--PROMPT
--PROMPT Creating table NOW_GRUPO_DEL
--PROMPT ============================
--PROMPT
create table HISTORICOS.NOW_GRUPO_DEL
(
  data_hora_del  DATE not null,
  id_usuario_del NUMBER(10),
  osuser_del     VARCHAR2(256),
  machine_del    VARCHAR2(64),
  id_grupo       NUMBER(12) not null,
  nome           VARCHAR2(72) not null
)
;

--PROMPT
--PROMPT Creating table NOW_GRUPO_LG
--PROMPT ===========================
--PROMPT
create table HISTORICOS.NOW_GRUPO_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_GRUPO_I1 on HISTORICOS.NOW_GRUPO_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_GRUPO_I2 on HISTORICOS.NOW_GRUPO_LG (DATA_HORA);

--PROMPT
--PROMPT Creating table NOW_GRUPO_UNIDADE_DEL
--PROMPT ====================================
--PROMPT
create table HISTORICOS.NOW_GRUPO_UNIDADE_DEL
(
  data_hora_del    DATE not null,
  id_usuario_del   NUMBER(10),
  osuser_del       VARCHAR2(256),
  machine_del      VARCHAR2(64),
  id_grupo_unidade NUMBER(12) not null,
  id_grupo         NUMBER(12) not null,
  id_unidade       NUMBER(12) not null
)
;

--PROMPT
--PROMPT Creating table NOW_GRUPO_UNIDADE_LG
--PROMPT ===================================
--PROMPT
create table HISTORICOS.NOW_GRUPO_UNIDADE_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_GRUPO_UNIDADE_I1 on HISTORICOS.NOW_GRUPO_UNIDADE_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_GRUPO_UNIDADE_I2 on HISTORICOS.NOW_GRUPO_UNIDADE_LG (DATA_HORA);

--PROMPT
--PROMPT Creating table NOW_TEMPO_ESPEC_RISCO_DEL
--PROMPT ========================================
--PROMPT
create table HISTORICOS.NOW_TEMPO_ESPEC_RISCO_DEL
(
  id_usuario_del           NUMBER(10),
  osuser_del               VARCHAR2(256),
  machine_del              VARCHAR2(64),
  id_tempo_espec_risco     NUMBER(12) not null,
  id_unidade_especialidade NUMBER(12) not null,
  id_risco                 NUMBER(12),
  qt_pacientes_maximo      NUMBER(4),
  qt_minutos_maximo        NUMBER(4) not null,
  qt_minutos_estimativa    NUMBER(6),
  data_hora_utc_del        TIMESTAMP(6) WITH TIME ZONE
)
;
comment on column HISTORICOS.NOW_TEMPO_ESPEC_RISCO_DEL.data_hora_utc_del
  is 'DATA/HORA DA EXCLUSÿO NO FUSO HORÁRIO DO USUARIO';

--PROMPT
--PROMPT Creating table NOW_TEMPO_ESPEC_RISCO_LG
--PROMPT =======================================
--PROMPT
create table HISTORICOS.NOW_TEMPO_ESPEC_RISCO_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_TEMPO_ESPEC_RISCO_I1 on HISTORICOS.NOW_TEMPO_ESPEC_RISCO_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_TEMPO_ESPEC_RISCO_I2 on HISTORICOS.NOW_TEMPO_ESPEC_RISCO_LG (DATA_HORA);

--PROMPT
--PROMPT Creating table NOW_TEMPO_FASE_RISCO_DEL
--PROMPT =======================================
--PROMPT
create table HISTORICOS.NOW_TEMPO_FASE_RISCO_DEL
(
  id_usuario_del        NUMBER(10),
  osuser_del            VARCHAR2(256),
  machine_del           VARCHAR2(64),
  id_tempo_fase_risco   NUMBER(12) not null,
  id_unidade_fase       NUMBER(12) not null,
  id_risco              NUMBER(12),
  qt_pacientes_maximo   NUMBER(4) not null,
  qt_minutos_maximo     NUMBER(4) not null,
  qt_minutos_estimativa NUMBER(6),
  data_hora_utc_del     TIMESTAMP(6) WITH TIME ZONE
)
;
comment on column HISTORICOS.NOW_TEMPO_FASE_RISCO_DEL.data_hora_utc_del
  is 'DATA/HORA DA EXCLUSÿO NO FUSO HORÁRIO DO USUARIO';

--PROMPT
--PROMPT Creating table NOW_TEMPO_FASE_RISCO_LG
--PROMPT ======================================
--PROMPT
create table HISTORICOS.NOW_TEMPO_FASE_RISCO_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_TEMPO_FASE_RISCO_I1 on HISTORICOS.NOW_TEMPO_FASE_RISCO_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_TEMPO_FASE_RISCO_I2 on HISTORICOS.NOW_TEMPO_FASE_RISCO_LG (DATA_HORA);

--PROMPT
--PROMPT Creating table NOW_UNIDADE_DEL
--PROMPT ==============================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_DEL
(
  id_usuario_del        NUMBER(10),
  osuser_del            VARCHAR2(256),
  machine_del           VARCHAR2(64),
  id_unidade            NUMBER(12) not null,
  id_base               NUMBER(12) not null,
  nm_unidade            VARCHAR2(60) not null,
  id_regional           NUMBER(12) not null,
  id_escala_risco       NUMBER(12) not null,
  dt_hr_atualizacao     DATE,
  dt_hr_fim_atualizacao DATE,
  cd_unidade            VARCHAR2(10),
  fl_ativa              NUMBER(1) not null,
  data_hora_utc_del     TIMESTAMP(6) WITH TIME ZONE
)
;
comment on column HISTORICOS.NOW_UNIDADE_DEL.data_hora_utc_del
  is 'DATA/HORA DA EXCLUSÿO NO FUSO HORÁRIO DO USUARIO';

--PROMPT
--PROMPT Creating table NOW_UNIDADE_DIVISAO_DEL
--PROMPT ======================================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_DIVISAO_DEL
(
  data_hora_utc_del  TIMESTAMP(6) WITH TIME ZONE,
  id_usuario_del     NUMBER(10),
  osuser_del         VARCHAR2(256),
  machine_del        VARCHAR2(64),
  id_unidade_divisao NUMBER(12) not null,
  id_unidade         NUMBER(12) not null,
  nm_divisao         VARCHAR2(100) not null
)
;

--PROMPT
--PROMPT Creating table NOW_UNIDADE_DIVISAO_LG
--PROMPT =====================================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_DIVISAO_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_UNIDADE_DIVISAO_I1 on HISTORICOS.NOW_UNIDADE_DIVISAO_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_UNIDADE_DIVISAO_I2 on HISTORICOS.NOW_UNIDADE_DIVISAO_LG (DATA_HORA);

--PROMPT
--PROMPT Creating table NOW_UNIDADE_ESPECIALIDADE_DEL
--PROMPT ============================================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_ESPECIALIDADE_DEL
(
  id_usuario_del           NUMBER(10),
  osuser_del               VARCHAR2(256),
  machine_del              VARCHAR2(64),
  id_unidade_especialidade NUMBER(12) not null,
  id_unidade               NUMBER(12) not null,
  id_chave_especialidade   NUMBER(5) not null,
  cd_espec_unidade         VARCHAR2(10) not null,
  data_hora_utc_del        TIMESTAMP(6) WITH TIME ZONE
)
;
comment on column HISTORICOS.NOW_UNIDADE_ESPECIALIDADE_DEL.data_hora_utc_del
  is 'DATA/HORA DA EXCLUSÿO NO FUSO HORÁRIO DO USUARIO';

--PROMPT
--PROMPT Creating table NOW_UNIDADE_ESPECIALIDADE_LG
--PROMPT ===========================================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_ESPECIALIDADE_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_UNIDADE_ESPECIALIDADE_I1 on HISTORICOS.NOW_UNIDADE_ESPECIALIDADE_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_UNIDADE_ESPECIALIDADE_I2 on HISTORICOS.NOW_UNIDADE_ESPECIALIDADE_LG (DATA_HORA);

--PROMPT
--PROMPT Creating table NOW_UNIDADE_FASE_DEL
--PROMPT ===================================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_FASE_DEL
(
  id_usuario_del      NUMBER(10),
  osuser_del          VARCHAR2(256),
  machine_del         VARCHAR2(64),
  id_unidade_fase     NUMBER(12) not null,
  id_unidade          NUMBER(12) not null,
  id_fase             NUMBER(12) not null,
  nm_unidade_fase     VARCHAR2(40) not null,
  qt_pacientes_maximo NUMBER(4) not null,
  qt_minutos_maximo   NUMBER(4) not null,
  nr_ordem            NUMBER(2),
  data_hora_utc_del   TIMESTAMP(6) WITH TIME ZONE
)
;
comment on column HISTORICOS.NOW_UNIDADE_FASE_DEL.data_hora_utc_del
  is 'DATA/HORA DA EXCLUSÿO NO FUSO HORÁRIO DO USUARIO';

--PROMPT
--PROMPT Creating table NOW_UNIDADE_FASE_ESPEC_DEL
--PROMPT =========================================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_FASE_ESPEC_DEL
(
  id_usuario_del           NUMBER(10),
  osuser_del               VARCHAR2(256),
  machine_del              VARCHAR2(64),
  id_unidade_fase_espec    NUMBER(12) not null,
  id_unidade_fase          NUMBER(12) not null,
  id_unidade_especialidade NUMBER(12) not null,
  data_hora_utc_del        TIMESTAMP(6) WITH TIME ZONE
)
;
comment on column HISTORICOS.NOW_UNIDADE_FASE_ESPEC_DEL.data_hora_utc_del
  is 'DATA/HORA DA EXCLUSÿO NO FUSO HORÁRIO DO USUARIO';

--PROMPT
--PROMPT Creating table NOW_UNIDADE_FASE_ESPEC_LG
--PROMPT ========================================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_FASE_ESPEC_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_UNIDADE_FASE_ESPEC_I1 on HISTORICOS.NOW_UNIDADE_FASE_ESPEC_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_UNIDADE_FASE_ESPEC_I2 on HISTORICOS.NOW_UNIDADE_FASE_ESPEC_LG (DATA_HORA);

--PROMPT
--PROMPT Creating table NOW_UNIDADE_FASE_LG
--PROMPT ==================================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_FASE_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_UNIDADE_FASE_I1 on HISTORICOS.NOW_UNIDADE_FASE_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_UNIDADE_FASE_I2 on HISTORICOS.NOW_UNIDADE_FASE_LG (DATA_HORA);

--PROMPT
--PROMPT Creating table NOW_UNIDADE_FASE_PERIODO_DEL
--PROMPT ===========================================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_FASE_PERIODO_DEL
(
  id_usuario_del          NUMBER(10),
  osuser_del              VARCHAR2(256),
  machine_del             VARCHAR2(64),
  id_unidade_fase_periodo NUMBER(12) not null,
  id_unidade_fase         NUMBER(12) not null,
  qt_minutos_inferior     NUMBER(3) not null,
  data_hora_utc_del       TIMESTAMP(6) WITH TIME ZONE
)
;
comment on column HISTORICOS.NOW_UNIDADE_FASE_PERIODO_DEL.data_hora_utc_del
  is 'DATA/HORA DA EXCLUSÿO NO FUSO HORÁRIO DO USUARIO';

--PROMPT
--PROMPT Creating table NOW_UNIDADE_FASE_PERIODO_LG
--PROMPT ==========================================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_FASE_PERIODO_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_UNIDADE_FASE_PERIODO_I1 on HISTORICOS.NOW_UNIDADE_FASE_PERIODO_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_UNIDADE_FASE_PERIODO_I2 on HISTORICOS.NOW_UNIDADE_FASE_PERIODO_LG (DATA_HORA);

--PROMPT
--PROMPT Creating table NOW_UNIDADE_LG
--PROMPT =============================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_UNIDADE_I1 on HISTORICOS.NOW_UNIDADE_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_UNIDADE_I2 on HISTORICOS.NOW_UNIDADE_LG (DATA_HORA);

--PROMPT
--PROMPT Creating table NOW_UNIDADE_USUARIO_DEL
--PROMPT ======================================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_USUARIO_DEL
(
  data_hora_utc_del  TIMESTAMP(6) WITH TIME ZONE,
  id_usuario_del     NUMBER(10),
  osuser_del         VARCHAR2(256),
  machine_del        VARCHAR2(64),
  id_unidade_usuario NUMBER(12),
  id_unidade         NUMBER(12),
  id_usuario         NUMBER(5),
  id_grupo           NUMBER(12)
)
;

--PROMPT
--PROMPT Creating table NOW_UNIDADE_USUARIO_LG
--PROMPT =====================================
--PROMPT
create table HISTORICOS.NOW_UNIDADE_USUARIO_LG
(
  data_hora     DATE not null,
  id_usuario    NUMBER(10),
  osuser        VARCHAR2(256),
  machine       VARCHAR2(64),
  id_chave      NUMBER,
  i_a           CHAR(1),
  nome_coluna   VARCHAR2(30),
  tipo_coluna   VARCHAR2(1),
  original      VARCHAR2(4000),
  novo          VARCHAR2(4000),
  original_lob  CLOB,
  novo_lob      CLOB,
  data_hora_utc TIMESTAMP(6) WITH TIME ZONE
)
;
create index HISTORICOS.NOW_UNIDADE_USUARIO_I1 on HISTORICOS.NOW_UNIDADE_USUARIO_LG (ID_CHAVE, DATA_HORA);
create index HISTORICOS.NOW_UNIDADE_USUARIO_I2 on HISTORICOS.NOW_UNIDADE_USUARIO_LG (DATA_HORA);

/
--------------------------------------------------------
--  DDL for Table LOG_TABELA
--------------------------------------------------------

  CREATE TABLE "HISTORICOS"."LOG_TABELA" 
   (	"ID_TABELA" NUMBER(8,0), 
	"OWNER" VARCHAR2(30 BYTE), 
	"NOME" VARCHAR2(30 BYTE), 
	"SEQUENCE" VARCHAR2(40 BYTE), 
	"CHAVE" VARCHAR2(30 BYTE), 
	"TABELA_DELECAO" VARCHAR2(61 BYTE), 
	"ATIVO" NUMBER DEFAULT 1, 
	"OWNER_LOG" VARCHAR2(30 BYTE), 
	"NOME_LOG" VARCHAR2(30 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 4 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 40960 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HISTORICOS" ;

   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA"."ID_TABELA" IS 'Valor alimentado por sequence.';
   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA"."SEQUENCE" IS 'Nome da sequence a ser utilizada para preencher o campo chave de log da tabela.';
   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA"."ATIVO" IS 'Ativa ou Inativa a pkgdefs de logar a tabela. 1=LOG ATIVO | 0=LOG INATIVO';
   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA"."OWNER_LOG" IS 'Owner da tabela de alteracao que sera gravado o log';
   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA"."NOME_LOG" IS 'Nome da tabela que sera gravado alteracao e insercao';
--------------------------------------------------------
--  DDL for Table GLB_LOG_OPERACAO
--------------------------------------------------------
/
  CREATE TABLE "HISTORICOS"."GLB_LOG_OPERACAO" 
   (	"ID_LOG_OPERACAO" NUMBER, 
	"DATA_HORA" TIMESTAMP (6), 
	"USUARIO" VARCHAR2(30 BYTE), 
	"OPERACAO" VARCHAR2(45 BYTE), 
	"ORIGEM" VARCHAR2(45 BYTE), 
	"DETALHES" VARCHAR2(4000 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HISTORICOS" ;

   COMMENT ON COLUMN "HISTORICOS"."GLB_LOG_OPERACAO"."ID_LOG_OPERACAO" IS 'ID da tabela - Chave Primária.';
   COMMENT ON COLUMN "HISTORICOS"."GLB_LOG_OPERACAO"."DATA_HORA" IS 'Data e hora em que a operação aconteceu.';
   COMMENT ON COLUMN "HISTORICOS"."GLB_LOG_OPERACAO"."USUARIO" IS 'Usuário responsável pela operação.';
   COMMENT ON COLUMN "HISTORICOS"."GLB_LOG_OPERACAO"."OPERACAO" IS 'Operação realizada.';
   COMMENT ON COLUMN "HISTORICOS"."GLB_LOG_OPERACAO"."ORIGEM" IS 'Ip de origem da conexão.';
   COMMENT ON COLUMN "HISTORICOS"."GLB_LOG_OPERACAO"."DETALHES" IS 'Detalhes adicionais da operação.';
   COMMENT ON TABLE "HISTORICOS"."GLB_LOG_OPERACAO"  IS 'Tabela contendo os logs de operação do usuário.';
--------------------------------------------------------
--  DDL for Table LOG_TABELA_TIPO
--------------------------------------------------------
/
  CREATE TABLE "HISTORICOS"."LOG_TABELA_TIPO" 
   (	"ID_TABELA_TIPO" NUMBER(12,0), 
	"NM_TABELA_TIPO" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HISTORICOS" ;

   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA_TIPO"."ID_TABELA_TIPO" IS 'Id sequencial da tabela';
   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA_TIPO"."NM_TABELA_TIPO" IS 'Descrição do tipo de tabela';
   COMMENT ON TABLE "HISTORICOS"."LOG_TABELA_TIPO"  IS 'Tipos de tabelas';
--------------------------------------------------------
--  DDL for Table LOG_TABELA_VERSAO
--------------------------------------------------------
/
  CREATE TABLE "HISTORICOS"."LOG_TABELA_VERSAO" 
   (	"ID_TABELA_VERSAO" NUMBER(12,0), 
	"ID_TABELA" NUMBER(12,0), 
	"ID_TABELA_TIPO" NUMBER(12,0), 
	"NM_VERSAO" VARCHAR2(50 BYTE), 
	"NM_IDIOMA" VARCHAR2(30 BYTE), 
	"DT_INICIO" DATE DEFAULT sysdate, 
	"DT_FIM" DATE, 
	"FL_SITUACAO" NUMBER(1,0) DEFAULT 1
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HISTORICOS" ;

   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA_VERSAO"."ID_TABELA_VERSAO" IS 'Id sequencial da tabela';
   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA_VERSAO"."ID_TABELA" IS 'ID da tabela referente à versão';
   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA_VERSAO"."ID_TABELA_TIPO" IS 'ID do tipo da tabela';
   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA_VERSAO"."NM_VERSAO" IS 'Versão da tabela';
   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA_VERSAO"."NM_IDIOMA" IS 'Idioma da versão';
   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA_VERSAO"."DT_INICIO" IS 'Data início da vigência';
   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA_VERSAO"."DT_FIM" IS 'Data final da vigência';
   COMMENT ON COLUMN "HISTORICOS"."LOG_TABELA_VERSAO"."FL_SITUACAO" IS 'Flag situação 0 - Inativo 1 - Ativo';
   COMMENT ON TABLE "HISTORICOS"."LOG_TABELA_VERSAO"  IS 'Versões de tabelas';
REM INSERTING into HISTORICOS.LOG_TABELA

/




--spool off

   CREATE SEQUENCE  "HISTORICOS"."LOG_TABELA_TIPO_SQ"  MINVALUE 1 MAXVALUE 999999999999 INCREMENT BY 1 START WITH 10 CACHE 20 NOORDER  NOCYCLE ;
   CREATE SEQUENCE  "HISTORICOS"."LOG_TABELA_VERSAO_SQ"  MINVALUE 1 MAXVALUE 999999999999 INCREMENT BY 1 START WITH 11 CACHE 20 NOORDER  NOCYCLE ;
   CREATE SEQUENCE  "HISTORICOS"."SEQ_GLB_LOG_OPERACAO"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 56731670 CACHE 100 NOORDER  NOCYCLE ;
   CREATE SEQUENCE  "HISTORICOS"."SEQ_LOG_TABELA"  MINVALUE 1 MAXVALUE 99999999 INCREMENT BY 1 START WITH 1711 CACHE 20 NOORDER  NOCYCLE ;
   CREATE SEQUENCE  "HISTORICOS"."SEQ_SEN_PROCED_VALIDO_CIRURG"  MINVALUE 1 MAXVALUE 999999999999 INCREMENT BY 1 START WITH 25 CACHE 20 NOORDER  NOCYCLE ;



--------------------------------------------------------
--  Arquivo criado - Segunda-feira-Junho-18-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger LOG_TABELA_TG1
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "HISTORICOS"."LOG_TABELA_TG1" 
 BEFORE
  INSERT
 ON historicos.log_tabela
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
  vTabela NUMBER(8);
BEGIN
  SELECT historicos.seq_log_tabela.nextval INTO vTabela FROM dual;
  :new.id_tabela := vTabela;
END;

/
ALTER TRIGGER "HISTORICOS"."LOG_TABELA_TG1" ENABLE;
--------------------------------------------------------
--  DDL for Trigger LOG_TABELA_TIPO_TGI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "HISTORICOS"."LOG_TABELA_TIPO_TGI" 
   before insert
   on historicos.log_tabela_tipo
   referencing new as new old as old
   for each row
begin
   select historicos.log_tabela_tipo_sq.nextval
     into :new.id_tabela_tipo
     from dual;
end;

/
ALTER TRIGGER "HISTORICOS"."LOG_TABELA_TIPO_TGI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger LOG_TABELA_VERSAO_TGI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "HISTORICOS"."LOG_TABELA_VERSAO_TGI" 
   before insert
   on historicos.log_tabela_versao
   referencing new as new old as old
   for each row
begin
   select historicos.log_tabela_versao_sq.nextval
     into :new.id_tabela_versao
     from dual;
end;

/
ALTER TRIGGER "HISTORICOS"."LOG_TABELA_VERSAO_TGI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_GLB_LOG_OPERACAO_TGI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "HISTORICOS"."TRG_GLB_LOG_OPERACAO_TGI" 
 BEFORE INSERT ON historicos.glb_log_operacao
 REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   SELECT historicos.seq_glb_log_operacao.NEXTVAL
     INTO :NEW.id_log_operacao
     FROM DUAL;
END;
/
ALTER TRIGGER "HISTORICOS"."TRG_GLB_LOG_OPERACAO_TGI" ENABLE;



