EditarCriarUnidadeController = {
    Init: function () {
        
        EditarCriarUnidadeController.AdicionarMascaras();

        EditarCriarUnidadeController.ConfigurarFormulario();
        EditarCriarUnidadeController.FormBehavior();
        EditarCriarUnidadeController.ConfigurarMapa();

        EditarCriarUnidadeController.VerificarAcessoQRCode();


    },
    ConfigurarFormulario: function () {
        // Habilitar ou desabilitar checkboxs de acordo com as regras de negócios.
        if ($('#ExibeApp').is(":checked")) {
            $("[data-dependeExibeApp]").attr("disabled", false);
        }
        else {
            $("[data-dependeExibeApp]").prop("checked", false);
            $("[data-dependePreTriagem]").prop("checked", false);
            $("[data-dependeExibeApp]").attr("disabled", true);
            $("[data-dependePreTriagem]").attr("disabled", true).val("");
            $("[data-dependeGPS]").attr("disabled", true).val("");
        }
        //if ($("#sistOrig").val() != "SisHosp") {
        //    $("#relNOW").attr("disabled", true);
        //    //$("#relNOW").val("");
        //}
        if ($("#PreTriagem").is(":checked"))
            $("[data-dependePreTriagem]").attr("disabled", false).attr("required", "");
        else
            $("[data-dependePreTriagem], [data-dependeGPS]")
                .attr("disabled", true)
                .val("")
                .prop("checked", false)
                .removeAttr("required")
                .removeClass("red-border");

        if ($("#SenhaBeacon").is(":checked"))
            $("#beaconContainer").show();

        if ($("input#Identificador").val() == 0)
            $("#Ativo").attr("checked", true);

        
        if ($("#SistOrigemHidden").val()) {
            $("#sistOrig").val($("#SistOrigemHidden").val());
            if ($("#sistOrig").val() != "SisHosp")
                $("#relNOW").attr("disabled", true);
        }
        else {
            $("#relNOW").attr("disabled", true);
            $("#relNOW").val("");
        }

        $("#uf").change(function () {
            $("#ufHidden").val($(this).val());
        });
        
    },

    AdicionarMascaras: function () {
        $("#CEP").mask('99999-999');
        $("#Numero").mask("999999");
        $("#tempoPreTriagem").mask("99");
        $("#raioGPS").mask("999999");
        $('#Telefone').mask(EditarCriarUnidadeController.SPMaskBehavior, EditarCriarUnidadeController.spOptions);
        $('#codCorporativo').mask('9999999999');
    },
    spOptions: {
        onKeyPress: function (val, e, field, options) {
            field.mask(EditarCriarUnidadeController.SPMaskBehavior.apply({}, arguments), options);
        }
    },
    SPMaskBehavior: function (val) {
        return val.replace(/\D/g, '').length === 11 ? '(00) 00000-0000' : '(00) 0000-00009';
    },
    FormBehavior: function () {
        $('#ExibeApp').change(function () {
            if ($(this).is(":checked")) {
                $("[data-dependeExibeApp]").attr("disabled", false);
            }
            else {
                $("[data-dependeExibeApp]").prop("checked", false);
                $("[data-dependePreTriagem]").removeAttr("required");
                $("[data-dependePreTriagem]").prop("checked", false);
                $("[data-dependeExibeApp]").attr("disabled", true);
                $("[data-dependePreTriagem]").attr("disabled", true).val("");
                $("[data-dependeGPS]").attr("disabled", true).val("");
            }
        });
        $('#PreTriagem').change(function () {
            if ($(this).is(":checked"))
                $("[data-dependePreTriagem]").attr("disabled", false).attr("required", "");
            else
                $("[data-dependePreTriagem], [data-dependeGPS]")
                    .attr("disabled", true)
                    .val("")
                    .prop("checked", false)
                    .removeAttr("required")
                    .removeClass("red-border");
        });
        $("#SenhaQRCode").change(function () {
            if ($(this).is(":checked"))
                $("#gerarQRCode").show();
            else
                $("#gerarQRCode").hide();

            if ($('#codCorporativo').val())
                $("#gerarQRCode").attr("disabled", false);
            else
                $("#gerarQRCode").attr("disabled", true);

        });
        $('#SenhaGPS').change(function () {
            if ($(this).is(":checked"))
                $("[data-dependeGPS]").attr("disabled", false).attr("required", "");
            else
                $("[data-dependeGPS]")
                    .attr("disabled", true)
                    .val("")
                    .removeAttr("required")
                    .removeClass("red-border");

        });
        $("#codCorporativo").on("keyup", function () {

            if ($(this).val())
                $("#gerarQRCode").attr("disabled", false);
            else
                $("#gerarQRCode").attr("disabled", true);
        });
        $("#SenhaBeacon").change(function () {
            if ($("#SenhaBeacon").is(":checked"))
                $("#beaconContainer").show();
            else
                $("#beaconContainer").hide();
        });

        if ($("#ufHidden").val())
            $("#uf").val($("#ufHidden").val());

        

        $("#Logradouro, #Numero, #Numero, #Municipio").blur(function () {
            if ($("#Logradouro").val() && $("#Numero").val() && $("#Numero").val() && $("#Municipio").val()) {
                BuscarEndereco();
            }
        });

        $('#uploadFoto').on("change", function () {
            uploadFile();
        });

        $("#sistOrig").change(function () {
            $("#SistOrigemHidden").val($("#sistOrig").val());
            if ($(this).val() === "SisHosp") {
                $("#relNOW").attr("disabled", false);
                $("#relNOW").attr("required", true);
            }
            else {
                $("#relNOW").val('');
                $("#relNOW").attr("disabled", true);
                $("#relNOW").attr("required", false);
            }
        });
        $("#relNOW").on("blur", function () {
            PesquisarUnidadeNow();
        });
    },
    ConfigurarMapa: function () {
        if (AmilMaps.oMap.gMap == null) {
            AmilMaps.init(google);
        } else {
            AmilMaps.ResetMap();
        }

        AmilMaps.settings.UrlSite = "/Content/Imagens/"
        AmilMaps.settings.StartZoom = 15;
        AmilMaps.settings.CircleRadius = 300;
        AmilMaps.StartMaps();
        BuscarEndereco();
    },
    CancelarForm: function () {
        if (confirm("Deseja realmente voltar?"))
            window.history.go(-1);//window.location = "../../AppHospitais/Unidades";
    },

    VerificarAcessoQRCode: function () {
        if ($('#SenhaQRCode').is(":checked"))
            $("#gerarQRCode").show();
        else
            $("#gerarQRCode").hide();

        if ($("#codCorporativo").val())
            $("#gerarQRCode").attr("disabled", false);
        else
            $("#gerarQRCode").attr("disabled", true);
    },

    Mensagem: function (titulo, texto, tipo) {
        toastr.options = {
            "closeButton": true,
            "debug": false,
            "newestOnTop": false,
            "progressBar": false,
            "positionClass": "toast-bottom-full-width",
            "preventDuplicates": false,
            "onclick": null,
            "showDuration": "300",
            "hideDuration": "1000",
            "timeOut": "5000",
            "extendedTimeOut": "1000",
            "showEasing": "swing",
            "hideEasing": "linear",
            "showMethod": "fadeIn",
            "hideMethod": "fadeOut"
        }
        toastr[tipo](texto, titulo)
    },
}