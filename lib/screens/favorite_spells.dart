import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/notification.dart';

class FavoriteSpellsPage extends StatelessWidget {
  const FavoriteSpellsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('favorites');

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Spell')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box b, _) {
          if (b.isEmpty) {
            return const Center(child: Text('Belum ada spell favorit'));
          }
          final keys = b.keys.toList();
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: keys.length,
            itemBuilder: (context, i) {
              final key = keys[i];
              final data = Map<String, dynamic>.from(b.get(key));
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(data['spell'] ?? '-'),
                  subtitle: Text(data['use'] ?? '-'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await b.delete(key);
                      await NotificationService.showDeleteNotification(
                        data['spell'] ?? '',
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
