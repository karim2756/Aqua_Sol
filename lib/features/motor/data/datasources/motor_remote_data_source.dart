import 'package:firebase_database/firebase_database.dart';

class MotorRemoteDataSource {
  final DatabaseReference _motorRef =
  FirebaseDatabase.instance.ref('devices/motor/control');

  Future<bool> getMotorStatus() async {
    final snapshot = await _motorRef.get();
    return (snapshot.value == 1 || snapshot.value == true);
  }

  Future<void> setMotorStatus(bool turnOn) async {
    await _motorRef.set(turnOn ? 1 : 0);
  }

  Stream<bool> watchMotorStatus() {
    return _motorRef.onValue.map((event) {
      final value = event.snapshot.value;
      return (value == 1 || value == true);
    });
  }
}