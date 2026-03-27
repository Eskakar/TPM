import 'package:flutter/material.dart';
import '../../../services/math_service.dart';

class NumberCheckerScreen extends StatefulWidget {
  const NumberCheckerScreen({super.key});

  @override
  State<NumberCheckerScreen> createState() => _NumberCheckerScreenState();
}

class _NumberCheckerScreenState extends State<NumberCheckerScreen> {
  final _controller = TextEditingController();
  Map<String, String>? _result; 

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// validasi input
  void _check() {
    FocusScope.of(context).unfocus();
    final input = _controller.text.trim();

    // validasi input kosong
    if (input.isEmpty) {
      _showSnackBar('Input tidak boleh kosong');
      setState(() => _result = null);
      return;
    }

    // validasi angka
    final n = int.tryParse(input);
    if (n == null) {
      _showSnackBar('Silakan masukkan bilangan bulat yang valid');
      setState(() => _result = null);
      return;
    }

    // Validasi bilangan negatif
    if (n < 0) {
      _showSnackBar('Masukkan bilangan non-negatif');
      setState(() => _result = null);
      return;
    }

    try {
      setState(() {
        _result = {
          'angka': n.toString(),
          'jenis': MathService.isEven(n) ? 'Genap' : 'Ganjil',
          'status': MathService.isPrime(n) ? 'Bilangan Prima ✓' : 'Bukan Bilangan Prima',
        };
      });
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: ${e.toString()}');
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF43B89C),
        foregroundColor: Colors.white,
        title: const Text('Pengecekan Angka', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Masukkan Angka',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _check(),
                    decoration: const InputDecoration(
                      hintText: 'Contoh: 11',
                      prefixIcon: Icon(Icons.tag),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF43B89C),
                      ),
                      onPressed: _check,
                      icon: const Icon(Icons.search),
                      label: const Text('Cek Bilangan'),
                    ),
                  ),
                ],
              ),
            ),

            // Result card
            if (_result != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF43B89C), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF43B89C).withOpacity(0.1), blurRadius: 10),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Hasil Analisis',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(height: 24),
                    _resultRow('Angka', _result!['angka']!),
                    const SizedBox(height: 10),
                    _resultRow('Jenis', _result!['jenis']!),
                    const SizedBox(height: 10),
                    _resultRow('Status', _result!['status']!),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ],
    );
  }
}
