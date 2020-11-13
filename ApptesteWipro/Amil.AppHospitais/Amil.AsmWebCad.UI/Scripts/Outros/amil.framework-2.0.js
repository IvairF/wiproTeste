$.isNullOrEmpty = function (seletor) {
    var value = $(seletor).val();
    return (!value || $.trim(value) === "");
};

$.urlParam = function (name) {
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    return (results == null) ? null : (results[1] || 0);
};

jQuery.fn.delay = function (time, func) {
    this.each(function () {
        setTimeout(func, time);
    });
    return this;
};

// Define an Enum function for the base Object class
//Object.defineProperty(Object.prototype, 'Enum', {
//    value: function () {
//        for (i in arguments) {
//            Object.defineProperty(this, arguments[i], {
//                value: parseInt(i),
//                writable: false,
//                enumerable: true,
//                configurable: true
//            });
//        }
//    },
//    writable: false,
//    enumerable: false,
//    configurable: false
//});

var AmilFramework = {
    Messages: {
        AlertTitle: 'Mensagem do sistema'
    },
    Common: {
        Pick: function Pick(arg, def) {

            if (typeof arg == 'undefined')
                return def;

            if (arg == null)
                return def;

            return arg;
        },
        StringIsNullOrEmpty: function (s) {
            return (s == null || s === '');
        },
        StringFormat: function () {
            var s = arguments[0];
            for (var i = 0; i < arguments.length - 1; i++) {
                var reg = new RegExp("\\{" + i + "\\}", "gm");
                s = s.replace(reg, arguments[i + 1]);
            }
            return s;
        },
        GetSystemName: function (data) {
            var os = data.appVersion;
            var osName = "Unknown OS";

            if (os.indexOf("Win") != -1) {
                if ((os.indexOf("Windows NT 5.1") != -1) || (os.indexOf("Windows XP") != -1)) {
                    osName = "Windows XP";
                } else if ((os.indexOf("Windows NT 7.0") != -1) || (os.indexOf("Windows NT 6.1") != -1)) {
                    osName = "Win 7";
                } else if ((os.indexOf("Windows NT 6.0") != -1)) {
                    osName = "Windows Vista/Server 08";
                } else if (os.indexOf("Windows ME") != -1) {
                    osName = "Windows ME";
                } else if ((os.indexOf("Windows NT 4.0") != -1) || (os.indexOf("WinNT4.0") != -1) || (os.indexOf("WinNT") != -1)) {
                    osName = "Windows NT";
                } else if ((os.indexOf("Windows NT 5.2") != -1)) {
                    osName = "Windows Server 03";
                } else if ((os.indexOf("Windows NT 5.0") != -1) || (os.indexOf("Windows 2000") != -1)) {
                    osName = "Windows 2000";
                } else if ((os.indexOf("Windows 98") != -1) || (os.indexOf("Win98") != -1)) {
                    osName = "Windows 98";
                } else if ((os.indexOf("Windows 95") != -1) || (os.indexOf("Win95") != -1) || (os.indexOf("Windows_95") != -1)) {
                    osName = "Windows 95";
                } else if ((os.indexOf("Win16") != -1)) {
                    osName = "Windows 3.1";
                } else {
                    osName = "Windows Ver. Unknown";
                }

                if ((os.indexOf("WOW64") != -1) || (os.indexOf("x64") != -1) || (os.indexOf("Win64") != -1) || (os.indexOf("IA64") != -1)) {
                    osName = osName + "(x64)";
                } else {
                    osName = osName + "(x32)";
                }
            } else if (os.indexOf("Mac") != -1) {
                osName = "MacOS";
            } else if (os.indexOf("X11") != -1) {
                osName = "UNIX";
            } else if (os.indexOf("Linux") != -1) {
                osName = "Linux";
            }

            return osName;
        },
        EncryptQueryUrl: function (data, callBackOk) {
            $.ajax({
                cache: false,
                type: "POST",
                url:  "../Security/Encrypt",
                data: { "data": data },
                success: function (result) {
                    if (!result.IsError) {
                        callBackOk(result);
                    }
                    else {
                        AmilFramework.Alert.Create(4, result.message, 400);
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    AmilFramework.Alert.Create(4, thrownError, 400);
                }
            });
        },
        OpenAjaxURL: function (url, content, activeMenu, beforeClickCallback) {

            if (beforeClickCallback)
                beforeClickCallback();

            window.location.href = url;
            return false;
        },
    },
    Form: {
        Initialize: function () {
            //$('form').each(function () {
            //    var validator = $(this).data('validator');
            //    validator.settings.showErrors = AmilFramework.Form.Validation.OnValidated;
            //});

            //AmilFramework.Form.Validation.ApplyValidation();
        },
        SetDefaultButton: function (formField, target) {
            $(formField).bind('keydown', function (event) {
                if (event.keyCode == 13) {

                    var doit = true;

                    if ($('.bootstrap-dialog-header').is(":visible") == true)
                        doit = false;

                    if ($('[type=reset]').is(':focus') == true)
                        doit = false;

                    if (doit)
                        $(target).click();
                }
            });
        },
        Validation: {
            FormField: null,
            IgnoreFields: null,
            Classes: { groupIdentifier: '.form-group', error: 'error', success: null },
            Apply: function (formField, ignoreFields) {

                this.FormField = formField;
                this.IgnoreFields = AmilFramework.Common.Pick(ignoreFields, null);

                $(formField).data('validator').settings.showErrors = AmilFramework.Form.Validation.OnValidated;

                $(formField).submit(function (event) {
                    var enviar = AmilFramework.Form.Validation.Validate();

                    if (!enviar)
                        event.preventDefault();
                });
            },
            IsValid: function (formField, ignoreFields) {

                ignoreFields = AmilFramework.Common.Pick(ignoreFields, null);

                $.validator.unobtrusive.parse(formField);

                var validator = $(formField).data('validator');
                if (validator) {
                    if (ignoreFields != null)
                        validator.settings.ignore = ignoreFields;
                }

                return $(formField).valid();
            },
            Validate: function () {

                var formField = this.FormField;
                var ignoreFields = this.IgnoreFields;

                $.validator.unobtrusive.parse(formField);

                $(formField).each(function () {
                    var validator = $(this).data('validator');

                    if (validator) {

                        if (ignoreFields != null)
                            validator.settings.ignore = ignoreFields;

                        validator.settings.showErrors = AmilFramework.Form.Validation.OnValidated;
                    }
                });

                return $(formField).validate().form();
            },
            UpdateClasses: function (inputElement, toAdd, toRemove) {

                var classes = this.Classes;


                var group = inputElement.closest(classes.groupIdentifier);
                if (group.length > 0) {
                    group.addClass(toAdd).removeClass(toRemove);
                }

                inputElement.addClass(toAdd).removeClass(toRemove);
            },
            OnValidated: function (errorMap, errorList) {
                $.each(errorList, function () {
                    AmilFramework.Form.Validation.OnError($(this.element), this.message);
                });

                if (this.settings.success) {
                    $.each(this.successList, function () {
                        AmilFramework.Form.Validation.OnSuccess($(this));
                    });
                }
            },
            OnError: function (inputElement, message) {
                var classes = this.Classes;
                AmilFramework.Form.Validation.UpdateClasses(inputElement, classes.error, classes.success);
                var options = { html: true, title: '<div class="tooltip-alert alert-danger">' + message + '</div>' };

                var group = inputElement.closest(classes.groupIdentifier);
                if (group.length > 0)
                    group.tooltip('destroy').tooltip(options);

                inputElement.tooltip('destroy').addClass('error').tooltip(options);
            },
            OnSuccess: function (inputElement) {
                var classes = this.Classes;
                AmilFramework.Form.Validation.UpdateClasses(inputElement, classes.success, classes.error);

                var group = inputElement.closest(classes.groupIdentifier);
                if (group.length > 0)
                    group.tooltip('destroy');

                inputElement.tooltip('destroy');
            }
        }
    },
    Layout: {
        Initialize: function () {

            AmilFramework.Layout.ApplyMasks();
            AmilFramework.Layout.ApplyCalendar();
            AmilFramework.Layout.ApplyChousen();
            AmilFramework.Layout.ApplyInputClickForm();

            // Menu OffCanvas
            $('[data-toggle="offcanvas"]').click(function () {
                $('.row-offcanvas').toggleClass('active');
            });

            $.ajaxPrefilter("json script", function (options) {
                options.crossDomain = true;
            });

            // remove window resize namespace
            $(document).on("dialogclose", ".ui-dialog", function () {
                $(window).off("resize.responsive");
            });

            $(document).ajaxSend(function (e, xhr, opt) {

                var showModal = AmilFramework.Common.Pick(opt.showModal, true);

                if (showModal)
                    AmilFramework.Layout.ShowModalWait();
            });

            $(document).ajaxComplete(function () {
                self.setTimeout(function () {
                    AmilFramework.Layout.HideModalWait();
                }, 300);
            });

            $('#js-loading-bar').on('shown.bs.modal', function () {

                var maxZ = Math.max.apply(null, $.map($('body > *'), function (e, n) {
                    if ($(e).css('position') == 'absolute')
                        return parseInt($(e).css('z-index')) || 1;
                }));
                var $modal = $('#js-loading-bar'),
                $back = $('.modal-backdrop');
                $modal.css('z-index', maxZ + 20);
                $back.css('z-index', maxZ + 10);
            });
        },
        ApplyMasks: function () {
            $('INPUT[dataMask]').each(function () {
                var t = $(this);
                t.mask(t.attr('dataMask'));
            });
        },
        ApplyCalendar: function () {
            $('DIV.dataCalendar').each(function () {
                var t = $(this);
                var viewMode = AmilFramework.Common.Pick(t.attr('data-date-viewmode'), 'days');
                t.datetimepicker({ format: 'DD/MM/YYYY', viewMode: viewMode, defaultDate: null, locale:'pt-BR' });
               
            });
        },
        ApplyChousen: function () {
            $('SELECT.select-chousen').each(function () {
                var t = $(this);

                var disableSearch = AmilFramework.Common.Pick(t.attr('data-chousen-search'), false);
                //var threshold = AmilFramework.Common.Pick(t.attr('data-chousen-threshold'), 5);

                //alert(t.attr('id') + ' - ' + threshold);
                t.chosen({ disable_search: disableSearch, disable_search_threshold: 5, width: "100%" });
            });
        },
        ApplyInputClickForm: function () {
            if ($('LABEL[data-input-click-form] INPUT').length) {
                $('LABEL[data-input-click-form]').each(function () {
                    $(this).removeClass('on');
                });
                $('LABEL[data-input-click-form] INPUT:checked').each(function () {
                    $(this).parent('label').addClass('on');
                });
            }

            $('LABEL[data-input-click-form]').on('click', function () {
                var field = $(this).attr('data-input-click-form');

                if ($('LABEL[data-input-click-form=' + field + '] INPUT').length) {
                    $('LABEL[data-input-click-form=' + field + ']').each(function () {
                        $(this).removeClass('on');
                    });
                    $('LABEL[data-input-click-form=' + field + '] INPUT:checked').each(function () {
                        $(this).parent('label').addClass('on');
                    });
                }
            });
        },
        ShowModalWait: function () {
            var $modal = $('#js-loading-bar'),
                $bar = $modal.find('.progress-bar');

            $modal.modal('show');
            $bar.addClass('animate');
            //$bar.progressbar({ value: 0 });


            var progressbar = $("#progressbar"), progressLabel = $(".progress-label");

            progressbar.progressbar({
                value: false,
                change: function () {
                    //progressLabel.text(progressbar.progressbar("value") + "%");
                },
                complete: function () {
                    //progressLabel.text("100%");
                    $(".loader").delay(1000).fadeOut(750);
                    progressbar.progressbar("value", 0);
                }
            });

            function progress() {
                var val = progressbar.progressbar("value") || 0;

                progressbar.progressbar("value", val + 1);

                if (val < 100) {
                    setTimeout(progress, 100);
                }
            }

            setTimeout(progress, 2000);

        },
        HideModalWait: function () {
            var $modal = $('#js-loading-bar'),
            $bar = $modal.find('.progress-bar');

            $bar.removeClass('animate');
            $modal.modal('hide');
        }
    },
    Alert: {
        /*
        * vType: Tipo do alerta a ser criado        
        * vMessage: Mensagem
        * vWidth: Largura do modal
        * vButtons: Botoes do modal
        * vTitle: Titulo do modal
        * vHeight: Altura do modal
        * vResisable: Bollean de redimencionamento
        * vDraggable: Bollean de arrastar
        */
        Type: [
            { CssClass: 'Success' },
            { CssClass: 'Info' },
            { CssClass: 'Warning' },
            { CssClass: 'Error' },

        ],
        Include: function (vTitle, vMessage) {
            var id = 'alert-' + (Math.floor(Math.random() * 20 + 1)).toString();
            $('BODY').append('<div id="' + id + '" title="' + vTitle + '" class="none">' + vMessage + '</div>');

            return id;
        },
        Create: function (vType, vMessage, vWidth, vButtons, vTitle, vHeight, vResisable, vDraggable) {
            //limpa todos os alertas antes de criar o novo...
            $("div[id^='alert-']").remove();
            $(".modal-backdrop.fade.in").remove();

            var frmWk = AmilFramework;

            try {

                if (typeof vType != 'number' || (vType < 0 || vType > 3))
                    throw new Error('Informe o tipo do alerta a ser criado.');

                if (vMessage.length <= 0)
                    throw new Error('Informe a mensagem do alerta a ser criado.');

                if (typeof vWidth != 'number' || vWidth <= 0)
                    throw new Error('Informe a largura do alerta a ser criado.');

                var idModal = 'alert-' + (Math.floor(Math.random() * 20 + 1)).toString();
                vTitle = frmWk.Common.Pick(vTitle, frmWk.Messages.AlertTitle);
                vButtons = frmWk.Common.Pick(vButtons, { Ok: function () { $('#' + idModal).modal('hide') } });
                vHeight = frmWk.Common.Pick(vHeight, 0);
                vResisable = frmWk.Common.Pick(vResisable, false);
                vDraggable = frmWk.Common.Pick(vDraggable, false);

                var buttons

                var $modal = $('<div class="modal fade bs-example-modal-lg ' + AmilFramework.Alert.Type[vType].CssClass + '" id="' + idModal + '" tabindex="-1" role="dialog"> ' +
                               '    <div class="modal-dialog modal-lg" role="document"> ' +
                               '        <div class="modal-content"> ' +
                               '            <div class="modal-header"> ' +
                               '                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button> ' +
                               '                <h4 class="modal-title">' + vTitle + '</h4> ' +
                               '            </div> ' +
                               '            <div class="modal-body">' + vMessage + '</div> ' +
                               '            <div class="modal-footer"> </div>' +
                               '        </div> ' +
                               '    </div> ' +
                               '</div>');

                $.each(vButtons, function (idx, btn) {
                    var $button = $('<button type="button" class="' + btn.cssClass + '">' + btn.text + '</button>'); // data-dismiss="modal"

                    if (btn.close) {
                        $button.attr('data-dismiss', 'modal');
                    }

                    if (btn.click != null) {
                        $button.click(function () {
                            return btn.click(idModal);
                        });
                    }
                    $modal.find('.modal-footer').append($button);
                });

                $('BODY').append($modal);
                $('#' + idModal).modal('show');

            } catch (ex) {
                console.log(ex.message);
            }
        }
    },
};

var AmilGrid = function (vIdSeletor, vUrl, vData, vActions, vPageLength) {

    var gridInstance;
    var idSeletor = '#' + vIdSeletor;
    var url = vUrl;
    var ajaxType = 'POST';
    var parameters = vData;
    var actions = vActions;
    var columns = getCollumns();

    var selected = [];
    var actionSelected = null;

    this.Create = create;
    this.Destroy = destroy;
    this.GetInstance = getInstance;
    this.GetSelected = getSelected;
    this.SetData = setData;
    this.SetActionSelected = setActionSelected;

    var lstLanguages = {
        'pt-br': {
            lengthMenu: 'Mostrar _MENU_ registros',
            zeroRecords: 'Nenhum registro encontrado',
            info: 'Mostrando p\u00e1gina _PAGE_ de _PAGES_',
            infoEmpty: 'Nenhum registro dispon\u00edvel',
            infoFiltered: '(filtrando de _MAX_ registros)',
            processing: 'Processando...',
            search: 'Buscar ',
            paginate: {
                previous: '&#60;',//'Anterior',
                next: '&#62;'//'Pr\u00f3ximo'
            }
        }
    };

    function create() {

        destroy();
        var d = $.Deferred();

        gridInstance = $(idSeletor).DataTable({
            bJQueryUI: false,
            bPaginate: true,
            sPaginationType: 'simple_numbers',
            language: lstLanguages['pt-br'],
            bLengthChange: false,
            bFilter: false,
            bSort: true,
            bInfo: false,
            pageLength: 5,
            bAutoWidth: false,
            destroy: true,
            processing: false,
            serverSide: true,
            //ajax: { showModal: false, url: url, type: ajaxType, data: parameters },
            bStateSave: false,
            columns: columns,
            sAjaxSource: url,
            fnServerParams: function (aoData) {
                $.each(parameters, function (item, val) {
                    aoData.push({ 'name': item, 'value': val });
                });
            },
            fnServerData: function (sSource, aoData, fnCallback, oSettings) {
                
                //console.log('aoData', aoData);
                //console.log('fnCallback', fnCallback);

                oSettings.jqXHR = $.ajax({
                    "showModal": false,
                    "type": 'POST',
                    "url": sSource,
                    "data": aoData,
                    "success": function (json) {
                        //console.log('success json', json);
                        return fnCallback(json);
                    },
                    "cache": false
                }).done(function(p){
                    d.resolve(p);
                }).fail(d.reject); 
            },
            rowCallback: function (row, data) {

                var identify = $(idSeletor).attr('data-dtid');

                $(row).attr('id', data[identify]);
                if ($.inArray(data[identify], selected) !== -1) {
                    $(row).addClass('selected');
                }
            }
        });

        if (actionSelected != null) {
            $(idSeletor + ' tbody').on('click', 'tr', function () {
                var id = this.id;
                selected = [id];
                actionSelected();
                $(idSeletor + ' tbody tr').removeClass('selected');
                $(this).toggleClass('selected');
            });
        }

        return d.promise();
    }

    function destroy() {
        //$(_idSeletor).addClass('displayNone');
        //$(_idSeletor + ' TBODY').remove();
        if (gridInstance != null)
            gridInstance.destroy();
        //gridInstance.fnDestroy();
    }

    function getInstance() {
        return gridInstance;
    }

    function getSelected() {
        return selected;
    }

    function setData(vData) {
        parameters = vData;
    }

    function setActionSelected(fnc) {
        actionSelected = fnc;
    }

    function getCollumns() {
        var collumn = [];

        $(idSeletor + ' THEAD TH').each(function () {

            var $t = $(this);
            var collumnData = $t.attr('data-dtcolumn');
            var actionData = $t.attr('data-dtaction');
            var columnClassName = $t.attr('data-column-class');

            var sort = true;

            if (actionData != null)
                sort = false;

            var columnJson = {
                'data': collumnData,
                'orderable':sort
            };

            if (actionData != null) {
                columnJson['render'] = function (data, type, full, meta) {
                    return generateActions(data, type, full, meta, actionData);
                };
            }

            if (columnClassName != null) {
                columnJson['className'] = columnClassName;
            }

            collumn.push(columnJson);

        });
        return collumn;
    }

    function generateActions(data, type, full, meta, actionData) {

        var buttons = '';

        $.each(actions, function (idx1, actionCollumn) {

            if (actionCollumn.Collumn == actionData) {

                $.each(actionCollumn.Buttons, function (key1, actionButton) {

                    var layout = (this.Layout.Default == null) ? this.Layout[(full[actionButton.Layout.ValueData]).toString().toUpperCase()] : this.Layout.Default;
                    var call = '';

                    if (actionButton.Action.Function != null) {

                        var fncParameter = [];

                        $.each(this.Action.Parameter, function (idx2, prm) {
                            fncParameter.push('\'' + full[prm] + '\'');
                        });

                        call += 'onclick="' + this.Action.Function + '(' + fncParameter.join(',') + ');"';
                    }
                    else if (actionButton.Action.Url != null) {
                        //call += 'onclick="' + this.Action.Function + '({ ' + this.Action.Parameter + ': \'' + full[this.Action.Data] + '\'});"';
                    }

                    if (AmilFramework.Common.StringIsNullOrEmpty(call)) {
                        buttons += AmilFramework.Common.StringFormat('<i title="{0}" class="{1}"></i>', layout.Title, layout.CssClass);
                    }
                    else {
                        buttons += AmilFramework.Common.StringFormat('<a href="javascript:void(0);" {0}><i title="{1}" class="{2}"></i></a>', call, layout.Title, layout.CssClass);
                    }

                });
            }
        });

        return buttons;
    }
};

    (function ($) {
        $.eventReport = function (selector, root) {
            var s = [];
            $(selector || '*', root).addBack().each(function () {
                var e = $._data(this, 'events');
                if (!e) return;
                var tagGroup = this.tagName || "document";
                if (this.id) tagGroup += '#' + this.id;
                if (this.className) tagGroup += '.' + this.className.replace(/ +/g, '.');

                var delegates = [];
                for (var p in e) {
                    var r = e[p];
                    var h = r.length - r.delegateCount;

                    if (h)
                        s.push([tagGroup, p + ' handler' + (h > 1 ? 's' : '')]);

                    if (r.delegateCount) {
                        for (var q = 0; q < r.length; q++)
                            if (r[q].selector) s.push([tagGroup + ' delegates', p + ' for ' + r[q].selector]);
                    }
                }
            });
            return s;
        };
        $.fn.eventReport = function (selector) {
            return $.eventReport(selector, this);
        };
    })(jQuery);

    (function ($) {
        // Chrome fixed
        $.validator.addMethod(
              "date",
              function (value, element) {
                  var check = false;
                  var re = /^\d{1,2}\/\d{1,2}\/\d{4}$/;
                  if (re.test(value)) {
                      var adata = value.split('/');
                      var gg = parseInt(adata[0], 10);
                      var mm = parseInt(adata[1], 10);
                      var aaaa = parseInt(adata[2], 10);
                      var xdata = new Date(aaaa, mm - 1, gg);
                      if ((xdata.getFullYear() == aaaa) && (xdata.getMonth() == mm - 1) && (xdata.getDate() == gg))
                          check = true;
                      else
                          check = false;
                  } else
                      check = false;
                  return this.optional(element) || check;
              },
              "Insira uma data v\u00e1lida"
         );
    }(jQuery));

    $(function () {

        AmilFramework.Layout.Initialize();
        AmilFramework.Form.Initialize();
        $(document).ajaxSuccess(function () {
            AmilFramework.Layout.Initialize();
            AmilFramework.Form.Initialize();
        });
    })