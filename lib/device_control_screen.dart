import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DeviceControlScreen extends StatefulWidget {
  const DeviceControlScreen({super.key});

  @override
  _DeviceControlScreenState createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('devices');

  int motorControl = 0;
  int pumpControl = 0;
  int soilMoisture = 0;

  @override
  void initState() {
    super.initState();

    // One-time test read
    _database.get().then((snapshot) {
      print('One-time fetch: ${snapshot.value}');
    });

    // Listen to realtime changes
    _database.onValue.listen((event) {
      print('Database snapshot received');
      final data = event.snapshot.value as Map?;
      if (data != null) {
        print('Data from Firebase: $data');
        setState(() {
          motorControl = data['motor']?['control'] ?? 0;
          pumpControl = data['pump']?['control'] ?? 0;
          soilMoisture = data['sensor']?['soil_moisture'] ?? 0;
        });
      } else {
        print('Data is null');
      }
    });
  }

  Future<void> updateControl(String device, int value) async {
    try {
      await _database.child(device).update({'control': value});
      print('$device control updated to $value');
    } catch (e) {
      print('Error updating $device: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Control')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Motor Control:'),
            Text('Status: $motorControl'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => updateControl('motor', 1),
                  child: const Text('Turn Motor ON'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => updateControl('motor', 0),
                  child: const Text('Turn Motor OFF'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Pump Control:'),
            Text('Status: $pumpControl'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => updateControl('pump', 1),
                  child: const Text('Turn Pump ON'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => updateControl('pump', 0),
                  child: const Text('Turn Pump OFF'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Soil Moisture:'),
            Text('Value: $soilMoisture'),
          ],
        ),
      ),
    );
  }
}
