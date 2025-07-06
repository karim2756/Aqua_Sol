import 'package:firebase_database/firebase_database.dart';

class WaterPumpRemoteDataSource {
  final DatabaseReference _pumpRef =
  FirebaseDatabase.instance.ref('devices/pump/control');

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