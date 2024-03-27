
import 'package:geolocator/geolocator.dart';
Future<Position> determinePosition() async{
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied){
      return Future.error('error');
    }
  }
  return await Geolocator.getCurrentPosition();
}
Future<Position> getCurrentPosition() async{
  Position position = await determinePosition();
  print(position);
  return position;
}
Future<double> getCurrentLatitude() async{
  Position position = await determinePosition();
  print(position.latitude);
  return position.latitude;
}

Future<double> getCurrentLongitude() async{
  Position position = await determinePosition();
  print(position.longitude);
  return position.longitude;
}


