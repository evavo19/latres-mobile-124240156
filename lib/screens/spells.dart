import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../utils/app_snackbar.dart';
import 'favorite_spells.dart';
import 'login.dart';

class SpellsPage extends StatefulWidget {
  const SpellsPage({super.key});

  @override
  State<SpellsPage> createState() => _SpellsPageState();
}

class _SpellsPageState extends State<SpellsPage> {
  late Future<List<Map<String, dynamic>>> _future;
  final Box _box = Hive.box('favorites');

  @override
  void initState() {
    super.initState();
    _future = ApiService.getSpells();
  }

  void _toggleFavorite(Map<String, dynamic> spell) {
    final name = spell['spell'] as String;
    if (_box.containsKey(name)) {
      _box.delete(name);
      showAppSnackBar(
        'Remove!',
        '$name removed from fav list!',
        success: false,
      );
    } else {
      _box.put(name, {'spell': name, 'use': spell['use'] ?? ''});
      showAppSnackBar(
        'Add!',
        '$name successfully added to fav list!',
        success: true,
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
    showAppSnackBar('Success!', 'Logged out Successfully', success: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry Potter Spells Gallery'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final list = snap.data!;
          // ValueListenableBuilder supaya ikon hati ikut berubah otomatis
          return ValueListenableBuilder(
            valueListenable: _box.listenable(),
            builder: (context, Box box, _) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final s = list[i];
                  final isFav = box.containsKey(s['spell']);
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.book),
                      title: Text(s['spell'] ?? '-'),
                      subtitle: Text(s['use'] ?? '-'),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: isFav ? Colors.red : Colors.grey[800],
                        ),
                        onPressed: () => _toggleFavorite(s),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoriteSpellsPage()),
        ),
        child: const Icon(Icons.favorite, color: Colors.red),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Characters'),
        ),
      ),
    );
  }
}
