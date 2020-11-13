var WorkFlow = {
    Titulo: '',
    Urls: {
        PesquisaWorkFlowHabilitacao: '',
        PesquisaWorkFlowAprovacao: '',
        ProfissionalManutencao: '',
        ValidarProfissionalLock: ''
    },
    Mensagens:
       {
           SucessoGravacao: '',
           ConfirmacaoExclusao: ''
       },
};

var WorkFlowHabilitacao =
    {
        GridWorkFlow: null,
        Inicializar: function () {
            $('#dttWorkFlow').hide();
            $('#Data').focus();
        },
        Limpar: function () {
            $('#dttWorkFlow').hide();
        },
        Pesquisar: function () {
            var nome = $('#txtNomeFiltro').val();
            var idUnidade = $('#ddlUnidadeFiltro').val();
            var statusId = $('#ddlStatusFiltro').val();
            var data = $('#Data').val();

            var buttons1 = [{
                text: "Ok",
                cssClass: 'btn btn-primary btn-outline',
                close: true
            }];

            if (idUnidade == "") {
                AmilFramework.Alert.Create(0, "Favor selecionar uma unidade", 400, buttons1, "Aviso");
            }
            else if (statusId == "" && data == "") {
                var buttons1 = [
                    {
                        text: "Ok",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }
                ];

                AmilFramework.Alert.Create(0, "Favor selecionar uma data ou um status.", 400, buttons1, "Aviso");
            } else {
                var actions = [
                    {
                        Collumn: 'Acoes',
                        Buttons: {
                            Visualizar: {
                                Action: {
                                    Function: 'WorkFlowHabilitacao.Visualizar',
                                    Parameter: ['Id', 'IdProfissional']
                                },
                                Layout: { Default: { Title: 'Visualizar', CssClass: 'fa fa-search margin2' } }
                            },
                        }
                    }
                ];
                WorkFlowHabilitacao.GridWorkFlow = new AmilGrid('grvWorkFlow', WorkFlow.Urls.PesquisaWorkFlowHabilitacao, { nome: nome, idUnidade: idUnidade, data: data, statusId: statusId }, actions);
                WorkFlowHabilitacao.GridWorkFlow.Create();
                $('#dttWorkFlow').show();
                //$.ajax({
                //    url: WorkFlow.Urls.GerarToken,
                //    type: 'POST',
                //    data: {},
                //    success: function (token) {
                //        WorkFlowHabilitacao.GridWorkFlow = new AmilGrid('grvWorkFlow', WorkFlow.Urls.PesquisaWorkFlowHabilitacao, { nome: nome, idUnidade: idUnidade, data: data, statusId: statusId, token: token }, actions);
                //        WorkFlowHabilitacao.GridWorkFlow.Create();

                //        
                //    }

                //});
            }
        },

        Visualizar: function (idProfUniEsp, idProfissional) {
            $.ajax({
                url: WorkFlow.Urls.ValidarProfissionalLock,
                type: 'POST',
                data: {
                    idProfUniEsp: idProfUniEsp,
                    idProfissional: idProfissional
                },
                success: function (data) {
                    if (data.Erro) {
                        var buttons = [{
                            text: "Fechar",
                            cssClass: "btn btn-primary btn-outline",
                            close: true
                        }];

                        AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, WorkFlow.Titulo);

                    } else {
                        AmilFramework.Common.EncryptQueryUrl("idProfUniEsp=" + idProfUniEsp + "&idProfissional=" + idProfissional + "&idTipoConselho=0&idUFConselho=0&numeroConselho=0&workflow=1&idProfissionalUsuario=0", function (data) {
                            AmilFramework.Common.OpenAjaxURL(WorkFlow.Urls.ProfissionalManutencao + "?" + data);
                        });
                    }
                }
            });
        }

    };

var WorkFlowAprovacao =
    {
        GridWorkFlow: null,
        Inicializar: function () {
            $('#dttWorkFlow').hide();
            $('#Data').focus();
        },
        Limpar: function () {
            $('#dttWorkFlow').hide();
        },
        Pesquisar: function () {
            var nome = $('#txtNomeFiltro').val();
            var idUnidade = $('#ddlUnidadeFiltro').val();
            var statusId = $('#ddlStatusFiltro').val();
            var data = $('#Data').val();

            if (idUnidade == "") {

                var buttons1 = [{
                    text: "Ok",
                    cssClass: 'btn btn-primary btn-outline',
                    close: true
                }];

                AmilFramework.Alert.Create(0, "Favor selecionar uma unidade", 400, buttons1, "Aviso");
            }
            else if (statusId == "" && data == "") {
                var buttons1 = [
                    {
                        text: "Ok",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }
                ];

                AmilFramework.Alert.Create(0, "Favor selecionar uma data ou um status.", 400, buttons1, "Aviso");
            } else {
                var actions = [
                    {
                        Collumn: 'Acoes',
                        Buttons: {
                            Visualizar: {
                                Action: {
                                    Function: 'WorkFlowAprovacao.Visualizar',
                                    Parameter: ['Id', 'IdProfissional']
                                },
                                Layout: { Default: { Title: 'Visualizar', CssClass: 'fa fa-search margin2' } }
                            },
                        }
                    }
                ];

                WorkFlowAprovacao.GridWorkFlow = new AmilGrid('grvWorkFlow', WorkFlow.Urls.PesquisaWorkFlowAprovacao, { nome: nome, idUnidade: idUnidade, data: data, statusId: statusId }, actions);
                WorkFlowAprovacao.GridWorkFlow.Create();
                $('#dttWorkFlow').show();
                //$.ajax({
                //    url: WorkFlow.Urls.GerarToken,
                //    type: 'POST',
                //    data: {},
                //    success: function (token) {
                //        WorkFlowAprovacao.GridWorkFlow = new AmilGrid('grvWorkFlow', WorkFlow.Urls.PesquisaWorkFlowAprovacao, { nome: nome, idUnidade: idUnidade, data: data, statusId: statusId, token: token }, actions);
                //        WorkFlowAprovacao.GridWorkFlow.Create();

                //        
                //    }
                //});
            }
        },
        Visualizar: function (idProfUniEsp, idProfissional) {
            $.ajax({
                url: WorkFlow.Urls.ValidarProfissionalLock,
                type: 'POST',
                data: {
                    idProfUniEsp: idProfUniEsp,
                    idProfissional: idProfissional
                },
                success: function (data) {
                    if (data.Erro) {
                        var buttons = [{
                            text: "Fechar",
                            cssClass: "btn btn-primary btn-outline",
                            close: true
                        }];

                        AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, WorkFlow.Titulo);

                    } else {
                        AmilFramework.Common.EncryptQueryUrl("idProfUniEsp=" + idProfUniEsp + "&idProfissional=" + idProfissional + "&idTipoConselho=0&idUFConselho=0&numeroConselho=0&workflow=2&idProfissionalUsuario=0", function (data) {
                            AmilFramework.Common.OpenAjaxURL(WorkFlow.Urls.ProfissionalManutencao + "?" + data);
                        });
                    }
                }

            });
        }
    };