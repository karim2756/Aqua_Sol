import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WaterPumpRemoteDataSource {

final _pumpRef = FirebaseDatabase.instance.ref(dotenv.env['PUMP_CONTROL_PATH']!);

  Future<bool> getPumpStatus() async {
    final snapshot = await _pumpRef.get();
    return (snapshot.value == 1 || snapshot.value == true);
  }

  Future<void> setPumpStatus(bool turnOn) async {
    await _pumpRef.set(turnOn ? 1 : 0);
  }

  Stream<bool> watchPumpStatus() {
    return _pumpRef.onValue.map((event) {
      final value = event.snapshot.value;
      return (value == 1 || value == true);
    });
  }
}