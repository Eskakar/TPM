import 'package:flutter/material.dart';
import '../../../services/math_service.dart';

class CharacterCounterScreen extends StatefulWidget {
  const CharacterCounterScreen({super.key});

  @override
  State<CharacterCounterScreen> createState() => _CharacterCounterScreenState();
}

class _CharacterCounterScreenState extends State<CharacterCounterScreen> {
  final _controller = TextEditingController();
  Map<String, int>? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// validasi karakter masuk
  void _count() {
    FocusScope.of(context).unfocus();
    final text = _controller.text;

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Teks tidak boleh kosong'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      setState(() => _result = null);
      return;
    }

    try {
      setState(() {
        _result = MathService.countCharacters(text);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    }
  }

  void _clear() {
    _controller.clear();
    setState(() => _result = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6584),
        foregroundColor: Colors.white,
        title: const Text('Penghitung Karakter', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Masukkan Teks',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: 'Ketik atau tempel teks di sini...',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6584),
                          ),
                          onPressed: _count,
                          icon: const Icon(Icons.analytics_outlined),
                          label: const Text('Hitung Karakter'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: _clear,
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (_result != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF6584), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6584).withOpacity(0.08),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Hasil Analisis',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(height: 24),
                    _statTile(
                      'Total Karakter',
                      _result!['total']!,
                      Icons.format_size,
                      const Color(0xFF6C63FF),
                    ),
                    _statTile(
                      'Total Huruf',
                      _result!['letters']!,
                      Icons.abc,
                      const Color(0xFF43B89C),
                    ),
                    _statTile(
                      'Total Angka',
                      _result!['digits']!,
                      Icons.pin,
                      const Color(0xFFFFAA00),
                    ),
                    _statTile(
                      'Total Simbol',
                      _result!['symbols']!,
                      Icons.alternate_email,
                      const Color(0xFFFF6584),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statTile(String label, int value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
