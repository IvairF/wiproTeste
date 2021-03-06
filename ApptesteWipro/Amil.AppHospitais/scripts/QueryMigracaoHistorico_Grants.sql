
-- Amesp
create user HISTORICOSUSR
  default tablespace TBSASM_DATA
  temporary tablespace TEMP
  profile DEFAULT
  identified by "HISTORICOSUSR#2018"
  account lock;
/
grant create any table to HISTORICOSUSR;
/
grant drop any table to HISTORICOSUSR;
/
grant unlimited tablespace to HISTORICOSUSR; 
/
create user HISTORICOSUSRH
  default tablespace TBSASM_DATA
  temporary tablespace TEMP
  profile DEFAULT
  identified by "HISTORICOSUSRH#2018"
  account lock;
/
grant create any table to HISTORICOSUSRH
/
grant drop any table to HISTORICOSUSRH
/
grant unlimited tablespace to HISTORICOSUSRH
/
CREATE ROLE HISTORICO_ROLE
/
ALTER USER HISTORICOSUSR DEFAULT TABLESPACE TBSASM_DATA
/
ALTER USER HISTORICOSUSR QUOTA UNLIMITED ON TBSASM_DATA
/
ALTER USER HISTORICOSUSR QUOTA UNLIMITED ON TBSASM_INDEX
/
GRANT CREATE SESSION TO HISTORICOSUSR 
/
ALTER USER HISTORICOSUSRH DEFAULT TABLESPACE TBSASM_DATA
/
ALTER USER HISTORICOSUSRH QUOTA UNLIMITED ON TBSASM_DATA
/
ALTER USER HISTORICOSUSRH QUOTA UNLIMITED ON TBSASM_INDEX
/
GRANT CREATE SESSION TO HISTORICOSUSRH
/
GRANT HISTORICO_ROLE TO HISTORICOSUSRH
/
GRANT HISTORICO_ROLE TO HISTORICOSUSRH
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_ESPECIALIDADES_DEL TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_ESPECIALIDADES_LG TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_ESPECIALIDADE_DIVISAO_DEL TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_ESPECIALIDADE_DIVISAO_LG TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_FEEDBACK_PACIENTE_DEL TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_FEEDBACK_PACIENTE_LG TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_GRUPO_DEL TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_GRUPO_LG TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_GRUPO_UNIDADE_LG TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_TEMPO_ESPEC_RISCO_DEL TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_TEMPO_ESPEC_RISCO_LG TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_TEMPO_FASE_RISCO_DEL TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_TEMPO_FASE_RISCO_LG TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_DEL TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_DIVISAO_DEL TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_DIVISAO_LG TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_ESPECIALIDADE_DEL TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_ESPECIALIDADE_LG TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_FASE_DEL TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_FASE_ESPEC_DEL TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_FASE_ESPEC_LG TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_FASE_LG TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_FASE_PERIODO_DEL TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_FASE_PERIODO_LG TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_LG TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_USUARIO_DEL TO HISTORICO_ROLE
/
GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICOS.NOW_UNIDADE_USUARIO_LG TO HISTORICO_ROLE
/






