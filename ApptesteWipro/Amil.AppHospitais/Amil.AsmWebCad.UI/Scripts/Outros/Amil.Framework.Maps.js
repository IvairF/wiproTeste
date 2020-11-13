var AmilMaps = {
    jQuery: $,
    google: null,
    oMap: {
        gMap: null,
        gGeoCoder: null,
        gMarker: null,
        gCityCircle: null,
        gInfoWindow: null,
        gUnitPoints: [{}]
    },
    UrlMarker:{
        UrlSite: '/Content/Imagens/'
    },
    settings: {
        UrlSite: 'Imagens/',
        IdMap: 'MapCanvas',
        IdFieldAdress: 'txtEndereco',
        IdBtnSearch: 'btnBuscaEndereco',
        IdFieldLatitude: '',
        IdFieldLongitude: '',
        StartLatitude: -14.408749,
        StartLongitude: -51.663108,
        StartZoom: 4,
        StartCircle: false,
        CityCircleSearch: true,
        ZoomSearch: 12,
        CircleRadius: 10000
    },
    historic: {
        latitude: -14.408749,
        longitude: -51.663108
    },
    init: function (google) {
        this.google = google;
        this.StartMaps();
        if(!window.location.port)
            AmilMaps.UrlMarker.UrlSite = '/' + window.location.pathname.split('/')[1] + AmilMaps.UrlMarker.UrlSite;
        //this.AutoComplete();
    },
    StartMaps: function () {

        var google = this.google,
            oMap = this.oMap,
            settings = this.settings;

        var mapOptions = {
            center: AmilMaps.StartLatLng(),
            zoom: settings.StartZoom,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            mapTypeControl: false,
            panControl: false,
            zoomControl: true,
            scaleControl: false,
            streetViewControl: false,
            mapTypeControlOptions: { style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR, position: google.maps.ControlPosition.BOTTOM_CENTER },
            panControlOptions: { position: google.maps.ControlPosition.TOP_RIGHT },
            zoomControlOptions: { style: google.maps.ZoomControlStyle.SMALL, position: google.maps.ControlPosition.RIGHT_BOTTOM },
            scaleControlOptions: { position: google.maps.ControlPosition.TOP_LEFT },
            streetViewControlOptions: { position: google.maps.ControlPosition.LEFT_TOP }
        };

        //new google.maps.Marker({
        //    position: new google.maps.LatLng(parseFloat(me.result_.lat),
        //                 parseFloat(me.result_.lng)),
        //    icon: gYellowIcon, shadow: gSmallShadow, map: gMap
        //})

        oMap.gMap = new google.maps.Map(document.getElementById(settings.IdMap), mapOptions);

        // Add the circle for this city to the map.
        oMap.gCityCircle = AmilMaps.CreateCircle(AmilMaps.StartLatLng());
        oMap.gCityCircle.setMap((settings.StartCircle) ? oMap.gMap : null);

        // Initialize the local searcher
        oMap.gGeoCoder = new google.maps.Geocoder();

        var iconMarkerUser = new google.maps.MarkerImage(AmilMaps.UrlMarker.UrlSite + 'map_marker_user.png', //settings.UrlSite + 'map_marker_user.png',
            new google.maps.Size(52, 52),
            new google.maps.Point(0, 0));



        oMap.gMarker = new google.maps.Marker({
            position: AmilMaps.StartLatLng(),
            icon: iconMarkerUser,
            shadow: AmilMaps.UrlMarker.UrlSite + 'map_marker_user.png',//settings.UrlSite + 'map_marker_user.png',
            map: oMap.gMap,
            draggable: false
        });

        oMap.gUnitPoints = [];



    },
    StartLatLng: function () {
        var settings = this.settings;
        return new google.maps.LatLng(settings.StartLatitude, settings.StartLongitude);
    },
    CreateCircle: function (latLng) {

        var google = this.google,
            oMap = this.oMap,
            settings = this.settings;

        var circle = new google.maps.Circle({
            strokeColor: '#FF7272',
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: '#FFFFFF',
            fillOpacity: 0.2,
            map: oMap.gMap,
            center: latLng,
            radius: settings.CircleRadius
        });

        return circle;
    },
    SetNewRaioCircle: function (raio) {
        var google = this.google,
            oMap = this.oMap,
            settings = this.settings;

        settings.CircleRadius = raio;
        oMap.gCityCircle.setRadius(raio);
    },
    Search: function (value, daysOfWeek) {

        var oMap = this.oMap,
            settings = this.settings,
            historic = this.historic;

        var address = (value.length <= 0)
                        ? $('#' + settings.IdFieldAdress).val()
                        : value;

        oMap.gGeoCoder.geocode({ 'address': address + ', Brasil', 'region': 'BR' }, function (results, status) {

            if (status == google.maps.GeocoderStatus.OK) {
                if (results[0]) {
                    //console.log('teste01');
                    var latitude = results[0].geometry.location.lat();
                    var longitude = results[0].geometry.location.lng();
                    AmilMaps.SetCenterMap(latitude, longitude);


                    var obj = {
                        'Address': address,
                        'Latitude': latitude,
                        'Longitude': longitude,
                        'Raio': settings.CircleRadius,
                        'DiasDaSemana': (daysOfWeek.length > 0) ? daysOfWeek : '1,2,3,4,5,6,7'
                    };

                    // Set Longitude
                    if (settings.IdFieldLongitude.length > 0 && $('#' + settings.IdFieldLongitude) != undefined) {
                        $('#' + settings.IdFieldLongitude).val(longitude);
                    }

                    // Set Latitude
                    if (settings.IdFieldLatitude.length > 0 && $('#' + settings.IdFieldLatitude) != undefined) {
                        $('#' + settings.IdFieldLatitude).val(latitude);
                    }

                    $('#' + settings.IdBtnSearch).trigger('AmilMaps.Selected', obj);

                }
            } else if (status == 'ZERO_RESULTS') {
                $.modaldialog.error('Endereço não localizado.', { title: 'SisAgenda' });
            }
        });
    },
    SetCenterMap: function (latitude, longitude, setPosition, setCircle, zoom) {
        var oMap = this.oMap,
            settings = this.settings,
            historic = this.historic;

        var location = new google.maps.LatLng(latitude, longitude);

        // Set center marker, map and circle
        setPosition = Amil.Framework.Common.Pick(setPosition, true);
        setCircle = Amil.Framework.Common.Pick(setCircle, true);

        if (setPosition) {
            oMap.gMarker.setPosition(location);
            oMap.gMap.setZoom(settings.ZoomSearch);
        }

        oMap.gMap.setCenter(location);

        if (setCircle) {
            if (settings.CityCircleSearch) {
                oMap.gCityCircle.setMap(oMap.gMap);
                oMap.gCityCircle.setCenter(new google.maps.LatLng(latitude, longitude));
            } else {
                oMap.gCityCircle.setMap(null);
            }
        }
    },
    SetPoints: function (units) {

        var google = this.google,
            oMap = this.oMap,
            settings = this.settings;

        var iconMarkerShadow = new google.maps.MarkerImage(settings.UrlSite + 'map_marker_shadow.png',
            new google.maps.Size(22, 22), //size
            new google.maps.Point(0, 0), //origin
            new google.maps.Point(21, 42) //anchor
        );
        $('#LstUnits').height($('BODY').height() - 195);
        $('#boxHistoricoEndereco').addClass("BoxHide");
        $.each(units, function (index, ponto) {
            var iconMarkerUser = new google.maps.MarkerImage(settings.UrlSite + 'map_marker_' + ponto.Color + '.png',
                new google.maps.Size(25, 32),
                new google.maps.Point(0, 0));

            var marker = new google.maps.Marker({
                position: new google.maps.LatLng(ponto.Latitude, ponto.Longitude),
                icon: iconMarkerUser,
                shadow: iconMarkerShadow,
                title: ponto.UnitName,
                map: oMap.gMap
            });

            google.maps.event.addListener(marker, 'click', function () {
                //if (infoWindow) infoWindow.close();
                var infoWindow = AmilMaps.CreateUnitInfoWindow(ponto);
                infoWindow.open(marker.get('map'), marker);
            });

            oMap.gUnitPoints.push(marker);
        });
    },
    RemoveAllPoints: function () {
        var oMap = this.oMap;

        for (var i = 0; i < oMap.gUnitPoints.length; i++) {
            oMap.gUnitPoints[i].setMap(null);
        }

        oMap.gUnitPoints = [];

        //arr = [1, 2, 3, 4, 5];
        //arr.splice(2, 2);
        // [1, 2, 5]

    },
    CreateUnitInfoWindow: function (unit) {

        return new google.maps.InfoWindow({

            content: '<div class="ItemUnit InfoWindow" style="height:80px; *max-width:360px;"> ' +
                     '    <h3>' + unit.UnitName + '</h3>' +
                     '    <p class="type1">' + unit.UnitAddress + '</p>' +
                     '    <div style="clear:both;"></div>' +
                     '</div>',
            width: 350,
            height: 200
        });

    },
    Refresh: function () {
        var google = this.google,
            oMap = this.oMap,
            historic = this.historic;

        var location = new google.maps.LatLng(historic.latitude, historic.longitude);
        oMap.gMap.setCenter(location);
    },
    AutoComplete: function () {
        var $ = this.jQuery,
            google = this.google,
            oMap = this.oMap,
            settings = this.settings,
            historic = this.historic;


        $('#' + settings.IdFieldAdress).autocomplete({
            source: function (request, response) {
                oMap.gGeoCoder.geocode({ 'address': request.term + ', Brasil', 'region': 'BR' }, function (results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                        response($.map(results, function (item) {
                            return {
                                label: item.formatted_address,
                                value: item.formatted_address,
                                latitude: item.geometry.location.lat(),
                                longitude: item.geometry.location.lng()
                            };
                        }));
                    }
                });
            },
            select: function (event, ui) {
                $('#' + settings.IdFieldAdress).val(ui.item.label);

                historic.latitude = ui.item.latitude;
                historic.longitude = ui.item.longitude;

                var location = new google.maps.LatLng(ui.item.latitude, ui.item.longitude);
                oMap.gMarker.setPosition(location);
                oMap.gMap.setCenter(location);
                oMap.gMap.setZoom(settings.ZoomSearch);

                if (settings.CityCircleSearch) {
                    oMap.gCityCircle.setMap(oMap.gMap);
                    oMap.gCityCircle.setCenter(new google.maps.LatLng(ui.item.latitude, ui.item.longitude));
                } else {
                    oMap.gCityCircle.setMap(null);
                }

                var obj = {
                    'Address': ui.item.label,
                    'Latitude': ui.item.latitude,
                    'Longitude': ui.item.longitude,
                    'Raio': settings.CircleRadius,
                    'DiasDaSemana': '1,2,3,4,5,6,7'
                };

                $(this).trigger('AmilMaps.AutoCompleteSelected', obj);
            }
        }).autocomplete("widget").addClass("AutoCompleteMap");
    },
    ResetMap: function () {

        var oMap = this.oMap,
            settings = this.settings;

        oMap.gMap.setZoom(settings.StartZoom);
        oMap.gMap.setCenter(AmilMaps.StartLatLng());
        oMap.gMarker.setPosition(AmilMaps.StartLatLng());
        oMap.gCityCircle.setMap(null);

        AmilMaps.RemoveAllPoints();
    },
    Destroy: function () {
        var settings = this.settings;

        this.google = null;

        this.oMap = {
            gMap: null,
            gGeoCoder: null,
            gMarker: null,
            gCityCircle: null,
            gUnitPoints: null
        };

        $('#' + settings.IdMap).html('').attr('style', '');
    },
    TypeOf: function (obj) {
        if (typeof (obj) == 'object')
            return (obj.length) ? 'array' : 'object';
        else
            return typeof (obj);
    },
    ReverseGeocoding: function (latitude, longitude, callback) {
        var address = '';
        var geocoder = new google.maps.Geocoder;
        var latlng = { lat: parseFloat(latitude), lng: parseFloat(longitude) };

        geocoder.geocode({ 'location': latlng }, function (results, status) {
            if (status === google.maps.GeocoderStatus.OK) {
                if (results[0]) {
                    callback(results[0].formatted_address);
                }
            }
        });
    },
    Geocoding: function (address, callback) {
        var geocoder = new google.maps.Geocoder;
        geocoder.geocode({ 'address': address }, function (results, status) {
            if (status === google.maps.GeocoderStatus.OK) {
                callback(results[0].geometry.location);
            }
            else {
                callback("ZERO_RESULTS");
            }
        });
    },
    LocationType: function (address, callback) {
        var geocoder = new google.maps.Geocoder;
        geocoder.geocode({ 'address': address }, function (results, status) {
            if (status === google.maps.GeocoderStatus.OK) {
                callback(results[0].geometry.location_type);
            }
            else {
                callback("ZERO_RESULTS");
            }
        });
    }, 
    SetMarker: function (latitude, longitude, titulo, infoWindowContent, color) {
        var google = this.google,
            oMap = this.oMap
        var latlng = { lat: parseFloat(latitude), lng: parseFloat(longitude) };

        var pinImage = new google.maps.MarkerImage("http://maps.google.com/mapfiles/ms/icons/" + color + "-dot.png", new google.maps.Size(25, 34), new google.maps.Point(0, 0), new google.maps.Point(10, 34));

        var marker = new google.maps.Marker({
            position: latlng,
            map: oMap.gMap,
            icon: pinImage,
            title: titulo,
        });

        if (infoWindowContent != null) {

            var infowindow = new google.maps.InfoWindow({
                content: infoWindowContent
            });

            marker.addListener('click', function () {
                infowindow.open(oMap.gMap, marker);
            });
        }
    },
    SetZoom: function (zoom) {
        var oMap = this.oMap;
        oMap.gMap.setZoom(zoom);
    }
};