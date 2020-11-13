var Home = {
    Titulo: '',
    Urls: {
        PesquisaWorkflow: '',
        RegistrosAprovacao: '',
        RegistrosHabilitacao: '',
        //AL
        //GerarToken: ''
    },
    Mensagens:
       {
           SucessoGravacao: '',
           ConfirmacaoExclusao: ''
       }
};


var PesquisaResumo =
{
    GridHabilitacao: null,
    GridAprovacao: null,
    Inicializar: function () {
        PesquisaResumo.PesquisarWorkflow();
    },
    PesquisarWorkflow: function () {
        //$.ajax({
        //    url: Home.Urls.GerarToken,
        //    type: 'POST',
        //    data: {},
        //    success: function (token) {

        PesquisaResumo.GridHabilitacao = new AmilGrid('grvHabilitacoes', Home.Urls.PesquisaWorkflow, { idWorkflow: 1 });//, token : token
                PesquisaResumo.GridHabilitacao.Create();
                $('#dttHabilitacao').show();

                PesquisaResumo.GridAprovacao = new AmilGrid('grvAprovacoes', Home.Urls.PesquisaWorkflow, { idWorkflow: 2});//, token : token
                PesquisaResumo.GridAprovacao.Create();
                $('#dttAprovacao').show();
        //    }
        //});
    },
    RegistrosAprovacao: function () {
        AmilFramework.Common.OpenAjaxURL(Home.Urls.RegistrosAprovacao);
    },
    RegistrosHabilitacao: function () {
        AmilFramework.Common.OpenAjaxURL(Home.Urls.RegistrosHabilitacao);

        setTimeout(
            function () {
                $('#Data').focus();
            }, 500);
    }
};