import 'package:flutter/material.dart';
import '../services/socket_service.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SocketService.connect();
    
    SocketService.socket?.on('match_found', (data) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Match found! Room: ${data['roomId']}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
        // TODO: Navigate to GameScreen
      }
    });
  }

  @override
  void dispose() {
    SocketService.disconnect();
    super.dispose();
  }

  void _logout() async {
    await ApiService.logout();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZyngoPlay Lobby'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet), 
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wallet coming soon')));
            }
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildGameCard('Ludo', Icons.casino, Colors.red),
          _buildGameCard('Rummy', Icons.style, Colors.green),
          _buildGameCard('Chess', Icons.grid_on, Colors.black87),
          _buildGameCard('Carrom', Icons.radio_button_checked, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildGameCard(String title, IconData icon, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joining $title queue...')));
          SocketService.joinMatchmaking(title.toLowerCase());
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
