$(function () {
    ConfigAppController.Init();
})
var ConfigAppController = {
    Init: function () {
        $.each($("[name=UrlLoja]"), function (i) {
            $(this).attr("name", "Aplicativos[" + i + "].UrlLoja");
        });
        $.each($("[name=VersaoMinima]"), function (i) {
            $(this).attr("name", "Aplicativos[" + i + "].VersaoMinima");
        });
        $.each($("[name=VersaoAtual]"), function (i) {
            $(this).attr("name", "Aplicativos[" + i + "].VersaoAtual");
        });
        $.each($("[name=Sistema]"), function (i) {
            $(this).attr("name", "Aplicativos[" + i + "].Sistema");
        });
        $("#ddlTipoTempo").val($("#HddUnidadeTempo").val());

        $("#ddlTipoTempo").change(function () {
            $("#HddUnidadeTempo").val($("#ddlTipoTempo").val());
        });
    }
}