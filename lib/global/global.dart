import 'package:firebase_auth/firebase_auth.dart';
import 'package:logisticx_datn/models/user_model.dart';

import '../models/direction_details_info.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;

String cloudMessagingServerToken = "key=";
List driversList = [];
DirectionDetailsInfo? tripDirectionDetailsInfo;
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhong = "";

double countRatingStars = 0.0;
String titleStarsRating = "";
