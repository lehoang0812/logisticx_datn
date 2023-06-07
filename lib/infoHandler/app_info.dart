import 'package:flutter/widgets.dart';

import '../models/directions.dart';
import '../models/trips_history_model.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  List<String> historyTripsKeysList = [];
  List<TripsHistoryModel> allTripsHistoryInfoList = [];

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  void updateOverallTripsCounter(int overallTripsCounter) {
    countTotalTrips = overallTripsCounter;
    notifyListeners();
  }

  void updateOverallTripsKeys(List<String> tripsKeysList) {
    historyTripsKeysList = tripsKeysList;
    notifyListeners();
  }

  updateOverallTripsHistoryInfo(TripsHistoryModel eachTripHistory) {
    allTripsHistoryInfoList.add(eachTripHistory);
    notifyListeners();
  }
}
