import 'package:flutter/material.dart';
import 'main_screen.dart'; // Pastikan import MainScreen kamu benar

class StatisticsScreen extends StatelessWidget {
  final List<Map<String, String>> dataJurnal;

  const StatisticsScreen({super.key, required this.dataJurnal});

  // --- 1. LOGIKA DATA UNTUK GRAFIK GARIS ---
  List<Map<String, dynamic>> getLineChartData() {
    if (dataJurnal.isEmpty) return [];

    return dataJurnal.reversed
        .take(7)
        .map((item) {
          String mood = item['mood'] ?? "";
          double value = 3.0;

          if (mood.contains("🤩"))
            value = 5.0;
          else if (mood.contains("😊"))
            value = 4.0;
          else if (mood.contains("😐"))
            value = 3.0;
          else if (mood.contains("😔"))
            value = 2.0;
          else if (mood.contains("😢")) value = 1.0;

          return {
            "day": _getNamaHari(item['tgl'] ?? ""),
            "value": value,
          };
        })
        .toList()
        .reversed
        .toList();
  }

  // --- 2. HELPER: HITUNG HARI ---
  String _getNamaHari(String tglString) {
    try {
      List<String> namaHari = [
        "",
        "Sen",
        "Sel",
        "Rab",
        "Kam",
        "Jum",
        "Sab",
        "Min"
      ];
      List<String> p = tglString.split(' ');
      DateTime d =
          DateTime(int.parse(p[2]), _blnKeAngka(p[1]), int.parse(p[0]));
      return namaHari[d.weekday];
    } catch (e) {
      return tglString.split(' ').first;
    }
  }

  int _blnKeAngka(String b) {
    Map<String, int> m = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'Mei': 5,
      'Jun': 6,
      'Jul': 7,
      'Agt': 8,
      'Sep': 9,
      'Okt': 10,
      'Nov': 11,
      'Des': 12
    };
    return m[b] ?? 1;
  }

  int hitungPersen(String moodTarget) {
    if (dataJurnal.isEmpty) return 0;
    int jml =
        dataJurnal.where((item) => item['mood']!.contains(moodTarget)).length;
    return ((jml / dataJurnal.length) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final chartData = getLineChartData();
    int totalHappy = hitungPersen("Bahagia") + hitungPersen("🤩");
    int totalSad = hitungPersen("Sedih") + hitungPersen("😢");

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        // --- TOMBOL KEMBALI YANG BERFUNGSI (KE BERANDA) ---
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            // Kita arahkan balik ke MainScreen di tab index 0 (Beranda)
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainScreen(initialIndex: 0)),
              (route) => false,
            );
          },
        ),
        title: const Text("Mood Statistics",
            style: TextStyle(
                color: Color(0xFF6D28D9),
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Atas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent]),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Weekly Average Mood",
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(
                      totalHappy >= totalSad
                          ? "Mood looks better this week ✨"
                          : "Hang in there, Putri! 💪",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("Weekly Chart",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // --- AREA GRAFIK GARIS ---
            Container(
              padding: const EdgeInsets.fromLTRB(45, 20, 20, 45),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04), blurRadius: 12)
                  ]),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: chartData.isEmpty
                    ? const Center(child: Text("Belum ada data jurnal"))
                    : CustomPaint(
                        painter: MoodLinePainter(chartData),
                      ),
              ),
            ),

            const SizedBox(height: 30),
            const Text("Mood Summary",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                    child: summaryCard(
                        title: "Happy", value: "$totalHappy%", icon: "😊")),
                const SizedBox(width: 16),
                Expanded(
                    child: summaryCard(
                        title: "Sad", value: "$totalSad%", icon: "😢")),
              ],
            ),

            const SizedBox(height: 30),

            // Insight Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(28)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("💡 Insight Minggu Ini",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Text(
                      "Berdasarkan ${dataJurnal.length} catatanmu, grafik garis menunjukkan tren suasana hatimu secara otomatis.",
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget summaryCard(
      {required String title, required String value, required String icon}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)
          ]),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D28D9))),
          Text(title, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class MoodLinePainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  MoodLinePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6D28D9)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()..color = const Color(0xFF6D28D9);
    final gridPaint = Paint()..color = Colors.grey.withOpacity(0.1);

    double heightScale = size.height / 5;
    double stepX = size.width / (data.length > 1 ? (data.length - 1) : 1);

    List<String> emojis = ["😢", "😔", "😐", "😊", "🤩"];
    for (int i = 0; i < 5; i++) {
      double y = size.height - ((i + 1) * heightScale);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);

      final tp = TextPainter(
        text: TextSpan(text: emojis[i], style: const TextStyle(fontSize: 15)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(-40, y - (tp.height / 2)));
    }

    if (data.isEmpty) return;

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      double x = i * stepX;
      double y = size.height - (data[i]['value'] * heightScale);

      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);

      canvas.drawCircle(Offset(x, y), 6, dotPaint);

      final tpDay = TextPainter(
        text: TextSpan(
            text: data[i]['day'],
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 11,
                fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      )..layout();
      tpDay.paint(canvas, Offset(x - (tpDay.width / 2), size.height + 15));
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
