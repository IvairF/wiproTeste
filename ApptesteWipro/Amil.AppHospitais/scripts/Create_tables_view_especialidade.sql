-- Create table
create table HOSPITAIS.APPHOSP_ESPECIALIDADE_CORP
(
  id_app_especialidade NUMBER not null,
  cd_corporativo       VARCHAR2(200),
  ds_especialidade     VARCHAR2(200),
  id_chave             NUMBER(5),
  PRIMARY KEY (ID_APPHOSP_ESPECIALIDADE)
);

CREATE SEQUENCE hospitais.APPHOSP_ESPECIALIDADE_CORP_SEQ
  MINVALUE 1
  MAXVALUE 999999999999999999999999999       
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE OR REPLACE TRIGGER hospitais.APPHOSP_ESPECIALIDADE_CORP_TRG
  BEFORE INSERT ON hospitais.APPHOSP_ESPECIALIDADE_CORP
  FOR EACH ROW
BEGIN
  SELECT hospitais.APPHOSP_ESPECIALIDADE_CORP_SEQ.NEXTVAL 
  INTO :NEW.ID_APPHOSP_ESPECIALIDADE
  FROM DUAL;
END; 

/
GRANT SELECT, INSERT, UPDATE, DELETE ON hospitais.APPHOSP_ESPECIALIDADE_CORP TO hospitais
/
GRANT SELECT, INSERT, UPDATE, DELETE ON hospitais.APPHOSP_ESPECIALIDADE_CORP TO hospitaisusr
/

CREATE OR REPLACE VIEW HOSPITAIS.apphosp_especialidade_view AS
select a.id_apphosp_espec_unid as ID_APPHOSP_ESPECIALIDADE, 
       a.id_apphosp_unidade as ID_APPHOSP_UNIDADE, 
       b.id_chave as ID_ESPECIALIDADE_CHAVE, 
       b.ds_especialidade as DESCRICAO,
       b.cd_corporativo,
       0 as FL_BLOQUEAR_TEMPO,
       1 as FL_ESPECIALIDADE_NOW
from hospitais.apphosp_espec_unidade a
inner join hospitais.apphosp_especialidade_corp b on b.id_apphosp_especialidade = a.id_app_especialidade
/
GRANT SELECT, INSERT, UPDATE, DELETE ON hospitais.apphosp_especialidade_view TO hospitais
/
GRANT SELECT, INSERT, UPDATE, DELETE ON hospitais.apphosp_especialidade_view TO hospitaisusr
