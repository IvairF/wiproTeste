var TipoDocumento = {
    Titulo: 'Tipo de Documento',
    Urls: {
        PesquisaTipoDocumento: '',
        InclusaoTipoDocumento: '',
        ManutecaoTipoDocumento: '',
        ExclusaoTipoDocumento: '',
        //AL
        //GerarToken: ''
    },
    Mensagens:
       {
           SucessoGravacao: '',
           ConfirmacaoExclusao: '',
           SucessoExclusao: ''
       }
};

var PesquisaTipoDocumento =
{
    GridTipoDocumento: null,
    Inicializar: function () {
        $('#txtDescricaoFiltro').focus();
        $('#dttTipoDocumento').hide();
    },
    Limpar: function () {
        $('#txtDescricaoFiltro').val('');
        $('#txtStatusFiltro').val('');
        $('#dttTipoDocumento').hide();
    },
    Pesquisar: function () {

        var descricao = $("#txtDescricaoFiltro").val();
        var status = $("#ddlStatusFiltro").val();
        var dataEmissao = $("#ddlDataEmissaoFiltro").val();
        var restrito = $("#ddlRestritoFiltro").val();

        var actions = [
            {
                Collumn: 'Acoes',
                Buttons: {
                    //Visualizar: {
                    //    Action: { Function: 'PesquisaTipoDocumento.Alterar', Parameter: ['Id'] },
                    //    Layout: { Default: { Title: 'Visualizar', CssClass: 'fa fa-check margin2' } }
                    //},
                    Editar: {
                        Action: { Function: 'PesquisaTipoDocumento.Alterar', Parameter: ['Id'] },
                        Layout: { Default: { Title: 'Alterar', CssClass: 'fa fa-edit margin2' } }
                    },
                    Excluir: {
                        Action: { Function: 'PesquisaTipoDocumento.Excluir', Parameter: ['Id'] },
                        Layout: {
                            Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                        }
                    }
                }
            }
        ];

        //$.ajax({
        //    url: TipoDocumento.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
        //PesquisaTipoDocumento.GridTipoDocumento = new AmilGrid('grvTipoDocumento', TipoDocumento.Urls.PesquisaTipoDocumento, { descricao: descricao, status: status, restrito: restrito, dataEmissao: dataEmissao, token: token }, actions);
        //PesquisaTipoDocumento.GridTipoDocumento.Create();
        //    }
        //});

        PesquisaTipoDocumento.GridTipoDocumento = new AmilGrid('grvTipoDocumento', TipoDocumento.Urls.PesquisaTipoDocumento, { descricao: descricao, status: status, restrito: restrito, dataEmissao: dataEmissao }, actions);
        PesquisaTipoDocumento.GridTipoDocumento.Create();

        $('#dttTipoDocumento').show();
    },
    Incluir: function () {
        AmilFramework.Common.EncryptQueryUrl("idTipoDocumento=0", function (data) {
            AmilFramework.Common.OpenAjaxURL(TipoDocumento.Urls.ManutencaoTipoDocumento + "?" + data);
        });
    },
    Alterar: function (id) {
        AmilFramework.Common.EncryptQueryUrl("idTipoDocumento=" + id, function (data) {
            AmilFramework.Common.OpenAjaxURL(TipoDocumento.Urls.ManutencaoTipoDocumento + "?" + data);
        });
    },
    Excluir: function (id) {

        var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');
                            //$.ajax({
                            //    url: TipoDocumento.Urls.GerarToken,
                            //    type: 'POST',
                            //    data: {},
                            //    success: function (token) {
                                    $.ajax({
                                        url: TipoDocumento.Urls.ExclusaoTipoDocumento,
                                        type: 'POST',
                                        data:
                                            {
                                                idTipoDocumento: id//, token: token
                                            },
                                        success: function (data) {
                                            if (!data.Erro) {
                                                PesquisaTipoDocumento.Pesquisar();
                                                var buttons1 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true
                                                }];

                                                AmilFramework.Alert.Create(0, TipoDocumento.Mensagens.SucessoExclusao, 400, buttons1, TipoDocumento.Titulo);
                                            } else {
                                                var buttons2 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true
                                                }];

                                                AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, TipoDocumento.Titulo);
                                            }
                                        }
                                    });
                            //    }
                            //});
                        }
                    },
                    {
                        text: "Não",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }
        ];

        AmilFramework.Alert.Create(2, TipoDocumento.Mensagens.ConfirmacaoExclusao, 400, buttons);
    }
};

var ManutencaoTipoDocumento = {
    IdTipoDocumento: 0,
    GridPesquisaTipoDocumento: null,
    Inicializar: function () {

        var descricao = $('#Descricao').val();
        var dataEmissao = $("#DataEmissao :selected").val();
        var restrito = $("#Restrito :selected").val();

        ManutencaoTipoDocumento.MostrarQuantidadeMeses(dataEmissao);

        if (restrito == "true") {
            $("#Obrigatorio").prop('disabled', true);
        }
        else {
            $("#Obrigatorio").prop('disabled', false);
        }


        if (descricao == '') {
            $('#Descricao').prop('disabled', false);
            $('#Descricao').focus();
        }
        /* else {
             $('#Descricao').prop('disabled', true);
         }*/
    },
    Voltar: function () {
        AmilFramework.Common.OpenAjaxURL(TipoDocumento.Urls.PesquisaTipoDocumento);
    },
    Salvar: function () {
        var formValido = AmilFramework.Form.Validation.IsValid('#frmManutencaoTipoDocumento');

        if (formValido) {
            var descricao = $('#Descricao').val();
            var restrito = $("#Restrito :selected").val();
            var obrigatorio = $("#Obrigatorio :selected").val();
            var ativo = $("#Ativo :selected").val();
            var idTipoDocumento = $('#Id').val();
            var dataEmissao = $("#DataEmissao :selected").val();
            var qtdMesesValidade = $('#QtdMesesValidade').val();
            //$.ajax({
            //    url: TipoDocumento.Urls.GerarToken,
            //    type: 'POST',
            //    data: {},
            //    success: function (token) {
                    $.ajax({
                        url: TipoDocumento.Urls.Manutencao,
                        type: 'POST',
                        data:
                            {
                                idTipoDocumento: idTipoDocumento,
                                descricao: descricao,
                                restrito: restrito,
                                obrigatorio: obrigatorio,
                                ativo: ativo,
                                dataEmissao: dataEmissao,
                                qtdMesesValidade: qtdMesesValidade,
                                //token: token
                            },
                        success: function (data) {
                            if (!data.Erro) {
                                var buttons = [{
                                    text: "Fechar",
                                    cssClass: 'btn btn-primary btn-outline',
                                    click: function () {
                                        AmilFramework.Common.OpenAjaxURL(TipoDocumento.Urls.PesquisaTipoDocumento);
                                    }
                                }];

                                AmilFramework.Alert.Create(0, TipoDocumento.Mensagens.SucessoGravacao, 400, buttons, TipoDocumento.Titulo);
                            } else {
                                var buttons = [{
                                    text: "Fechar",
                                    cssClass: 'btn btn-primary btn-outline',
                                    close: true
                                }];

                                AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, TipoDocumento.Titulo);
                            }
                        }
                    });
            //    }
            //});
        }
    },
    MostrarQuantidadeMeses: function (item) {
        if (item == "true") {
            $('.qntMeses').show();
        }
        else
            if (item == "false") {
                $('.qntMeses').hide();
                $('#QtdMesesValidade').val('');
            }
    },
    ValidarObrigatoriedade: function (item) {
        if (item == "true") {
            $("#Obrigatorio").val('false');
            $("#Obrigatorio").prop('disabled', true);
        }
        else {
            $("#Obrigatorio").prop('disabled', false);
        }

    }
};
