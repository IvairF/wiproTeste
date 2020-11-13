CREATE OR REPLACE TRIGGER "AMESP"."AA_ESPECIALIDADES_TC_TRG" 
   before delete or update of fl_total_care
   on amesp.aa_especialidades
   referencing new as new old as old
   for each row
declare
   l_i_aux pls_integer;
begin
   -- Se estiver apagando uma especialidade ou desmarcando o flag Total Care
   if    deleting
      or (    nvl(:old.fl_total_care, 0) = 1
          and nvl(:new.fl_total_care, 0) <> 1) then
      select count(1)
        into l_i_aux
        from amesp.cm_tot_medicos
       where especialidade = :new.codigo
         and nvl(fl_alto_risco, 'N') = 'S'
         and rownum = 1;

      if l_i_aux = 1 then
         raise_application_error
            (-20500,
             'Existem profissionais cadastrados nesta especialidade e marcados como Total Care.');
      end if;
   end if;
end;

/

/
ALTER TRIGGER "AMESP"."AA_ESPECIALIDADES_TC_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger AA_ESPECIALIDADES_TGD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."AA_ESPECIALIDADES_TGD" 
AFTER DELETE ON amesp.aa_especialidades
FOR EACH ROW
	BEGIN
  amesp.pkgdefs.IDENTIFICA_USUARIO;
INSERT INTO historicos.aa_especialidades_del
    (data_hora_utc_del,id_usuario,osuser,machine,codigo,especialidade,status_registro,tipo,correspondente,correspondente_internacao,limite_solicit,limite_ch_por_cons,correspondente_espec,marcacao_mpv,referencia,encaminhamento,tipo_sip,id_ocupacao,id_amb_especialidade,id_amb_medial,id_tipo_cr,id_evento_especialidade,id_efoccus,id_sisagenda,fl_total_care,id_chave,fl_hab_ated_grupo)
  VALUES
    (localtimestamp at time zone 'UTC',amesp.pkgdefs.gUser,amesp.pkgdefs.gOSUser,amesp.pkgdefs.gMachine,:old.codigo,:old.especialidade,:old.status_registro,:old.tipo,:old.correspondente,:old.correspondente_internacao,:old.limite_solicit,:old.limite_ch_por_cons,:old.correspondente_espec,:old.marcacao_mpv,:old.referencia,:old.encaminhamento,:old.tipo_sip,:old.id_ocupacao,:old.id_amb_especialidade,:old.id_amb_medial,:old.id_tipo_cr,:old.id_evento_especialidade,:old.id_efoccus,:old.id_sisagenda,:old.fl_total_care,:old.id_chave,:old.fl_hab_ated_grupo);
END;
/
ALTER TRIGGER "AMESP"."AA_ESPECIALIDADES_TGD" ENABLE;


--------------------------------------------------------
--  DDL for Trigger AA_ESPECIALIDADES_TGI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."AA_ESPECIALIDADES_TGI" 
BEFORE INSERT ON amesp.aa_especialidades
FOR EACH ROW
BEGIN
  :new.id_chave := amesp.pkgdefs.NOVA_CHAVE_LOG('amesp','aa_especialidades');
  amesp.pkgdefs.REGISTRA_INCLUSAO('amesp','aa_especialidades',:new.id_chave,'historicos');
END;

/
ALTER TRIGGER "AMESP"."AA_ESPECIALIDADES_TGI" ENABLE;

/
--------------------------------------------------------
--  DDL for Trigger AA_ESPECIALIDADES_TGU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."AA_ESPECIALIDADES_TGU" 
 AFTER
  UPDATE
 ON amesp.aa_especialidades
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'codigo',:old.codigo,:new.codigo,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'especialidade',:old.especialidade,:new.especialidade,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'status_registro',:old.status_registro,:new.status_registro,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'tipo',:old.tipo,:new.tipo,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'correspondente',:old.correspondente,:new.correspondente,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'correspondente_internacao',:old.correspondente_internacao,:new.correspondente_internacao,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'limite_solicit',:old.limite_solicit,:new.limite_solicit,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'limite_ch_por_cons',:old.limite_ch_por_cons,:new.limite_ch_por_cons,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'correspondente_espec',:old.correspondente_espec,:new.correspondente_espec,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'marcacao_mpv',:old.marcacao_mpv,:new.marcacao_mpv,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'referencia',:old.referencia,:new.referencia,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'encaminhamento',:old.encaminhamento,:new.encaminhamento,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'tipo_sip',:old.tipo_sip,:new.tipo_sip,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'id_ocupacao',:old.id_ocupacao,:new.id_ocupacao,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'id_amb_especialidade',:old.id_amb_especialidade,:new.id_amb_especialidade,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'id_amb_medial',:old.id_amb_medial,:new.id_amb_medial,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'id_tipo_cr',:old.id_tipo_cr,:new.id_tipo_cr,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'id_evento_especialidade',:old.id_evento_especialidade,:new.id_evento_especialidade,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'id_efoccus',:old.id_efoccus,:new.id_efoccus,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'id_sisagenda',:old.id_sisagenda,:new.id_sisagenda,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'fl_total_care',:old.fl_total_care,:new.fl_total_care,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','aa_especialidades',:old.id_chave,'fl_hab_ated_grupo',:old.fl_hab_ated_grupo,:new.fl_hab_ated_grupo,'historicos');
END;
/
ALTER TRIGGER "AMESP"."AA_ESPECIALIDADES_TGU" ENABLE;

/

--------------------------------------------------------
--  DDL for Trigger ACESSO_CHAVE_ATIVACAO_BFI_TG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."ACESSO_CHAVE_ATIVACAO_BFI_TG" 
before insert on amesp.acesso_chave_ativacao
for each row
declare
  l_v_invalidos varchar2(3) := '0OI'; -- Lista de caracteres inválidos
begin
  while :new.cd_chave is null loop
      :new.cd_chave := dbms_random.string('x', 6);
      -- Chave não deve conter caracteres "inválidos" (que podem deixar dúvida ao usuário)
      if translate(:new.cd_chave, l_v_invalidos, lpad(' ', length(l_v_invalidos))) = :new.cd_chave then
        -- Verifica se chave não existe na tabela.
        -- Se já existir, variável ficará nula e o loop irá continuar
        begin
          select null
            into :new.cd_chave
            from amesp.acesso_chave_ativacao
           where cd_chave = :new.cd_chave;
        exception
          when no_data_found then
            null;
        end;
      else
        -- Se chave contiver caracteres inválidos, ficará nula e o loop continuará
        :new.cd_chave := null;
      end if;
  end loop;
end;

/
ALTER TRIGGER "AMESP"."ACESSO_CHAVE_ATIVACAO_BFI_TG" ENABLE;

/

--------------------------------------------------------
--  DDL for Trigger ACESSO_LOGIN_TG2
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."ACESSO_LOGIN_TG2" 
 BEFORE
   INSERT OR DELETE OR UPDATE OF id_usuario
 ON amesp.acesso_login
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
  IF DELETING THEN
     -- Deleção
     RAISE_APPLICATION_ERROR(-20500, 'Os registros desta tabela não podem ser deletados.');
  ELSIF UPDATING THEN
     -- Alteração
     RAISE_APPLICATION_ERROR(-20500, 'O campo ID_USUARIO desta tabela não pode ser alterado.');
  ELSE
     -- Inclusão
     IF :NEW.CPF IS NULL THEN
        RAISE_APPLICATION_ERROR(-20500, 'O campo CPF é obrigatório.');
     END IF;
  END IF;
END;

/
ALTER TRIGGER "AMESP"."ACESSO_LOGIN_TG2" ENABLE;     

/
--------------------------------------------------------
--  DDL for Trigger ACESSO_LOGIN_TGI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."ACESSO_LOGIN_TGI" 
BEFORE INSERT ON amesp.acesso_login
FOR EACH ROW
BEGIN
  :new.id_usuario := pkgdefs.NOVA_CHAVE_LOG('amesp','acesso_login');
  pkgdefs.REGISTRA_INCLUSAO('amesp','acesso_login',:new.id_usuario,'historicos');
END;


/
ALTER TRIGGER "AMESP"."ACESSO_LOGIN_TGI" ENABLE;
/
--------------------------------------------------------
--  DDL for Trigger ACESSO_LOGIN_TGU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."ACESSO_LOGIN_TGU" 
 AFTER
  UPDATE
 ON amesp.acesso_login
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
  pkgdefs.IDENTIFICA_USUARIO;
  pkgdefs.REGISTRA_ALTERACAO('amesp','acesso_login',:old.id_usuario,'nome',:old.nome,:new.nome,'historicos');
  pkgdefs.REGISTRA_ALTERACAO('amesp','acesso_login',:old.id_usuario,'nome_completo',:old.nome_completo,:new.nome_completo,'historicos');
  pkgdefs.REGISTRA_ALTERACAO('amesp','acesso_login',:old.id_usuario,'usuario_inativo',:old.usuario_inativo,:new.usuario_inativo,'historicos');
  pkgdefs.REGISTRA_ALTERACAO('amesp','acesso_login',:old.id_usuario,'id_unidade',:old.id_unidade,:new.id_unidade,'historicos');
  pkgdefs.REGISTRA_ALTERACAO('amesp','acesso_login',:old.id_usuario,'id_depto',:old.id_depto,:new.id_depto,'historicos');
  pkgdefs.REGISTRA_ALTERACAO('amesp','acesso_login',:old.id_usuario,'email_externo',:old.email_externo,:new.email_externo,'historicos');
  pkgdefs.REGISTRA_ALTERACAO('amesp','acesso_login',:old.id_usuario,'email_interno',:old.email_interno,:new.email_interno,'historicos');
  pkgdefs.REGISTRA_ALTERACAO('amesp','acesso_login',:old.id_usuario,'cpf',:old.cpf,:new.cpf,'historicos');
  pkgdefs.REGISTRA_ALTERACAO('amesp','acesso_login',:old.id_usuario,'usuario_bloqueado',:old.usuario_bloqueado,:new.usuario_bloqueado,'historicos');
END;
/
ALTER TRIGGER "AMESP"."ACESSO_LOGIN_TGU" ENABLE;
/

--------------------------------------------------------
--  DDL for Trigger ACESSO_SISTEMA_VERSOES_TGIU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."ACESSO_SISTEMA_VERSOES_TGIU" 
   before insert or update
   on AMESP.ACESSO_SISTEMA_VERSOES
   for each row
begin
   if inserting then
      :new.DATA_VERSAO := sysdate;
   elsif updating then
      if     :old.ATIVO = 1
         and :new.ATIVO = 0 then
         :new.DATA_TERMINO := sysdate;
      elsif     :old.ATIVO = 0
            and :new.ATIVO = 1 then
         :new.DATA_TERMINO := null;
      end if;
   end if;
end;


/
ALTER TRIGGER "AMESP"."ACESSO_SISTEMA_VERSOES_TGIU" ENABLE;

/

--------------------------------------------------------
--  DDL for Trigger ACESSO_SISTEMAS_VERSOES_TGD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."ACESSO_SISTEMAS_VERSOES_TGD" 
 after
  delete
 on amesp.acesso_sistema_versoes
referencing new as new old as old
 for each row
begin
   RAISE_APPLICATION_ERROR
      (-20001,
       'Não é possível excluir registros dessa tabela, por favor atribua 0 (zero) ao campo ATIVO!');
end;


/
ALTER TRIGGER "AMESP"."ACESSO_SISTEMAS_VERSOES_TGD" ENABLE;
/
--------------------------------------------------------
--  DDL for Trigger ACESSO_SISTEMAS_VERSOES_TGI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."ACESSO_SISTEMAS_VERSOES_TGI" 
BEFORE INSERT ON amesp.ACESSO_SISTEMA_VERSOES
FOR EACH ROW
BEGIN
  :new.id_chave := pkgdefs.NOVA_CHAVE_LOG('amesp','acesso_sistemas_versoes');
  pkgdefs.REGISTRA_INCLUSAO('amesp','acesso_sistemas_versoes',:new.id_chave,'historicos');
END;


/
ALTER TRIGGER "AMESP"."ACESSO_SISTEMAS_VERSOES_TGI" ENABLE;
/

--------------------------------------------------------
--  DDL for Trigger ACESSO_SISTEMAS_VERSOES_TGU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."ACESSO_SISTEMAS_VERSOES_TGU" 
 AFTER 
 UPDATE
 ON AMESP.ACESSO_SISTEMA_VERSOES
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW 
begin
   PKGDEFS.IDENTIFICA_USUARIO;
   PKGDEFS.REGISTRA_ALTERACAO('amesp',
                              'acesso_sistemas_versoes',
                              :old.ID_CHAVE,
                              'id_sistema',
                              :old.ID_SISTEMA,
                              :new.ID_SISTEMA,
                              'historicos');
   PKGDEFS.REGISTRA_ALTERACAO('amesp',
                              'acesso_sistemas_versoes',
                              :old.ID_CHAVE,
                              'versao',
                              :old.VERSAO,
                              :new.VERSAO,
                              'historicos');
   PKGDEFS.REGISTRA_ALTERACAO('amesp',
                              'acesso_sistemas_versoes',
                              :old.ID_CHAVE,
                              'data_versao',
                              :old.DATA_VERSAO,
                              :new.DATA_VERSAO,
                              'historicos');
   PKGDEFS.REGISTRA_ALTERACAO('amesp',
                              'acesso_sistemas_versoes',
                              :old.ID_CHAVE,
                              'ativo',
                              :old.ATIVO,
                              :new.ATIVO,
                              'historicos');
   PKGDEFS.REGISTRA_ALTERACAO('amesp',
                              'acesso_sistemas_versoes',
                              :old.ID_CHAVE,
                              'data_termino',
                              :old.DATA_TERMINO,
                              :new.DATA_TERMINO,
                              'historicos');
end;


/
ALTER TRIGGER "AMESP"."ACESSO_SISTEMAS_VERSOES_TGU" ENABLE;
/

--------------------------------------------------------
--  DDL for Trigger ACSSISVRS_HASH_MINUSC_TG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."ACSSISVRS_HASH_MINUSC_TG" 
   before insert or update of tx_hash
   on amesp.acesso_sistema_versoes
   for each row
begin
   :new.tx_hash := lower(:new.tx_hash);
end;
/
ALTER TRIGGER "AMESP"."ACSSISVRS_HASH_MINUSC_TG" ENABLE;
/


--------------------------------------------------------
--  DDL for Trigger CM_BASE_DADOS_WPD_TGD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."CM_BASE_DADOS_WPD_TGD" 
AFTER DELETE ON amesp.cm_base_dados_wpd
FOR EACH ROW
	BEGIN
  amesp.pkgdefs.IDENTIFICA_USUARIO;
  INSERT INTO historicos.cm_base_dados_wpd_del
    (data_hora_utc_del,id_usuario,osuser,machine,id_base_dados,nome,alias)
  VALUES
    (localtimestamp at time zone 'UTC',amesp.pkgdefs.gUser,amesp.pkgdefs.gOSUser,amesp.pkgdefs.gMachine,:old.id_base_dados,:old.nome,:old.alias);
END;
/
ALTER TRIGGER "AMESP"."CM_BASE_DADOS_WPD_TGD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CM_BASE_DADOS_WPD_TGI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."CM_BASE_DADOS_WPD_TGI" 
BEFORE INSERT ON amesp.cm_base_dados_wpd
FOR EACH ROW
BEGIN
  amesp.pkgdefs.REGISTRA_INCLUSAO('amesp','cm_base_dados_wpd',:new.id_base_dados,'historicos');
END;
/
ALTER TRIGGER "AMESP"."CM_BASE_DADOS_WPD_TGI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CM_BASE_DADOS_WPD_TGU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."CM_BASE_DADOS_WPD_TGU" 
   after update
   on amesp.cm_base_dados_wpd
   referencing new as new old as old
   for each row
begin
   amesp.pkgdefs.identifica_usuario;
   amesp.pkgdefs.registra_alteracao('amesp',
                                    'cm_base_dados_wpd',
                                    :old.id_base_dados,
                                    'nome',
                                    :old.nome,
                                    :new.nome,
                                    'historicos');
   amesp.pkgdefs.registra_alteracao('amesp',
                                    'cm_base_dados_wpd',
                                    :old.id_base_dados,
                                    'alias',
                                    :old.alias,
                                    :new.alias,
                                    'historicos');
   amesp.pkgdefs.registra_alteracao('amesp',
                                    'cm_base_dados_wpd',
                                    :old.id_base_dados,
                                    'fl_especialidade_totalcare',
                                    :old.fl_especialidade_totalcare,
                                    :new.fl_especialidade_totalcare,
                                    'historicos');
end;
/




ALTER TRIGGER "AMESP"."CM_BASE_DADOS_WPD_TGU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CM_ESTRATRISCO_TGD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."CM_ESTRATRISCO_TGD" 
after delete on amesp.cm_estratificacao_risco
for each row
	begin
  amesp.pkgdefs.identifica_usuario;
  insert into historicos.cm_estratificacao_risco_dl
    (data_hora_utc_del,id_usuario,osuser,machine,id_risco,cd_risco,nm_risco,id_escala_risco,nr_risco)
  values
    (localtimestamp at time zone 'UTC',amesp.pkgdefs.guser,amesp.pkgdefs.gosuser,amesp.pkgdefs.gmachine,:old.id_risco,:old.cd_risco,:old.nm_risco,:old.id_escala_risco,:old.nr_risco);
END;
/
ALTER TRIGGER "AMESP"."CM_ESTRATRISCO_TGD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CM_ESTRATRISCO_TGI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."CM_ESTRATRISCO_TGI" 
before insert on amesp.cm_estratificacao_risco
for each row
begin
  :new.id_risco := amesp.pkgdefs.nova_chave_log('amesp','cm_estratificacao_risco');
  amesp.pkgdefs.registra_inclusao('amesp','cm_estratificacao_risco',:new.id_risco,'historicos');
end;
/
ALTER TRIGGER "AMESP"."CM_ESTRATRISCO_TGI" ENABLE;

--------------------------------------------------------
--  DDL for Trigger CM_ESTRATRISCO_TGU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."CM_ESTRATRISCO_TGU" 
AFTER UPDATE ON amesp.cm_estratificacao_risco
FOR EACH ROW
BEGIN
  amesp.pkgdefs.IDENTIFICA_USUARIO;
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','cm_estratificacao_risco',:old.id_risco,'cd_risco',:old.cd_risco,:new.cd_risco,'historicos');
  amesp.pkgdefs.REGISTRA_ALTERACAO('amesp','cm_estratificacao_risco',:old.id_risco,'nm_risco',:old.nm_risco,:new.nm_risco,'historicos');
END;

/
ALTER TRIGGER "AMESP"."CM_ESTRATRISCO_TGU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CM_FILIAL_TGD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."CM_FILIAL_TGD" 
AFTER DELETE ON amesp.cm_filial
FOR EACH ROW
	BEGIN
  amesp.pkgdefs.IDENTIFICA_USUARIO;
  INSERT INTO historicos.cm_filial_dl
    (data_hora_utc_del,id_usuario,osuser,machine,id_filial,nm_filial,fl_ativo)
  VALUES
    (localtimestamp at time zone 'UTC',amesp.pkgdefs.gUser,amesp.pkgdefs.gOSUser,amesp.pkgdefs.gMachine,:old.id_filial,:old.nm_filial,:old.fl_ativo);
END;
/
ALTER TRIGGER "AMESP"."CM_FILIAL_TGD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CM_FILIAL_TGI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMESP"."CM_FILIAL_TGI" 
BEFORE INSERT ON amesp.cm_filial
FOR EACH ROW
BEGIN
  :new.id_filial := amesp.pkgdefs.NOVA_CHAVE_LOG('amesp','cm_filial');
  amesp.pkgdefs.REGISTRA_INCLUSAO('amesp','cm_filial',:new.id_filial,'historicos');
END;

/
ALTER TRIGGER "AMESP"."CM_FILIAL_TGI" ENABLE;

