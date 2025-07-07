import 'package:firebase_database/firebase_database.dart';

class SoilRemoteDataSource {
  final DatabaseReference _soilRef =
  FirebaseDatabase.instance.ref('devices/sensor/soil_moisture');

  Stream<double> watchMoisture() {
    return _soilRef.onValue.map((event) {
      final val = event.snapshot.value;
      return val is int ? val.toDouble() : double.tryParse(val.toString()) ?? 0.0;
    });
  }
}