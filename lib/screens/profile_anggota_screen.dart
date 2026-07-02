import 'package:flutter/material.dart';

class ProfileAnggotaScreen extends StatelessWidget {
  const ProfileAnggotaScreen({super.key});

  static const List<Map<String, dynamic>> anggotaTim = [
    {
      "nama": "Ayu Oktafiani",
      "nim": "19241700",
      "peran": "Ketua",
      "gambar": "assets/images/Image01.jpg",
    },
    {
      "nama": "Novita Tri Indriyani",
      "nim": "19242499",
      "peran": "Anggota 1",
      "gambar": "assets/images/Image02.jpg",
    },
    {
      "nama": "Nur Baeti",
      "nim": "19242504",
      "peran": "Anggota 2",
      "gambar": "assets/images/Image03.jpg",
    },
    {
      "nama": "Nur Hidayati",
      "nim": "19242500",
      "peran": "Anggota 3",
      "gambar": "assets/images/Image04.jpg",
    },
    {
      "nama": "Putri Hadiyani",
      "nim": "19242495",
      "peran": "Anggota 4",
      "gambar": "assets/images/Image05.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FF),
      appBar: AppBar(
        title: const Text(
          "Tim Pengembang ReflectMe",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: anggotaTim.length,
        itemBuilder: (context, index) {
          final anggota = anggotaTim[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFEDE9FE),
                backgroundImage: AssetImage(anggota["gambar"]),
              ),
              title: Text(
                anggota["nama"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                anggota["peran"],
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF8B5CF6),
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailAnggotaScreen(
                      data: anggota,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailAnggotaScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailAnggotaScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FF),
      appBar: AppBar(
        title: const Text(
          "Profile Anggota",
          style: TextStyle(color: Colors.white, 
          fontWeight: FontWeight.bold,), 
        ),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF8B5CF6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(data["gambar"]),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              data["nama"],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              data["peran"],
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF8B5CF6),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.badge,
                          color: Color(0xFF8B5CF6),
                        ),
                        title: const Text("NIM"),
                        subtitle: Text(data["nim"]),
                      ),
                      const Divider(),
                      const ListTile(
                        leading: Icon(
                          Icons.favorite,
                          color: Color(0xFF8B5CF6),
                        ),
                        title: Text("Kontribusi"),
                        subtitle: Text(
                          "Pengembangan aplikasi ReflectMe",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}