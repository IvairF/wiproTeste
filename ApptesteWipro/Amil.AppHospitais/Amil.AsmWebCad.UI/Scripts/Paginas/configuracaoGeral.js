var Configuracao = {
    Titulo: '',
    Urls: {
        Manutencao: '',
        GerarToken: ''
    }
    ,
    Mensagens:
       {
           SucessoGravacao: '',
           MensagemAviso: '',
           ErroDadosInvalidos: ''
       }
};

var Manutencao = {

    Mensagens:
    {
        SucessoGravacao: ''
    },

    Inicializar: function () {

    },

    Voltar: function () {
        AmilFramework.Common.OpenAjaxURL(Configuracao.Urls.HomeResumo);
    },

    Salvar: function () {

        var formValido = AmilFramework.Form.Validation.IsValid('#frmManutencaoConfiguracao');

        if (formValido) {

            var configs = [];

            for (var i = 0; i <= 2; i++) {

                var config = { IdTipoConfiguracao: $('#IdTipoConfiguracao' + i).val(), Id: $('#Id' + i).val(), Chave: $('#Chave' + i).val(), Valor: $('#Valor' + i).val() };
                configs[i] = config
            }
            ////Obtem o token e envia para validação durante a pesquisa.
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
            //                    configs: configs,
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
                        configs: configs
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

