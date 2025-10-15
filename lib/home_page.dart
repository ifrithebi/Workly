import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'history_page.dart';
import 'settings_page.dart';
import 'storage_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isWorking = false;
  DateTime? startTime;
  double totalMinutesToday = 0;
  double hourlyRate = 20;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final box = Hive.box('work_data');
    final savedRate = box.get('rate', defaultValue: 20);
    final todayMinutes = await StorageService.getMinutesForToday();
    setState(() {
      hourlyRate = savedRate.toDouble();
      totalMinutesToday = todayMinutes;
    });
  }

  void toggleWork() async {
    if (isWorking) {
      // stop
      final now = DateTime.now();
      final minutesWorked = now.difference(startTime!).inMinutes;
      totalMinutesToday += minutesWorked;
      await StorageService.saveMinutesForToday(totalMinutesToday);
      setState(() => isWorking = false);
    } else {
      // start
      startTime = DateTime.now();
      setState(() => isWorking = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hours = (totalMinutesToday / 60).toStringAsFixed(2);
    final earnings = (totalMinutesToday / 60 * hourlyRate).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Timer'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryPage())),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SettingsPage()));
              loadData();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Dzisiaj: $hours h', style: const TextStyle(fontSize: 24)),
            Text('Zarobek: $earnings zł', style: const TextStyle(fontSize: 20, color: Colors.greenAccent)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: toggleWork,
              style: ElevatedButton.styleFrom(
                backgroundColor: isWorking ? Colors.redAccent : Colors.greenAccent,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
              ),
              child: Text(
                isWorking ? 'STOP' : 'START',
                style: const TextStyle(fontSize: 28, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            if (isWorking)
              Text('Rozpoczęto o ${startTime!.hour}:${startTime!.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey))
          ],
        ),
      ),
    );
  }
}