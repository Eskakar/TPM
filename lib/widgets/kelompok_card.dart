import 'package:flutter/material.dart';

class KelompokCard extends StatelessWidget {
  final String nama;
  final String nim;
  final String foto;

  const KelompokCard({
    super.key,
    required this.nama,
    required this.nim,
    required this.foto,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(foto),
            ),

            const SizedBox(height: 10),

            Text(
              "Nama: $nama",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 5),
            
            Text(
              "NIM: $nim",
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}