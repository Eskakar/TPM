import 'package:flutter/material.dart';
import '../../../services/math_service.dart';

class PyramidScreen extends StatefulWidget {
  const PyramidScreen({super.key});

  @override
  State<PyramidScreen> createState() => _PyramidScreenState();
}

class _PyramidScreenState extends State<PyramidScreen> {
  final _lengthCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _slantCtrl = TextEditingController();

  double? _volume;
  double? _surfaceArea;

  @override
  void dispose() {
    _lengthCtrl.dispose();
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    _slantCtrl.dispose();
    super.dispose();
  }

  /// validasi input dan hitung hasil
  void _calculate() {
    FocusScope.of(context).unfocus();

    if (_lengthCtrl.text.trim().isEmpty ||
        _widthCtrl.text.trim().isEmpty ||
        _heightCtrl.text.trim().isEmpty ||
        _slantCtrl.text.trim().isEmpty) {
      _showError('Semua field wajib diisi');
      return;
    }

    final length = double.tryParse(_lengthCtrl.text.trim());
    final width = double.tryParse(_widthCtrl.text.trim());
    final height = double.tryParse(_heightCtrl.text.trim());
    final slant = double.tryParse(_slantCtrl.text.trim());

    if (length == null || width == null || height == null || slant == null) {
      _showError('Silakan masukkan angka yang valid');
      return;
    }

    // validasi angka < 0
    if (length <= 0 || width <= 0 || height <= 0 || slant <= 0) {
      _showError('Nilai harus lebih besar dari nol');
      return;
    }

    try {
      setState(() {
        _volume = MathService.pyramidVolume(length, width, height);
        _surfaceArea = MathService.pyramidSurfaceArea(length, width, slant);
      });
    } catch (e) {
      _showError('Terjadi kesalahan perhitungan: ${e.toString()}');
    }
  }

  void _reset() {
    _lengthCtrl.clear();
    _widthCtrl.clear();
    _heightCtrl.clear();
    _slantCtrl.clear();
    setState(() {
      _volume = null;
      _surfaceArea = null;
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    setState(() {
      _volume = null;
      _surfaceArea = null;
    });
  }

  /// format 4 angka dibelakang koma`
  String _fmt(double v) {
    final s = v.toStringAsFixed(4);
    return double.parse(s).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D9EF5),
        foregroundColor: Colors.white,
        title: const Text('Kalkulator Piramida', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pyramid illustration
            Center(
              child: Icon(
                Icons.change_history_rounded,
                size: 64,
                color: const Color(0xFF3D9EF5).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Masukkan dimensi piramida',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 20),

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
                children: [
                  _inputField(
                    controller: _lengthCtrl,
                    label: 'Panjang Alas',
                    hint: 'cm',
                    icon: Icons.straighten,
                  ),
                  const SizedBox(height: 14),
                  _inputField(
                    controller: _widthCtrl,
                    label: 'Lebar Alas',
                    hint: 'cm',
                    icon: Icons.straighten,
                  ),
                  const SizedBox(height: 14),
                  _inputField(
                    controller: _heightCtrl,
                    label: 'Tinggi Piramida',
                    hint: 'cm',
                    icon: Icons.height,
                  ),
                  const SizedBox(height: 14),
                  _inputField(
                    controller: _slantCtrl,
                    label: 'Tinggi Sisi (Slant Height)',
                    hint: 'cm',
                    icon: Icons.linear_scale,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3D9EF5),
                          ),
                          onPressed: _calculate,
                          icon: const Icon(Icons.calculate_outlined),
                          label: const Text('Hitung'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: _reset,
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Result card
            if (_volume != null && _surfaceArea != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF3D9EF5), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3D9EF5).withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Hasil Perhitungan',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(height: 24),
                    const Text(
                      'V = ⅓ × panjang × lebar × tinggi',
                      style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 12),
                    _resultCard(
                      label: 'Volume',
                      value: '${_fmt(_volume!)} cm³',
                      color: const Color(0xFF3D9EF5),
                      icon: Icons.view_in_ar,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'L = luas alas + (½ × keliling × tinggi sisi)',
                      style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 12),
                    _resultCard(
                      label: 'Luas Permukaan',
                      value: '${_fmt(_surfaceArea!)} cm²',
                      color: const Color(0xFF6C63FF),
                      icon: Icons.grid_on,
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

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _resultCard({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
