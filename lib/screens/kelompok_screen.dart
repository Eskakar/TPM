import 'package:flutter/material.dart';
import 'package:tpm_tugas2/widgets/kelompok_card.dart';

class DataKelompok extends StatelessWidget {
  const DataKelompok({super.key});

  static const List<Map<String, dynamic>> _menuItems = [
    {
      "nama": "Rifqi Rahardian",
      "nim": "123230119",
      "foto": "assets/images/kaka.jpeg",
    },
    {
      "nama": "Nabil Aqila Putra",
      "nim": "123230085",
      "foto": "assets/images/kaka.jpeg",
    },
    {
      "nama": "Verrel Pratama Aji",
      "nim": "123230069",
      "foto": "assets/images/kaka.jpeg",
    },
    {
      "nama": "Andhika Herindra Septiawan",
      "nim": "123230117",
      "foto": "assets/images/kaka.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Data Kelompok',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Center(
              child:  Text(
                'Anggota Kelompok Kami',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
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
                  return KelompokCard(
                    nama: item['nama'] as String,
                    nim: item['nim'] as String,
                    foto: item['foto'] as String,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}