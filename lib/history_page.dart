import 'package:flutter/material.dart';
import 'storage_service.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final history = StorageService.getAllDays();

    return Scaffold(
      appBar: AppBar(title: const Text('Historia')),
      body: ValueListenableBuilder(
        valueListenable: history,
        builder: (context, BoxData, _) {
          final items = BoxData.entries.toList()
            ..sort((a, b) => b.key.compareTo(a.key));

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final date = items[i].key;
              final minutes = items[i].value;
              final hours = (minutes / 60).toStringAsFixed(2);
              final earnings = (hours == '0.00')
                  ? 0
                  : (minutes / 60 * (BoxData.get('rate') ?? 20)).toStringAsFixed(2);
              return ListTile(
                title: Text('$date – ${hours}h'),
                subtitle: Text('$earnings zł'),
              );
            },
          );
        },
      ),
    );
  }
}
Wysłano
Napisz do:
