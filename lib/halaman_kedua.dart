import 'package:flutter/material.dart';

class HalamanKedua extends StatelessWidget {
  final String nim;
  final String nama;
  final String matakuliah;
  final int nilai;

  const HalamanKedua({
    super.key,
    required this.nim,
    required this.nama,
    required this.matakuliah,
    required this.nilai,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Halaman Kedua"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "NIM: $nim",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Nama: $nama",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.blue,
              ),
            ),
            Text(
              "Matakuliah: $matakuliah",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.blue,
              ),
            ),
            Text(
              "Nilai: $nilai",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("KEMBALI"),
            ),
          ],
        ),
      ),
    );
  }
}