import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SoilRemoteDataSource {

final _soilRef = FirebaseDatabase.instance.ref(dotenv.env['SOIL_MOISTURE_PATH']!);
  Stream<double> watchMoisture() {
    return _soilRef.onValue.map((event) {
      final val = event.snapshot.value;
      return val is int ? val.toDouble() : double.tryParse(val.toString()) ?? 0.0;
    });
  }
}