import 'package:flutter/material.dart'; 
// import 'halaman_pertama.dart'; // <-- Import halaman yang sedang aktif 
import 'bottom_nav_page.dart';
// Entry point aplikasi 
void main() { 
runApp(const AplikasiKu()); 
} 
// Root widget (Stateless) 
class AplikasiKu extends StatelessWidget { 
const AplikasiKu({super.key}); 
@override 
Widget build(BuildContext context) { 
return MaterialApp( 
debugShowCheckedModeBanner: false, 
// Theme agar tidak hardcode warna utama 
theme: ThemeData( 
colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), 
useMaterial3: true, 
), 
// Gunakan const untuk optimasi 
home: const BottomNavPage(), // <-- TAMPILKAN PAGE terkait 
); 
} 
} 