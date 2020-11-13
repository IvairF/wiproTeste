var Especialidade = {
    Titulo: '',
    Urls: {
        PesquisaEspecialidades: '',
        ManutencaoEspecialidade: '',
        EspecialidadeCodigoBaseModal: "",
        ExclusaoEspecialidade: '',
        GerarToken: '',
        ValidarAcessoPesquisa: ''
    },

    Mensagens:
       {
           SucessoGravacao: '',
           ConfirmacaoExclusao: '',
           PreenchaDescricao: ''
       }
};

var PesquisaEspecialidade =
{
    GridEspecialidade: null,

    Mensagens:
    {
        ConfirmacaoExclusao: '',
        SucessoExclusao: ''
    },
    Inicializar: function () {
        PesquisaEspecialidade.Pesquisar();
    },
    Limpar: function () {
        $('#txtDescricaoFiltro').val('');
        $('#txtDescricaoFiltro').focus();
        $('#dttEspecialidades').hide();


        AmilFramework.Common.OpenAjaxURL(Especialidade.Urls.PesquisaEspecialidades + "?" + "limpar=S");
    },



    LimparModal: function () {
        $('#txtNomeFiltro').val('');
        $('#especialidadesModal').modal('hide');
        

    },

    LimparCodigoBaseModal: function () {
        $('#codigoBaseModal').modal('hide');

    },

    Incluir: function () {

        $.ajax({
            url: Especialidade.Urls.ValidarAcessoPesquisa,
            type: 'POST',
            data: {},
            success: function (data) {
                if (!data.Erro) {
                    AmilFramework.Common.EncryptQueryUrl("idEspecialidade=0", function (data) {
                        AmilFramework.Common.OpenAjaxURL(Especialidade.Urls.ManutencaoEspecialidade + "?" + data);
                    });

                }
                else {
                    var buttons2 = [{
                        text: "Fechar",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }];

                    AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Especialidade.Titulo);
                }
            }
        });
    },
    Visualizar: function (id, nome) {
        $('#dttEspecialidades').hide();
        //AmilFramework.Common.EncryptQueryUrl("idUnidade=" + id + "&limpar=S" + "&modal=S", function (data) {
        AmilFramework.Common.OpenAjaxURL(Especialidade.Urls.EspecialidadeCodigoBaseModal + "?idEspecialidade=" + id + "&nome=nome");
        //    AmilFramework.Common.OpenAjaxURL(Unidade.Urls.PesquisaUnidade + "?" + data);
        //});
    },
    Alterar: function (id) {
        AmilFramework.Common.EncryptQueryUrl("idEspecialidade=" + id, function (data) {
            AmilFramework.Common.OpenAjaxURL(Especialidade.Urls.ManutencaoEspecialidade + "?" + data);
        });

    },
    Excluir: function (id, desc) {

        var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');

                            $.ajax({
                                url: Especialidade.Urls.ExclusaoEspecialidade,
                                type: 'POST',
                                data:
                                    {
                                        idEspecialidade: id
                                    },
                                success: function (data) {
                                    if (!data.Erro) {
                                        PesquisaEspecialidade.Pesquisar();
                                        var buttons1 = [{
                                            text: "Fechar",
                                            cssClass: 'btn btn-primary btn-outline',
                                            close: true
                                        }];

                                        AmilFramework.Alert.Create(0, PesquisaEspecialidade.Mensagens.SucessoExclusao, 400, buttons1, Especialidade.Titulo);
                                    } else {
                                        var buttons2 = [{
                                            text: "Fechar",
                                            cssClass: 'btn btn-primary btn-outline',
                                            close: true
                                        }];

                                        AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Especialidade.Titulo);
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


        AmilFramework.Alert.Create(2, Especialidade.Mensagens.ConfirmacaoExclusao.replace('#', ' a Especialidade ' + desc), 400, buttons);
    },
    Pesquisar: function (modal) {
        var nome = $("#txtNomeFiltro").val();
        var tipoConsulta = $("#ddlTipoFiltro").val();

        var buttons = [{
            text: "Fechar",
            cssClass: 'btn btn-primary btn-outline',
            close: true
        }];

        if (modal) {
            var actions = [
                {
                    Collumn: 'Acoes',
                    Buttons: {
                        Visualizar: {
                            Action: { Function: 'PesquisaUnidade.Visualizar', Parameter: ['SpecialtyId', 'Specialty'] },
                            Layout: { Default: { Title: 'Visualizar', CssClass: 'fa fa-file-o margin2' } }
                        },

                    }
                }
            ];
        }
        else {

            var actions = [
                {
                    Collumn: 'Acoes',
                    Buttons: {
                        Editar: {
                            Action: { Function: 'PesquisaEspecialidade.Alterar', Parameter: ['SpecialtyId'] },
                            Layout: { Default: { Title: 'Alterar', CssClass: 'fa fa-edit margin2' } }
                        },
                        Excluir: {
                            Action: { Function: 'PesquisaEspecialidade.Excluir', Parameter: ['SpecialtyId', 'Specialty'] },
                            Layout: {
                                Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                            }
                        }
                    }
                }
            ];
        }

        $.ajax({
            url: Especialidade.Urls.ValidarAcessoPesquisa,
            type: 'POST',
            success: function (data) {
                if (!data.Erro) {

                    if (modal) {
                        PesquisaEspecialidade.GridEspecialidades = new AmilGrid('grvEspecialidadesModal', Especialidade.Urls.PesquisaEspecialidades, { tipoConsulta: tipoConsulta, nome: nome }, actions);
                        PesquisaEspecialidade.GridEspecialidades.Create();
                    }
                    else {
                        PesquisaEspecialidade.GridEspecialidades = new AmilGrid('grvEspecialidades', Especialidade.Urls.PesquisaEspecialidades, { tipoConsulta: tipoConsulta, nome: nome }, actions);
                        PesquisaEspecialidade.GridEspecialidades.Create();
                    }

                    $('#dttEspecialidades').show();
                }
                else {
                    var buttons2 = [{
                        text: "Fechar",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }];

                    AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Especialidade.Titulo);
                }
            }
        });




    }
};

var ManutencaoEspecialidade = {
    IdEspecialidade: 0,
    Inicializar: function () {
        IdEspecialidade = $('#Id').val()
        $('#Descricao').focus();

        if (IdEspecialidade > 0) {
            $("#btnAssociarModulo").show();
            $("#Codigo").attr("disabled", "disabled");
        }
        else {
            $("#Codigo").prop("disabled", false);
        }
    },
    Voltar: function () {
        AmilFramework.Common.OpenAjaxURL(Especialidade.Urls.PesquisaEspecialidades);
    },

    Salvar: function () {
        var formValido = AmilFramework.Form.Validation.IsValid('#frmManutencaoEspecialidade');

        if (formValido) {
            var descricao = $('#Descricao').val();
            var codigo = $('#Codigo').val();
            var idEspecialidade = $('#Id').val();

            var EspecialidadeModel = {
                Id: idEspecialidade,
                Descricao: descricao,
                Codigo: codigo,
            };

            var json = JSON.stringify(EspecialidadeModel);

            $.ajax({
                url: Especialidade.Urls.ManutencaoEspecialidade,
                type: 'POST',
                data:
                    {
                        json: json
                    },
                success: function (data) {

                    if (!data.Erro) {
                        $("#btnAssociarModulo").show();
                        $("#Id").val(data.Result.Id);
                        $("#Codigo").attr("disabled", "disabled");
                        $("#IdSistema").attr("disabled", "disabled");
                        var buttons = [{
                            text: "Fechar",
                            cssClass: 'btn btn-primary btn-outline',
                            click: function () {
                                $('.modal-backdrop.fade.in').hide();
                                $('.modal.fade.bs-example-modal-lg.Success.in').hide();
                            }
                        }];
                        AmilFramework.Alert.Create(0, Especialidade.Mensagens.SucessoGravacao, 400, buttons, Especialidade.Titulo);
                    } else {
                        var buttons = [{
                            text: "Fechar",
                            cssClass: 'btn btn-primary btn-outline',
                            close: true
                        }];

                        AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Especialidade.Titulo);
                    }
                }
            });
            //    }
            //});

        }
    }
};

