
<!DOCTYPE html>
<meta charset="utf-8">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="https://www.codexworld.com/wp-content/uploads/2014/09/favicon.ico" type="image/x-icon" />
    <meta name="description" content="Live Demo at CodexWorld - Autocomplete Location Search using Google Maps JavaScript API and jQuery by CodexWorld">
    <meta name="keywords" content="demo, codexworld demo, project demo, live demo, tutorials, programming, coding">
    <meta name="author" content="CodexWorld">
    <title>Live Demo - Autocomplete Location Search using Google Maps JavaScript API and jQuery by CodexWorld</title>
    <!-- Bootstrap core CSS -->
    <link href="http://demos.codexworld.com/includes/css/bootstrap.css" rel="stylesheet">
    <!-- Add custom CSS here -->
    <link href="http://demos.codexworld.com/includes/css/style.css" rel="stylesheet">
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
    <style type="text/css">
        #geomap {
            width: 100%;
            height: 300px;
        }
        ul#geoData {
            text-align: left;
            font-weight: bold;
            margin-top: 10px;
        }
        ul#geoData span {
            font-weight: normal;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <a class="navbar-brand" href="index.jsp">
                    <span style="color:red">Fanet In Cloud</span>
                </a>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-right">
                    <li>
                        <span style="color:#ff00cc">Thesis Done BY Billal And Sahjahan</span>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
    </nav>

    <div class="container">
        <div class="row">
            <div class="col-sm">
                <div class="div-center">
                    <h4>Search Location</h4>
                    <!-- search input box -->
                    <form>
                        <div class="form-group input-group">
                            <div class="col-xs-4"> 
                                <input type="text" id="source_location" class="form-control" placeholder="Source Address"> <br>
                                <input type="text" id="destination_location" class="form-control" placeholder="Destination Address">
                            </div>
                            <div class="input-group-btn">
                                <button class="btn btn-default get_map" type="submit">
                                    Locate
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="col-sm">    
                <!-- display google map -->
                <div id="geomap"></div>

                <!-- display selected location information -->
                <h4>Location Details</h4>
                <ul id="geoData">
                    <li>Full Address: <span class="search_addr"></span></li>
                    <li>Latitude: <span class="search_latitude"></span></li>
                    <li>Longitude: <span class="search_longitude"></span></li>
                </ul>
            </div>
        </div>
    </div> 
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="http://demos.codexworld.com/includes/js/bootstrap.js"></script>
    <!-- Place this tag in your head or just before your close body tag. -->
    <script src="https://apis.google.com/js/platform.js" async defer></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>

    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD8pZxUOR0h2lo_uHZx4-JbryPEjf7zm1E"></script>
    <script type="text/javascript">
        var geocoder;
        var map;
        var marker;

        /*
         * Google Map with marker
         */
        function initialize() {
            var initialLat = $('.search_latitude').text();
            var initialLong = $('.search_longitude').text();
            initialLat = initialLat ? initialLat : 36.169648;
            initialLong = initialLong ? initialLong : -115.141000;

            var latlng = new google.maps.LatLng(initialLat, initialLong);
            var options = {
                zoom: 16,
                center: latlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };

            map = new google.maps.Map(document.getElementById("geomap"), options);

            geocoder = new google.maps.Geocoder();

            marker = new google.maps.Marker({
                map: map,
                draggable: true,
                position: latlng
            });

            google.maps.event.addListener(marker, "dragend", function () {
                var point = marker.getPosition();
                map.panTo(point);
                geocoder.geocode({'latLng': marker.getPosition()}, function (results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                        map.setCenter(results[0].geometry.location);
                        marker.setPosition(results[0].geometry.location);
                        $('.search_addr').text(results[0].formatted_address);
                        $('.search_latitude').text(marker.getPosition().lat());
                        $('.search_longitude').text(marker.getPosition().lng());
                    }
                });
            });

        }

        //google.maps.event.addDomListener(window, 'load', initialize);

        $(document).ready(function () {
            //load google map
            initialize();

            /*
             * autocomplete location search
             */
            var PostCodeid = '#source_location';
            var PostCodeid1 ='#destination_location';
            $(function () {
                $(PostCodeid).autocomplete({
                    source: function (request, response) {
                        geocoder.geocode({
                            'address': request.term,
                            /*componentRestrictions: {country: "us"}*/
                        }, function (results, status) {
                            response($.map(results, function (item) {
                                return {
                                    label: item.formatted_address,
                                    value: item.formatted_address,
                                    lat: item.geometry.location.lat(),
                                    lon: item.geometry.location.lng()
                                };
                            }));
                        });
                    },
                    select: function (event, ui) {
                        $('.search_addr').text(ui.item.value);
                        $('.search_latitude').text(ui.item.lat);
                        $('.search_longitude').text(ui.item.lon);
                        var latlng = new google.maps.LatLng(ui.item.lat, ui.item.lon);
                        marker.setPosition(latlng);
                        initialize();
                    }
                });
                
                $(PostCodeid1).autocomplete({
                    source: function (request, response) {
                        geocoder.geocode({
                            'address': request.term,
                            /*componentRestrictions: {country: "us"}*/
                        }, function (results, status) {
                            response($.map(results, function (item) {
                                return {
                                    label: item.formatted_address,
                                    value: item.formatted_address,
                                    lat: item.geometry.location.lat(),
                                    lon: item.geometry.location.lng()
                                };
                            }));
                        });
                    },
                    select: function (event, ui) {
                        $('.search_addr').text(ui.item.value);
                        $('.search_latitude').text(ui.item.lat);
                        $('.search_longitude').text(ui.item.lon);
                        var latlng = new google.maps.LatLng(ui.item.lat, ui.item.lon);
                        marker.setPosition(latlng);
                        initialize();
                    }
                });
            });

            /*
             * Point location on google map
             */
            $('.get_map').click(function (e) {
                var address = $(PostCodeid).val();
                geocoder.geocode({'address': address}, function (results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                        map.setCenter(results[0].geometry.location);
                        marker.setPosition(results[0].geometry.location);
                        $('.search_addr').text(results[0].formatted_address);
                        $('.search_latitude').text(marker.getPosition().lat());
                        $('.search_longitude').text(marker.getPosition().lng());
                    } else {
                        alert("Geocode was not successful for the following reason: " + status);
                    }
                });
                e.preventDefault();
            });

            //Add listener to marker for reverse geocoding
            google.maps.event.addListener(marker, 'drag', function () {
                geocoder.geocode({'latLng': marker.getPosition()}, function (results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                        if (results[0]) {
                            $('.search_addr').text(results[0].formatted_address);
                            $('.search_latitude').text(marker.getPosition().lat());
                            $('.search_longitude').text(marker.getPosition().lng());
                        }
                    }
                });
            });
        });

    </script>
</body>
</html>
