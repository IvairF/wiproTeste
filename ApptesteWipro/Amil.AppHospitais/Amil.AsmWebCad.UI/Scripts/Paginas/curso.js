var Curso = {
    Titulo: '',
    Urls: {
        PesquisaCursos: '',
        ManutencaoCurso: '',
        ExclusaoCurso: '',
        GerarToken: ''
    },

    Mensagens:
       {
           SucessoGravacao: '',
           ConfirmacaoExclusao: '',
           PreenchaDescricao: '',
           PreenchaStatus: ''
       }
};

var PesquisaCurso =
{
    GridCursos: null,

    Mensagens:
    {
        ConfirmacaoExclusao: '',
        SucessoExclusao: ''
    },
    Inicializar: function () {
        $('#txtDescricaoFiltro').focus();
        $('#dttCursos').hide();
    },
    Limpar: function () {
        $('#txtDescricaoFiltro').val('');
        $('#txtStatusFiltro').val('');
        $('#txtDescricaoFiltro').focus();
        $('#dttCursos').hide();
    },
    Incluir: function () {
        AmilFramework.Common.EncryptQueryUrl("idCurso=0", function (data) {
            AmilFramework.Common.OpenAjaxURL(Curso.Urls.ManutencaoCurso + "?" + data);
        });
    },
    Alterar: function (id) {
        AmilFramework.Common.EncryptQueryUrl("idCurso=" + id, function (data) {
            AmilFramework.Common.OpenAjaxURL(Curso.Urls.ManutencaoCurso + "?" + data);
        });
    },
    Excluir: function (id, desc) {
        
        var buttons = [
                    {
                        text: "Sim",
                        cssClass: 'btn btn-primary',
                        click: function (idModal) {
                            $('#' + idModal).modal('hide');

                            //$.ajax({
                            //    url: Curso.Urls.GerarToken,
                            //    type: 'POST',
                            //    data: {},
                            //    success: function (token) {
                                    $.ajax({
                                        url: Curso.Urls.ExclusaoCurso,
                                        type: 'POST',
                                        data:
                                            {
                                                idCurso: id
                                            },
                                        success: function (data) {
                                            if (!data.Erro) {
                                                PesquisaCurso.Pesquisar();
                                                var buttons1 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true
                                                }];

                                                AmilFramework.Alert.Create(0, PesquisaCurso.Mensagens.SucessoExclusao, 400, buttons1, Curso.Titulo);
                                            } else {
                                                var buttons2 = [{
                                                    text: "Fechar",
                                                    cssClass: 'btn btn-primary btn-outline',
                                                    close: true
                                                }];

                                                AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Curso.Titulo);
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

       
        AmilFramework.Alert.Create(2, Curso.Mensagens.ConfirmacaoExclusao.replace('#', ' o curso ' + desc), 400, buttons);
    },
    Pesquisar: function () {
        var descricao = $("#txtDescricaoFiltro").val();
        var ativo = $("#ddlStatusFiltro").val();

        var buttons = [{
            text: "Fechar",
            cssClass: 'btn btn-primary btn-outline',
            close: true
        }];

        if (descricao == '') {
            AmilFramework.Alert.Create(1, Curso.Mensagens.PreenchaDescricao, 400, buttons, Curso.Titulo);
            return;
        }

        if (ativo == '') {
            AmilFramework.Alert.Create(1, Curso.Mensagens.PreenchaStatus, 400, buttons, Curso.Titulo);
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
                        Action: { Function: 'PesquisaCurso.Alterar', Parameter: ['Id'] },
                        Layout: { Default: { Title: 'Alterar', CssClass: 'fa fa-edit margin2' } }
                    },
                    Excluir: {
                        Action: { Function: 'PesquisaCurso.Excluir', Parameter: ['Id' , 'Descricao'] },
                        Layout: {
                            Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                        }
                    }
                }
            }
        ];

        //$.ajax({
        //    url: Curso.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                PesquisaCurso.GridCursos = new AmilGrid('grvCursos', Curso.Urls.PesquisaCursos, { descricao: descricao, ativo: ativo }, actions);
                PesquisaCurso.GridCursos.Create();
        //    }
        //});



        $('#dttCursos').show();
    }
};

var ManutencaoCurso = {
    IdCurso: 0,
    GridPesquisaCurso: null,
    Inicializar: function () {
        IdCurso = $('#Id').val()
        $('#Descricao').focus();
    },
    
    Voltar: function () {
        AmilFramework.Common.OpenAjaxURL(Curso.Urls.PesquisaCursos);
    },

    Salvar: function () {
        var formValido = AmilFramework.Form.Validation.IsValid('#frmManutencaoCurso');

        if (formValido) {
            var descricao = $('#Descricao').val();
            var ativo = $("#Ativo :selected").val();
            var idCurso = $('#Id').val();


            //$.ajax({
            //    url: Curso.Urls.GerarToken,
            //    type: 'POST',
            //    data: {},
            //    success: function (token) {
                    $.ajax({
                        url: Curso.Urls.ManutencaoCurso,
                        type: 'POST',
                        data:
                            {
                                idCurso: idCurso,
                                descricao: descricao,
                                ativo: ativo
                            },
                        success: function (data) {
                            if (!data.Erro) {
                                var buttons = [{
                                    text: "Fechar",
                                    cssClass: 'btn btn-primary btn-outline',
                                    click: function () {
                                        AmilFramework.Common.OpenAjaxURL(Curso.Urls.PesquisaCursos);
                                    }
                                }];

                                AmilFramework.Alert.Create(0, Curso.Mensagens.SucessoGravacao, 400, buttons, Curso.Titulo);
                            } else {
                                var buttons = [{
                                    text: "Fechar",
                                    cssClass: 'btn btn-primary btn-outline',
                                    close: true
                                }];

                                AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Curso.Titulo);
                            }
                        }
                    });
            //    }
            //});

        }
    }
};

