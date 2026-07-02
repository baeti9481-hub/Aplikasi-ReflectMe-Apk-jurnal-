import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 1. Tambahkan import ini
import 'editprofile_screen.dart';
import 'profile_anggota_screen.dart';
import 'login_screen.dart';

class AccountScreen extends StatefulWidget {
  final String nama;
  final String email;

  const AccountScreen({
    super.key,
    required this.nama,
    required this.email,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late String currentNama;
  late String currentEmail;

  @override
  void initState() {
    super.initState();
    currentNama = widget.nama;
    currentEmail = widget.email;
    _loadSavedData(); // 2. Ambil data dari SharedPreferences saat layar pertama dimuat
  }

  // Fungsi untuk memuat data lokal yang pernah disimpan oleh EditProfileScreen
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Jika data di SharedPreferences ada, pakai itu. Jika kosong (null), pakai data kiriman awal (widget.nama/email)
      currentNama = prefs.getString("nama") ?? widget.nama;
      currentEmail = prefs.getString("email") ?? widget.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              // Avatar + Nama + Email
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: const Color(0xFFEDE9FE),
                          child: const Icon(Icons.person,
                              size: 50, color: Color(0xFF8B5CF6)),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Color(0xFF8B5CF6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit,
                                size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentNama,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentEmail,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Menu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Edit Profile
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.edit_outlined,
                            color: Color(0xFF8B5CF6)),
                        title: const Text(
                          'Edit Profile',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(Icons.arrow_forward,
                            color: Color(0xFF8B5CF6)),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfileScreen(
                                nama: currentNama,
                                email: currentEmail,
                              ),
                            ),
                          );

                          // 3. Perbaikan ekstraksi data map di sini
                          if (result != null && result is Map<String, String>) {
                            setState(() {
                              currentNama = result['nama'] ?? currentNama;
                              currentEmail = result['email'] ?? currentEmail;
                            });
                          }
                        },
                      ),
                    ),

                    // Profile Anggota
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.group_outlined,
                          color: Color(0xFF8B5CF6),
                        ),
                        title: const Text(
                          'Profile Anggota',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF8B5CF6),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileAnggotaScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    // Logout
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing:
                            const Icon(Icons.arrow_forward, color: Colors.red),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
