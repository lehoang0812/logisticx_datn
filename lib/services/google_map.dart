import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as webService;
import 'package:location/location.dart';
import 'package:logisticx_datn/services/google_map_places.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late GoogleMapController _ggcontroller;
  LocationData? _currentLocation;
  List<webService.PlacesSearchResult> _places = [];
  Completer<GoogleMapController> _controller = Completer();
  double zoomVal = 5.0;
  MapType _currentMapType = MapType.normal;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Location location = new Location();
    LocationData currentLocation = await location.getLocation();
    setState(() {
      _currentLocation = currentLocation;
      _getNearbyPlaces();
    });
  }

  void _getNearbyPlaces() async {
    final places = new webService.GoogleMapsPlaces(
        apiKey: 'AIzaSyC-g_UhcAV4iYBCUuTnnEfYv0cKXE_abgU');
    webService.Location location = webService.Location(
      lat: _currentLocation!.latitude!,
      lng: _currentLocation!.longitude!,
    );

    webService.PlacesSearchResponse response =
        await places.searchNearbyWithRadius(
      location,
      1500, // radius in meters
      type: 'store', // specify the type of place you want to search
    );
    setState(() {
      _places = response.results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          title: Text(
            'Google Map',
            style: TextStyle(
                fontSize: 24,
                color: Colors.grey[800],
                fontWeight: FontWeight.w400),
          ),
          backgroundColor: Colors.white70,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) => _ggcontroller = controller,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),
                zoom: 14,
              ),
              markers: _places
                  .map((place) => Marker(
                        markerId: MarkerId(place.id.toString()),
                        position: LatLng(place.geometry!.location.lat,
                            place.geometry!.location.lng),
                        infoWindow: InfoWindow(title: place.name),
                      ))
                  .toSet(),
            ),
    );
  }

  // Future<Widget> _buildGoogleMap(BuildContext context) async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error(
  //         'Dịch vụ truy cập vị trí đã bị hủy. Vui lòng bật Vị trí và tải lại ứng dụng');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Quyền truy cập vị trí bị từ chối !');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Quyền truy cập vị trí đã bị từ chối vĩnh viễn, bạn phải vào cài đặt để cấp quyền.');
  //   }
  //   return NearbyPlacesMapScreen();
  // return FutureBuilder<Position>(
  //   future: Geolocator.getCurrentPosition(),
  //   builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
  //     if (snapshot.hasData) {
  //       Position currentPosition = snapshot.data!;
  //       LatLng latLng =
  //           LatLng(currentPosition.latitude, currentPosition.longitude);
  //       return Container(
  //         height: MediaQuery.of(context).size.height,
  //         width: MediaQuery.of(context).size.width,
  //         child: GoogleMap(
  //           mapType: _currentMapType,
  //           initialCameraPosition: CameraPosition(target: latLng, zoom: 12),
  //           onMapCreated: (GoogleMapController controller) {
  //             _controller.complete(controller);
  //           },
  //           markers: {
  //             Marker(
  //               markerId: MarkerId('current'),
  //               position: latLng,
  //               infoWindow: InfoWindow(title: 'Vị trí hiện tại của bạn'),
  //             ),
  //           },
  //         ),
  //       );
  //     } else if (snapshot.hasError) {
  //       return Center(child: Text('Error: ${snapshot.error}'));
  //     } else {
  //       return Center(child: CircularProgressIndicator());
  //     }
  //   },
  // );
  // }

  // Widget _rightButtonFunction() {
  //   return Align(
  //     alignment: Alignment.topRight,
  //     child: Stack(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(top: 30, right: 8.0),
  //           child: Row(
  //             children: [
  //               Spacer(),
  //               Column(
  //                 children: [
  //                   Container(
  //                     width: 55.0,
  //                     height: 55.0,
  //                     decoration: BoxDecoration(
  //                       color: Colors.red,
  //                       borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(40.0),
  //                         topRight: Radius.circular(40.0),
  //                         bottomLeft: Radius.circular(40.0),
  //                         bottomRight: Radius.circular(40.0),
  //                       ),
  //                     ),
  //                     child: IconButton(
  //                         icon: FaIcon(
  //                           FontAwesomeIcons.locationDot,
  //                           color: Colors.white,
  //                           size: 20,
  //                         ),
  //                         onPressed: () {
  //                           // _getCurrentLocation().then((value) {
  //                           //   lat = '${value.latitude}';
  //                           //   long = '${value.longtitude}';
  //                           //   setState(() {});
  //                           // });
  //                         }),
  //                   ),
  //                   SizedBox(height: 10),
  //                   Container(
  //                     width: 55.0,
  //                     height: 55.0,
  //                     decoration: BoxDecoration(
  //                       color: Colors.blueAccent,
  //                       borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(40.0),
  //                         topRight: Radius.circular(40.0),
  //                         bottomLeft: Radius.circular(40.0),
  //                         bottomRight: Radius.circular(40.0),
  //                       ),
  //                     ),
  //                     child: IconButton(
  //                         icon: FaIcon(
  //                           FontAwesomeIcons.map,
  //                           color: Colors.white,
  //                           size: 20,
  //                         ),
  //                         onPressed: () {
  //                           setState(() {
  //                             _currentMapType =
  //                                 _currentMapType == MapType.normal
  //                                     ? MapType.satellite
  //                                     : MapType.normal;
  //                           });
  //                         }),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Future<void> _openMap(String lat, String long) async {
  //   String ggURL = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  //   await canLaunchUrlString(ggURL)
  //       ? await launchUrlString(ggURL)
  //       : throw 'K có thông tin $ggURL';
  // }

  // Future<void> _minus(double zoomVal) async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //       CameraPosition(target: LatLng(38.9573415, 35.240741), zoom: zoomVal)));
  // }

  // Future<void> _plus(double zoomVal) async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //       CameraPosition(target: LatLng(38.9573415, 35.240741), zoom: zoomVal)));
  // }

  // Marker marker1 = Marker(
  //     markerId: MarkerId('gramercy'),
  //     position: LatLng(38.9573415, 35.240741),
  //     infoWindow: InfoWindow(title: 'Gramercy Tavern'),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(
  //       BitmapDescriptor.hueRed,
  //     ));
}
