import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'tulis_jurnal_page.dart'; // Memastikan halaman tulis/edit jurnal terhubung

class DetailCatatanScreen extends StatefulWidget {
  final Map<String, String> dataCatatan;
  final int index;
  final Function(Map<String, String>) onSaved;

  const DetailCatatanScreen({
    super.key,
    required this.dataCatatan,
    required this.index,
    required this.onSaved,
  });

  @override
  State<DetailCatatanScreen> createState() => _DetailCatatanScreenState();
}

class _DetailCatatanScreenState extends State<DetailCatatanScreen> {
  late Map<String, String> _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.dataCatatan;
  }

  // Fungsi untuk konversi label ke emoji
  String _getEmoji(String? mood) {
    switch (mood) {
      case "Sangat Bahagia":
        return "🤩";
      case "Bahagia":
        return "😊";
      case "Biasa Saja":
        return "😐";
      case "Sedih":
        return "😔";
      case "Sangat Sedih":
        return "😢";
      default:
        return "😊";
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? imagePath = _currentData['gambar'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Catatan",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          // Tombol Edit lingkaran ungu di pojok kanan atas
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF6D28D9),
              radius: 18,
              child: Icon(Icons.edit, color: Colors.white, size: 18),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TulisJurnalPage(
                    dataLama: _currentData,
                    index: widget.index,
                    onSaved: (hasilEdit) {
                      setState(() {
                        _currentData =
                            hasilEdit; // Perbarui data halaman detail secara real-time
                      });
                      widget.onSaved(
                          hasilEdit); // Kirim pembaruan ke halaman daftar
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TAMPILAN IMAGE PREVIEW
            if (imagePath != null && imagePath.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: kIsWeb
                      ? Image.network(imagePath, fit: BoxFit.cover)
                      : Image.file(File(imagePath), fit: BoxFit.cover),
                ),
              ),

            // 2. PANEL TANGGAL (FIX: const dilepas total biar linter aman)
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined,
                    color: Colors.black45, size: 18),
                const SizedBox(width: 8),
                Text(
                  _currentData['tgl'] ?? "3 Jun 2026",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. BADGE STATUS MOOD TUNGGAL
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getEmoji(_currentData['mood']),
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _currentData['mood'] ?? "Bahagia",
                    style: const TextStyle(
                      color: Color(0xFF6D28D9),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 4. JUDUL CATATAN (Berupa teks biasa, bukan field input)
            Text(
              _currentData['judul'] == "Tanpa Judul" ||
                      (_currentData['judul'] ?? '').isEmpty
                  ? "Catatan Tanpa Judul"
                  : _currentData['judul']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 20),

            // 5. ISI JURNAL (Murni tulisan mengalir)
            Text(
              _currentData['isi'] ?? "",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.6, // Jarak baris yang nyaman dibaca
              ),
            ),
          ],
        ),
      ),
    );
  }
}
