import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isHidden = true;

  void register() async {

  if (nameController.text.trim().isEmpty ||
      emailController.text.trim().isEmpty ||
      passwordController.text.trim().isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Semua field harus diisi"),
      ),
    );

    return;
  }

  try {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      "name",
      nameController.text.trim(),
    );

    await prefs.setString(
      "email",
      emailController.text.trim(),
    );

    await prefs.setString(
      "password",
      passwordController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Register berhasil"),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {

      Navigator.pop(context);

    });

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $e"),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FF),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        foregroundColor: Colors.deepPurple,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [

              const SizedBox(height: 20),

              // LOGO

              Container(
                width: 110,
                height: 110,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade400,
                      Colors.purple.shade300,
                    ],
                  ),
                ),

                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 55,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                "Create Account ✨",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D28D9),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Start your self-reflection journey",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              // NAME

              TextField(
                controller: nameController,

                decoration: InputDecoration(
                  hintText: "Full Name",

                  prefixIcon: const Icon(
                    Icons.person_outline,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // EMAIL

              TextField(
                controller: emailController,

                decoration: InputDecoration(
                  hintText: "Email",

                  prefixIcon: const Icon(
                    Icons.email_outlined,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // PASSWORD

              TextField(
                controller: passwordController,
                obscureText: isHidden,

                decoration: InputDecoration(
                  hintText: "Password",

                  prefixIcon: const Icon(
                    Icons.lock_outline,
                  ),

                  suffixIcon: IconButton(
                    icon: Icon(
                      isHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),

                    onPressed: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // BUTTON REGISTER

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed: register,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Text(
                    "Already have an account?",
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFF8B5CF6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}