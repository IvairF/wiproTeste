var Grupo = {
    Titulo: '',
    Urls: {
        PesquisaGrupo: '',
        ManutencaoGrupo: '',
        ExclusaoGrupo: '',
        IncluirGrupo: '',
        SalvarGrupo: '',
        IncluirFuncionalidade: '',
        PesquisaFuncionalidade: '',
        ExclusaoGrupo: '',
        ExclusaoFuncionalidade: '',
        BuscarFuncionalidade: '',
        ValidarUsuarioGrupo: '',

        //AL

        GerarToken: ''
    },
    Mensagens:
      {
          SucessoGravacao: '',
          ConfirmacaoExclusao: '',
          SucessoExclusao: '',
          DesativarGrupo: ''
      }
};
var PesquisaGrupo = {
    GridGrupo: null,
    Mensagens:
    {
        ConfirmacaoExclusao: '',
        SucessoExclusao: ''
    },
    Inicializar: function () {
        $('#txtNomeFiltro').focus();
        $('#dttGrupo').hide();
        PesquisaGrupo.Configurar();
    },
    Configurar: function () {
        $('#btnPesquisa').off('click');
        $('#btnLimpar').off('click');
        $('#btnInserir').off('click');
        $('#btnPesquisa').on('click', function (e) { PesquisaGrupo.Pesquisar(); });
        $('#btnLimpar').on('click', function (e) { PesquisaGrupo.Limpar(); });
        $('#btnInserir').on('click', function (e) { PesquisaGrupo.Incluir(); });
    },
    Limpar: function () {
        $('#txtNomeFiltro').val('');
        $('#txtStatusFiltro').val('');
        $('#txtNomeFiltro').focus();
        $('#dttGrupo').hide();
    },
    Incluir: function () {
        AmilFramework.Common.EncryptQueryUrl("idGrupo=0", function (data) {
            AmilFramework.Common.OpenAjaxURL(Grupo.Urls.ManutencaoGrupo + "?" + data);
        });
    },
    Alterar: function (id) {
        AmilFramework.Common.EncryptQueryUrl("idGrupo=" + id, function (data) {
            AmilFramework.Common.OpenAjaxURL(Grupo.Urls.ManutencaoGrupo + "?" + data);
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
                            //    url: Grupo.Urls.GerarToken,
                            //    type: 'POST',
                            //    data: {},
                            //    success: function (token) {
                                 
                                    $.ajax({
                                        url: Grupo.Urls.ExclusaoGrupo,
                                        type: 'POST',
                                        data:
                                            {
                                                idGrupo: id
                                                //token: token
                                            },
                                        success: function (data) {
                                            if (!data.Erro) {

                                                var buttons1 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true,
                                                    click: function () {
                                                        PesquisaGrupo.Pesquisar();
                                                    }
                                                }];

                                                AmilFramework.Alert.Create(0, PesquisaGrupo.Mensagens.SucessoExclusao, 400, buttons1, Grupo.Titulo);
                                            } else {
                                                var buttons2 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true
                                                }];

                                                AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Grupo.Titulo);
                                            }
                                        }
                                    //});
                                //}
                            });
                           
                        }
                    },
                    {
                        text: "Não",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }
        ];

        AmilFramework.Alert.Create(2, PesquisaGrupo.Mensagens.ConfirmacaoExclusao, 400, buttons);
    },
    Pesquisar: function () {

        var nome = $("#txtNomeFiltro").val();
        var ativo = $("#ddlStatusFiltro").val();

        //Algum desses itens precisão estar preenchidos para a pesquisa
        if (nome.trim() == '' && ativo == '') {

            var buttons = [{
                text: "Fechar",
                cssClass: 'btn btn-primary btn-outline',
                click: function () {
                    AmilFramework.Common.OpenAjaxURL(Grupo.Urls.PesquisaGrupo);
                }
            }];

            AmilFramework.Alert.Create(0, PesquisaGrupo.Mensagens.AlertaPesquisaComCampos, 400, buttons, Grupo.Titulo);

            return;
        }

        var actions = [
            {
                Collumn: 'Acoes',
                Buttons: {
                    Editar: {
                        Action: { Function: 'PesquisaGrupo.Alterar', Parameter: ['Id'] },
                        Layout: { Default: { Title: 'Alterar', CssClass: 'fa fa-edit margin2' } }
                    },
                    Excluir: {
                        Action: { Function: 'PesquisaGrupo.Excluir', Parameter: ['Id'] },
                        Layout: {
                            Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                        }
                    }
                }
            }
        ];

        //Obtem o token e envia para validação durante a pesquisa.
        
        //$.ajax({
        //    url: Grupo.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
             //PesquisaGrupo.GridGrupo = new AmilGrid('grvGrupo', Grupo.Urls.PesquisaGrupo, { nome: nome, ativo: ativo, token: token }, actions);
               PesquisaGrupo.GridGrupo = new AmilGrid('grvGrupo', Grupo.Urls.PesquisaGrupo, { nome: nome, ativo: ativo }, actions);
               PesquisaGrupo.GridGrupo.Create();
            //}
        //});

        $('#dttGrupo').show();
    }
};


var ManutencaoGrupo = {
    IdGrupo: 0,
    GridPesquisaFunc: null,
    GridFuncionalidades: null,

    Urls: {
        //AL
        GerarToken: ''
    },

    Inicializar: function () {
        $('#Descricao').focus();
        ManutencaoGrupo.IdGrupo = parseInt($('#Id').val());
        ManutencaoGrupo.Configurar();
        ManutencaoGrupo.CarregarFuncionalidades();
    },
    Configurar: function () {
        $('#btnSalvar').off('click');
        $('#btnVoltar').off('click');
        $('#btnFuncionalidades').off('click');
        $('#btnPesquisaFunc').off('click');
        $('#btnSalvar').on('click', function (e) { ManutencaoGrupo.Salvar(); });
        $('#btnVoltar').on('click', function (e) { ManutencaoGrupo.Voltar(); });
        $('#btnFuncionalidades').on('click', function (e) { ManutencaoGrupo.Funcionalidades(); });
        $('#btnPesquisaFunc').on('click', function (e) { ManutencaoGrupo.PesquisarFuncionalidade(); });
    },
    CarregarFuncionalidades: function () {

        var actions = [
            {
                Collumn: 'Acoes',
                Buttons: {
                    Excluir: {
                        Action: { Function: 'ManutencaoGrupo.ExcluirFuncionalidade', Parameter: ['Id'] },
                        Layout: {
                            Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                        }
                    }
                }
            }
        ];

        //$.ajax({
        //    url: Grupo.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
               //ManutencaoGrupo.GridFuncionalidades = new AmilGrid('grvFuncionalidades', Grupo.Urls.PesquisaFuncionalidade, { idGrupo: ManutencaoGrupo.IdGrupo, token: token }, actions);
                 ManutencaoGrupo.GridFuncionalidades = new AmilGrid('grvFuncionalidades', Grupo.Urls.PesquisaFuncionalidade, { idGrupo: ManutencaoGrupo.IdGrupo }, actions);
                 ManutencaoGrupo.GridFuncionalidades.Create();
        //    }
        //});

        $('#docs-form').show();

        if (ManutencaoGrupo.IdGrupo) {
            $('#dttFuncionalidades').show();
            $('#btnFuncionalidades').show();
        }
        else {
            $('#dttFuncionalidades').hide();
            $('#btnFuncionalidades').hide();
        }

    },
    Voltar: function () {
        AmilFramework.Common.OpenAjaxURL(Grupo.Urls.PesquisaGrupo);
    },
    Salvar: function () {

        //$.ajax({
        //    url: Grupo.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function(token) {
                var formValido = AmilFramework.Form.Validation.IsValid('#frmManutencaoGrupo');

                if (formValido) {
                    var descricao = $('#Descricao').val();
                    var ativo = $("#Ativo :selected").val();
                    var SalvarGrupo = function() {
                        $.ajax({
                            url: Grupo.Urls.ManutencaoGrupo,
                            type: 'POST',
                            data:
                            {
                                idGrupo: ManutencaoGrupo.IdGrupo,
                                descricao: descricao,
                                ativo: ativo,
                                //token: token
                            },
                            success: function(data) {
                                if (!data.Erro) {
                                    $("#Id").val(data.Result);
                                    var buttons = [
                                        {
                                            text: "Fechar",
                                            cssClass: 'btn btn-primary btn-outline',
                                            click: function() {
                                                AmilFramework.Common.OpenAjaxURL(Grupo.Urls.PesquisaGrupo);
                                            }
                                        }
                                    ];
                                    AmilFramework.Alert
                                        .Create(0, Grupo.Mensagens.SucessoGravacao, 400, buttons, Grupo.Titulo);
                                } else {
                                    var buttons = [
                                        {
                                            text: "Fechar",
                                            cssClass: 'btn btn-primary btn-outline',
                                            close: true
                                        }
                                    ];
                                    AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Grupo.Titulo);
                                }
                            }
                        });
                    }
                    $.ajax({
                        url: Grupo.Urls.ValidarUsuarioGrupo,
                        type: 'POST',
                        data:
                        {
                            idGrupo: ManutencaoGrupo.IdGrupo,
                            ativo: ativo,
                            //token: token
                        },
                        success: function(data) {
                            if (!data.Erro) {
                                if (data.Result == false)
                                    SalvarGrupo();
                                else {
                                    var buttonValidar = [
                                        {
                                            text: "Sim",
                                            cssClass: 'btn btn-primary',
                                            click: function(idModal) {
                                                $('#' + idModal).modal('hide');
                                                SalvarGrupo();
                                            }
                                        },
                                        {
                                            text: "Não",
                                            cssClass: 'btn btn-primary btn-outline',
                                            close: true
                                        }
                                    ];
                                    AmilFramework.Alert.Create(2, Grupo.Mensagens.DesativarGrupo, 400, buttonValidar);
                                }
                            } else {
                                var buttons = [
                                    {
                                        text: "Fechar",
                                        cssClass: 'btn btn-primary btn-outline',
                                        close: true
                                    }
                                ];
                                AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Grupo.Titulo);
                            }
                        }
                    });

                }
            //}
        //});
    },
    Funcionalidades: function () {
        $("#FuncionalidadeModal").modal({
            open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); },
            backdrop: 'static',
            keyboard: false
        });

        $('#dttPesquisaFuncionalidade').hide();
        $("#txtPesquisaFuncionalidade").val('');
    },
    PesquisarFuncionalidade: function () {
        var funcionalidade = $("#txtPesquisaFuncionalidade").val();
        var actions = [
            {
                Collumn: 'Acao',
                Buttons: {
                    Incluir: {
                        Action: { Function: 'ManutencaoGrupo.IncluirFuncionalidades', Parameter: ['Id', 'Descricao'] },
                        Layout: {
                            Default: { Title: 'Incluir', CssClass: 'fa fa-check margin2' } //plus
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
       //     ManutencaoGrupo.GridPesquisaFunc = new AmilGrid('grvPesquisaFuncionalidade', Grupo.Urls.BuscarFuncionalidade, { idGrupo: ManutencaoGrupo.IdGrupo, funcionalidade: funcionalidade, token: token }, actions);
              ManutencaoGrupo.GridPesquisaFunc = new AmilGrid('grvPesquisaFuncionalidade', Grupo.Urls.BuscarFuncionalidade, { idGrupo: ManutencaoGrupo.IdGrupo, funcionalidade: funcionalidade }, actions);
              ManutencaoGrupo.GridPesquisaFunc.Create();
        $('#dttPesquisaFuncionalidade').show();
        //    }
        //});
    },

    IncluirFuncionalidades: function (idFuncionalidade, funcionalidade) {

        //$.ajax({
        //    url: Grupo.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function(token) {
                $.ajax({
                    url: Grupo.Urls.IncluirFuncionalidade,
                    type: 'POST',
                    data:
                    {
                        idGrupo: ManutencaoGrupo.IdGrupo,
                        idFuncionalidade: idFuncionalidade,
                        funcionalidade: funcionalidade,
                        //token: token
                    },
                    success: function(data) {
                        if (!data.Erro) {
                            var buttons = [
                                {
                                    text: "Fechar",
                                    cssClass: 'btn btn-primary btn-outline',
                                    click: function() {
                                        PesquisaGrupo.Alterar(ManutencaoGrupo.IdGrupo);
                                    }
                                }
                            ];

                            AmilFramework.Alert.Create(0,
                                Grupo.Mensagens.SucessoGravacao,
                                400,
                                buttons,
                                Grupo.Titulo);

                        } else {
                            var buttons = [
                                {
                                    text: "Fechar",
                                    cssClass: 'btn btn-primary btn-outline',
                                    close: true
                                }
                            ];

                            AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Grupo.Titulo);
                        }
                    }
                });

        //    }
        //});
    },
    ExcluirFuncionalidade: function(Id) {
        //$.ajax({
        //    url: Grupo.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function(token) {
                var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        close: true,
                        click: function(idModal) {
                            $('#' + idModal).modal('hide');

                            $.ajax({
                                url: Grupo.Urls.ExclusaoFuncionalidade,
                                type: 'POST',
                                data:
                                {
                                    idGrupo: ManutencaoGrupo.IdGrupo,
                                    idFuncionalidade: Id,
                                    //token: token
                                },
                                success: function(data) {
                                    if (!data.Erro) {
                                        var buttons1 = [
                                            {
                                                text: "Fechar",
                                                cssClass: 'btn btn-primary btn-outline',
                                                close: true,
                                                click: function() {
                                                    PesquisaGrupo.Alterar(ManutencaoGrupo.IdGrupo);
                                                }
                                            }
                                        ];

                                        AmilFramework.Alert
                                            .Create(0, Grupo.Mensagens.SucessoExclusao, 400, buttons1, Grupo.Titulo);
                                    } else {
                                        var buttons2 = [
                                            {
                                                text: "Fechar",
                                                cssClass: 'btn btn-primary btn-outline',
                                                close: true
                                            }
                                        ];

                                        AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Grupo.Titulo);
                                    }
                                }
                            });
                        }
                    },
                    {
                        text: "Não",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }
                ];

                AmilFramework.Alert.Create(2, Grupo.Mensagens.ConfirmacaoExclusao, 400, buttons);


        //    }
        //});

    }
};
