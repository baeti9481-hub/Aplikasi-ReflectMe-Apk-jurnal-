import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget decorativeStar(double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: Icon(
        Icons.star,
        color: Colors.deepPurple.shade100,
        size: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FF),

      body: Stack(
        children: [

          // Decorative stars
          decorativeStar(120, 60),
          decorativeStar(200, 300),
          decorativeStar(500, 80),
          decorativeStar(650, 250),

          // Top blob
          Positioned(
            top: -60,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Bottom wave 1
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFE9D5FF),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(120),
                  topRight: Radius.circular(120),
                ),
              ),
            ),
          ),

          // Bottom wave 2
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                color: const Color(0xFFD8B4FE),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
              ),
            ),
          ),

          // Content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Logo circle
                  Container(
                    width: 140,
                    height: 140,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade400,
                          Colors.purple.shade300,
                        ],
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.spa_rounded,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // App name
                  const Text(
                    "ReflectMe",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D28D9),
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Tagline
                  Text(
                    "Journaling. Reflecting. Growing.",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.deepPurple.shade300,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Loading dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dot(false),
                      dot(true),
                      dot(false),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    "Memuat...",
                    style: TextStyle(
                      color: Colors.deepPurple.shade300,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 12 : 10,
      height: active ? 12 : 10,
      decoration: BoxDecoration(
        color: active
            ? Colors.deepPurple
            : Colors.deepPurple.shade100,
        shape: BoxShape.circle,
      ),
    );
  }
}