import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../models/location_data.dart';
import '../../models/product.dart';
import 'package:location/location.dart' as geolocation;

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final Product product;

  LocationInput(this.setLocation, this.product);
  @override
    State<StatefulWidget> createState() {
      return _LocationInputState();
    }
}
class _LocationInputState extends State<LocationInput> {
  Uri _staticMapUri;
  final FocusNode _locationInputFocusNode = FocusNode();
  final TextEditingController _locationInputController = TextEditingController();
  LocationData _locationData;
  
  @override
    void initState() {
      _locationInputFocusNode.addListener(
        _updateLocation
      );
      if (widget.product != null) { 
        _getStaticMap(location: widget.product.locationAddress);
      }
      super.initState();
    }

  @override
    void dispose() {
      _locationInputFocusNode.removeListener(_updateLocation);
      super.dispose();
    }

  void _updateLocation() {
    if (!_locationInputFocusNode.hasFocus) {
      _getStaticMap(location: _locationInputController.text);
    }
  }

  void _getStaticMap({String location}) async {
    if (location == null || location.isEmpty) {
      setState(() {
        _staticMapUri = null;
      });
      widget.setLocation(null);
      return;
    }
    final Uri geocodingUri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {
      'address': location,
      'key': 'AIzaSyBcz50gxQeynJ923eU9awz_gZuCrFVHn4M'
    });
    final http.Response response = await http.get(geocodingUri);
    print(response.statusCode);
    final responseData = json.decode(response.body);
    print(responseData);
    final results = responseData['results'];
    print(results);
    if (results != null && results.length != 0) {
      print(results);
      final firstResult = results[0];
      final formattedAddress = firstResult['formatted_address'];
      final coordinates = firstResult['geometry']['location'];

      _locationData = LocationData(latitude: coordinates['lat'],
                                   longitude: coordinates['lng'],
                                   address: formattedAddress);

      // 37.36970, -119.66325
      final StaticMapProvider staticMapViewProvider = StaticMapProvider('AIzaSyBcz50gxQeynJ923eU9awz_gZuCrFVHn4M');
      final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers([
        Marker('position', 'Position', _locationData.latitude, _locationData.longitude)
      ], center: Location(_locationData.latitude, _locationData.longitude), width: 500, height: 300, maptype: StaticMapViewType.roadmap);
      widget.setLocation(_locationData);
      if (mounted) { // Avoid memory leaks
        setState(() {
          _locationInputController.text = _locationData.address;
          _staticMapUri = staticMapUri;
        });
      } 
    }
  }

  void _getUserLocation() async {
    final location = geolocation.Location();
    final userLocation = await location.getLocation();
    final userAddress = await _getAddress(userLocation['latitude'], userLocation['longitude']);
    _getStaticMap(location: userAddress);
  }

  Future<String> _getAddress(double latitude, double longitude) async {
    final Uri geocodingUri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {
      'latlng': '${latitude.toString()},${longitude.toString()}',
      'key': 'AIzaSyBcz50gxQeynJ923eU9awz_gZuCrFVHn4M'
    });
    final http.Response response = await http.get(geocodingUri);
    final responseData = json.decode(response.body);
    final results = responseData['results'];
    if (results != null) {
      final String formattedAddress = results[0]['formatted_address'];
      return formattedAddress;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          validator: (String value) {
            if (_locationData == null || value.isEmpty) {
              return 'Location required';
            }
          },
          focusNode: _locationInputFocusNode,
          controller: _locationInputController,
          decoration: InputDecoration(
          labelText: 'Location',
          contentPadding:
              EdgeInsets.all(8.0) // Puts padding inside of the textField
          ),
        ),
        Container(height: 10.0,),
        FlatButton(
          child: Text('Use Current Location'),
          onPressed: () {
            _getUserLocation();
          },
        ),
        Container(height: 10.0,),
        _staticMapUri != null ? Image.network(_staticMapUri.toString()) : Container()
      ]
    );
  } 
}