var Configuracao = {
    Titulo: '',
    Urls: {
        Manutencao: '',
        GerarToken: ''
    }
    ,
    Mensagens:
       {
           SucessoGravacao: ''
       }
};


var Manutencao = {

    Mensagens:
    {
        SucessoGravacao: ''
    },



    SomenteNumeros: function (e)
    {
        // Allow: backspace, delete, tab, escape, enter and .
        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
            // Allow: Ctrl+A
            (e.keyCode == 65 && e.ctrlKey === true) ||
            // Allow: Ctrl+C
            (e.keyCode == 67 && e.ctrlKey === true) ||
            // Allow: Ctrl+X
            (e.keyCode == 88 && e.ctrlKey === true) ||
            // Allow: home, end, left, right
            (e.keyCode >= 35 && e.keyCode <= 39)) {
            // let it happen, don't do anything
            return;
        }
        // Ensure that it is a number and stop the keypress
        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
            e.preventDefault();
        }
    },

    Inicializar: function () {


        $("#ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC").keydown(function (e) {
            Manutencao.SomenteNumeros(e);
        });

        $("#ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC").keydown(function (e) {
            Manutencao.SomenteNumeros(e);
        });

        $("#ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC").focusout(function () {
            if ($("#ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC").val().length == 0) {
                $("#ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC").val("0");
            }
        });

        $("#ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC")
          .focusout(function () {
              if ($("#ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC").val().length == 0) {
                  $("#ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC").val("0");
              }
          });

    },

    Voltar: function () {

        //Arrumar
        AmilFramework.Common.OpenAjaxURL(Configuracao.Urls.Manutencao);
    },

    Salvar: function () {

        var formValido = AmilFramework.Form.Validation.IsValid('#frmManutencaoConfiguracao');

        if (formValido) {

            var IdTipoConfiguracao = $('#IdTipoConfiguracao').val();

            /*----Campos------*/
            var ENVIAR_EMAIL_AO_PROFISSIONAL_ANTES_VENC_DOC = $('#ENVIAR_EMAIL_AO_PROFISSIONAL_ANTES_VENC_DOC').is(':checked');

            var ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC = $('#ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC').val();
            var ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_VENC_DOC = $('#ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_VENC_DOC').is(':checked');
            var ENVIAR_EMAIL_AOS_RESPONSAVEIS_APOS_VENC_DOC = $('#ENVIAR_EMAIL_AOS_RESPONSAVEIS_APOS_VENC_DOC').is(':checked');

            var ENVIAR_SMS_AO_PROFISSIONAL_ANTES_VENC_DOC = $('#ENVIAR_SMS_AO_PROFISSIONAL_ANTES_VENC_DOC').is(':checked');
            var ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC = $('#ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC').val();
            var ENVIAR_SMS_AO_PROFISSIONAL_APOS_VENC_DOC = $('#ENVIAR_SMS_AO_PROFISSIONAL_APOS_VENC_DOC').is(':checked');

            var ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO = $('#ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO').is(':checked');
            var ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO = $('#ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO').is(':checked');

            var ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO = $('#ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO').is(':checked');
            var ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO = $('#ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO').is(':checked');

            /*----IDS-----*/
            var id_ENVIAR_EMAIL_AO_PROFISSIONAL_ANTES_VENC_DOC = $('#id_ENVIAR_EMAIL_AO_PROFISSIONAL_ANTES_VENC_DOC').val();
            var id_ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC = $('#id_ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC').val();
            var id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_VENC_DOC = $('#id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_VENC_DOC').val();
            var id_ENVIAR_EMAIL_AOS_RESPONSAVEIS_APOS_VENC_DOC = $('#id_ENVIAR_EMAIL_AOS_RESPONSAVEIS_APOS_VENC_DOC').val();

            var id_ENVIAR_SMS_AO_PROFISSIONAL_ANTES_VENC_DOC = $('#id_ENVIAR_SMS_AO_PROFISSIONAL_ANTES_VENC_DOC').val();
            var id_ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC = $('#id_ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC').val();
            var id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_VENC_DOC = $('#id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_VENC_DOC').val();

            var id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO = $('#id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO').val();
            var id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO = $('#id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO').val();

            var id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO = $('#id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO').val();
            var id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO = $('#id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO').val();            
            
            var validationButtons = [{
                text: "Fechar",
                cssClass: 'btn btn-primary btn-outline',
                close: true
            }];
            
            if (ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC < 0 || ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC > 90 || ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC < 0 || ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC > 90)
            {
                AmilFramework.Alert.Create(0, 'Os valores permitidos para os campos quantidade de dias antes do vencimento para o envio dos Alertas de E-mail ou SMS possuem limitação maxima de 90 e mínima de 0.', 400,validationButtons);
                return;
            }            
            //var tkn = '';
            //$.ajax({
            //    url: Configuracao.Urls.GerarToken,
            //    type: 'POST',
            //    data: {},
            //    success: function (token) {

            //        $.ajax({
            //            url: Configuracao.Urls.Manutencao,
            //            type: 'POST',
            //            data:
            //                {
            //                    IdTipoConfiguracao: IdTipoConfiguracao,

            //                    //**Campos
            //                    ENVIAR_EMAIL_AO_PROFISSIONAL_ANTES_VENC_DOC: ENVIAR_EMAIL_AO_PROFISSIONAL_ANTES_VENC_DOC,
            //                    ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC: ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC,
            //                    ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_VENC_DOC: ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_VENC_DOC,
            //                    ENVIAR_EMAIL_AOS_RESPONSAVEIS_APOS_VENC_DOC: ENVIAR_EMAIL_AOS_RESPONSAVEIS_APOS_VENC_DOC,

            //                    ENVIAR_SMS_AO_PROFISSIONAL_ANTES_VENC_DOC: ENVIAR_SMS_AO_PROFISSIONAL_ANTES_VENC_DOC,
            //                    ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC: ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC,
            //                    ENVIAR_SMS_AO_PROFISSIONAL_APOS_VENC_DOC: ENVIAR_SMS_AO_PROFISSIONAL_APOS_VENC_DOC,

            //                    ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO: ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO,
            //                    ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO: ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO,

            //                    ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO: ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO,
            //                    ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO: ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO,

            //                    //**Ids

            //                    id_ENVIAR_EMAIL_AO_PROFISSIONAL_ANTES_VENC_DOC: id_ENVIAR_EMAIL_AO_PROFISSIONAL_ANTES_VENC_DOC,
            //                    id_ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC: id_ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC,
            //                    id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_VENC_DOC: id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_VENC_DOC,
            //                    id_ENVIAR_EMAIL_AOS_RESPONSAVEIS_APOS_VENC_DOC: id_ENVIAR_EMAIL_AOS_RESPONSAVEIS_APOS_VENC_DOC,

            //                    id_ENVIAR_SMS_AO_PROFISSIONAL_ANTES_VENC_DOC: id_ENVIAR_SMS_AO_PROFISSIONAL_ANTES_VENC_DOC,
            //                    id_ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC: id_ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC, 
            //                    id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_VENC_DOC: id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_VENC_DOC,

            //                    id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO: id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO,
            //                    id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO: id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO,

            //                    id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO: id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO,
            //                    id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO: id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO,
            //                    token: token


            //                },
            //            success: function (data) {
            //                if (!data.Erro) {
            //                    var buttons = [{
            //                        text: "Fechar",
            //                        cssClass: 'btn btn-primary btn-outline',
            //                        click: function () {
            //                            AmilFramework.Common.OpenAjaxURL(Configuracao.Urls.Manutencao);
            //                        }
            //                    }];

            //                    AmilFramework.Alert.Create(0, Configuracao.Mensagens.SucessoGravacao, 400, buttons, Configuracao.Titulo);
            //                } else {
            //                    var buttons = [{
            //                        text: "Fechar",
            //                        cssClass: 'btn btn-primary btn-outline',
            //                        close: true
            //                    }];

            //                    AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Configuracao.Titulo);
            //                }
            //            }
            //        });
            //    }
            //});

            $.ajax({
                url: Configuracao.Urls.Manutencao,
                type: 'POST',
                data:
                    {
                        IdTipoConfiguracao: IdTipoConfiguracao,

                        //**Campos
                        ENVIAR_EMAIL_AO_PROFISSIONAL_ANTES_VENC_DOC: ENVIAR_EMAIL_AO_PROFISSIONAL_ANTES_VENC_DOC,
                        ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC: ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC,
                        ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_VENC_DOC: ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_VENC_DOC,
                        ENVIAR_EMAIL_AOS_RESPONSAVEIS_APOS_VENC_DOC: ENVIAR_EMAIL_AOS_RESPONSAVEIS_APOS_VENC_DOC,

                        ENVIAR_SMS_AO_PROFISSIONAL_ANTES_VENC_DOC: ENVIAR_SMS_AO_PROFISSIONAL_ANTES_VENC_DOC,
                        ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC: ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC,
                        ENVIAR_SMS_AO_PROFISSIONAL_APOS_VENC_DOC: ENVIAR_SMS_AO_PROFISSIONAL_APOS_VENC_DOC,

                        ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO: ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO,
                        ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO: ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO,

                        ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO: ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO,
                        ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO: ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO,

                        //**Ids

                        id_ENVIAR_EMAIL_AO_PROFISSIONAL_ANTES_VENC_DOC: id_ENVIAR_EMAIL_AO_PROFISSIONAL_ANTES_VENC_DOC,
                        id_ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC: id_ENVIAR_EMAIL_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC,
                        id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_VENC_DOC: id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_VENC_DOC,
                        id_ENVIAR_EMAIL_AOS_RESPONSAVEIS_APOS_VENC_DOC: id_ENVIAR_EMAIL_AOS_RESPONSAVEIS_APOS_VENC_DOC,

                        id_ENVIAR_SMS_AO_PROFISSIONAL_ANTES_VENC_DOC: id_ENVIAR_SMS_AO_PROFISSIONAL_ANTES_VENC_DOC,
                        id_ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC: id_ENVIAR_SMS_AO_PROFISSIONAL_QTDE_DIAS_ANTES_VENC_DOC,
                        id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_VENC_DOC: id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_VENC_DOC,

                        id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO: id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO,
                        id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO: id_ENVIAR_EMAIL_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO,

                        id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO: id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_HABILITACAO,
                        id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO: id_ENVIAR_SMS_AO_PROFISSIONAL_APOS_LIBERACAO_APROVACAO


                    },
                success: function (data) {
                    if (!data.Erro) {
                        var buttons = [{
                            text: "Fechar",
                            cssClass: 'btn btn-primary btn-outline',
                            click: function () {
                                AmilFramework.Common.OpenAjaxURL(Configuracao.Urls.Manutencao);
                            }
                        }];

                        AmilFramework.Alert.Create(0, Configuracao.Mensagens.SucessoGravacao, 400, buttons, Configuracao.Titulo);
                    } else {
                        var buttons = [{
                            text: "Fechar",
                            cssClass: 'btn btn-primary btn-outline',
                            close: true
                        }];

                        AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Configuracao.Titulo);
                    }
                }
            });
        }
    }

};

