// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart' as webService;
// import 'package:location/location.dart';

// class GoogleMapPage extends StatefulWidget {
//   const GoogleMapPage({Key? key}) : super(key: key);

//   @override
//   State<GoogleMapPage> createState() => _GoogleMapPageState();
// }

// class _GoogleMapPageState extends State<GoogleMapPage> {
//   late GoogleMapController _ggcontroller;
//   LocationData? _currentLocation;
//   List<webService.PlacesSearchResult> _places = [];
//   double zoomVal = 5.0;
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   void _getCurrentLocation() async {
//     Location location = new Location();
//     LocationData currentLocation = await location.getLocation();
//     setState(() {
//       _currentLocation = currentLocation;
//       _getNearbyPlaces();
//     });
//   }

//   void _getNearbyPlaces() async {
//     final places = new webService.GoogleMapsPlaces(
//         apiKey: 'AIzaSyC-g_UhcAV4iYBCUuTnnEfYv0cKXE_abgU');
//     webService.Location location = webService.Location(
//       lat: _currentLocation!.latitude!,
//       lng: _currentLocation!.longitude!,
//     );

//     webService.PlacesSearchResponse response =
//         await places.searchNearbyWithRadius(
//       location,
//       1500, // radius in meters
//       // type: 'store', // specify the type of place you want to search
//     );
//     setState(() {
//       _places = response.results;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(55.0),
//         child: AppBar(
//           title: Text(
//             'Google Map',
//             style: TextStyle(
//                 fontSize: 24,
//                 color: Colors.grey[800],
//                 fontWeight: FontWeight.w400),
//           ),
//           backgroundColor: Colors.white70,
//           elevation: 0,
//           automaticallyImplyLeading: false,
//         ),
//       ),
//       body: _currentLocation == null
//           ? Center(child: CircularProgressIndicator())
//           : GoogleMap(
//               onMapCreated: (controller) => _ggcontroller = controller,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(
//                   _currentLocation!.latitude!,
//                   _currentLocation!.longitude!,
//                 ),
//                 zoom: 14,
//               ),
//               markers: _places
//                   .map((place) => Marker(
//                         markerId: MarkerId(place.id.toString()),
//                         position: LatLng(place.geometry!.location.lat,
//                             place.geometry!.location.lng),
//                         infoWindow: InfoWindow(title: place.name),
//                       ))
//                   .toSet(),
//             ),
//     );
//   }
// }
