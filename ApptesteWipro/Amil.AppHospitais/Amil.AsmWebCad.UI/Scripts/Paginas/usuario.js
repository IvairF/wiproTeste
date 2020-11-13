var Usuario = {
    Titulo: '',
    Urls: {
        PesquisaUsuario: '',
        ManutencaoUsuario: '',
        GerarToken: '',
        PesquisarConselho: '',
        ExclusaoConselho: '',
        InclusaoConselho: ''
    },
    Mensagens:
      {
          SucessoGravacao: '',
          ConfirmacaoExclusao: '',
          SucessoExclusao: '',
          BloqueioUsuario: '',
          MensagemTipoConselho: '',
          MensagemNumeroConselho: '',
          MensagemUF: ''
      }
};
var PesquisaUsuario = {
    GridUsuario: null,
    Mensagens:
    {
        ConfirmacaoExclusao: '',
        SucessoExclusao: '',
        SucessoGravacao: ''
    },
    Inicializar: function () {
        $('#txtCPFFiltro').focus();
        $('#dttUsuario').hide();
        PesquisaUsuario.Configurar();
        var cpf = $("#txtCPFFiltro").val().replace(".", "").replace(".", "").replace("-", "");
        var login = $("#txtLoginFiltro").val();
        var nome = $("#txtNomeFiltro").val();
        $("#ddlStatusFiltro").val($('#Status').val());
        var ativo = $("#ddlStatusFiltro").val();
        $("#ddlTipoFiltro").val($('#Tipo').val());
        var tipo = $("#ddlTipoFiltro").val();
        var primeiroAcesso = $("#PrimeiroAcesso").val();
        //Algum desses itens precisão estar preenchidos para a pesquisa
        if ((cpf.trim() != '' || login.trim() != '' || nome.trim() != '' || ativo != '' || tipo != '')  && (primeiroAcesso == "N")) {
            PesquisaUsuario.Pesquisar();
        }
    },
    Configurar: function () {
        $('#btnPesquisa').off('click');
        $('#btnLimpar').off('click');
        $('#btnInserir').off('click');
        $('#btnPesquisa').on('click', function (e) { PesquisaUsuario.Pesquisar(); });
        $('#btnLimpar').on('click', function (e) { PesquisaUsuario.Limpar(); });
        $('#btnInserir').on('click', function (e) { PesquisaUsuario.Incluir(); });
    },
    Limpar: function () {
        $('#txtCPFFiltro').val('');
        $('#txtLoginFiltro').val('');
        $('#txtNomeFiltro').val('');
        $('#txtStatusFiltro').val('');
        $('#txtDocumentoFiltro').val('');
        $('#txtCPFFiltro').focus();
        $('#dttUsuario').hide();
        $('#ddlConselhoFiltro').val('');

        AmilFramework.Common.OpenAjaxURL(Usuario.Urls.PesquisaUsuario + "?" + "limpar=S");
        


    },
    Incluir: function () {

        $.ajax({
            url: Usuario.Urls.ValidarAcessoPesquisa,
            type: 'POST',
            data: {},
            success: function (data) {
                if (!data.Erro) {

                    AmilFramework.Common.EncryptQueryUrl("idUsuario=0", function (data) {
                        AmilFramework.Common.OpenAjaxURL(Usuario.Urls.ManutencaoUsuario + "?" + data);
                    });
                }
                else {
                    var buttons2 = [{
                        text: "Fechar",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }];

                    AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Usuario.Titulo);
                }
            }
        });

    },
    Alterar: function (id, email, tipo) {
        AmilFramework.Common.EncryptQueryUrl("idUsuario=" + id + "&emailUsuario=" + email + "&tipo=" + tipo, function (data) {
            AmilFramework.Common.OpenAjaxURL(Usuario.Urls.ManutencaoUsuario + "?" + data);
        });
    },
    Excluir: function (id) {
        var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');
                          
                            $.ajax({
                                url: Usuario.Urls.ManutencaoUsuario,
                                type: 'POST',
                                data:
                                {
                                    idUsuario: id,
                                    desativar: true
                        },
                                success: function (data) {
                                    if (!data.Erro) {

                                        var buttons = [{
                                            text: "Fechar",
                                            cssClass: 'btn btn-primary btn-outline',
                                            close: true,
                                            click: function () {
                                                PesquisaUsuario.Pesquisar();
                                            }
                                        }];

                                        AmilFramework.Alert.Create(0, PesquisaUsuario.Mensagens.SucessoExclusao, 400, buttons, Usuario.Titulo);
                                    } else {
                                        var buttons = [{
                                            text: "Fechar",
                                            cssClass: 'btn btn-primary btn-outline',
                                            close: true
                                        }];

                                        AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Usuario.Titulo);
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
        AmilFramework.Alert.Create(2, PesquisaUsuario.Mensagens.ConfirmacaoExclusao, 400, buttons);
    },
    Pesquisar: function () {
        var cpf = $("#txtCPFFiltro").val().replace(".", "").replace(".", "").replace("-", "");
        var login = $("#txtLoginFiltro").val();
        var nome = $("#txtNomeFiltro").val();
        var ativo = $("#ddlStatusFiltro").val();
        var incluirBloqueadoFiltro = 0;
        var tipo = $("#ddlTipoFiltro").val();
        var conselho = $("#IdConselho").val();
        var documento = $("#txtDocumentoFiltro").val();

        //Algum desses itens precisão estar preenchidos para a pesquisa
        if (cpf.trim() == '' && login.trim() == '' && nome.trim() == '' && ativo == '' ) {

            var buttons = [{
                text: "Fechar",
                cssClass: 'btn btn-primary btn-outline',
                click: function () {
                    AmilFramework.Common.OpenAjaxURL(Usuario.Urls.PesquisaUsuario);
                }
            }];

            AmilFramework.Alert.Create(0, PesquisaUsuario.Mensagens.AlertaPesquisaComCampos, 400, buttons, Usuario.Titulo);

            return;
        }
        
        var actions = [
            {
                Collumn: 'Acoes',
                Buttons: {
                    Editar: {
                        Action: { Function: 'PesquisaUsuario.Alterar', Parameter: ['Id', 'Email', 'DescricaoUsuarioTipo'] },
                        Layout: { Default: { Title: 'Alterar', CssClass: 'fa fa-edit margin2' } }
                    }
                }
            }
        ];

        $.ajax({
            url: Usuario.Urls.ValidarAcessoPesquisa,
            type: 'POST',
            data: {},
            success: function (data) {
                if (!data.Erro) {

                    PesquisaUsuario.GridUsuario = new AmilGrid('grvUsuario', Usuario.Urls.PesquisaUsuario, { cpf: cpf, login: login, nome: nome, ativo: ativo, tipo: tipo, conselho: conselho, documento: documento}, actions, 15);
                    PesquisaUsuario.GridUsuario.Create();
                    $('#dttUsuario').show();
                }
                else {
                    var buttons2 = [{
                        text: "Fechar",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }];

                    AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Usuario.Titulo);
                }
            }
        });

    }
};


var UsuarioConselho = {
    Cancelar: function () {
        $("#ConselhoModal").modal("hide");
    },
    Limpar: function () {
        $("#Conselho_TipoConselho").val("");
        $("#Conselho_NumeroConselho").val("");
        $("#Conselho_UF").val("");
    },
    IncluirModal: function () {
        $("#ConselhoModal").modal();
        UsuarioConselho.Limpar();

    },
    Incluir: function () {
        if ($("#Conselho_TipoConselho").val() == "") {
            var buttons = [{
                text: "Fechar",
                cssClass: "btn btn-primary btn-outline",
                close: true
            }];
            AmilFramework.Alert.Create(1, Usuario.Mensagens.MensagemTipoConselho, 400, buttons, "Aviso");

        } else if ($("#Conselho_NumeroConselho").val() == "") { // && $("#Conselho_TipoConselho").val() != 1) {
            var buttons = [{
                text: "Fechar",
                cssClass: "btn btn-primary btn-outline",
                close: true
            }];
            AmilFramework.Alert.Create(1, Usuario.Mensagens.MensagemNumeroConselho, 400, buttons, "Aviso");

        } else if ($("#Conselho_UF").val() == "") { //&& $("#Conselho_TipoConselho").val() != 1) {
            var buttons = [{
                text: "Fechar",
                cssClass: "btn btn-primary btn-outline",
                close: true
            }];
            AmilFramework.Alert.Create(1, Usuario.Mensagens.MensagemUF, 400, buttons, "Aviso");

        } else {
            var idUsuario = $('#Id').val();
            var flgInterno = $('#Tipo').val() == 'Externo' ? 0 : 1;
            var numeroConselho = $("#Conselho_NumeroConselho").val();
            var idUFConselho = $("#Conselho_UF").val();
            var idTipoConselho = $("#Conselho_TipoConselho").val();

            $.ajax({
                url: Usuario.Urls.InclusaoConselho,
                type: 'POST',
                data:
                    {
                        idUsuario: idUsuario,
                        flgInterno: flgInterno,
                        idTipoConselho: idTipoConselho,
                        idUfConselho: idUFConselho,
                        numeroConselho: numeroConselho
                    },
                success: function (data) {
                    if (!data.Erro) {
                        var buttons1 = [{
                            text: "Fechar",
                            cssClass: 'btn btn-primary btn-outline',
                            close: true
                        }];

                        AmilFramework.Alert.Create(0, "Documento incluído com sucesso.", 400, buttons1, 'Incluir Documento');
                        UsuarioConselho.Limpar();
                        ManutencaoUsuario.PerquisarConselho();

                    } else {
                        var buttons2 = [{
                            text: "Fechar",
                            cssClass: 'btn btn-primary btn-outline',
                            close: true
                        }];

                        AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, 'Incluir Documento');
                    }
                }
            });
        }

    },
    ExcluirConselho: function (id, doc, conselho) {

        var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');

                            $.ajax({
                                url: Usuario.Urls.ExclusaoConselho,
                                type: 'POST',
                                data:
                                    {
                                        idConselho: id
                                    },
                                success: function (data) {
                                    if (!data.Erro) {
                                        ManutencaoUsuario.PerquisarConselho();
                                        var buttons1 = [{
                                            text: "Fechar",
                                            cssClass: 'btn btn-primary btn-outline',
                                            close: true
                                        }];

                                        AmilFramework.Alert.Create(0, ManutencaoUsuario.Mensagens.SucessoExclusao, 400, buttons1, 'Excluir Documento');
                                    } else {
                                        var buttons2 = [{
                                            text: "Fechar",
                                            cssClass: 'btn btn-primary btn-outline',
                                            close: true
                                        }];

                                        AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, 'Excluir Documento');
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

        var msg = ' o documento ' + doc + ' (' + conselho + ')';
        AmilFramework.Alert.Create(2, ManutencaoUsuario.Mensagens.ConfirmacaoExclusao.replace('#', msg), 400, buttons);

    }
};

var ManutencaoUsuario = {
    GridConselho: null,
    idUsuario: 0,
    login: '',
    Mensagens:
    {
        ConfirmacaoExclusao: '',
        SucessoExclusao: ''
    },
    Inicializar: function () {
        $('#boxConselho').hide();
        $('#dttConselho').hide();
        $('#Nome').focus();
        if ($('#Login').val() === "")
            $("#btnAssociarPerfil").hide();
        
        ManutencaoUsuario.idUsuario = parseInt($('#Id').val());
        ManutencaoUsuario.Configurar();

        if($("#DataNascimento").val() === "01/01/0001")
            $("#DataNascimento").val("")
        $("#dtData").datetimepicker({
            inline: true,
            sideBySide: true,
            format: "DD/MM/YYYY",
            locale: "pt-br"
        });

        if (ManutencaoUsuario.idUsuario > 0) {
            ManutencaoUsuario.PerquisarConselho();
        }
            
    },
    PerquisarConselho: function () {
            $('#boxConselho').show();
            $('#dttConselho').show();
            var idusuario = ManutencaoUsuario.idUsuario;
            var flginterno = $('#Tipo').val() == 'Externo' ? 0 : 1 ;

            // carrega os registros de conselho profissional
            var actions = [
                {
                    Collumn: 'Acoes',
                    Buttons: {
                        Excluir: {
                            Action: { Function: 'UsuarioConselho.ExcluirConselho', Parameter: ['Id','Documento','Conselho'] },
                            Layout: {
                                Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                            }
                        }
                    }
                }
            ];

            ManutencaoUsuario.GridConselho = new AmilGrid('grvConselho', Usuario.Urls.PesquisarConselho, { idusuario: idusuario, flginterno: flginterno }, actions, 15);
            ManutencaoUsuario.GridConselho.Create();
    },
    Configurar: function () {
        $('#btnSalvar').off('click');
        $('#btnVoltar').off('click');
        $('#btnConfirmar').off('click');
        $('#CPF').off('blur');


        $('#btnSalvar').on('click', function (e) { ManutencaoUsuario.Salvar(); });
        $('#btnVoltar').on('click', function (e) { ManutencaoUsuario.Voltar(); });
        $('#CPF').on('blur', function (e) { ManutencaoUsuario.ValidarCampoCPF($('#CPF')); });
    },
    ValidarCampoCPF: function (campo) {

        if (campo != null && campo.val()) {
            if (!ValidaCPF(campo.val().replace('.', '').replace('.', '').replace('-', ''))) {
                campo.attr('class', 'form-control input-validation-error');
                $errorSpan = $("span[data-valmsg-for='CPF']");
                $errorSpan.attr('class', 'field-validation-error');
                $errorSpan.html("<span for='CPF' generated='true' class=''>CPF inválido.</span>");
                $errorSpan.show();
                return false;
            }
            return true;
        }
    },
    Limpar: function () {
        $('#Nome').val('');
        $('#CPF').val('');
        $("#DataNascimento").val();
        $('#Login').val('');
        $('#Ativo').val('');
    },
    Salvar: function () {
        var formValido = AmilFramework.Form.Validation.IsValid('#frmManutencaoUsuario');

        var CampoBloqueado = 0;
        if ($("#chkBloqueado").prop("checked")) {
            CampoBloqueado = 1;
        }

        var strData = $("#DataNascimento").val();
        var partesData = strData.split("/");
        var data = new Date(partesData[2], partesData[1] - 1, partesData[0]);
        if (data > new Date()) {

            var buttons = [{
                text: "Fechar",
                cssClass: 'btn btn-primary btn-outline',
                close: true
            }];
            AmilFramework.Alert.Create(3, "A Data de Nascimento não pode ser maior que a data atual.", 400, buttons, "Erro");
            return;
        }

        var status = $("#Status").val();
        if (status == "") {
            var buttons = [{
                text: "Fechar",
                cssClass: 'btn btn-primary btn-outline',
                close: true
            }];
            AmilFramework.Alert.Create(3, "Selecione status do Usuário", 400, buttons, "Erro");
        } else {

            var tipoUsuario = $('#Tipo').val();

            if (formValido && (tipoUsuario == 'Externo' || ManutencaoUsuario.ValidarCampoCPF($('#CPF')))) {
                var UsuarioModel = {
                    Id: ManutencaoUsuario.idUsuario,
                    Nome: $('#Nome').val(),
                    Cpf: $('#CPF').val().replace('.', '').replace('.', '').replace('-', ''),
                    DataNascimento: $("#DataNascimento").val(),
                    Login: $('#Login').val().toLowerCase(),
                    Ativo: $("#Ativo :selected").val(),
                    Status: $("#Status").val(),
                    Bloqueado: CampoBloqueado,
                    Tipo: tipoUsuario
                }

                var json = JSON.stringify(UsuarioModel);
                $.ajax({
                    url: Usuario.Urls.ManutencaoUsuario,
                    type: 'POST',
                    data:
                    {
                        json: json
                    },
                    success: function(data) {
                        if (!data.Erro) {
                            $("#btnAssociarPerfil").show();
                            $("#Id").val(data.Result.Id);
                            ManutencaoUsuario.idUsuario = data.Result.Id;
                            var buttons = [
                                {
                                    text: "Fechar",
                                    cssClass: 'btn btn-primary btn-outline',
                                    click: function() {
                                        //  AmilFramework.Common.OpenAjaxURL(Usuario.Urls.PesquisaUsuario);
                                        $('.modal-backdrop.fade.in').hide();
                                        $('.modal.fade.bs-example-modal-lg.Success.in').hide();
                                    }
                                }
                            ];
                            AmilFramework.Alert.Create(0,
                                ManutencaoUsuario.Mensagens.SucessoGravacao,
                                400,
                                buttons,
                                Usuario.Titulo);
                        } else {
                            var buttons = [
                                {
                                    text: "Fechar",
                                    cssClass: 'btn btn-primary btn-outline',
                                    close: true
                                }
                            ];
                            AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, "Erro");
                        }
                    }
                });
            }
        }
    },
    Voltar: function () {
        AmilFramework.Common.OpenAjaxURL(Usuario.Urls.PesquisaUsuario);
    }
};

var AssociarPerfil =
{
    ControlarSelecao: function (controle1, controle2) {
        var $options = $(controle1).clone();
        $(controle2).append($options);
        $(controle1).remove();
    },
    AdicionarPerfis: function () {
        var idUsuario = $('#Id').val();

        var listaPerfilUsuario = $('#ListaPerfisSelecionados option').map(function (i, n) {
            return { 'Usuario': { 'Id': idUsuario, 'Email': $('#Login').val() }, 'Perfil': { 'Id': $(n).val() } };
        }).get();

        var listaPerfilUsuarioJson = JSON.stringify(listaPerfilUsuario);

        $.ajax({
            url: Usuario.Urls.AdicionarPerfis,
            type: 'POST',
            data:
                {
                    email: $('#Login').val(),
                    json: listaPerfilUsuarioJson
                },
            success: function (data) {
                if (!data.Erro) {
                    var buttons = [{
                        text: "Fechar",
                        cssClass: 'btn btn-primary btn-outline',
                        click: function () {
                            $('.modal-backdrop.fade.in').hide();
                            $('.modal.fade.bs-example-modal-lg.Success.in').hide();
                        }
                    }];

                    AmilFramework.Alert.Create(0, "Perfil atualizado com sucesso!", 400, buttons, Usuario.Titulo);
                } else {
                    var buttons = [{
                        text: "Fechar",
                        cssClass: 'btn btn-primary btn-outline',
                        close: true
                    }];

                    AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Usuario.Titulo);
                }
            }
        });
    }
};