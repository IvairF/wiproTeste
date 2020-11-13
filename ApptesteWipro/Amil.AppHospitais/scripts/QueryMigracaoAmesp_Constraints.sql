alter table AMESP.AA_ESPECIALIDADES
  add constraint PK_AAESPECIALIDADES primary key (CODIGO);
alter table AMESP.AA_ESPECIALIDADES
  add constraint AA_ESPECIALIDADES_DESC_UK unique (ESPECIALIDADE);
alter table AMESP.AA_ESPECIALIDADES
  add constraint AA_ESPECIALIDADES_UK unique (ID_CHAVE);
/*alter table AMESP.AA_ESPECIALIDADES
  add constraint AA_ESPECIALIDADES_CLASS_BI_FK foreign key (ID_ESPEC_CLASSIFICACAO_BI)
  references AMESP.AA_ESPEC_CLASSIFICACAO_BI (ID_ESPEC_CLASSIFICACAO_BI);
alter table AMESP.AA_ESPECIALIDADES
  add constraint AA_ESPECIALIDADES_CLI_FK foreign key (ID_CLINICA)
  references AMESP.GLB_CLINICA (ID_CLINICA);
alter table AMESP.AA_ESPECIALIDADES
  add constraint AA_ESPECIALIDADES_GRP_BI_FK foreign key (ID_ESPEC_GRUPO_BI)
  references AMESP.AA_ESPEC_GRUPO_BI (ID_ESPEC_GRUPO_BI);
alter table AMESP.AA_ESPECIALIDADES
  add constraint AA_ESPECIALIDADES_ID_EVENTO_FK foreign key (ID_EVENTO_CONDUTA)
  references AMESP.GLB_EVENTO (ID_EVENTO);
alter table AMESP.AA_ESPECIALIDADES
  add constraint AA_ESPECIALIDADE_ID_EV_ESP_FK foreign key (ID_EVENTO_ESPECIALIDADE)
  references AMESP.GLB_EVENTO_ESPECIALIDADE (ID_EVENTO_ESPECIALIDADE);
alter table AMESP.AA_ESPECIALIDADES
  add constraint AA_ESPEC_ID_TISS_FK foreign key (ID_TISS)
  references AMESP.GLB_TISS (ID_TISS);
alter table AMESP.AA_ESPECIALIDADES
  add constraint SCM_CLASSIF_OCUPACOES_FK foreign key (ID_OCUPACAO)
  references AMESP.CLASSIFICACAO_OCUPACOES_OLD_DR (ID_OCUPACAO);*/
alter table AMESP.AA_ESPECIALIDADES
  add check (TIPO IN ('E','P','X'));
alter table AMESP.AA_ESPECIALIDADES
  add check (TIPO IN ('E','P','X'));

  alter table AMESP.ACESSO_LOGIN
  add constraint ACESSO_LOGIN_PK primary key (ID_USUARIO);
alter table AMESP.ACESSO_LOGIN
  add constraint ACESSO_LOGIN_NOME_UK unique (NOME);
alter table AMESP.ACESSO_LOGIN
  add constraint ACESSO_LOGIN_NOME_NN
  check ("NOME" IS NOT NULL);
alter table AMESP.ACESSO_LOGIN
  add constraint ACESSO_LOGIN_STATUS_CK
  check (usuario_inativo in ('S', '*'));

  alter table AMESP.ACESSO_CHAVE_ATIVACAO
  add constraint ACESSO_CHAVE_ATIVACAO_PK primary key (CD_CHAVE);
/*alter table AMESP.ACESSO_CHAVE_ATIVACAO
  add constraint ACESSO_CHAVEATIV_SISTEMA_FK foreign key (ID_SISTEMA)
  references AMESP.ACESSO_SISTEMAS (ID_SISTEMA);*/
alter table AMESP.ACESSO_CHAVE_ATIVACAO
  add constraint ACESSO_CHAVEATIV_USUARIO_FK foreign key (ID_USUARIO)
  references AMESP.ACESSO_LOGIN (ID_USUARIO);
alter table AMESP.ACESSO_CHAVE_ATIVACAO
  add constraint ACESSO_CHAVEATIV_ATIVADA_CK
  check (fl_ativada in (0,1));

/*alter table AMESP.ACESSO_SISTEMA_VERSOES
  add constraint ACESSO_SISTEMA_VERSOES_FK1 foreign key (ID_SISTEMA)
  references AMESP.ACESSO_SISTEMAS (ID_SISTEMA);
alter table AMESP.ACESSO_SISTEMA_VERSOES
  add constraint ACSEXE_ACSSISVRS_IDEXE_FK foreign key (ID_EXECUTAVEL)
  references AMESP.ACESSO_EXECUTAVEL (ID_EXECUTAVEL);*/
alter table AMESP.ACESSO_SISTEMA_VERSOES
  add constraint ACSSISVRS_ATIVO_CK
  check (ativo in (0,1));
alter table AMESP.ACESSO_SISTEMA_VERSOES
  add constraint ACSSISVRS_ATV_DTTERM_CK
  check ((ativo = 0 and data_termino is not null) or (ativo = 1 and data_termino is null));
alter table AMESP.ACESSO_SISTEMA_VERSOES
  add constraint ACSSISVRS_IDSIS_IDEXE_CK
  check ((id_executavel is not null and id_sistema is null) or (id_executavel is null and id_sistema is not null));


alter table AMESP.CM_BASE_DADOS_WPD
  add constraint CM_BASE_DADOS_WPD_PK primary key (ID_BASE_DADOS);
alter table AMESP.CM_BASE_DADOS_WPD
  add constraint CM_BASEWPD_ALIAS_UK unique (ALIAS);

alter table AMESP.CM_ESCALA_RISCO
  add constraint CM_ESCALA_RISCO_PK primary key (ID_ESCALA_RISCO);
alter table AMESP.CM_ESCALA_RISCO
  add constraint CM_ESCALARISCO_NOME_UK unique (NM_ESCALA_RISCO);

alter table AMESP.CM_ESTRATIFICACAO_RISCO
  add constraint CM_ESTRATIFICACAO_RISCO_PK primary key (ID_RISCO);
alter table AMESP.CM_ESTRATIFICACAO_RISCO
  add constraint CM_ESTRATRISCO_ESC_COD_UK unique (ID_ESCALA_RISCO, CD_RISCO);
alter table AMESP.CM_ESTRATIFICACAO_RISCO
  add constraint CM_ESTRATRISCO_ESC_NOM_UK unique (ID_ESCALA_RISCO, NM_RISCO);
alter table AMESP.CM_ESTRATIFICACAO_RISCO
  add constraint CM_ESTRATRISCO_ESC_NUM_UK unique (ID_ESCALA_RISCO, NR_RISCO);
alter table AMESP.CM_ESTRATIFICACAO_RISCO
  add constraint CM_ESTRATRISCO_ESCALA_FK foreign key (ID_ESCALA_RISCO)
  references AMESP.CM_ESCALA_RISCO (ID_ESCALA_RISCO);

alter table AMESP.CM_FILIAL
  add constraint CM_FILIAL_PK primary key (ID_FILIAL);
alter table AMESP.CM_FILIAL
  add constraint CM_FILIAL_NM_FILIAL_UK unique (NM_FILIAL);
alter table AMESP.CM_FILIAL
  add constraint CM_FILIAL_FL_ATIVO_CK
  check (fl_ativo in (0, 1));

alter table AMESP.ESTADOS
  add primary key (ID_UF);
/*alter table AMESP.ESTADOS
  add constraint ESTADOS_REGIAO_FK foreign key (ID_REGIAO)
  references AMESP.REGIAO (ID_REGIAO);*/

alter table AMESP.GLB_FUSO_HORARIO
  add constraint GLB_FUSO_HORARIO_PK primary key (ID_FUSO_HORARIO);

  
alter table AMESP.CM_FILIAL_UF
  add constraint CM_FILIAL_UF_PK primary key (ID_FILIAL_UF);
alter table AMESP.CM_FILIAL_UF
  add constraint CM_FILIAL_UF_ID_UF_UK unique (ID_UF);
alter table AMESP.CM_FILIAL_UF
  add constraint CM_FILIAL_UF_FUSO_FK foreign key (ID_FUSO_HORARIO)
  references AMESP.GLB_FUSO_HORARIO (ID_FUSO_HORARIO);
alter table AMESP.CM_FILIAL_UF
  add constraint CM_FILIAL_UF_ID_FILIAL_FK foreign key (ID_FILIAL)
  references AMESP.CM_FILIAL (ID_FILIAL);
alter table AMESP.CM_FILIAL_UF
  add constraint CM_FILIAL_UF_ID_UF_FK foreign key (ID_UF)
  references AMESP.ESTADOS (ID_UF);
alter table AMESP.CM_FILIAL_UF
  add constraint CM_FILIAL_UF_FL_ATIVO_CK
  check (fl_ativo in (0, 1));

  
alter table AMESP.CM_REGIONAL
  add constraint CM_REGIONAL_PK primary key (ID_REGIONAL);
alter table AMESP.CM_REGIONAL
  add constraint CM_REGIONAL_FIL_UF_REGIONAL_UK unique (ID_FILIAL_UF, NM_REGIONAL);
alter table AMESP.CM_REGIONAL
  add constraint CM_REGIONAL_ID_FILIAL_FK foreign key (ID_FILIAL_UF)
  references AMESP.CM_FILIAL_UF (ID_FILIAL_UF);
alter table AMESP.CM_REGIONAL
  add constraint CM_REGIONAL_FL_ATIVO_CK
  check (fl_ativo in (0, 1));

  
alter table AMESP.GLB_CONFIG_DATABASE
  add constraint GLB_CONFIG_DATABASE_PK primary key (ID_CONFIG_DATABASE);
alter table AMESP.GLB_CONFIG_DATABASE
  add constraint GLB_CONFDB_ID_CONFIG_DB_UK unique (ID_CONFIG, ID_DATABASE);
/*alter table AMESP.GLB_CONFIG_DATABASE
  add constraint GLB_CONFDB_DATABASE_FK foreign key (ID_DATABASE)
  references AMESP.GLB_DATABASE (ID_DATABASE);
alter table AMESP.GLB_CONFIG_DATABASE
  add constraint GLB_CONFDB_ID_CONFIG_FK foreign key (ID_CONFIG)
  references AMESP.GLB_CONFIG (ID_CONFIG);*/

  
alter table AMESP.INI_CONFIG
  add constraint INI_CONFIG_PK primary key (ID_CHAVE);
alter table AMESP.INI_CONFIG
  add constraint INI_CONFIG_FK1 foreign key (ID_USUARIO)
  references AMESP.ACESSO_LOGIN (ID_USUARIO);
/*alter table AMESP.INI_CONFIG
  add constraint INI_CONFIG_FK2 foreign key (ID_UNIDADE)
  references AMESP.CM_PARAMETROS (CENTRO_MEDICO);*/

  
alter table AMESP.NOW_UNIDADE
  add constraint NOW_UNIDADE_PK primary key (ID_UNIDADE);
alter table AMESP.NOW_UNIDADE
  add constraint NOW_UNIDADE_BASECOD_UK unique (ID_BASE, CD_UNIDADE);
alter table AMESP.NOW_UNIDADE
  add constraint NOW_UNIDADE_NOME_UK unique (NM_UNIDADE);
alter table AMESP.NOW_UNIDADE
  add constraint NOW_UNIDADE_ESCALA_FK foreign key (ID_ESCALA_RISCO)
  references AMESP.CM_ESCALA_RISCO (ID_ESCALA_RISCO);
alter table AMESP.NOW_UNIDADE
  add constraint NOW_UNIDADE_ID_BASE_FK foreign key (ID_BASE)
  references AMESP.CM_BASE_DADOS_WPD (ID_BASE_DADOS);
alter table AMESP.NOW_UNIDADE
  add constraint NOW_UNIDADE_ID_REGIONAL_FK foreign key (ID_REGIONAL)
  references AMESP.CM_REGIONAL (ID_REGIONAL);
alter table AMESP.NOW_UNIDADE
  add constraint NOW_UNIDADE_FL_ATIVA_CK
  check (fl_ativa in (0, 1));

alter table AMESP.NOW_FASE
  add constraint NOW_FASE_PK primary key (ID_FASE);
alter table AMESP.NOW_FASE
  add constraint NOW_FASE_NOME_UK unique (NM_FASE);

alter table AMESP.NOW_UNIDADE_FASE
  add constraint NOW_UNIDADE_FASE_PK primary key (ID_UNIDADE_FASE);
alter table AMESP.NOW_UNIDADE_FASE
  add constraint NOW_UNIDFASE_UNID_NOME_UK unique (ID_UNIDADE, NM_UNIDADE_FASE);
alter table AMESP.NOW_UNIDADE_FASE
  add constraint NOW_UNIDFASE_ID_FASE_FK foreign key (ID_FASE)
  references AMESP.NOW_FASE (ID_FASE);
alter table AMESP.NOW_UNIDADE_FASE
  add constraint NOW_UNIDFASE_ID_UNIDADE_FK foreign key (ID_UNIDADE)
  references AMESP.NOW_UNIDADE (ID_UNIDADE);

  
alter table AMESP.NOW_UNIDADE_FASE_PERIODO
  add constraint NOW_UNIDADE_FASE_PERIODO_PK primary key (ID_UNIDADE_FASE_PERIODO);
alter table AMESP.NOW_UNIDADE_FASE_PERIODO
  add constraint NOW_UNIDFASEPER_UNDFASEMIN_UK unique (ID_UNIDADE_FASE, QT_MINUTOS_INFERIOR);
alter table AMESP.NOW_UNIDADE_FASE_PERIODO
  add constraint NOW_UNIDFASEPER_UNIDFASE_FK foreign key (ID_UNIDADE_FASE)
  references AMESP.NOW_UNIDADE_FASE (ID_UNIDADE_FASE);

  
alter table AMESP.NOW_CONTAGEM_PACIENTES
  add constraint NOW_CONTAGEM_PACIENTES_PK primary key (ID_CONTAGEM_PACIENTES);
alter table AMESP.NOW_CONTAGEM_PACIENTES
  add constraint NOW_CONTPAC_RISCO_FK foreign key (ID_RISCO)
  references AMESP.CM_ESTRATIFICACAO_RISCO (ID_RISCO) on delete cascade;
alter table AMESP.NOW_CONTAGEM_PACIENTES
  add constraint NOW_CONTPAC_UNIDFASEPER_FK foreign key (ID_UNIDADE_FASE_PERIODO)
  references AMESP.NOW_UNIDADE_FASE_PERIODO (ID_UNIDADE_FASE_PERIODO) on delete cascade;

  
alter table AMESP.NOW_ESPECIALIDADES
  add constraint NOW_ESPECIALIDADES_PK primary key (ID_ESPECIALIDADE);
alter table AMESP.NOW_ESPECIALIDADES
  add constraint NOW_ESPECIALIDADES_CHAVESP_UK unique (ID_CHAVE_ESPECIALIDADE);
alter table AMESP.NOW_ESPECIALIDADES
  add constraint NOW_ESPECIALIDADES_SG_ESP_UK unique (SG_ESPECIALIDADE);
alter table AMESP.NOW_ESPECIALIDADES
  add constraint NOW_ESPECIALIDADES_CHAVESP_FK foreign key (ID_CHAVE_ESPECIALIDADE)
  references AMESP.AA_ESPECIALIDADES (ID_CHAVE);

  
alter table AMESP.NOW_UNIDADE_DIVISAO
  add constraint NOW_UNIDADE_DIVISAO_PK primary key (ID_UNIDADE_DIVISAO);
alter table AMESP.NOW_UNIDADE_DIVISAO
  add constraint NOW_UNIDDIV_UNID_DIV_FK unique (ID_UNIDADE, NM_DIVISAO);
alter table AMESP.NOW_UNIDADE_DIVISAO
  add constraint NOW_UNIDDIV_UNIDADE_FK foreign key (ID_UNIDADE)
  references AMESP.NOW_UNIDADE (ID_UNIDADE);

  
alter table AMESP.NOW_UNIDADE_ESPECIALIDADE
  add constraint NOW_UNIDADE_ESPECIALIDADE_PK primary key (ID_UNIDADE_ESPECIALIDADE);
alter table AMESP.NOW_UNIDADE_ESPECIALIDADE
  add constraint NOW_UNIDESPEC_UNID_CDESPEC_UK unique (ID_UNIDADE, CD_ESPEC_UNIDADE);
alter table AMESP.NOW_UNIDADE_ESPECIALIDADE
  add constraint NOW_UNIDESPEC_UNID_ESPEC_UK unique (ID_UNIDADE, ID_CHAVE_ESPECIALIDADE);
alter table AMESP.NOW_UNIDADE_ESPECIALIDADE
  add constraint NOW_UNIDESPEC_CHAVEESPEC_FK foreign key (ID_CHAVE_ESPECIALIDADE)
  references AMESP.AA_ESPECIALIDADES (ID_CHAVE);
alter table AMESP.NOW_UNIDADE_ESPECIALIDADE
  add constraint NOW_UNIDESPEC_ID_UNIDADE_FK foreign key (ID_UNIDADE)
  references AMESP.NOW_UNIDADE (ID_UNIDADE);

alter table AMESP.NOW_ESPECIALIDADE_DIVISAO
  add constraint NOW_ESPECIALIDADE_DIVISAO_PK primary key (ID_ESPECIALIDADE_DIVISAO);
alter table AMESP.NOW_ESPECIALIDADE_DIVISAO
  add constraint NOW_ESPDIV_UNIDDIV_FK foreign key (ID_UNIDADE_DIVISAO)
  references AMESP.NOW_UNIDADE_DIVISAO (ID_UNIDADE_DIVISAO);
alter table AMESP.NOW_ESPECIALIDADE_DIVISAO
  add constraint NOW_ESPDIV_UNIDESP_FK foreign key (ID_UNIDADE_ESPECIALIDADE)
  references AMESP.NOW_UNIDADE_ESPECIALIDADE (ID_UNIDADE_ESPECIALIDADE);

  
alter table AMESP.NOW_FASE_SUMARIO
  add constraint NOW_FASE_SUMARIO_PK primary key (ID_FASE_SUMARIO);
alter table AMESP.NOW_FASE_SUMARIO
  add constraint NOW_FASESUM_UNIDDIF_FASE_UK unique (ID_UNIDADE_DIVISAO, ID_FASE);
alter table AMESP.NOW_FASE_SUMARIO
  add constraint NOW_FASESUM_FASE_FK foreign key (ID_FASE)
  references AMESP.NOW_FASE (ID_FASE) on delete cascade;
alter table AMESP.NOW_FASE_SUMARIO
  add constraint NOW_FASESUM_UNIDDIV_FK foreign key (ID_UNIDADE_DIVISAO)
  references AMESP.NOW_UNIDADE_DIVISAO (ID_UNIDADE_DIVISAO) on delete cascade;
alter table AMESP.NOW_FASE_SUMARIO
  add constraint NOW_FASESUM_AGUARDA_CK
  check (FL_AGUARDA_FEEDBACK IN (0, 1));
alter table AMESP.NOW_FASE_SUMARIO
  add constraint NOW_FASESUM_STQUANT_CK
  check (ST_QUANTIDADE IN (1, 2, 3));
alter table AMESP.NOW_FASE_SUMARIO
  add constraint NOW_FASESUM_STTEMPO_CK
  check (ST_TEMPO IN (1, 2, 3));

  
alter table AMESP.NOW_FEEDBACK_PACIENTE
  add constraint NOW_FEEDBACK_PACIENTE_PK primary key (ID_FEEDBACK_PACIENTE);
alter table AMESP.NOW_FEEDBACK_PACIENTE
  add constraint NOW_FDBKPAC_UNID_SEN_DHFB_UK unique (ID_UNIDADE, ID_SENHA, DH_FEEDBACK);
alter table AMESP.NOW_FEEDBACK_PACIENTE
  add constraint NOW_FDBKPAC_UNID_FK foreign key (ID_UNIDADE)
  references AMESP.NOW_UNIDADE (ID_UNIDADE);
alter table AMESP.NOW_FEEDBACK_PACIENTE
  add constraint NOW_FDBKPAC_DATAS_CK
  check ((DH_SOLICITACAO IS NOT NULL OR DH_FEEDBACK IS NOT NULL) AND DH_FEEDBACK > DH_SOLICITACAO);

  
alter table AMESP.NOW_GRUPO
  add constraint NOW_GRUPO_PK primary key (ID_GRUPO);

alter table AMESP.NOW_GRUPO_UNIDADE
  add constraint NOW_GRUPO_UNIDADE_PK primary key (ID_GRUPO_UNIDADE);
alter table AMESP.NOW_GRUPO_UNIDADE
  add constraint NOW_GRUPO_UNIDADE_GRUPO foreign key (ID_GRUPO)
  references AMESP.NOW_GRUPO (ID_GRUPO);
alter table AMESP.NOW_GRUPO_UNIDADE
  add constraint NOW_GRUPO_UNIDADE_UNIDADE foreign key (ID_UNIDADE)
  references AMESP.NOW_UNIDADE (ID_UNIDADE);

  
alter table AMESP.NOW_TEMPO_ESPEC_RISCO
  add constraint NOW_TEMPO_ESPEC_RISCO_PK primary key (ID_TEMPO_ESPEC_RISCO);
alter table AMESP.NOW_TEMPO_ESPEC_RISCO
  add constraint NOW_TEMPOFASE_ID_RISCO_FK foreign key (ID_RISCO)
  references AMESP.CM_ESTRATIFICACAO_RISCO (ID_RISCO);
alter table AMESP.NOW_TEMPO_ESPEC_RISCO
  add constraint NOW_TMPOESPRSC_UNIDESPEC_FK foreign key (ID_UNIDADE_ESPECIALIDADE)
  references AMESP.NOW_UNIDADE_ESPECIALIDADE (ID_UNIDADE_ESPECIALIDADE);

  
alter table AMESP.NOW_TEMPO_FASE_RISCO
  add constraint NOW_TEMPO_FASE_RISCO_PK primary key (ID_TEMPO_FASE_RISCO);
alter table AMESP.NOW_TEMPO_FASE_RISCO
  add constraint NOW_TMPFASERISC_RISCO_FK foreign key (ID_RISCO)
  references AMESP.CM_ESTRATIFICACAO_RISCO (ID_RISCO);
alter table AMESP.NOW_TEMPO_FASE_RISCO
  add constraint NOW_TMPFASERISC_UNIDFASE_FK foreign key (ID_UNIDADE_FASE)
  references AMESP.NOW_UNIDADE_FASE (ID_UNIDADE_FASE);

  
alter table AMESP.NOW_UNIDADE_FASE_ESPEC
  add constraint NOW_UNIDADE_FASE_ESPEC_PK primary key (ID_UNIDADE_FASE_ESPEC);
alter table AMESP.NOW_UNIDADE_FASE_ESPEC
  add constraint NOW_UNIDFASEESP_UNIDFASEESP_UK unique (ID_UNIDADE_FASE, ID_UNIDADE_ESPECIALIDADE);
alter table AMESP.NOW_UNIDADE_FASE_ESPEC
  add constraint NOW_UNIDFASEESP_UNID_ESP_FK foreign key (ID_UNIDADE_ESPECIALIDADE)
  references AMESP.NOW_UNIDADE_ESPECIALIDADE (ID_UNIDADE_ESPECIALIDADE);
alter table AMESP.NOW_UNIDADE_FASE_ESPEC
  add constraint NOW_UNIDFASEESP_UNID_FASE_FK foreign key (ID_UNIDADE_FASE)
  references AMESP.NOW_UNIDADE_FASE (ID_UNIDADE_FASE);

  
alter table AMESP.NOW_UNIDADE_FASE_SUMARIO
  add constraint NOW_UNIDADE_FASE_SUMARIO_PK primary key (ID_UNIDADE_FASE_SUMARIO);
alter table AMESP.NOW_UNIDADE_FASE_SUMARIO
  add constraint NOW_UNIFASESUM_UNIFASE_UK unique (ID_UNIDADE_FASE);
alter table AMESP.NOW_UNIDADE_FASE_SUMARIO
  add constraint NOW_UNIFASESUM_UNIFA_FK foreign key (ID_UNIDADE_FASE)
  references AMESP.NOW_UNIDADE_FASE (ID_UNIDADE_FASE);
alter table AMESP.NOW_UNIDADE_FASE_SUMARIO
  add constraint NOW_UNI_FASESUM_AGUARDA_CK
  check (FL_AGUARDA_FEEDBACK IN (0,1));
alter table AMESP.NOW_UNIDADE_FASE_SUMARIO
  add constraint NOW_UNI_FASESUM_STQUANT_CK
  check (ST_QUANTIDADE IN (1, 2, 3));
alter table AMESP.NOW_UNIDADE_FASE_SUMARIO
  add constraint NOW_UNI_FASESUM_STTEMPO_CK
  check (ST_TEMPO IN (1, 2, 3));
  
alter table AMESP.NOW_UNIDADE_USUARIO
  add constraint NOW_UNIDADE_USUARIO_PK primary key (ID_UNIDADE_USUARIO);
alter table AMESP.NOW_UNIDADE_USUARIO
  add constraint NOW_UNIDUSU_GRUPO_FK foreign key (ID_GRUPO)
  references AMESP.NOW_GRUPO (ID_GRUPO);
alter table AMESP.NOW_UNIDADE_USUARIO
  add constraint NOW_UNIDUSU_UNIDADE_FK foreign key (ID_UNIDADE)
  references AMESP.NOW_UNIDADE (ID_UNIDADE);
alter table AMESP.NOW_UNIDADE_USUARIO
  add constraint NOW_UNIDUSU_USUARIO_FK foreign key (ID_USUARIO)
  references AMESP.ACESSO_LOGIN (ID_USUARIO);

  
alter table AMESP.WF_HISTORICO
  add constraint WF_HISTORICO_PK primary key (ID_CHAVE, MODULO, DATA_INCLUSAO, ID_STATUS);
/*alter table AMESP.WF_HISTORICO
  add constraint WF_HISTORICO_FK2 foreign key (ID_STATUS)
  references AMESP.WF_STATUS (ID_STATUS);*/
alter table AMESP.WF_HISTORICO
  add constraint WF_HISTORICO_FK3 foreign key (ID_USUARIO)
  references AMESP.ACESSO_LOGIN (ID_USUARIO);
/*alter table AMESP.WF_HISTORICO
  add constraint WF_HISTORICO_OCORRENCIA_FK foreign key (ID_OCORRENCIA)
  references AMESP.WF_OCORRENCIA (ID_OCORRENCIA);*/
  
  
alter table AMESP.PROFISSIONAL_SAUDE_PROPRIO
  add constraint AA_PSP_ID_PROFISSIONAL_PK primary key (ID_PROFISSIONAL);
/*alter table AMESP.PROFISSIONAL_SAUDE_PROPRIO
  add constraint AA_PSP_ID_PROFISSIONAL_FK foreign key (ID_PROFISSIONAL)
  references AMESP.GLB_PROFISSIONAL_SAUDE (ID_PROFISSIONAL);*/
alter table AMESP.PROFISSIONAL_SAUDE_PROPRIO
  add constraint AA_PSP_CORINGA_CK
  check (coringa in ('S', 'N') );
alter table AMESP.PROFISSIONAL_SAUDE_PROPRIO
  add constraint AA_PSP_REFERENCIA_CK
  check (referencia in ('S', 'N') );
