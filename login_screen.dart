import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _handleLogin(BuildContext context) async {
    // Mocking Google Sign-In for demonstration
    // In production, use the google_sign_in package to get the real idToken
    bool success = await ApiService.loginWithGoogle('mock_id_token', 'device_123', 'fingerprint_123');
    
    if (success && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('ZyngoPlay', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 10),
            const Text('Multiplayer Gaming Platform', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 60),
            ElevatedButton.icon(
              onPressed: () => _handleLogin(context),
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
