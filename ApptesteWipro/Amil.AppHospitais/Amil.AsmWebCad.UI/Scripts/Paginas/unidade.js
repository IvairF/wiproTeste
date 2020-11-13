var Unidade = {
    Titulo: '',
    Urls: {
        PesquisaUnidades: '',
        ExclusaoUnidade: '',
        ManutencaoUnidade: '',

        PesquisarDocumento: '',
        InclusaoDocumentos: '',
        PesquisarDocumentoUnidade: '',
        ExcluirDocumentoUnidade: '',

        PesquisarUnidade: '',
        InclusaoEspecialidade: '',
        PesquisarEspecialidadeUnidade: '',
        ExcluirEspecialidadeUnidade: '',

        //AL
        GerarToken: ''
    },
    Mensagens:
       {
           SucessoGravacao: '',
           ConfirmacaoExclusao: '',
           ConfirmaInativacao: '',
           AlertaNome3Caracteres: '',
           AlertaPesquisaComCampos: ''
       },
    Descricoes:
        {
            DocumentosObrigatorios: ''
        }
};

var PesquisaUnidade =
{
    GridUnidades: null,
    Mensagens:
    {
        ConfirmacaoExclusao: '',
        SucessoExclusao: '',
        ConfirmaInativacao: ''
    },
    Inicializar: function () {
        $('#txtNomeFiltro').focus();
        $('#dttUnidades').hide();
    },
    Limpar: function () {
        $('#txtNomeFiltro').val('');
        $('#txtTipoUnidadeFiltro').val('');
        $('#txtStatusFiltro').val('');
        $('#txtCodigoIntegracao').val('');
        $('#txtNomeFiltro').focus();
        $('#dttUnidades').hide();
    },
    Incluir: function () {
        AmilFramework.Common.EncryptQueryUrl("idUnidade=0", function (data) {
            AmilFramework.Common.OpenAjaxURL(Unidade.Urls.ManutencaoUnidade + "?" + data);
        });
    },
    Alterar: function (id) {
        AmilFramework.Common.EncryptQueryUrl("idUnidade=" + id, function (data) {
            AmilFramework.Common.OpenAjaxURL(Unidade.Urls.ManutencaoUnidade + "?" + data);
        });
    },
    //Visualizar: function (id) {
    //    AmilFramework.Common.OpenAjaxURL(Unidade.Urls.ManutencaoUnidade + "?idUnidade=" + id + "&visualiza=1");
    //},
    Excluir: function (id) {
        var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');

                            $.ajax({
                                url: Unidade.Urls.GerarToken,
                                type: 'POST',
                                data: {},
                                success: function (token) {
                                    $.ajax({
                                        url: Unidade.Urls.ExclusaoUnidade,
                                        type: 'POST',
                                        data:
                                            {
                                                idUnidade: id,
                                                token: token
                                            },
                                        success: function (data) {
                                            if (!data.Erro) {
                                                PesquisaUnidade.Pesquisar();
                                                var buttons1 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true
                                                }];

                                                AmilFramework.Alert.Create(0, PesquisaUnidade.Mensagens.SucessoExclusao, 400, buttons1, Unidade.Titulo);
                                            } else {
                                                var buttons2 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true
                                                }];

                                                AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Unidade.Titulo);
                                            }
                                        }
                                    });
                                }
                            });


                            //$.ajax({
                            //    url: Unidade.Urls.ExclusaoUnidade,
                            //    type: 'POST',
                            //    data:
                            //        {
                            //            idUnidade: id
                            //        },
                            //    success: function (data) {
                            //        if (!data.Erro) {
                            //            PesquisaUnidade.Pesquisar();
                            //            var buttons1 = [{
                            //                text: "Fechar",
                            //                cssClass: 'btn btn-primary btn-outline',
                            //                close: true
                            //            }];

                            //            AmilFramework.Alert.Create(0, PesquisaUnidade.Mensagens.SucessoExclusao, 400, buttons1, Unidade.Titulo);
                            //        } else {
                            //            var buttons2 = [{
                            //                text: "Fechar",
                            //                cssClass: 'btn btn-primary btn-outline',
                            //                close: true
                            //            }];

                            //            AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Unidade.Titulo);
                            //        }
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

        AmilFramework.Alert.Create(2, Unidade.Mensagens.ConfirmacaoExclusao, 400, buttons);
    },
    Pesquisar: function () {
        var nome = $("#txtNomeFiltro").val();
        var idTipoUnidade = $("#ddlTipoUnidadeFiltro").val();
        var ativo = $("#ddlStatusFiltro").val();
        var codIntegracao = $('#txtCodigoIntegracao').val();

        if (nome.toString().trim().length >= 1 && nome.toString().trim().length < 3) {
            //O campo nome precisa ter pelo menos 3 caracteres para realizar a busca

            var buttons = [{
                text: "Fechar",
                cssClass: 'btn btn-primary btn-outline',
                close: true
                //click: function () {
                //    AmilFramework.Common.OpenAjaxURL(Unidade.Urls.PesquisaUnidades);
                //}
            }];

            AmilFramework.Alert.Create(0, PesquisaUnidade.Mensagens.AlertaNome3Caracteres, 400, buttons, Unidade.Titulo);

            return;

        }

        //Algum desses itens precisão estar preenchidos para 
        if (nome.trim() == '' && codIntegracao == '' && idTipoUnidade == '' && ativo == '') {

            var buttons = [{
                text: "Fechar",
                cssClass: 'btn btn-primary btn-outline',
                close: true
                //click: function () {
                //    AmilFramework.Common.OpenAjaxURL(Unidade.Urls.PesquisaUnidades);
                //}
            }];

            AmilFramework.Alert.Create(0, PesquisaUnidade.Mensagens.AlertaPesquisaComCampos, 400, buttons, Unidade.Titulo);

            return;
        }


        var actions = [
            {
                Collumn: 'Acoes',
                Buttons: {
                    //Visualizar: {
                    //    Action: { Function: 'PesquisaUnidade.Visualizar', Parameter: ['Id'] },
                    //    Layout: { Default: { Title: 'Visualizar', CssClass: 'fa fa-edit margin2' } }
                    //},
                    Editar: {
                        Action: { Function: 'PesquisaUnidade.Alterar', Parameter: ['Id'] },
                        Layout: { Default: { Title: 'Alterar', CssClass: 'fa fa-edit margin2' } }
                    },
                    Excluir: {
                        Action: { Function: 'PesquisaUnidade.Excluir', Parameter: ['Id'] },
                        Layout: {
                            Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                        }
                    }
                }
            }
        ];

        //Obtem o token e envia para validação durante a pesquisa.
        var tkn = '';
        $.ajax({
            url: Unidade.Urls.GerarToken,
            type: 'POST',
            data: {},
            success: function (data) {
                PesquisaUnidade.GridUnidades = new AmilGrid('grvUnidades', Unidade.Urls.PesquisaUnidades, { nome: nome, idTipoUnidade: idTipoUnidade, ativo: ativo, codigoCorporativo: codIntegracao, token: data }, actions);
                PesquisaUnidade.GridUnidades.Create();
            }
        });
        //----------------------------------------------------------

        //var tok = $('[name=__RequestVerificationToken]').val();

        //PesquisaUnidade.GridUnidades = new AmilGrid('grvUnidades', Unidade.Urls.PesquisaUnidades, { nome: nome, idTipoUnidade: idTipoUnidade, ativo: ativo, codigoCorporativo: codIntegracao, token: tkn }, actions);
        //PesquisaUnidade.GridUnidades.Create();

        $('#dttUnidades').show();
    },
};

var ManutencaoUnidade = {
    IdUnidade: 0,
    GridUnidadesDocs: null,
    GridUnidadesEspec: null,

    Urls:{
        //AL
        GerarToken: ''
    },

    Inicializar: function () {

        IdUnidade = $('#Id').val();
        ManutencaoUnidade.IdUnidade = $('#Id').val();

        if (IdUnidade == 0) {

            $('#especialidade-form').hide();
            $('#docs-form').hide();

            $('#dttUnidades').hide();
            $('#dttDocumentos').hide();
            $('#dttEspecUnidades').hide();
            $('#dttEspecialidades').show();
        }
        else {
            ManutencaoUnidade.PesquisarDocumentoUnidade();
            ManutencaoUnidade.PesquisarEspecialidadeUnidade();
        }

        $('#Descricao').focus();
    },
    IncluirDocs: function () {
        $('#DocumentosObrigatoriosModal').modal();
        $('#dttDocumentos').hide();

        setTimeout(
          function () {
              $('#txtPesquisaDocumento').focus();
              $("#txtPesquisaDocumento").val('');
          }, 500);
    },
    IncluirEspec: function () {
        $('#EspecialidadeObrigatoriosModal').modal();
        $('#dttEspecialidades').hide();

        setTimeout(
          function () {
              $('#txtPesquisaEspecialidade').focus();
              $("#txtPesquisaEspecialidade").val('');
          }, 500);
    },

    PesquisarDocumento: function () {
        var documento = $("#txtPesquisaDocumento").val();

        var actions = [
            {
                Collumn: 'Acao',
                Buttons: {
                    Incluir: {
                        Action: { Function: 'ManutencaoUnidade.IncluirDocumentoUnidade', Parameter: ['Descricao'] },
                        Layout: {
                            Default: { Title: 'Incluir', CssClass: 'fa fa-check margin2' }
                        }
                    },
                }
            }
        ];

        $.ajax({
            url: Unidade.Urls.GerarToken,
            type: 'POST',
            data: {},
            success: function (token) {
                ManutencaoUnidade.GridUnidadesDocs = new AmilGrid('grvDocumentos', Unidade.Urls.PesquisarDocumento, { documento: documento, idUnidade: ManutencaoUnidade.IdUnidade, token: token }, actions);
                ManutencaoUnidade.GridUnidadesDocs.Create();
            }
        });

        $('#dttDocumentos').show();
    },
    IncluirDocumentoUnidade: function (documento) {
        $.ajax({
            url: Unidade.Urls.GerarToken,
            type: 'POST',
            data: {},
            success: function (token) {
                $.ajax({
                    url: Unidade.Urls.InclusaoDocumentos,
                    type: 'POST',
                    data:
                        {
                            idUnidade: IdUnidade,
                            documento: documento,
                            token: token
                        },
                    success: function (data) {
                        if (!data.Erro) {
                            ManutencaoUnidade.PesquisarDocumentoUnidade();
                            var buttons = [{
                                text: "Fechar",
                                cssClass: 'btn btn-primary btn-outline',
                                close: true
                            }];
                            ManutencaoUnidade.PesquisarDocumento();
                            AmilFramework.Alert.Create(0, Unidade.Mensagens.SucessoGravacao, 400, buttons, Unidade.Titulo);

                        } else {
                            var buttons = [{
                                text: "Fechar",
                                cssClass: 'btn btn-primary btn-outline',
                                close: true
                            }];

                            AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Unidade.Titulo);
                        }
                    }
                });
            }
        });



        //$.ajax({
        //    url: Unidade.Urls.InclusaoDocumentos,
        //    type: 'POST',
        //    data:
        //        {
        //            idUnidade: IdUnidade,
        //            documento: documento
        //        },
        //    success: function (data) {
        //        if (!data.Erro) {
        //            ManutencaoUnidade.PesquisarDocumentoUnidade();
        //            var buttons = [{
        //                text: "Fechar",
        //                cssClass: 'btn btn-primary btn-outline',
        //                close: true
        //            }];
        //            ManutencaoUnidade.PesquisarDocumento();
        //            AmilFramework.Alert.Create(0, Unidade.Mensagens.SucessoGravacao, 400, buttons, Unidade.Titulo);

        //        } else {
        //            var buttons = [{
        //                text: "Fechar",
        //                cssClass: 'btn btn-primary btn-outline',
        //                close: true
        //            }];

        //            AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Unidade.Titulo);
        //        }
        //    }
        //});
    },
    PesquisarDocumentoUnidade: function () {
        var actions = [
            {
                Collumn: 'Acao',
                Buttons: {
                    Excluir: {
                        Action: { Function: 'ManutencaoUnidade.ExcluirDocumentoUnidade', Parameter: ['Id'] },
                        Layout: {
                            Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                        }
                    }
                }
            }
        ];

        //$.ajax({
        //    url: Unidade.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                ManutencaoUnidade.GridUnidadesDocs = new AmilGrid('grvDocUnidades', Unidade.Urls.PesquisarDocumentoUnidade, { idUnidade: IdUnidade }, actions);
                ManutencaoUnidade.GridUnidadesDocs.Create();
        //    }
        //});

        $('#docs-form').show();
        $('#dttDocsUnidades').show();

    },
    ExcluirDocumentoUnidade: function (idDocumentoUnidade) {
        var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');


                            //$.ajax({
                            //    url: Unidade.Urls.GerarToken,
                            //    type: 'POST',
                            //    data: {},
                            //    success: function (token) {
                                    $.ajax({
                                        url: Unidade.Urls.ExcluirDocumentoUnidade,
                                        type: 'POST',
                                        data:
                                            {
                                                idDocumentoUnidade: idDocumentoUnidade
                                            },
                                        success: function (data) {
                                            if (!data.Erro) {
                                                ManutencaoUnidade.PesquisarDocumentoUnidade();
                                                var buttons1 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true
                                                }];

                                                AmilFramework.Alert.Create(0, PesquisaUnidade.Mensagens.SucessoExclusao, 400, buttons1, Unidade.Titulo);
                                            } else {
                                                var buttons2 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true
                                                }];

                                                AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Unidade.Titulo);
                                            }
                                        }
                                    });

                            //    }
                            //});





                            //$.ajax({
                            //    url: Unidade.Urls.ExcluirDocumentoUnidade,
                            //    type: 'POST',
                            //    data:
                            //        {
                            //            idDocumentoUnidade: idDocumentoUnidade
                            //        },
                            //    success: function (data) {
                            //        if (!data.Erro) {
                            //            ManutencaoUnidade.PesquisarDocumentoUnidade();
                            //            var buttons1 = [{
                            //                text: "Fechar",
                            //                cssClass: 'btn btn-primary btn-outline',
                            //                close: true
                            //            }];

                            //            AmilFramework.Alert.Create(0, PesquisaUnidade.Mensagens.SucessoExclusao, 400, buttons1, Unidade.Titulo);
                            //        } else {
                            //            var buttons2 = [{
                            //                text: "Fechar",
                            //                cssClass: 'btn btn-primary btn-outline',
                            //                close: true
                            //            }];

                            //            AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Unidade.Titulo);
                            //        }
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

        AmilFramework.Alert.Create(2, Unidade.Mensagens.ConfirmacaoExclusao, 400, buttons);
    },

    PesquisarEspecialidade: function () {
        var especialidade = $("#txtPesquisaEspecialidade").val();

        var actions = [
             {
                 Collumn: 'Acao',
                 Buttons: {
                     Incluir: {
                         Action: { Function: 'ManutencaoUnidade.IncluirEspecialidadeUnidade', Parameter: ['Descricao'] },
                         Layout: {
                             Default: { Title: 'Incluir', CssClass: 'fa fa-check margin2' }
                         }
                     },
                 }
             }
        ];

        //$.ajax({
        //    url: Unidade.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                ManutencaoUnidade.GridUnidadesEspec = new AmilGrid('grvEspecialidades', Unidade.Urls.PesquisarEspecialidade, { especialidade: especialidade }, actions);
                ManutencaoUnidade.GridUnidadesEspec.Create();
        //    }
        //});

        $('#dttEspecialidades').show();

    },
    IncluirEspecialidadeUnidade: function (especialidade) {

        //$.ajax({
        //    url: Unidade.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                $.ajax({
                    url: Unidade.Urls.InclusaoEspecialidade,
                    type: 'POST',
                    data:
                        {
                            idUnidade: IdUnidade,
                            especialidade: especialidade
                        },
                    success: function (data) {
                        if (!data.Erro) {
                            ManutencaoUnidade.PesquisarEspecialidadeUnidade();
                            var buttons = [{
                                text: "Fechar",
                                cssClass: 'btn btn-primary btn-outline',
                                close: true
                            }];

                            AmilFramework.Alert.Create(0, Unidade.Mensagens.SucessoGravacao, 400, buttons, Unidade.Titulo);

                        } else {
                            var buttons = [{
                                text: "Fechar",
                                cssClass: 'btn btn-primary btn-outline',
                                close: true
                            }];

                            AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Unidade.Titulo);
                        }
                    }
                });

        //    }
        //});


        //$.ajax({
        //    url: Unidade.Urls.InclusaoEspecialidade,
        //    type: 'POST',
        //    data:
        //        {
        //            idUnidade: IdUnidade,
        //            especialidade: especialidade
        //        },
        //    success: function (data) {
        //        if (!data.Erro) {
        //            ManutencaoUnidade.PesquisarEspecialidadeUnidade();
        //            var buttons = [{
        //                text: "Fechar",
        //                cssClass: 'btn btn-primary btn-outline',
        //                close: true
        //            }];

        //            AmilFramework.Alert.Create(0, Unidade.Mensagens.SucessoGravacao, 400, buttons, Unidade.Titulo);

        //        } else {
        //            var buttons = [{
        //                text: "Fechar",
        //                cssClass: 'btn btn-primary btn-outline',
        //                close: true
        //            }];

        //            AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Unidade.Titulo);
        //        }
        //    }
        //});
    },
    PesquisarEspecialidadeUnidade: function () {
        var actions = [
            {
                Collumn: 'Acao',
                Buttons: {
                    Excluir: {
                        Action: { Function: 'ManutencaoUnidade.ExcluirEspecialidadeUnidade', Parameter: ['Id'] },
                        Layout: {
                            Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                        }
                    }
                }
            }
        ];

        //$.ajax({
        //    url: Unidade.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                ManutencaoUnidade.GridUnidadesEspec = new AmilGrid('grvEspecUnidades', Unidade.Urls.PesquisarEspecialidadeUnidade, { idUnidade: IdUnidade }, actions);
                ManutencaoUnidade.GridUnidadesEspec.Create();
        //    }
        //});

        $('#especialidade-form').show();
        $('#dttEspecUnidades').show();
    },
    ExcluirEspecialidadeUnidade: function (idEspecialidadeUnidade) {
        var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');


                            //$.ajax({
                            //    url: Unidade.Urls.GerarToken,
                            //    type: 'POST',
                            //    data: {},
                            //    success: function (token) {
                                    $.ajax({
                                        url: Unidade.Urls.ExcluirEspecialidadeUnidade,
                                        type: 'POST',
                                        data:
                                            {
                                                idEspecialidadeUnidade: idEspecialidadeUnidade
                                            },
                                        success: function (data) {
                                            if (!data.Erro) {
                                                ManutencaoUnidade.PesquisarEspecialidadeUnidade();
                                                var buttons1 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true
                                                }];

                                                AmilFramework.Alert.Create(0, PesquisaUnidade.Mensagens.SucessoExclusao, 400, buttons1, Unidade.Titulo);
                                            } else {
                                                var buttons2 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true
                                                }];

                                                AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Unidade.Titulo);
                                            }
                                        }
                                    });

                            //    }
                            //});


                            //$.ajax({
                            //    url: Unidade.Urls.ExcluirEspecialidadeUnidade,
                            //    type: 'POST',
                            //    data:
                            //        {
                            //            idEspecialidadeUnidade: idEspecialidadeUnidade,
                            //        },
                            //    success: function (data) {
                            //        if (!data.Erro) {
                            //            ManutencaoUnidade.PesquisarEspecialidadeUnidade();
                            //            var buttons1 = [{
                            //                text: "Fechar",
                            //                cssClass: 'btn btn-primary btn-outline',
                            //                close: true
                            //            }];

                            //            AmilFramework.Alert.Create(0, PesquisaUnidade.Mensagens.SucessoExclusao, 400, buttons1, Unidade.Titulo);
                            //        } else {
                            //            var buttons2 = [{
                            //                text: "Fechar",
                            //                cssClass: 'btn btn-primary btn-outline',
                            //                close: true
                            //            }];

                            //            AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Unidade.Titulo);
                            //        }
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

        AmilFramework.Alert.Create(2, Unidade.Mensagens.ConfirmacaoExclusao, 400, buttons);
    },

    Voltar: function () {
        AmilFramework.Common.OpenAjaxURL(Unidade.Urls.PesquisaUnidades);
    },
    Salvar: function () {

        var formValido = AmilFramework.Form.Validation.IsValid('#frmManutencaoUnidade');

        //if (formValido) {
        //    var descricao = $('#Descricao').val();
        //    var codigoIntegracao = $('#CodigoIntegracao').val();
        //    var idTipoUnidade = $("#IdTipoUnidade :selected").val();
        //    var ativo = $("#Ativo :selected").val();
        //    var possuiIntegracao = $("#PossuiIntegracao").val();
        //    var idUnidade = $('#Id').val();

        //    $.ajax({
        //        url: Unidade.Urls.ManutencaoUnidade,
        //        type: 'POST',
        //        data:
        //            {
        //                idUnidade: idUnidade,
        //                descricao: descricao,
        //                codigoIntegracao: codigoIntegracao,
        //                idTipoUnidade: idTipoUnidade,
        //                ativo: ativo,
        //                possuiIntegracao: possuiIntegracao
        //            },
        //        success: function (data) {
        //            if (!data.Erro) {
        //                var buttons = [{
        //                    text: "Fechar",
        //                    cssClass: 'btn btn-primary btn-outline',
        //                    click: function () {
        //                        AmilFramework.Common.OpenAjaxURL(Unidade.Urls.PesquisaUnidades);
        //                    }
        //                }];

        //                AmilFramework.Alert.Create(0, Unidade.Mensagens.SucessoGravacao, 400, buttons, Unidade.Titulo);
        //            } else {
        //                var buttons = [{
        //                    text: "Fechar",
        //                    cssClass: 'btn btn-primary btn-outline',
        //                    close: true
        //                }];

        //                AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Unidade.Titulo);
        //            }
        //        }
        //    });
        //}

        if (formValido) {

            var descricao = $('#Descricao').val();
            var codigoIntegracao = $('#CodigoIntegracao').val();
            var idTipoUnidade = $("#IdTipoUnidade :selected").val();
            var ativo = $("#Ativo :selected").val();
            //var possuiIntegracao = $("#PossuiIntegracao").val();
            var possuiIntegracao = 0;
            if ($("#chkPossuiIntegracao").prop("checked")) {
                possuiIntegracao = 1;
            }

            var idUnidade = $('#Id').val();
            var UnidadeAtiva = $('#UnidadeAtiva').val();

            var SalvarGrupo = function () {
                $.ajax({
                    url: Unidade.Urls.ManutencaoUnidade,
                    type: 'POST',
                    data:
                        {
                            idUnidade: idUnidade,
                            descricao: descricao,
                            codigoIntegracao: codigoIntegracao,
                            idTipoUnidade: idTipoUnidade,
                            ativo: ativo,
                            possuiIntegracao: possuiIntegracao
                        },
                    success: function (data) {
                        if (!data.Erro) {
                            var buttons = [{
                                text: "Fechar",
                                cssClass: 'btn btn-primary btn-outline',
                                click: function () {
                                    AmilFramework.Common.OpenAjaxURL(Unidade.Urls.PesquisaUnidades);
                                }
                            }];

                            AmilFramework.Alert.Create(0, Unidade.Mensagens.SucessoGravacao, 400, buttons, Unidade.Titulo);
                        } else {
                            var buttons = [{
                                text: "Fechar",
                                cssClass: 'btn btn-primary btn-outline',
                                close: true
                            }];

                            AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Unidade.Titulo);
                        }
                    }
                });
            }

            if (UnidadeAtiva == 'False') {
                //Já era desativada, não precisa dar mensagem para qualquer Save
                //AL
                //$.ajax({
                //    url: Unidade.Urls.GerarToken,
                //    type: 'POST',
                //    data: {},
                //    success: function (data) {
                        //SalvarGrupo(data);
                //    }
                //});

                SalvarGrupo();
            }
            else {
                //Era ativo
                if (ativo != 'false') {
                    //AL
                    //$.ajax({
                    //    url: Unidade.Urls.GerarToken,
                    //    type: 'POST',
                    //    data: {},
                    //    success: function (data) {
                    //        SalvarGrupo(data);
                    //    }
                    //});
                    SalvarGrupo();
                } else {
                    //Inativar 
                    var buttonValidar = [{
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');
                            //AL
                            $.ajax({
                                url: Unidade.Urls.GerarToken,
                                type: 'POST',
                                data: {},
                                success: function (data) {
                                    SalvarGrupo(data);
                                }
                            });
                            //SalvarGrupo();
                        }
                    },
                    {
                        text: "Não",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }];

                    var str = Unidade.Mensagens.ConfirmaInativacao;
                    var res = str.replace("_descricao_", descricao);

                    AmilFramework.Alert.Create(2, res, 400, buttonValidar);
                }
            }

        }
    }
};