--------------------------------------------------------
--  DDL for Type TO_NOW_FASE_SUMARIO
--------------------------------------------------------

  CREATE OR REPLACE TYPE "AMESP"."TO_NOW_FASE_SUMARIO" as object (
  id_unidade_divisao  integer,
  id_fase             integer,
  fl_aguarda_feedback number(1),
  qt_pacientes        integer,
  qt_minutos_maior    integer,
  st_quantidade       number(1),
  st_tempo            number(1))

/

--------------------------------------------------------
--  DDL for Type TO_NOW_UNIDADE_FASE_SUMARIO
--------------------------------------------------------

  CREATE OR REPLACE TYPE "AMESP"."TO_NOW_UNIDADE_FASE_SUMARIO" as object (
  id_unidade_fase          integer,
  fl_aguarda_feedback number(1),
  qt_pacientes        integer,
  qt_minutos_maior    integer,
  st_quantidade       number(1),
  st_tempo            number(1))

/

--------------------------------------------------------
--  DDL for Type TT_NOW_FASE_SUMARIO
--------------------------------------------------------

  CREATE OR REPLACE TYPE "AMESP"."TT_NOW_FASE_SUMARIO" as table of amesp.to_now_fase_sumario

/

--------------------------------------------------------
--  DDL for Type TT_NOW_UNIDADE_FASE_SUMARIO
--------------------------------------------------------

  CREATE OR REPLACE TYPE "AMESP"."TT_NOW_UNIDADE_FASE_SUMARIO" as table of amesp.to_now_unidade_fase_sumario

/

--------------------------------------------------------
--  DDL for Type TOESPECIALIDADE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "AMESP"."TOESPECIALIDADE" AS OBJECT (
  id_especialidade   VARCHAR2(2),
  descricao          VARCHAR2(30),
  STATIC FUNCTION CRIAR(rCod IN VARCHAR2) RETURN TOEspecialidade,
  STATIC FUNCTION CRIAR_VAZIO RETURN TOEspecialidade)
/
CREATE OR REPLACE TYPE BODY "AMESP"."TOESPECIALIDADE" AS 
  STATIC FUNCTION
      CRIAR(rCod IN VARCHAR2) RETURN TOEspecialidade IS
    vRet TOEspecialidade;
  BEGIN
    BEGIN
      SELECT TOEspecialidade(codigo,especialidade) INTO vRet
        FROM aa_especialidades
       WHERE codigo=rCod;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;
    RETURN vRet;
  END;
  
  STATIC FUNCTION CRIAR_VAZIO RETURN TOEspecialidade IS
  BEGIN
    RETURN TOEspecialidade(NULL,NULL);
  END;
END;

/
