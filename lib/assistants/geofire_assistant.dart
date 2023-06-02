import 'package:logisticx_datn/models/active_nearby_available_drivers.dart';

class GeofireAssistant {
  static List<ActiveNearbyAvailableDrivers> activenearbyAvailableDriversList =
      [];

  static void deleteOfflineDriverFromList(String driverId) {
    int indexNumber = activenearbyAvailableDriversList
        .indexWhere((element) => element.driverId == driverId);

    activenearbyAvailableDriversList.removeAt(indexNumber);
  }

  static void updateActiveNearbyAvailableDriverLocation(
      ActiveNearbyAvailableDrivers driverWhoMove) {
    int indexNumer = activenearbyAvailableDriversList
        .indexWhere((element) => element.driverId == driverWhoMove.driverId);

    activenearbyAvailableDriversList[indexNumer].locationLatitude =
        driverWhoMove.locationLatitude;
    activenearbyAvailableDriversList[indexNumer].locationLongitude =
        driverWhoMove.locationLongitude;
  }
}
