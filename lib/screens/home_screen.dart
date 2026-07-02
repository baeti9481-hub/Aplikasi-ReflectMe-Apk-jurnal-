import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'statistics_screen.dart';
import 'main_screen.dart';
import 'notification_screen.dart';
import 'tulis_jurnal_page.dart';
import 'editprofile_screen.dart'; // Pastikan di-import!

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMood = "😊";

  // Fungsi mengambil nama
  Future<String> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("nama") ?? "User";
  }

  // Fungsi tambahan untuk mengambil email saat dikirim ke halaman Edit
  Future<String> _getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("email") ?? "user@example.com";
  }

  // FUNGSI BARU: Berpindah ke EditProfile dan refresh nama saat kembali
  Future<void> _keHalamanEditProfile() async {
    final currentNama = await _getUserName();
    final currentEmail = await _getUserEmail();

    if (!mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          nama: currentNama,
          email: currentEmail,
        ),
      ),
    );

    // Jika kembali dan membawa data, trigger setState untuk meremajakan FutureBuilder
    if (result != null) {
      setState(() {}); 
    }
  }

  // List jurnal
  List<Map<String, dynamic>> journals = [
    {
      "title": "Hari yang produktif",
      "date": "14 Mei 2026",
      "mood": "😊",
    },
    {
      "title": "Capek setelah kuliah",
      "date": "13 Mei 2026",
      "mood": "😴",
    },
  ];

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  void _pindahKeTulisJurnal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TulisJurnalPage(
          onSaved: (data) {
            setState(() {
              journals.insert(0, {
                "title": data["judul"]!.isEmpty ? "Tanpa Judul" : data["judul"],
                "date": data["tgl"],
                "mood": data["mood"] == "Bahagia" ? "😊" : "😐",
              });
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _keHalamanEditProfile, // Kamu bisa klik area nama/sapaan untuk ke halaman edit profile
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<String>(
                            future: _getUserName(),
                            builder: (context, snapshot) {
                              String displayedName = snapshot.data ?? "User";
                              return Text(
                                "${getGreeting()}, $displayedName 👋",
                                style: const TextStyle(
                                  fontSize: 24, // Sedikit disesuaikan agar pas jika nama panjang
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6D28D9),
                                ),
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "How are you feeling today?",
                            style: TextStyle(color: Colors.black54, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildNotificationIcon(),
                ],
              ),

              const SizedBox(height: 25),

              // ================= MOOD CARD =================
              _buildMoodCard(),

              const SizedBox(height: 28),

              // ================= QUICK ACTION =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Quick Actions",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: const Text("See All",
                        style: TextStyle(color: Color(0xFF8B5CF6))),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pindahKeTulisJurnal,
                      child: actionCard(
                        icon: Icons.edit_note_rounded,
                        title: "Write Journal",
                        subtitle: "Express your thoughts",
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainScreen(initialIndex: 3),
                          ),
                        );
                      },
                      child: actionCard(
                        icon: Icons.bar_chart_rounded,
                        title: "Mood Stats",
                        subtitle: "Track your emotions",
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ================= RECENT JOURNAL =================
              const Text("Recent Journals",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...journals.map((journal) => _buildJournalItem(journal)).toList(),

              const SizedBox(height: 20),
              _buildQuoteCard(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8B5CF6),
        onPressed: _pindahKeTulisJurnal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 52, height: 52,
        decoration: BoxDecoration(color: Colors.deepPurple.shade100, borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF6D28D9)),
      ),
    );
  }

  Widget _buildMoodCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.deepPurple.shade400, Colors.purple.shade300]),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today's Mood", style: TextStyle(color: Colors.white70, fontSize: 15)),
          const SizedBox(height: 14),
          Text(selectedMood, style: const TextStyle(fontSize: 55)),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["😊", "😐", "😢", "😴", "😡"].map((mood) {
              return GestureDetector(
                onTap: () => setState(() => selectedMood = mood),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selectedMood == mood ? Colors.white : Colors.white24,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(mood, style: const TextStyle(fontSize: 24)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalItem(Map<String, dynamic> journal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12)],
      ),
      child: Row(
        children: [
          Container(
            width: 55, height: 55,
            decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(18)),
            child: Center(child: Text(journal["mood"], style: const TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(journal["title"], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(journal["date"], style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.black38)
        ],
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(28)),
      child: Column(
        children: [
          Icon(Icons.auto_awesome_rounded, color: Colors.deepPurple.shade300),
          const SizedBox(height: 14),
          const Text('"Every day is a fresh start."', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget actionCard({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: const Color(0xFF8B5CF6)),
          ),
          const SizedBox(height: 18),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        ],
      ),
    );
  }
}