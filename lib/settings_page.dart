import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final controller = TextEditingController();
  double hourlyRate = 20;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('work_data');
    hourlyRate = box.get('rate', defaultValue: 20).toDouble();
    controller.text = hourlyRate.toString();
  }

  void save() {
    final box = Hive.box('work_data');
    box.put('rate', double.parse(controller.text));
    Navigator.pop(context);
  }

  void reset() {
    final box = Hive.box('work_data');
    box.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stawka (zł/h)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: save, child: const Text('Zapisz')),
            const SizedBox(height: 20),
            TextButton(onPressed: reset, child: const Text('Wyczyść dane')),
          ],
        ),
      ),
    );
  }
}