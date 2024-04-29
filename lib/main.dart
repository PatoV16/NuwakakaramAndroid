import 'login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuwakakaram/Modulo_Ubicacion/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import "package:nuwakakaram/services/notification_services.dart";


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await determinePosition();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Locks the orientation to portrait upright
  ]);

 

  runApp(const MyApp());
  
}

