var Aviso = {
    Titulo: 'Aviso',
    Urls: {
        PesquisaAviso: '',
        PesquisaUnidades: '',
        PesquisaEspecialidades: '',
        PesquisaProfissionais: '',
        PesquisaVigencia: '',
        ExibeResumo: '',
        InclusaoAviso: '',
        ManutencaoAviso: '',
        ExclusaoAviso: '',
        ProfissionalAvisos: '',
        AlterarAviso: '',
        ExibeAviso: '',
        ProfissionalRedir: '',
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

var PesquisaAviso =
{
    GridAviso: null,
    Inicializar: function () {

        $('#txtNomeProfissionalFiltro').val('');
        $('#ddlTipoConselhoFiltro').val('');
        $('#txtNumeroConselhoFiltro').val('');
        $('#ddlUFFiltro').val('');
        $('#ddlUnidadeFiltro').val('');
        $('#DataInicial').val('');
        $('#DataFinal').val('');

        $('#txtNomeProfissionalFiltro').focus();
        $('#dttAviso').hide();
    },
    Validar: function () {
    },
    Limpar: function () {
        $('#txtNomeProfissionalFiltro').val('');
        $('#ddlTipoConselhoFiltro').val('');
        $('#txtNumeroConselhoFiltro').val('');
        $('#ddlUFFiltro').val('');
        $('#ddlUnidadeFiltro').val('');
        $('#DataInicial').val('');
        $('#DataFinal').val('');
        $('#dttAviso').hide();
    },
    Pesquisar: function () {
        var nomeProfissional = $("#txtNomeProfissionalFiltro").val();
        var conselho = $("#ddlTipoConselhoFiltro").val();
        var numeroConselho = $("#txtNumeroConselhoFiltro").val();
        var uf = $("#ddlUFFiltro").val();
        var unidade = $("#ddlUnidadeFiltro").val();
        var dataInicial = $("#txtDataInicialFiltro").val();
        var dataFinal = $("#txtDataFinalFiltro").val();

        var incluirInativos = 0;

        var validationButtons = [{
            text: "Fechar",
            cssClass: 'btn btn-primary btn-outline',
            close: true
        }];

        if (nomeProfissional.length === 0
            && conselho.length === 0
            && numeroConselho.length === 0
            && uf.length === 0
            && unidade.length === 0
            && dataInicial.length === 0
            && dataFinal.length === 0) {
            AmilFramework.Alert.Create(0, 'Selecione pelo menos 1 filtro antes de continuar.', 400, validationButtons, Aviso.Titulo);

            return;
        }

        if ($("#chkIncluirInativosFiltro").prop("checked"))
            incluirInativos = 1;

        if (numeroConselho != '' && conselho == '') {
            AmilFramework.Alert.Create(0, 'Selecione o tipo de conselho.', 400, validationButtons, Aviso.Titulo);

            return;

        }

        var actions = [
            {
                Collumn: 'Acoes',
                Buttons: {
                    Visualizar: {
                        Action: { Function: 'PesquisaAviso.Visualizar', Parameter: ['Id'] },
                        Layout: { Default: { Title: 'Visualizar', CssClass: 'fa fa-file-o margin2' } }
                    },
                    Editar: {
                        Action: { Function: 'PesquisaAviso.Alterar', Parameter: ['Id', 'FimVigencia'] },
                        Layout: { Default: { Title: 'Alterar', CssClass: 'fa fa-edit margin2' } }
                    },
                    Excluir: {
                        Action: { Function: 'PesquisaAviso.Excluir', Parameter: ['Id'] },
                        Layout: {
                            Default: { Title: 'Excluir', CssClass: 'fa fa-trash-o margin2' }
                        }
                    }
                }
            }
        ];

        PesquisaAviso.GridAviso = new AmilGrid('grvAviso', Aviso.Urls.PesquisaAviso, { nomeProfissional: nomeProfissional, conselho: conselho, numeroConselho: numeroConselho, uf: uf, unidade: unidade, incluirInativos: incluirInativos, dataInicial: dataInicial, dataFinal: dataFinal}, actions);
        PesquisaAviso.GridAviso.Create();

        //$.ajax({
        //    url: Aviso.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
        //        PesquisaAviso.GridAviso = new AmilGrid('grvAviso', Aviso.Urls.PesquisaAviso, { nomeProfissional: nomeProfissional, conselho: conselho, numeroConselho: numeroConselho, uf: uf, unidade: unidade, incluirInativos: incluirInativos, dataInicial: dataInicial, dataFinal: dataFinal, token: token }, actions);
        //        PesquisaAviso.GridAviso.Create();
        //    }
        //});

        $('#dttAviso').show();

    },
    Incluir: function () {
        AmilFramework.Common.EncryptQueryUrl("idAviso=0", function (data) {
            AmilFramework.Common.OpenAjaxURL(Aviso.Urls.ManutencaoAviso + "?" + data);
        });
    },
    Alterar: function (id, fimVigencia) {

        var from = fimVigencia.split('/');
        var fim = new Date(from[2], from[1] - 1, from[0]);
        var hoje = new Date();

        if (fim < hoje) {

            var buttons = [{
                text: "Fechar",
                cssClass: 'btn btn-primary btn-outline',
                close: true
            }];

            AmilFramework.Alert.Create(0, 'Não é possível alterar a vigência de avisos inativos.', 400, buttons, Aviso.Titulo);

        } else {

            AmilFramework.Common.EncryptQueryUrl("idAviso=" + id, function (data) {
                AmilFramework.Common.OpenAjaxURL(Aviso.Urls.PesquisaVigencia + "?" + data);
            });
        }

    },
    Excluir: function (id) {

        var buttons = [
                        {
                            text: "Sim",
                            cssClass: 'btn btn-primary',
                            click: function (idModal) {
                                $('#' + idModal).modal('hide');
                                //$.ajax({
                                //    url: Aviso.Urls.GerarToken,
                                //    type: 'POST',
                                //    data: {},
                                //    success: function (token) {
                                        $.ajax({
                                            url: Aviso.Urls.ExclusaoAviso,
                                            type: 'POST',
                                            data:
                                                {
                                                    idAviso: id,
                                                    //token: token
                                                },
                                            success: function (data) {
                                                if (!data.Erro) {
                                                    PesquisaAviso.Pesquisar();
                                                    var buttons1 = [{
                                                        text: "Fechar",
                                                        cssClass: 'btn btn-primary btn-outline',
                                                        close: true
                                                    }];

                                                    AmilFramework.Alert.Create(0, Aviso.Mensagens.SucessoExclusao, 400, buttons1, Aviso.Titulo);
                                                } else {
                                                    var buttons2 = [{
                                                        text: "Fechar",
                                                        cssClass: 'btn btn-primary btn-outline',
                                                        close: true
                                                    }];

                                                    AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons2, Aviso.Titulo);
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

        AmilFramework.Alert.Create(2, Aviso.Mensagens.ConfirmacaoExclusao, 400, buttons);
    },
    Visualizar: function (id) {
        AmilFramework.Common.EncryptQueryUrl("idAviso=" + id, function (data) {
            AmilFramework.Common.OpenAjaxURL(Aviso.Urls.ExibeAviso + "?" + data);
        });

    },
    Voltar: function () {
        AmilFramework.Common.OpenAjaxURL(Aviso.Urls.PesquisaAviso);
    }

};

var ManutencaoAviso =
{
    IdAviso: 0,
    DataInicioVigencia: '',
    DataFimVigencia: '',
    Inicializar: function () {

        IdAviso = $('#Id').val();

        $('#InicioVigencia').prop('disabled', true);
        $('#FimVigencia').prop('disabled', true);

        $('#dtDataInicial').datetimepicker({
            inline: true,
            sideBySide: true,
            format: 'DD/MM/YYYY',
            locale: 'pt-br',
        }).on('dp.change', function (e) {

            var dataInicioSelect = $('#dtDataInicial').data('DateTimePicker').date().format('DD/MM/YYYY');

            $('#InicioVigencia').val(dataInicioSelect);

            $("#dtDataFinal").data('DateTimePicker').minDate(dataInicioSelect);
            $('#dtDataFinal').data('DateTimePicker').date(dataInicioSelect);

        });

        $('#dtDataFinal').datetimepicker({
            inline: true,
            sideBySide: true,
            format: 'DD/MM/YYYY',
            locale: 'pt-br',
        }).on('dp.change', function (e) {

            var dataFimSelect = $('#dtDataFinal').data('DateTimePicker').date().format('DD/MM/YYYY');

            $('#FimVigencia').val(dataFimSelect);
        });

        if (IdAviso != '') {

            DataInicioVigencia = $('#InicioVigencia').val();
            DataFimVigencia = $('#FimVigencia').val();

            var hoje = new Date().toDateString();

            $('#dtDataInicial').data('DateTimePicker').date(DataInicioVigencia);
            $('#dtDataInicial').data('DateTimePicker').date();
            $("#dtDataInicial").data('DateTimePicker').minDate(moment(hoje).format('DD/MM/YYYY'));

            $('#dtDataFinal').data('DateTimePicker').date(DataFimVigencia);
            $('#dtDataFinal').data('DateTimePicker').date();
            $("#dtDataFinal").data('DateTimePicker').minDate(moment(hoje).format('DD/MM/YYYY'));

            $('#btnAvancar').hide();
            $('#btnVoltar').hide();

        } else {

            DataInicioVigencia = moment(hoje).format('DD/MM/YYYY');
            DataFimVigencia = moment(hoje).format('DD/MM/YYYY');

            $('#InicioVigencia').val(DataInicioVigencia);
            $('#FimVigencia').val(DataFimVigencia);

            $("#dtDataInicial").data('DateTimePicker').minDate(DataInicioVigencia);
            $("#dtDataFinal").data('DateTimePicker').minDate(DataFimVigencia);

            $('#Titulo').val('');
            $('#Conteudo').val('');
            $('#Id').val(0);

            $('#btnSalvar').hide();
        }

    },
    ControlarAbas: function () {

        var navListItems = $('div.setup-panel div a');
        var allWells = $('.setup-content');
        var allNextBtn = $('.nextBtn');
        var allPrevBtn = $('.prevBtn');

        allWells.hide();

        navListItems.click(function (e) {
            e.preventDefault();

            var $target = $($(this).attr('href'));
            var $item = $(this);

            if ($item.attr('disabled') != 'disabled') {

                navListItems.removeClass('btn-success').addClass('btn-default');
                $item.addClass('btn-success');
                allWells.hide();
                $target.show();
                $target.find('input:eq(0)').focus();
            }
        });

        $(document).on('click', '.nextBtn', function () {
            var $curStep = $(this).closest(".setup-content");
            var curStepBtn = $curStep.attr("id");
            var nextStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().next().children("a");


            var curInputs = $curStep.find("input[type = 'text'], textarea");
            var isValid = true;

            for (var i = 0; i < curInputs.length; i++) {
                var text = $(curInputs[i]).val();
                var controle = $(curInputs[i]);

                if (text.trim() == "" && controle.attr('Obrigatorio') == "true") {
                    isValid = false;
                }
            }

            if (isValid) {
                navListItems.attr('disabled', 'disabled');
                nextStepWizard.removeAttr('disabled').trigger('click');
            }

        });

        $(document).on('click', '.prevBtn', function () {
            var $curStep = $(this).closest(".setup-content");
            var curStepBtn = $curStep.attr("id");
            var prevStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().prev().children("a");

            navListItems.attr('disabled', 'disabled');
            prevStepWizard.removeAttr('disabled').trigger('click');
        });

        $('div.setup-panel div a.btn-success').trigger('click');

    },
    ControlarCheckBoxList: function () {

        // Add the "focus" value to class attribute 
        $('ul.checkbox li').focusin(function () {
            $(this).addClass('focus');
        }
        );

        // Remove the "focus" value to class attribute 
        $('ul.checkbox li').focusout(function () {
            $(this).removeClass('focus');
        }
        );

    },
    ControlarSelecao: function (controle1, controle2) {
        var $options = $(controle1).clone();
        $(controle2).append($options);
        $(controle1).remove();
    },
    FiltraCaixaDeSelecao: function (texto, caixaDeTexto) {

        var keyword = document.getElementById(texto).value;
        var select = document.getElementById(caixaDeTexto);
        for (var i = 0; i < select.length; i++) {
            var txt = select.options[i].text;
            if (txt.toLowerCase().indexOf(keyword.toLowerCase()) < 0) {
                $(select.options[i]).attr('disabled', 'disabled').hide();
            } else {
                $(select.options[i]).removeAttr('disabled').show();
            }
        }

    },
    PesquisarUnidades: function () {

        //$.ajax({
        //    url: Aviso.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                $.ajax({
                    type: 'POST',
                    dataType: "html",
                    //data: { token: token },
                    data: {},
                    url: Aviso.Urls.PesquisaUnidades,
                    success: function (data) {
                        $('#unidadesAviso').html(data);
                    }
                });
        //    }
        //});
    },
    PesquisarEspecialidades: function () {

        var mUnidades = $('#ListaUnidadesTodas option').map(function (i, n) {
            return { 'Id': $(n).val(), 'Descricao': $(n).text() };
        }).get();

        var mUnidadesSelecionadas = $('#ListaUnidadesSelecionadas option').map(function (i, n) {
            return { 'Id': $(n).val(), 'Descricao': $(n).text() };
        }).get();


        var unidades = JSON.stringify(mUnidades);
        var unidadesSelecionadas = JSON.stringify(mUnidadesSelecionadas);
        //$.ajax({
        //    url: Aviso.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                $.ajax({
                    type: 'POST',
                    dataType: "html",
                    url: Aviso.Urls.PesquisaEspecialidades,
                    data: {
                        unidades: unidades,
                        unidadesSelecionadas: unidadesSelecionadas,
                        //token: token
                    },
                    success: function (data) {
                        $('#especialidadesAviso').html(data);
                    }
                });
        //    }
        //});
    },
    PesquisarProfissionais: function () {

        var mEspecialidades = $('#ListaEspecialidadesTodas option').map(function (i, n) {
            return { 'Id': $(n).val(), 'Descricao': $(n).text() };
        }).get();

        var mEspecialidadesSelecionadas = $('#ListaEspecialidadesSelecionadas option').map(function (i, n) {
            return { 'Id': $(n).val(), 'Descricao': $(n).text() };
        }).get();


        var especialidades = JSON.stringify(mEspecialidades);
        var especialidadesSelecionadas = JSON.stringify(mEspecialidadesSelecionadas);


        //$.ajax({
        //    url: Aviso.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                $.ajax({
                    type: 'POST',
                    dataType: "html",
                    url: Aviso.Urls.PesquisaProfissionais,
                    data: {
                        especialidades: especialidades,
                        especialidadesSelecionadas: especialidadesSelecionadas,
                        //token: token
                    },
                    success: function (data) {
                        $('#profissionaisAviso').html(data);
                    }
                });
        //    }
        //});


    },
    ExibirResumo: function () {

        var mProfissionais = $('#ListaProfissionaisTodos option').map(function (i, n) {
            return { 'Id': $(n).val(), 'Nome': $(n).text() };
        }).get();

        var mProfissionaisSelecionados = $('#ListaProfissionaisSelecionados option').map(function (i, n) {
            return { 'Id': $(n).val(), 'Nome': $(n).text() };
        }).get();


        var profissionais = JSON.stringify(mProfissionais);
        var profissionaisSelecionados = JSON.stringify(mProfissionaisSelecionados);

        var idAviso = $('#Id').val();
        var tituloAviso = $('#Titulo').val();
        var conteudoAviso = $('#Conteudo').val();

        var inicioVigenciaAviso = $('#InicioVigencia').val();
        var fimVigenciaAviso = $('#FimVigencia').val();


        //$.ajax({
        //    url: Aviso.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                $.ajax({
                    type: 'POST',
                    url: Aviso.Urls.ExibeResumo,
                    data: {
                        idAviso: idAviso,
                        tituloAviso: tituloAviso,
                        conteudoAviso: conteudoAviso,
                        inicioVigenciaAviso: inicioVigenciaAviso,
                        fimVigenciaAviso: fimVigenciaAviso,
                        profissionais: profissionais,
                        profissionaisSelecionados: profissionaisSelecionados,
                        //token: token
                    },
                    success: function (data) {
                        $('#resumoAviso').html(data);
                    }
                });
        //    }
        //});

    },
    Salvar: function () {
        var idAviso = $('#Id').val();
        var tituloAviso = $('#Titulo').val();
        var conteudoAviso = $('#Conteudo').val();

        var inicioVigenciaAviso = $('#InicioVigencia').val();
        var fimVigenciaAviso = $('#FimVigencia').val();

        //$.ajax({
        //    url: Aviso.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                $.ajax({
                    url: Aviso.Urls.ManutencaoAviso,
                    type: 'POST',
                    data:
                        {
                            idAviso: idAviso,
                            tituloAviso: tituloAviso,
                            conteudoAviso: conteudoAviso,
                            inicioVigenciaAviso: inicioVigenciaAviso,
                            fimVigenciaAviso: fimVigenciaAviso,
                            //token: token
                        },
                    success: function (data) {
                        if (!data.Erro) {
                            var buttons = [{
                                text: "Fechar",
                                cssClass: 'btn btn-primary btn-outline',
                                click: function () {
                                    AmilFramework.Common.OpenAjaxURL(Aviso.Urls.PesquisaAviso);
                                }
                            }];

                            AmilFramework.Alert.Create(0, Aviso.Mensagens.SucessoGravacao, 400, buttons, Aviso.Titulo);
                        } else {
                            var buttons = [{
                                text: "Fechar",
                                cssClass: 'btn btn-primary btn-outline',
                                close: true
                            }];

                            AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Aviso.Titulo);
                        }
                    }
                });
        //    }
        //});
    },
    Cancelar: function () {
        AmilFramework.Common.OpenAjaxURL(Aviso.Urls.PesquisaAviso);
    }
};

var ManutencaoVigenciaAviso =
{
    IdAviso: 0,
    DataInicioVigencia: '',
    DataFimVigencia: '',
    Inicializar: function () {

        $('#InicioVigencia').prop('disabled', true);
        $('#FimVigencia').prop('disabled', true);

        IdAviso = $('#Id').val();

        DataInicioVigencia = $('#InicioVigencia').val();
        DataFimVigencia = $('#FimVigencia').val();


        $('#dtDataInicial').datetimepicker({
            inline: true,
            sideBySide: true,
            format: 'DD/MM/YYYY',
            locale: 'pt-br',
        }).on('dp.change', function (e) {

            var dataInicioSelect = $('#dtDataInicial').data('DateTimePicker').date().format('DD/MM/YYYY');

            $('#InicioVigencia').val(dataInicioSelect);

            $("#dtDataFinal").data('DateTimePicker').minDate(dataInicioSelect);
            $('#dtDataFinal').data('DateTimePicker').date(dataInicioSelect);

        });

        $('#dtDataFinal').datetimepicker({
            inline: true,
            sideBySide: true,
            format: 'DD/MM/YYYY',
            locale: 'pt-br',
        }).on('dp.change', function (e) {

            var dataFimSelect = $('#dtDataFinal').data('DateTimePicker').date().format('DD/MM/YYYY');

            $('#FimVigencia').val(dataFimSelect);
        });

        var hoje = new Date();
        //var bloqueioAte = hoje.setDate(hoje.getDate() + 500000);

       
        $("#dtDataInicial").data('DateTimePicker').minDate(moment(hoje).format('DD/MM/YYYY'));
        $("#dtDataFinal").data('DateTimePicker').minDate(moment(hoje).format('DD/MM/YYYY'));

        if (DataInicioVigencia <= hoje) {

            $('#dtDataInicial').data('DateTimePicker').disable();

        }

    },
    Salvar: function () {

        var idAviso = $("#Id").val();
        var titulo = $("#Titulo").val();
        var conteudo = $("#Conteudo").val();
        var inicioVigencia = $("#InicioVigencia").val();
        var fimVigencia = $('#FimVigencia').val();
        //$.ajax({
        //    url: Aviso.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                $.ajax({
                    url: Aviso.Urls.AlteraVigencia,
                    type: 'POST',
                    data:
                        {
                            idAviso: idAviso,
                            titulo: titulo,
                            conteudo: conteudo,
                            inicioVigencia: inicioVigencia,
                            fimVigencia: fimVigencia,
                            //token: token
                        },
                    success: function (data) {
                        if (!data.Erro) {
                            var buttons = [{
                                text: "Fechar",
                                cssClass: 'btn btn-primary btn-outline',
                                click: function () {
                                    AmilFramework.Common.OpenAjaxURL(Aviso.Urls.PesquisaAviso);
                                }
                            }];

                            AmilFramework.Alert.Create(0, Aviso.Mensagens.SucessoGravacao, 400, buttons, Aviso.Titulo);
                        } else {
                            var buttons = [{
                                text: "Fechar",
                                cssClass: 'btn btn-primary btn-outline',
                                close: true
                            }];

                            AmilFramework.Alert.Create(3, data.Mensagem, 400, buttons, Aviso.Titulo);
                        }
                    }
                });
        //    }
        //});
    },
    Cancelar: function () {
        AmilFramework.Common.OpenAjaxURL(Aviso.Urls.PesquisaAviso);
    }
};

var ProfissionalAviso =
{
    GridAviso: null,
    Inicializar: function () {
        //$.ajax({
        //    url: Aviso.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                $('#btnVoltar').on('click', function (e) { ProfissionalAviso.Voltar(); });
                ProfissionalAviso.GridAviso = new AmilGrid('grvAviso', Aviso.Urls.ProfissionalAvisos);//, { token: token }
                ProfissionalAviso.GridAviso.Create();//.done(function () {
                $('#grvAviso').on('draw.dt', function () {
                    $('#grvAviso td:nth-child(2)').each(function () {
                        var cellText = $(this).html();
                        if (cellText == "") {
                            $(this).prev().css('font-weight', 'bold');
                        }
                    });

                    $('#grvAviso tbody tr').click(function () {
                        $('#lblTitulo').text($(this).find('td:nth-child(1)').text());
                        $('#lblConteudo').text($(this).find('td:nth-child(4)').text());
                        $(this).find('td:nth-child(1)').css('font-weight', 'normal');
                        $('#AvisoProfissionalModal').modal();
                        if ($(this).find('td:nth-child(2)').html() == "") {
                            var currentdate = new Date();
                            var mes = (currentdate.getMonth() + 1);
                            if (mes < 10) {
                                mes = "0" + mes;
                            }
                            var datetime = currentdate.getDate() +
                                "/" +
                                (mes) +
                                "/" +
                                currentdate.getFullYear();
                            $(this).find('td:nth-child(2)').text(datetime);
                            ProfissionalAviso.MostrarModalAviso($(this).find('td:nth-child(3)').text());
                        }
                    });
                });

                $('#dttAviso').show();

        //    }
        //});
    },
    Voltar: function () {
        //$.ajax({
        //    url: Aviso.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                $.ajax({
                    url: Aviso.Urls.ProfissionalRedir,
                    type: 'POST',
                    data: { },//{ token: token },
                    success: function (data) {
                        var a = $.parseJSON(data.Result);
                        window.location.href = "../" + a;
                    }
                });
        //    }
        //});
    },
    MostrarModalAviso: function (idAviso) {
        //$.ajax({
        //    url: Aviso.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {
                $.ajax({
                    url: Aviso.Urls.AlterarAviso,
                    type: 'POST',
                    data:
                    {
                        idAviso: idAviso,
                        //token: token
                    }
                });
            }
    //    });
    //}
}
