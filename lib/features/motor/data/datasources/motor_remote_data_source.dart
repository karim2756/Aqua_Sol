import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MotorRemoteDataSource {

final _motorRef = FirebaseDatabase.instance.ref(dotenv.env['MOTOR_CONTROL_PATH']!);
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