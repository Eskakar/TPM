import 'package:flutter/material.dart';
import '../../../widgets/calculator_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  bool _hasError = false;
  bool _justCalculated = false;

  // Maksimal karakter input 64
  static const int _maxLength = 64;

  static const List<String> _operators = ['+', '-', '×', '÷'];

  /// Cek karakter terakhir
  bool get _endsWithOperator =>
      _display.isNotEmpty && _operators.contains(_display[_display.length - 1]);

  void _onButtonPressed(String value) {
    setState(() {
      _hasError = false;

      switch (value) {
        case 'C':
          _clear();
          break;
        case 'DEL':
          _delete();
          break;
        case '=':
          _calculate();
          break;
        default:
          _appendValue(value);
      }
    });
  }

  String _formatResult(double value) {
    if (value.isInfinite) return 'Error: Infinity';
    if (value.isNaN) return 'Error: NaN';

    if (value.abs() >= 1e15 || (value.abs() < 1e-7 && value != 0)) {
      return value.toStringAsExponential(6);
    }

    // Menghilangkan .0 jika angka bulat
    String res = value.toString();
    if (res.endsWith('.0')) {
      return res.substring(0, res.length - 2);
    }

    // Batasi desimal 
    if (res.contains('.')) {
      List<String> parts = res.split('.');
      if (parts[1].length > 10) {
        return value
            .toStringAsFixed(10)
            .replaceAll(RegExp(r'0+$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }
    }

    return res;
  }

  void _clear() {
    _display = '0';
    _expression = '';
    _justCalculated = false;
  }

  void _delete() {
    if (_justCalculated) {
      _clear();
      return;
    }
    if (_display.length <= 1) {
      _display = '0';
    } else {
      _display = _display.substring(0, _display.length - 1);
    }
  }

  /// tambah angka
  void _appendValue(String value) {
    final bool isOperator = _operators.contains(value);

    // refersh tamppilan kalkulator
    if (_justCalculated) {
      if (!isOperator) {
        _display = value;
        _expression = '';
        _justCalculated = false;
        return;
      }
      // jika masih berupa angka, bisa lanjut perhitungan
      _justCalculated = false;
    }

    // handle double opeator
    if (isOperator && _endsWithOperator) {
      _display = _display.substring(0, _display.length - 1) + value;
      return;
    }

    // pengecualian minus di depan
    if (isOperator && _display == '0') {
      if (value == '-') {
        _display = '-';
      }
      return;
    }

    // handle desimal
    if (value == '.') {
      final parts = _display.split(RegExp(r'[\+\-\×\÷]'));
      if (parts.isNotEmpty && parts.last.contains('.')) {
        return;
      }
    }

    if (_display.length >= _maxLength) return;

    // handle 0 value didepan
    if (_display == '0' && value != '.') {
      _display = value;
    } else {
      _display += value;
    }
  }

  /// handle perhitungan akhir
  void _calculate() {
    if (_display.isEmpty || _display == '0' || _hasError) return;
    if (_endsWithOperator) {
      _showError('Ekspresi tidak lengkap');
      return;
    }

    try {
      String finalExpression = _display;
      double result = _evaluate(finalExpression);

      setState(() {
        _expression = '$finalExpression =';
        _display = _formatResult(result);
        _justCalculated = true;
      });
    } catch (e) {
      _showError('Error: Perhitungan invalid');
    }
  }

  double _evaluate(String expression) {
    // tokenisasi karakter
    final tokens = <String>[];
    String current = '';

    for (int i = 0; i < expression.length; i++) {
      final char = expression[i];
      // handle value negatif
      if (char == '-' &&
          (current.isEmpty &&
              (tokens.isEmpty || _operators.contains(tokens.last)))) {
        current += char;
      } else if (_operators.contains(char)) {
        if (current.isNotEmpty) tokens.add(current);
        tokens.add(char);
        current = '';
      } else {
        current += char;
      }
    }
    if (current.isNotEmpty) tokens.add(current);

    if (tokens.isEmpty) throw Exception('Empty expression');

    final List<double> nums = [];
    final List<String> ops = [];

    for (final token in tokens) {
      if (_operators.contains(token)) {
        ops.add(token);
      } else {
        final n = double.tryParse(token);
        if (n == null) throw Exception('Nomor Invalid: $token');
        nums.add(n);
      }
    }

    if (nums.length != ops.length + 1) throw Exception('Ekspresi tidak valid');

    // perkalian dan pembagian dulu
    int i = 0;
    while (i < ops.length) {
      if (ops[i] == '×' || ops[i] == '÷') {
        final result =
            ops[i] == '×' ? nums[i] * nums[i + 1] : nums[i] / nums[i + 1];
        nums[i] = result;
        nums.removeAt(i + 1);
        ops.removeAt(i);
      } else {
        i++;
      }
    }

    // baru penjumlahan dan pengurangan
    double result = nums[0];
    for (int j = 0; j < ops.length; j++) {
      if (ops[j] == '+') {
        result += nums[j + 1];
      } else if (ops[j] == '-') {
        result -= nums[j + 1];
      }
    }

    return result;
  }

  void _showError(String message) {
    _display = message;
    _expression = '';
    _hasError = true;
    _justCalculated = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        title: const Text('Kalkulator',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              color: const Color(0xFF2D2D2D),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_expression.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse:
                          true, 
                      child: Text(
                        _expression,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _display,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                        color: _hasError ? Colors.redAccent : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: CalculatorButton(
                            label: 'C',
                            backgroundColor: const Color(0xFFFF6584),
                            textColor: Colors.white,
                            onPressed: () => _onButtonPressed('C'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CalculatorButton(
                            label: 'DEL',
                            backgroundColor: const Color(0xFFFFAA00),
                            textColor: Colors.white,
                            fontSize: 16,
                            onPressed: () => _onButtonPressed('DEL'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Rows: 7 8 9 /
                  _buildButtonRow(['7', '8', '9', '÷'],
                      operatorColor: const Color(0xFF6C63FF)),
                  const SizedBox(height: 10),
                  // Rows: 4 5 6 *
                  _buildButtonRow(['4', '5', '6', '×'],
                      operatorColor: const Color(0xFF6C63FF)),
                  const SizedBox(height: 10),
                  // Rows: 1 2 3 -
                  _buildButtonRow(['1', '2', '3', '-'],
                      operatorColor: const Color(0xFF6C63FF)),
                  const SizedBox(height: 10),
                  // Rows: 0 . = +
                  _buildButtonRow(
                    ['0', '.', '=', '+'],
                    operatorColor: const Color(0xFF6C63FF),
                    equalsColor: const Color(0xFF43B89C),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// row opeator
  Widget _buildButtonRow(
    List<String> labels, {
    Color? operatorColor,
    Color? equalsColor,
  }) {
    return Expanded(
      child: Row(
        children: labels.asMap().entries.map((entry) {
          final label = entry.value;
          final isOperator = _operators.contains(label);
          final isEquals = label == '=';

          Color? bg;
          Color? fg;
          if (isEquals) {
            bg = equalsColor ?? const Color(0xFF43B89C);
            fg = Colors.white;
          } else if (isOperator) {
            bg = operatorColor?.withOpacity(0.15);
            fg = operatorColor;
          }

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CalculatorButton(
                    label: label,
                    backgroundColor: bg,
                    textColor: fg,
                    onPressed: () => _onButtonPressed(label),
                  ),
                ),
                if (entry.key < labels.length - 1) const SizedBox(width: 10),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
