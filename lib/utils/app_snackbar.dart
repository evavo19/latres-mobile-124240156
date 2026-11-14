import 'package:flutter/material.dart';

// Key global supaya snackbar tetap tampil walau halaman berpindah
// (dipakai saat logout: pindah ke Login lalu snackbar muncul).
final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showAppSnackBar(String title, String message, {required bool success}) {
  final messenger = messengerKey.currentState;
  if (messenger == null) return;

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(message, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
}
