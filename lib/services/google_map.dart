import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  Completer<GoogleMapController> _controller = Completer();
  double zoomVal = 5.0;
  MapType _currentMapType = MapType.normal;
  @override
  void initState() {
    super.initState();
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
      body: Stack(
        children: <Widget>[
          FutureBuilder<Widget>(
            future: _buildGoogleMap(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              } else if (snapshot.hasError) {
                return Text("Lỗi là : ${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
          _zoomMinusFunction(),
        ],
      ),
    );
  }

  Future<Widget> _buildGoogleMap(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
          'Dịch vụ truy cập vị trí đã bị hủy. Vui lòng bật Vị trí');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Quyền truy cập vị trí bị từ chối !');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Quyền truy cập vị trí đã bị từ chối vĩnh viễn, bạn phải vào cài đặt để cấp quyền.');
    }
    return FutureBuilder<Position>(
      future: Geolocator.getCurrentPosition(),
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.hasData) {
          Position currentPosition = snapshot.data!;
          LatLng latLng =
              LatLng(currentPosition.latitude, currentPosition.longitude);
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              mapType: _currentMapType,
              initialCameraPosition: CameraPosition(target: latLng, zoom: 12),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _zoomMinusFunction() {
    return Align(
      alignment: Alignment.topRight,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 8.0),
            child: Row(
              children: [
                Spacer(),
                Column(
                  children: [
                    Container(
                      width: 55.0,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.minus,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            zoomVal--;
                            _minus(zoomVal);
                          }),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 55.0,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            zoomVal++;
                            _plus(zoomVal);
                          }),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 55.0,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.map,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _currentMapType =
                                  _currentMapType == MapType.normal
                                      ? MapType.satellite
                                      : MapType.normal;
                            });
                          }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(38.9573415, 35.240741), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(38.9573415, 35.240741), zoom: zoomVal)));
  }

  // Marker marker1 = Marker(
  //     markerId: MarkerId('gramercy'),
  //     position: LatLng(38.9573415, 35.240741),
  //     infoWindow: InfoWindow(title: 'Gramercy Tavern'),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(
  //       BitmapDescriptor.hueRed,
  //     ));
}
