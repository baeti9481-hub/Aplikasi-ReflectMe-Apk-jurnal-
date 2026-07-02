import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk cek kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TulisJurnalPage extends StatefulWidget {
  final Function(Map<String, String>) onSaved;
  final Map<String, String>? dataLama;
  final int? index;

  const TulisJurnalPage(
      {super.key, required this.onSaved, this.dataLama, this.index});

  @override
  State<TulisJurnalPage> createState() => _TulisJurnalPageState();
}

class _TulisJurnalPageState extends State<TulisJurnalPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  String _selectedMood = "Bahagia";
  XFile? _pickedFile; // Gunakan XFile agar lebih aman di Web
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, String>> _moods = [
    {"emoji": "🤩", "label": "Sangat Bahagia"},
    {"emoji": "😊", "label": "Bahagia"},
    {"emoji": "😐", "label": "Biasa Saja"},
    {"emoji": "😔", "label": "Sedih"},
    {"emoji": "😢", "label": "Sangat Sedih"},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.dataLama != null) {
      _judulController.text = widget.dataLama!['judul'] ?? "";
      _catatanController.text = widget.dataLama!['isi'] ?? "";
      _selectedMood = widget.dataLama!['mood'] ?? "Bahagia";
      // Jika ada path gambar lama, buat XFile dummy untuk preview
      if (widget.dataLama!['gambar'] != null &&
          widget.dataLama!['gambar']!.isNotEmpty) {
        _pickedFile = XFile(widget.dataLama!['gambar']!);
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (file != null) {
      setState(() {
        _pickedFile = file;
      });
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.dataLama == null ? "Tulis Catatan" : "Edit Catatan",
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (_catatanController.text.isNotEmpty) {
                widget.onSaved({
                  "judul": _judulController.text.isEmpty
                      ? "Tanpa Judul"
                      : _judulController.text,
                  "isi": _catatanController.text,
                  "mood": _selectedMood,
                  "tgl": widget.dataLama?['tgl'] ?? "17 Mei 2026",
                  "gambar": _pickedFile?.path ?? "", // Simpan path-nya saja
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Isi catatan dulu ya!")),
                );
              }
            },
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF6D28D9),
              radius: 18,
              child: Icon(Icons.check, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- PREVIEW GAMBAR (LOGIKA WEB) ---
            if (_pickedFile != null)
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[100],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: kIsWeb
                          ? Image.network(_pickedFile!.path, fit: BoxFit.cover)
                          : Image.file(File(_pickedFile!.path),
                              fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: GestureDetector(
                      onTap: () => setState(() => _pickedFile = null),
                      child: const CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 15,
                        child: Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  )
                ],
              ),

            Row(
              children: [
                const Icon(Icons.calendar_month_outlined,
                    color: Colors.grey, size: 18),
                const SizedBox(width: 8),
                Text(widget.dataLama?['tgl'] ?? "17 Mei 2026",
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Bagaimana mood kamu hari ini?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _moods.map((mood) {
                bool isSelected = _selectedMood == mood['label'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = mood['label']!),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEDE9FE)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF6D28D9)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Text(mood['emoji']!,
                            style: const TextStyle(fontSize: 30)),
                      ),
                      const SizedBox(height: 8),
                      Text(mood['label']!,
                          style: TextStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? const Color(0xFF6D28D9)
                                  : Colors.black54,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            const Text("Judul (opsional)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            TextField(
              controller: _judulController,
              decoration: InputDecoration(
                hintText: "Contoh: Hari yang produktif",
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 25),
            const Text("Catatan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            TextField(
              controller: _catatanController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "Tulis catatan harianmu di sini...",
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.image_outlined,
                        color: Colors.black54, size: 22),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.label_outline_rounded,
                      color: Colors.black54, size: 22),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_outline, size: 16, color: Colors.black54),
                      SizedBox(width: 5),
                      Text("Privat",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
