var Unidade = {
    Titulo: '',
    Urls: {
        PesquisaUnidade: '',
        ExclusaoUnidade: '',
        ManutencaoUnidade: '',
        ValidaAcessoPesquisa: '',
        PesquisaModalEspecialidades: '',

        InclusaoEspecialidade: '',
        PesquisarEspecialidade: '',
        ExcluirEspecialidadeUnidade: '',
        EditarEspecialidadeUnidade: '',
        EspecialidadeCodigoBaseModal: '',

        PesquisarDivisaoUnidade: '',
        ExcluirDivisaoUnidade: '',

        PesquisarGrafico: '',
        CarregaFase: '',

      //AL
        GerarToken: ''
    },
    Mensagens:
       {
           SucessoGravacao: '',
           SucessoExclusao: '',
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
        ConfirmaInativacao: '',
        AlertaNome3Caracteres: ''
    },
    Inicializar: function () {
        $('#txtFiltro').focus();
        $('#dttUnidade').hide();
        PesquisaUnidade.Configurar();

        var nome = $("#txtFiltro").val();
        var tipo = $("#ddlTipoFiltro").val();
        var primeiroAcesso = $("#PrimeiroAcesso").val();

        if ((nome.trim() != '') && (primeiroAcesso == "N")) {
            PesquisaUnidade.Pesquisar();
        }
    },

    Configurar: function () {
        $('#btnPesquisa').off('click');
        $('#btnLimpar').off('click');
        $('#btnInserir').off('click');
        $('#btnPesquisa').on('click', function (e) { PesquisaUnidade.Pesquisar(); });
        $('#btnLimpar').on('click', function (e) { PesquisaUnidade.Limpar(); });
        $('#btnInserir').on('click', function (e) { PesquisaUnidade.Incluir(); });
    },

    Limpar: function () {
        $('#txtNomeFiltro').val('');
        $('#txtTipoUnidadeFiltro').val('');
        $('#txtStatusFiltro').val('');
        $('#txtCodigoIntegracao').val('');
        $('#txtNomeFiltro').focus();
        $('#dttUnidade').hide();

        AmilFramework.Common.OpenAjaxURL(Unidade.Urls.PesquisaUnidade + "?" + "limpar=S");
    },
    
    Incluir: function () {
        AmilFramework.Common.EncryptQueryUrl("idUnidade=" + 0, function (data) {
            AmilFramework.Common.OpenAjaxURL(Unidade.Urls.InclusaoEspecialidade + "?" + data);
        });
    },    

    Alterar: function (id) {
        AmilFramework.Common.EncryptQueryUrl("idUnidade=" + id, function (data) {
            AmilFramework.Common.OpenAjaxURL(Unidade.Urls.ManutencaoUnidade + "?" + data);
        });
    },

    Visualizar: function (id, nome) {

        //$('#codigoBaseModal').on('show.bs.modal', function (event) {
        $('#especialidadesModal').modal('hide');

        var modal = $('#codigoBaseModal');
        $.ajax({
            url: Unidade.Urls.EspecialidadeCodigoBaseModal,
            type: "POST",
            data: {
                idEspecialidade: id,
                nome: nome
            },
            success: function (partialView) {
                modal.find(".modal-body").html(partialView);
                modal.modal('show');
            }

        });
        // });

        //AmilFramework.Common.EncryptQueryUrl("idEspecialidade=" + id + " modal=S", function (data) {
        //AmilFramework.Common.OpenAjaxURL(Unidade.Urls.EspecialidadeCodigoBaseModal + "?idEspecialidade=" + id + "&nome=" + nome);
        //AmilFramework.Common.OpenAjaxURL(Unidade.Urls.PesquisaUnidade + "?" + data);
        //});
    },

    Excluir: function (id) {
        var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');

                            $.ajax({
                                url: Unidade.Urls.ValidarAcessoPesquisa,
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

        AmilFramework.Alert.Create(2, PesquisaUnidade.Mensagens.ConfirmacaoExclusao.replace('#', ' o perfil ' + id), 400, buttons);

        //AmilFramework.Alert.Create(2, PesquisaUnidade.Mensagens.ConfirmacaoExclusao, 400, buttons);
    },

    Pesquisar: function (modal) {
        var nome = $("#txtFiltro").val();
        var tipo = $("#ddlTipoFiltro").val();

        if (nome.toString().trim().length < 3) {
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



        ////Algum desses itens precisão estar preenchidos para 
        //if (nome.trim() == '') {

        //    var buttons = [{
        //        text: "Fechar",
        //        cssClass: 'btn btn-primary btn-outline',
        //        close: true
        //        //click: function () {
        //        //    AmilFramework.Common.OpenAjaxURL(Unidade.Urls.PesquisaUnidades);
        //        //}
        //    }];

        //    AmilFramework.Alert.Create(0, PesquisaUnidade.Mensagens.AlertaPesquisaComCampos, 400, buttons, Unidade.Titulo);

        //    return;
        //}

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
                    //Visualizar: {
                    //    Action: { Function: 'PesquisaUnidade.Visualizar', Parameter: ['Id'] },
                    //    Layout: { Default: { Title: 'Visualizar', CssClass: 'fa fa-edit margin2' } }
                    //},
                    Editar: {
                        Action: { Function: 'PesquisaUnidade.Alterar', Parameter: ['ID_UNIDADE'] },
                        Layout: { Default: { Title: 'Alterar', CssClass: 'fa fa-edit margin2' } }
                    },
                    Excluir: {
                        Action: { Function: 'PesquisaUnidade.Excluir', Parameter: ['ID_UNIDADE'] },
                        Layout: {
                            Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                        }
                    }
                }
            }
            ];
        }

        $.ajax({
            url: Unidade.Urls.ValidarAcessoPesquisa,
            type: 'POST',
            data: {},
            success: function (data) {
                if (!data.Erro) {

                    PesquisaUnidade.GridUnidade = new AmilGrid('grvUnidade', Unidade.Urls.PesquisaUnidade, { nome: nome, tipo: tipo }, actions, 15);
                    PesquisaUnidade.GridUnidade.Create();
                    $('#dttUnidade').show();
                }
                else {
                    var buttons2 = [{
                        text: "Fechar",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }];

                    AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Unidade.Titulo);
                }
            }
        });
    },
};

var ManutencaoUnidade = {
    IdUnidade: 0,
    GridUnidadesEspec: null,
    GridUnidadesDivisao: null,
    GridUnidadesGrafico : null,
    Mensagens:
    {
        ConfirmacaoExclusao: '',
        SucessoExclusao: ''
    },

    Urls: {
        //AL
        GerarToken: ''
    },

    Inicializar: function () {

        IdUnidade = $('#Id').val();
        ManutencaoUnidade.IdUnidade = $('#Id').val();
        ManutencaoUnidade.Configurar();

        if (IdUnidade == 0) {

            $('#divtatbs').hide();
        }
        else {
            $('#divtatbs').show();
            UnidadeEspecialidade.PesquisarEspecialidade();
            UnidadeDivisao.PesquisarDivisao();
            UnidadeGrafico.PesquisarGrafico();
        }

        $('#Descricao').focus();
    },

    Configurar: function () {
        $('#btnSalvar').off('click');
        $('#btnVoltar').off('click');
        $('#btnConfirmar').off('click');

        $('#btnSalvar').on('click', function (e) { ManutencaoUnidade.Salvar(); });
        $('#btnVoltar').on('click', function (e) { ManutencaoUnidade.Voltar(); });
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

    IncluirEspecialidadeUnidade: function () {
        IdUnidade = $('#Id').val();
        IdEspecialidade = $('#IdEspecialidade').val();
        CodigoBase = $('#CodigoBase').val();

        $.ajax({
            url: Unidade.Urls.IncluirEspecialidadeUnidade,
            type: 'POST',
            data:
                {
                    idUnidade: IdUnidade,
                    idEspecialidade: IdEspecialidade,
                    codigoBase: CodigoBase,
                   
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


        AmilFramework.Common.EncryptQueryUrl("idUnidade=" + IdUnidade, function (data) {
            AmilFramework.Common.OpenAjaxURL(Unidade.Urls.IncluirEspecialidadeUnidade + "?" + data);
        });
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
    },

    IncluirDivisaoModal : function () {
        $("#DivisaoModal").modal();

    }

};

// Especialidade
var UnidadeEspecialidade = {

    IncluirEspecialidadeUnidade: function () {
        IdUnidade = $('#Id').val();

        AmilFramework.Common.EncryptQueryUrl("idUnidade=" + IdUnidade, function (data) {
            AmilFramework.Common.OpenAjaxURL(Unidade.Urls.InclusaoEspecialidade + "?" + data);
        });
    },

    PesquisarEspecialidade: function () {
        IdUnidade = $('#Id').val();

        var actions = [
            {
                Collumn: 'Acoes',
                Buttons: {
                    Editar: {
                        Action: { Function: 'UnidadeEspecialidade.EditarEspecialidadeUnidade', Parameter: ['ID_UNIDADE_ESPECIALIDADE'] },
                        Layout: { Default: { Title: 'Alterar', CssClass: 'fa fa-edit margin2' } }
                    },
                    Excluir: {
                        Action: { Function: 'UnidadeEspecialidade.ExcluirEspecialidade', Parameter: ['ID_UNIDADE_ESPECIALIDADE', 'ESPECIALIDADE'] },
                        Layout: {
                            Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                        }
                    }
                }
            }
        ];

        ManutencaoUnidade.GridUnidadesEspec = new AmilGrid('grvEspecialidades', Unidade.Urls.PesquisarEspecialidade, { idUnidade: IdUnidade }, actions);
        ManutencaoUnidade.GridUnidadesEspec.Create();

        $('#dttEspeccialidades').show();
    },

    ExcluirEspecialidade: function (id, desc) {

        var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');

                            $.ajax({
                                url: Unidade.Urls.ExcluirEspecialidade,
                                type: 'POST',
                                data:
                                    {
                                        idEspecialidade: id
                                    },
                                success: function (data) {
                                    if (!data.Erro) {
                                        UnidadeEspecialidade.PesquisarEspecialidade();
                                        var buttons1 = [{
                                            text: "Fechar",
                                            cssClass: 'btn btn-primary btn-outline',
                                            close: true
                                        }];

                                        AmilFramework.Alert.Create(0, Unidade.Mensagens.SucessoExclusao, 400, buttons1, Unidade.Titulo);
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
                        }
                    },
                    {
                        text: "Não",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }
        ];


        AmilFramework.Alert.Create(2, Unidade.Mensagens.ConfirmacaoExclusao.replace('#', ' a Especialidade ' + desc), 400, buttons);
    },

    EditarEspecialidadeUnidade: function (id) {

    },

};

var UnidadeDivisao = {
    Mensagens:
    {
        SucessoGravacao: '',
    },

    Urls: {
        InclusaoDivisao: '',
    },

    Cancelar: function () {
        $("#DivisaoModal").modal("hide");
    },

    Limpar: function () {
        $("#Divisao").val("");
    },

    IncluirModal: function () {
        $("#DivisaoModal").modal();
        UnidadeDivisao.Limpar();

    },

    EditarDivisao: function (id, idDivisao) {


        var modal = $('#especialidadeUnidadeModal');
        $.ajax({
            url: Unidade.Urls.EspecialidadeUnidadeDivisaoModal,
            type: "POST",
            data: {
                IdUnidade: id,
                IdDivisao: idDivisao
            },
            success: function (partialView) {
                modal.find(".modal-body").html(partialView);
                modal.modal('show');
            }

        });

    },

    PesquisarDivisao: function () {
        IdUnidade = $('#Id').val();

        var actions = [
            {
                Collumn: 'Acoes',
                Buttons: {
                    Editar: {
                        Action: { Function: 'UnidadeDivisao.EditarDivisao', Parameter: ['ID_UNIDADE', 'ID_UNIDADE_DIVISAO'] },
                        Layout: { Default: { Title: 'Alterar', CssClass: 'fa fa-edit margin2' } }
                    },
                    Excluir: {
                        Action: { Function: 'UnidadeDivisao.ExcluirDivisao', Parameter: ['ID_UNIDADE_DIVISAO', 'NM_DIVISAO'] },
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
        ManutencaoUnidade.GridUnidadesDivisao = new AmilGrid('grvDivisoes', Unidade.Urls.PesquisarDivisaoUnidade, { idUnidade: IdUnidade }, actions);
        ManutencaoUnidade.GridUnidadesDivisao.Create();
        //    }
        //});

        $('#dttDivisoes').show();
    },

    ExcluirDivisao: function (id, desc) {

        var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');

                            $.ajax({
                                url: Unidade.Urls.ExcluirDivisao,
                                type: 'POST',
                                data:
                                    {
                                        idDivisao: id
                                    },
                                success: function (data) {
                                    if (!data.Erro) {
                                        UnidadeDivisao.PesquisarDivisao();
                                        var buttons1 = [{
                                            text: "Fechar",
                                            cssClass: 'btn btn-primary btn-outline',
                                            close: true
                                        }];

                                        AmilFramework.Alert.Create(0, Unidade.Mensagens.SucessoExclusao, 400, buttons1, Unidade.Titulo);
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
                        }
                    },
                    {
                        text: "Não",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }
        ];


        AmilFramework.Alert.Create(2, Unidade.Mensagens.ConfirmacaoExclusao.replace('#', ' a divisão ' + desc), 400, buttons);
    },
   
    IncluirDivisao: function () {
        if ($("#Divisao").val() == "") { // && $("#Conselho_TipoConselho").val() != 1) {
            var buttons = [{
                text: "Fechar",
                cssClass: "btn btn-primary btn-outline",
                close: true
            }];
            AmilFramework.Alert.Create(1, UnidadeDivisao.Mensagens.AlertaDivisao, 400, buttons, "Aviso");

        }else {
            var idUnidade = $('#Id').val();

            var divisao = $("#Divisao").val();

            $.ajax({
                url: UnidadeDivisao.Urls.InclusaoDivisao,
                type: 'POST',
                data:
                    {
                        idUnidade: idUnidade,
                        divisao: divisao
                    },
                success: function (data) {
                    if (!data.Erro) {
                        var buttons1 = [{
                            text: "Fechar",
                            cssClass: 'btn btn-primary btn-outline',
                            close: true
                        }];

                        AmilFramework.Alert.Create(0, "Divisão incluída com sucesso.", 400, buttons1, 'Incluir Divisão');
                        UnidadeDivisao.Limpar();
                        UnidadeDivisao.PesquisarDivisao();

                    } else {
                        var buttons2 = [{
                            text: "Fechar",
                            cssClass: 'btn btn-primary btn-outline',
                            close: true
                        }];

                        AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, 'Incluir Divisão');
                    }
                }
            });
        }

    }
};


var UnidadeGrafico = {

    Limpar: function () {

    },

    // Grafico
    PesquisarGrafico: function () {

        IdUnidade = $('#Id').val();

        var actions = [
            {
                Collumn: 'Acoes',
                Buttons: {
                    Editar: {
                        Action: { Function: 'ManutencaoUnidade.EditarGraficoUnidade', Parameter: ['ID_UNIDADE_FASE'] },
                        Layout: { Default: { Title: 'Alterar', CssClass: 'fa fa-edit margin2' } }
                    },
                    Excluir: {
                        Action: { Function: 'UnidadeGrafico.ExcluirGrafico', Parameter: ['ID_UNIDADE_FASE', 'NM_UNIDADE_FASE'] },
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
        ManutencaoUnidade.GridUnidadesGrafico = new AmilGrid('grvGraficos', Unidade.Urls.PesquisarGrafico, { idUnidade: IdUnidade }, actions);
        ManutencaoUnidade.GridUnidadesGrafico.Create();
        //    }
        //});

        $('#dttGraficos').show();
    },

    ExcluirGrafico: function (id, desc) {

        var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');

                            $.ajax({
                                url: Unidade.Urls.ExclusaoGrafico,
                                type: 'POST',
                                data:
                                    {
                                        idGrafico: id
                                    },
                                success: function (data) {
                                    if (!data.Erro) {
                                        UnidadeGrafico.PesquisarGrafico();
                                        var buttons1 = [{
                                            text: "Fechar",
                                            cssClass: 'btn btn-primary btn-outline',
                                            close: true
                                        }];

                                        AmilFramework.Alert.Create(0, Unidade.Mensagens.SucessoExclusao, 400, buttons1, Unidade.Titulo);
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
                        }
                    },
                    {
                        text: "Não",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }
        ];


        AmilFramework.Alert.Create(2, Unidade.Mensagens.ConfirmacaoExclusao.replace('#', ' o Grafico ' + desc), 400, buttons);
    },

    EditarGraficoUnidade: function (id) {

    },

    IncluirModal: function () {

        $.ajax({
            url: Unidade.Urls.CarregaFase,
            type: 'POST',
            data: {},
            success: function (token) {
                $("#GraficoModal").modal();
                UnidadeGrafico.Limpar();

            }
        });

    },

    


};