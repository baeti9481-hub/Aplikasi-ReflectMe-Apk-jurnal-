import 'dart:io';
import 'package:flutter/material.dart';
import 'tulis_jurnal_page.dart';
import 'detail_catatan_screen.dart';

class DaftarCatatanPage extends StatefulWidget {
  final List<Map<String, String>> dataJurnal;

  const DaftarCatatanPage({super.key, required this.dataJurnal});

  @override
  State<DaftarCatatanPage> createState() => _DaftarCatatanPageState();
}

class _DaftarCatatanPageState extends State<DaftarCatatanPage> {
  // 1. Tambahkan controller dan list baru untuk menampung hasil filter
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredJurnal = [];

  @override
  void initState() {
    super.initState();
    // Isi list filter dengan semua data jurnal di awal halaman dibuka
    _filteredJurnal = widget.dataJurnal;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 2. Fungsi untuk memfilter data berdasarkan input user
  void _filterCatatan(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredJurnal = widget.dataJurnal;
      } else {
        _filteredJurnal = widget.dataJurnal.where((item) {
          final judul = (item['judul'] ?? '').toLowerCase();
          final isi = (item['isi'] ?? '').toLowerCase();
          final inputUser = query.toLowerCase();

          // Cari berdasarkan judul ATAU isi catatan
          return judul.contains(inputUser) || isi.contains(inputUser);
        }).toList();
      }
    });
  }

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Catatan",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController, // 3. Pasangkan controller-nya
              onChanged:
                  _filterCatatan, // 4. Jalankan fungsi filter tiap kali ngetik
              decoration: InputDecoration(
                hintText: "Cari catatan...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _filterCatatan('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
              ),
            ),
          ),

          // List Catatan
          Expanded(
            // 5. Ganti pengecekan dan itemBuilder dari widget.dataJurnal ke _filteredJurnal
            child: _filteredJurnal.isEmpty
                ? const Center(
                    child: Text(
                        "Catatan tidak ditemukan.\nMulai menulis cerita baru!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredJurnal.length,
                    itemBuilder: (context, index) {
                      final item = _filteredJurnal[index];
                      final String? imagePath = item['gambar'];

                      // Cari index asli dari dataJurnal untuk keperluan update/hapus
                      final int originalIndex = widget.dataJurnal.indexOf(item);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailCatatanScreen(
                                dataCatatan: item,
                                index: originalIndex,
                                onSaved: (hasilEdit) {
                                  setState(() {
                                    widget.dataJurnal[originalIndex] =
                                        hasilEdit;
                                    _filterCatatan(_searchController
                                        .text); // Refresh filter
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade100),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Row(
                            children: [
                              // --- BAGIAN FOTO/MOOD ---
                              Container(
                                width: 50,
                                height: 50,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.yellow[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: imagePath != null && imagePath.isNotEmpty
                                    ? Image.network(
                                        imagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                              child: Text(
                                                  _getEmoji(item['mood']),
                                                  style: const TextStyle(
                                                      fontSize: 24)));
                                        },
                                      )
                                    : Center(
                                        child: Text(_getEmoji(item['mood']),
                                            style:
                                                const TextStyle(fontSize: 24))),
                              ),
                              const SizedBox(width: 15),

                              // Judul & Isi
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['judul'] ?? "Tanpa Judul",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(item['isi'] ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13)),
                                  ],
                                ),
                              ),

                              // Tanggal + Aksi
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item['tgl'] ?? "17 Mei 2026",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Edit
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => TulisJurnalPage(
                                                dataLama: item,
                                                index: originalIndex,
                                                onSaved: (hasilEdit) {
                                                  setState(() {
                                                    widget.dataJurnal[
                                                            originalIndex] =
                                                        hasilEdit;
                                                    _filterCatatan(_searchController
                                                        .text); // Refresh filter
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          size: 18,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      // Hapus
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title:
                                                  const Text("Hapus Catatan"),
                                              content: const Text(
                                                  "Apakah kamu yakin ingin menghapus catatan ini?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text("Batal"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      widget.dataJurnal
                                                          .removeAt(
                                                              originalIndex);
                                                      _filterCatatan(
                                                          _searchController
                                                              .text); // Refresh filter
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Hapus",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
