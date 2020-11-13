var Perfil = {
    Titulo: '',
    Urls: {
        PesquisaPerfis: '',
        ManutencaoPerfil: '',
        ExclusaoPerfil: '',
        GerarToken: '',
        ModuloPerfil: '',
        UsuarioPerfil: '',
        PesquisarUsuarioPerfil: '',
        ExclusaoUsuario: '',
        ManutencaoUsuario: '',
        ValidarAcessoPesquisa: ''
    },

    Mensagens:
       {
           SucessoGravacao: '',
           ConfirmacaoExclusao: '',
           PreenchaDescricao: '',
           PreenchaSistema: ''
       }
};

var PesquisaPerfil =
{
    GridPerfil: null,

    Mensagens:
    {
        ConfirmacaoExclusao: '',
        SucessoExclusao: ''
    },
    Inicializar: function () {
        $('#txtDescricaoFiltro').focus();
        $('#dttPerfis').hide();

        //2804
        var primeiroAcesso = $("#PrimeiroAcesso").val();

        if (primeiroAcesso == "N") {
            PesquisaPerfil.Pesquisar();
        }

    },
    Limpar: function () {
        $('#txtDescricaoFiltro').val('');
        $('#ddlSistemaFiltro').val('');
        $('#txtDescricaoFiltro').focus();
        $('#dttPerfis').hide();

        AmilFramework.Common.OpenAjaxURL(Perfil.Urls.PesquisaPerfis + "?" + "limpar=S");
    },
    Incluir: function () {

        $.ajax({
            url: Perfil.Urls.ValidarAcessoPesquisa,
            type: 'POST',
            data: {},
            success: function (data) {
                if (!data.Erro) {
                    AmilFramework.Common.EncryptQueryUrl("idPerfil=0", function (data) {
                        AmilFramework.Common.OpenAjaxURL(Perfil.Urls.ManutencaoPerfil + "?" + data);
                    });

                }
                else {
                    var buttons2 = [{
                        text: "Fechar",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }];

                    AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Perfil.Titulo);
                }
            }
        });
    },
    Alterar: function (id) {
        AmilFramework.Common.EncryptQueryUrl("idPerfil=" + id, function (data) {
            AmilFramework.Common.OpenAjaxURL(Perfil.Urls.ManutencaoPerfil + "?" + data);
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
                                        url: Perfil.Urls.ExclusaoPerfil,
                                        type: 'POST',
                                        data:
                                            {
                                                idPerfil: id
                                            },
                                        success: function (data) {
                                            if (!data.Erro) {
                                                PesquisaPerfil.Pesquisar();
                                                var buttons1 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true
                                                }];

                                                AmilFramework.Alert.Create(0, PesquisaPerfil.Mensagens.SucessoExclusao, 400, buttons1, Perfil.Titulo);
                                            } else {
                                                var buttons2 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true
                                                }];

                                                AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Perfil.Titulo);
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

       
        AmilFramework.Alert.Create(2, Perfil.Mensagens.ConfirmacaoExclusao.replace('#', ' o perfil ' + desc), 400, buttons);
    },
    UsuariosPerfil: function (id) {
        AmilFramework.Common.EncryptQueryUrl("idperfil=" + id, function (data) {
            AmilFramework.Common.OpenAjaxURL(Perfil.Urls.UsuarioPerfil + "?" + data);
        });
    },
    Pesquisar: function () {
        var descricao = $("#txtDescricaoFiltro").val();
        var codigo = $("#txtCodigoFiltro").val();
        var sistema = $("#IdSistema").val();//$("#ddlSistemaFiltro").val();

        var buttons = [{
            text: "Fechar",
            cssClass: 'btn btn-primary btn-outline',
            close: true
        }];

        //if (sistema == '') {
        //    AmilFramework.Alert.Create(1, Perfil.Mensagens.PreenchaSistema, 400, buttons, Perfil.Titulo);
        //    return;
        //}

        var actions = [
            {
                Collumn: 'Acoes',
                Buttons: {
                    Visualizar: {
                        Action: { Function: 'PesquisaPerfil.UsuariosPerfil', Parameter: ['Id'] },
                        Layout: { Default: { Title: 'Usuários', CssClass: 'fa fa-list-alt margin2' } }
                    },
                    Editar: {
                        Action: { Function: 'PesquisaPerfil.Alterar', Parameter: ['Id'] },
                        Layout: { Default: { Title: 'Alterar', CssClass: 'fa fa-edit margin2' } }
                    },
                    Excluir: {
                        Action: { Function: 'PesquisaPerfil.Excluir', Parameter: ['Id' , 'Descricao'] },
                        Layout: { Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                        }
                    }
                }
            }
        ];

        $.ajax({
            url: Perfil.Urls.ValidarAcessoPesquisa,
            type: 'POST',
            data: {},
            success: function (data) {
                if (!data.Erro) {
                    PesquisaPerfil.GridPerfis = new AmilGrid('grvPerfis', Perfil.Urls.PesquisaPerfis, { descricao: descricao, codigo: codigo, sistema: sistema }, actions);
                    PesquisaPerfil.GridPerfis.Create();

                    $('#dttPerfis').show();
                }
                else {
                    var buttons2 = [{
                        text: "Fechar",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }];

                    AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Perfil.Titulo);
                }
            }
        });



        
    }
};

var ManutencaoPerfil = {
    IdPerfil: 0,
    GridPesquisaPerfil: null,
    Inicializar: function () {
        IdPerfil = $('#Id').val()
        $('#Descricao').focus();

        $("#btnAssociarModulo").hide();

        var IdSistema = $("#IdSistema").val();

        if (IdPerfil > 0) {
            $("#btnAssociarModulo").show();
            $("#Codigo").attr("disabled", "disabled");
            $("#IdSistema").attr("disabled", "disabled");
        }
        else {
            $("#Codigo").prop("disabled", false);
            $("#IdSistema").attr("disabled", false);
        }
    },
    Modulos: function () {

        AmilFramework.Common.EncryptQueryUrl("idPerfil="+IdPerfil+",IdSistema="+IdSistema, function (data) {
            AmilFramework.Common.OpenAjaxURL(Perfil.Urls.ModuloPerfil + "?" + data);
        });
    },
    Voltar: function () {
        AmilFramework.Common.OpenAjaxURL(Perfil.Urls.PesquisaPerfis);
    },

    AdicionarModulos: function () {
        var IdPerfil = $('#Id').val();
        var IdSistema = $("#IdSistema").val();

        var mModulos = $('#ListaModulosTodos option').map(function (i, n) {
            return { 'Id': $(n).val(), 'Descricao': $(n).text() };
        }).get();

        var mModulosSelecionados = $('#ListaModulosSelecionados option').map(function (i, n) {
            return { 'Id': $(n).val(), 'Descricao': $(n).text() };
        }).get();

        var modulos = JSON.stringify(mModulos);
        var modulosSelecionados = JSON.stringify(mModulosSelecionados);

        $.ajax({
            type: 'POST',
            url: Perfil.Urls.SalvarModulos,
            data: {
                modulos: modulos,
                modulosSelecionados: modulosSelecionados,
                idperfil: IdPerfil,
                idsistema: IdSistema,
            },
            success: function (data) {
                if (!data.Erro) {

                    var buttons = [{
                        text: "Fechar",
                        cssClass: 'btn btn-primary btn-outline',
                        click: function () {
                            PesquisaPerfil.Alterar(ManutencaoPerfil.IdPerfil);
                        }
                    }];

                    //AmilFramework.Alert.Create(0, "Perfil atualizado com sucesso!!!", 400, buttons, Perfil.Titulo);

                    //if (data.Result)
                    //    AmilFramework.Alert.Create(0, "Perfil atualizado com sucesso!", 400, buttons, "Módulos do Perfil");
                    //else
                    //    AmilFramework.Alert.Create(0, "Não foi possível remover alguns modulos!!!", 400, buttons, "Módulos do Perfil");

                } else {
                    var buttons = [{
                        text: "Fechar",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }];
                    AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Perfil.Titulo);
                }
            }
        });

    },

    Salvar: function () {
        var formValido = AmilFramework.Form.Validation.IsValid('#frmManutencaoPerfil');

        if (formValido) {
            var descricao = $('#Descricao').val();
            var codigo = $('#Codigo').val();
            var sistema = $("#IdSistema").val();
            var idPerfil = $('#Id').val();

            var PerfilModel = {
                Id: idPerfil,
                Descricao: descricao,
                Codigo: codigo,
                IdSistema: sistema
            };

            var json = JSON.stringify(PerfilModel);

                    $.ajax({
                        url: Perfil.Urls.ManutencaoPerfil,
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
                                AmilFramework.Alert.Create(0, Perfil.Mensagens.SucessoGravacao, 400, buttons, Perfil.Titulo);
                            } else {
                                var buttons = [{
                                    text: "Fechar",
                                    cssClass: 'btn btn-primary btn-outline',
                                    close: true
                                }];

                                AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Perfil.Titulo);
                            }
                        }
                    });
            //    }
            //});

        }
    }
};

var UsuarioPerfil = {
    Inicializar: function() {
        $("#CodigoPerfil").attr("disabled", "disabled");
        $("#DescricaoPerfil").attr("disabled", "disabled");
        $("#Sistema").attr("disabled", "disabled");

        var idperfil = $("#Id").val();

        var actions = [
            {
                Collumn: 'Acoes',
                Buttons: {
                    Excluir: {
                        Action: { Function: 'UsuarioPerfil.ExcluirUsuario', Parameter: ['Id', 'Nome'] },
                        Layout: {
                            Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                        }
                    },
                    Editar: {
                        Action: { Function: 'UsuarioPerfil.Alterar', Parameter: ['Id', 'Email'] },
                        Layout: { Default: { Title: 'Alterar', CssClass: 'fa fa-edit margin2' } }
                    }
                }
            }
        ];

        ManutencaoPerfil.GridPesquisaUsuarios = new AmilGrid('grvUsuarios', Perfil.Urls.PesquisarUsuarioPerfil, { idperfil: idperfil }, actions);
        ManutencaoPerfil.GridPesquisaUsuarios.Create();
        $('#dttUsuarios').show();

    },
    Alterar: function (id, email) {
            AmilFramework.Common.EncryptQueryUrl("idUsuario=" + id + "&emailUsuario=" + email, function (data) {
                AmilFramework.Common.OpenAjaxURL(Perfil.Urls.ManutencaoUsuario + "?" + data);
            });
    },
    ExcluirUsuario: function (id, desc) {
        var idperfil = $("#Id").val();

        var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');
                            $.ajax({
                                url: Perfil.Urls.ExclusaoUsuario,
                                type: 'POST',
                                data:
                                    {
                                        idUsuario: id,
                                        idPerfil: idperfil
                                    },
                                success: function (data) {
                                    if (!data.Erro) {
                                        UsuarioPerfil.Inicializar();
                                        var buttons1 = [{
                                            text: "Fechar",
                                            cssClass: 'btn btn-primary btn-outline',
                                            close: true
                                        }];

                                        AmilFramework.Alert.Create(0, PesquisaPerfil.Mensagens.SucessoExclusao, 400, buttons1, Perfil.Titulo);
                                    } else {
                                        var buttons2 = [{
                                            text: "Fechar",
                                            cssClass: 'btn btn-primary btn-outline',
                                            close: true
                                        }];

                                        AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Perfil.Titulo);
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
        var msg = ' o usuário ' + desc + ' do perfil ' + $("#CodigoPerfil").val();
        AmilFramework.Alert.Create(2, Perfil.Mensagens.ConfirmacaoExclusao.replace('#', msg ), 400, buttons);
    },
    Voltar: function () {
        AmilFramework.Common.OpenAjaxURL(Perfil.Urls.PesquisaPerfis);
    },
    PesquisaUsuarios: function () {

    }


};

var AssociarModulo =
{
    IdPerfil: 0,
    ControlarSelecao: function (controle1, controle2) {
        var $options = $(controle1).clone();
        $(controle2).append($options);
        $(controle1).remove();
    },
};
