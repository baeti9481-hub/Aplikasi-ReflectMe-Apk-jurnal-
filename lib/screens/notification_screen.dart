import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // KUNCINYA DI SINI: Pakai dynamic supaya Icons-nya terbaca
    final List<Map<String, dynamic>> notifications = [
      {
        "title": "Ingat tulis jurnal hari ini!",
        "desc": "Jangan lupa luapkan perasaanmu hari ini ya.",
        "time": "2 jam yang lalu",
        "icon": Icons.edit_note_rounded,
      },
      {
        "title": "Mood kamu membaik!",
        "desc": "Berdasarkan statistik, minggu ini kamu lebih ceria.",
        "time": "5 jam yang lalu",
        "icon": Icons.bar_chart_rounded,
      },
      {
        "title": "Update aplikasi tersedia",
        "desc": "Versi terbaru 2.0 sudah bisa diunduh.",
        "time": "Yesterday",
        "icon": Icons.rocket_launch_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FF),
      appBar: AppBar(
        title: const Text(
          "Notifikasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6D28D9),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];

          return Container(
            height: 125,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Icon(
                      item["icon"], // JANGAN pakai tanda seru (!) di sini
                      color: const Color(0xFF8B5CF6),
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item["title"]!, // Untuk teks tetap pakai (!)
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["desc"]!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item["time"]!,
                        style: const TextStyle(
                          color: Colors.black38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
