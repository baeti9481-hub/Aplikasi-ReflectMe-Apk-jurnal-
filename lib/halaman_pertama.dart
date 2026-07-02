import 'package:flutter/material.dart'; 
// import 'halaman_kedua.dart'; 
import 'halaman_edit.dart'; // Import halaman edit 
 
// UBAH JADI STATEFUL WIDGET (Ketik 'stful' di VS Code) 
class HalamanPertama extends StatefulWidget { 
  const HalamanPertama({super.key}); 
 
  @override 
  State<HalamanPertama> createState() => _HalamanPertamaState(); 
} 
 
class _HalamanPertamaState extends State<HalamanPertama> { 
  // State untuk menampung data yang dikembalikan 
  String _namaTampil = "Belum ada nama"; 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: const Text("Halaman Utama"), 
        backgroundColor: Colors.blue, 
        foregroundColor: Colors.white, 
      ), 
      body: Center( 
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [ 
            Text(_namaTampil, 
                style: 
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), 
            const SizedBox(height: 20), 
            ElevatedButton( 
              // TAMBAHKAN async DI SINI 
              onPressed: () async { 
                // TAMBAHKAN await DI SINI 
                final dataKembali = await Navigator.push( 
                  context, 
                  MaterialPageRoute( 
                    builder: (context) => HalamanEdit(teksLama: _namaTampil), 
                  ), 
                ); 
 
                // Jika ada data yang dikembalikan 
                if (dataKembali != null) { 
                  setState(() { 
                    _namaTampil = dataKembali; 
                  }); 
                } 
              }, 
              child: const Text("BUKA HALAMAN EDIT"), 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
}