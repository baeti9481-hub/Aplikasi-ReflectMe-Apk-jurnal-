import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'statistics_screen.dart';
import 'account_screen.dart';
import 'tulis_jurnal_page.dart';
import 'daftar_catatan.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  String _nama = '';
  String _email = '';

  // WADAH UTAMA: Semua catatan disimpan di sini
  List<Map<String, String>> listJurnalUtama = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex == 2 ? 0 : widget.initialIndex;
    loadUserData(); // Memanggil fungsi muat data user saat layar pertama kali dibuat
    _loadJurnal();
  }

  // --- FUNGSI BIAR DATA ENGGAK HILANG ---
  void _loadJurnal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString('list_catatan');

    if (dataString != null) {
      setState(() {
        List<dynamic> decodedData = jsonDecode(dataString);
        listJurnalUtama =
            decodedData.map((item) => Map<String, String>.from(item)).toList();
      });
    }
  }

  void _saveJurnal() async {
    final prefs = await SharedPreferences.getInstance();
    String dataString = jsonEncode(listJurnalUtama);
    await prefs.setString('list_catatan', dataString);

    // PENTING: Paksa refresh UI setelah simpan
    setState(() {});
  }

  void _editJurnal(int index, Map<String, String> dataBaru) {
    setState(() {
      listJurnalUtama[index] = dataBaru;
    });
    _saveJurnal();
  }

  // Diubah menjadi fungsi publik tanpa underscore agar bisa di-refresh dari luar jika diperlukan
  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('nama') ?? 'Pengguna';
      _email = prefs.getString('email') ?? '';
    });
  }

  // --- PILIH HALAMAN ---
  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return DaftarCatatanPage(
            key: ValueKey(listJurnalUtama.length), dataJurnal: listJurnalUtama);
      case 3:
        return StatisticsScreen(
            key: ValueKey(listJurnalUtama.length), // Ini penting agar di-refresh
            dataJurnal: listJurnalUtama);
      case 4:
        return AccountScreen(nama: _nama, email: _email);
      default:
        return const HomeScreen();
    }
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TulisJurnalPage(
            onSaved: (dataBaru) {
              setState(() {
                listJurnalUtama.insert(0, dataBaru);
              });
              _saveJurnal();
            },
          ),
        ),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined), label: 'Catatan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, size: 45, color: Colors.deepPurple),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined), label: 'Statistik'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Akun'),
        ],
      ),
    );
  }
}