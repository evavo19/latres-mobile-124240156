import 'package:flutter/material.dart';

class CharacterDetailPage extends StatelessWidget {
  final Map<String, dynamic> character;
  const CharacterDetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final children = (character['children'] as List?)?.join(', ') ?? '-';

    // Semua property dari API ditampilkan
    final rows = <MapEntry<String, String>>[
      MapEntry('Index', '${character['index'] ?? '-'}'),
      MapEntry('Full Name', '${character['fullName'] ?? '-'}'),
      MapEntry('Nickname', '${character['nickname'] ?? '-'}'),
      MapEntry('Hogwarts House', '${character['hogwartsHouse'] ?? '-'}'),
      MapEntry('Interpreted By', '${character['interpretedBy'] ?? '-'}'),
      MapEntry('Children', children.isEmpty ? '-' : children),
      MapEntry('Birthdate', '${character['birthdate'] ?? '-'}'),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(character['fullName'] ?? 'Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                character['image'] ?? '',
                height: 300,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, size: 120),
              ),
            ),
            const SizedBox(height: 16),
            for (final r in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(
                        r.key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: Text(r.value)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
