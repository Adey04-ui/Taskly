import 'package:flutter/material.dart';
import 'package:taskly/screens/main_screen.dart';
import 'package:taskly/utils/page_transitions.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;

  Future<void> _handleGetStarted() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return; // safety check — see explanation below

    Navigator.pushReplacement(context, slideRoute(const MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    final titleColor = isDarkMode ? Colors.white : const Color(0xFF0D1224);
    final subtitleColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/hero.png',
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 45),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Get things done \none task at a time',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Taskly helps you stay organized, focus on what matters and achieve your goals.',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: subtitleColor,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 150),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3134DE),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Get Started',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      if (_isLoading) ...[
                        const SizedBox(width: 4),
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}