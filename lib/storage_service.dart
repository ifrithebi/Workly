import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  static Box get box => Hive.box('work_data');

  static String _today() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  static Future<void> saveMinutesForToday(double minutes) async {
    await box.put(_today(), minutes);
  }

  static Future<double> getMinutesForToday() async {
    return box.get(_today(), defaultValue: 0.0);
  }

  static ValueListenable<Box> getAllDays() {
    return box.listenable();
  }
}