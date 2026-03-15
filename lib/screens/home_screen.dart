import 'package:flutter/material.dart';
import 'package:tpm_tugas2/screens/kelompok_screen.dart';
import '../../../widgets/menu_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Kalkulator',
      'icon': Icons.calculate_rounded,
      'color': Color(0xFF6C63FF),
      'route': '/calculator',
    },
    {
      'title': 'Pengecekan\nAngka',
      'icon': Icons.tag,
      'color': Color(0xFF43B89C),
      'route': '/number-checker',
    },
    {
      'title': 'Penghitung\nKarakter',
      'icon': Icons.text_fields_rounded,
      'color': Color(0xFFFF6584),
      'route': '/character-counter',
    },
    {
      'title': 'Stopwatch',
      'icon': Icons.timer_outlined,
      'color': Color(0xFFFFAA00),
      'route': '/stopwatch',
    },
    {
      'title': 'Kalkulator\nPiramida',
      'icon': Icons.change_history_rounded,
      'color': Color(0xFF3D9EF5),
      'route': '/pyramid',
    },
  ];

  /// Logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // close dialog
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  //About Us
  void _AboutUs(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=> const DataKelompok()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tugas 2 TPM',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Pilih Fitur',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Ketuk kartu untuk membuka fitur',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: _menuItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return MenuCard(
                    title: item['title'] as String,
                    icon: item['icon'] as IconData,
                    color: item['color'] as Color,
                    onTap: () => Navigator.pushNamed(context, item['route'] as String),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:  FloatingActionButton.extended(
        onPressed: (){_AboutUs(context);},
        label: const Text("About Us"),
        icon: const Icon(Icons.account_circle_sharp), 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, 
    );
  }
}
