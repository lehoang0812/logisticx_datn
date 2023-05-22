import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logisticx_datn/assistants/assistant_methods.dart';
import 'package:logisticx_datn/global/global.dart';
import 'package:logisticx_datn/global/map_key.dart';
import 'package:logisticx_datn/infoHandler/app_info.dart';
import 'package:logisticx_datn/screens/search_places_screen.dart';
import 'package:provider/provider.dart';

import '../models/directions.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final Completer<GoogleMapController> _controllerGGMap =
      Completer<GoogleMapController>();
  GoogleMapController? newGGMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220;
  double waitingResponsefromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> polylineCoordinatedList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "";
  String userEmail = "";

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);

    newGGMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            userCurrentPosition!, context);
    print("Địa chỉ của tôi là: " + humanReadableAddress);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;
  }

  getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: pickLocation!.latitude,
        longitude: pickLocation!.longitude,
        googleMapApiKey: mapKey,
      );
      setState(() {
        Directions userPickUpAddress = Directions();
        userPickUpAddress.locationLatitude = pickLocation!.latitude;
        userPickUpAddress.locationLongtitude = pickLocation!.longitude;
        userPickUpAddress.locationName = data.address;

        Provider.of<AppInfo>(context, listen: false)
            .updatePickUpLocationAddress(userPickUpAddress);

        // _address = data.address;
      });
    } catch (e) {
      print("Lỗi: $e");
    }
  }

  checkIfLocationPermisstionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polylineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGGMap.complete(controller);
              newGGMapController = controller;

              setState(() {});

              locateUserPosition();
            },
            onCameraMove: (CameraPosition? position) {
              if (pickLocation != position!.target) {
                setState(() {
                  pickLocation = position.target;
                });
              }
            },
            onCameraIdle: () {
              getAddressFromLatLng();
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Icon(
                Icons.location_on,
                size: 45,
              ),
            ),
          ),

          //vi for searching location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.amber.shade400,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Nơi lấy hàng",
                                        style: TextStyle(
                                            color: Colors.amber.shade400,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        Provider.of<AppInfo>(context)
                                                    .userPickUpLocation !=
                                                null
                                            ? (Provider.of<AppInfo>(context)
                                                        .userPickUpLocation!
                                                        .locationName!)
                                                    .substring(0, 24) +
                                                "..."
                                            : "Chưa nhận đc địa chỉ",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(
                              height: 1,
                              thickness: 2,
                              color: Colors.amber.shade400,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: GestureDetector(
                                onTap: () async {
                                  //chuyen den search places screen
                                  var responseFromSearchScreen =
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) =>
                                                  SearchPlacesScreen()));

                                  if (responseFromSearchScreen ==
                                      "obtainedDropoff") {
                                    setState(() {
                                      openNavigationDrawer = false;
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.amber.shade400,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nơi chuyển hàng",
                                          style: TextStyle(
                                              color: Colors.amber.shade400,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          Provider.of<AppInfo>(context)
                                                      .userDropOffLocation !=
                                                  null
                                              ? Provider.of<AppInfo>(context)
                                                  .userDropOffLocation!
                                                  .locationName!
                                              : "Bạn muốn chuyển hàng đến đâu?",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          )

          // Positioned(
          //     child: Container(
          //   decoration: BoxDecoration(
          //     border: Border.all(color: Colors.black),
          //     color: Colors.white,
          //   ),
          //   padding: EdgeInsets.all(20),
          //   child: Text(
          //     Provider.of<AppInfo>(context).userPickUpLocation != null
          //         ? (Provider.of<AppInfo>(context)
          //                     .userPickUpLocation!
          //                     .locationName!)
          //                 .substring(0, 24) +
          //             "..."
          //         : "Chưa nhận đc địa chỉ",
          //     overflow: TextOverflow.visible,
          //     softWrap: true,
          //   ),
          // ))
        ]),
      ),
    );
  }
}
