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
void getCurrentPosition() async{
  Position position = await determinePosition();
  print(position.latitude);
  print(position.longitude);
}
