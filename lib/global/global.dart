import 'package:firebase_auth/firebase_auth.dart';
import 'package:logisticx_datn/models/user_model.dart';

import '../models/direction_details_info.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;

String cloudMessagingServerToken =
    "key=AAAAFLbYYaQ:APA91bGs331nskOJ1qHoPwX9OI3jqTfHaG8D-0qUUxupfPbd51_PsNsQ_T1feAhVqB5ACCzvdbtGb3f0Hh3EV0B9TqQaT1ZkGoj9WDOmeKU_WYPvGRa3s12BPQDAtdbv_68drGlSv1kB";
List driversList = [];
DirectionDetailsInfo? tripDirectionDetailsInfo;
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
String driverRatings = "";

double countRatingStars = 0.0;
String titleStarsRating = "";
