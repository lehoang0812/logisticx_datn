// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart' as webService;
// import 'package:location/location.dart';

// class NearbyPlacesMapScreen extends StatefulWidget {
//   @override
//   _NearbyPlacesMapScreenState createState() => _NearbyPlacesMapScreenState();
// }

// class _NearbyPlacesMapScreenState extends State<NearbyPlacesMapScreen> {
//   late GoogleMapController _controller;
//   LocationData? _currentLocation;
//   List<webService.PlacesSearchResult> _places = [];

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
//       type: 'store', // specify the type of place you want to search
//     );
//     setState(() {
//       _places = response.results;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _currentLocation == null
//           ? Center(child: CircularProgressIndicator())
//           : GoogleMap(
//               onMapCreated: (controller) => _controller = controller,
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
