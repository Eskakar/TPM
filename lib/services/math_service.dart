import 'dart:math';

class MathService {

  /// Cek genap atau ganjil
  static bool isEven(int n) => n % 2 == 0;

  /// Cek bilangan prima
  static bool isPrime(int n) {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;
    for (int i = 3; i <= sqrt(n).toInt(); i += 2) {
      if (n % i == 0) return false;
    }
    return true;
  }


  /// cek jumlah karakter, huruf, angka, simbol
  static Map<String, int> countCharacters(String text) {
    int letters = 0;
    int digits = 0;
    int symbols = 0;

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
        letters++;
      } else if (RegExp(r'[0-9]').hasMatch(char)) {
        digits++;
      } else {
        symbols++;
      }
    }

    return {
      'total': text.length,
      'letters': letters,
      'digits': digits,
      'symbols': symbols,
    };
  }


  /// cek volume dan luas permukaan limas
  /// V = 1/3 × alas × tinggi
  static double pyramidVolume(double length, double width, double height) {
    final baseArea = length * width;
    return (1 / 3) * baseArea * height;
  }

  /// L = 2 × (panjang + lebar) × tinggi miring / 2
  static double pyramidSurfaceArea(
    double length,
    double width,
    double slantHeight,
  ) {
    final baseArea = length * width;
    final perimeter = 2 * (length + width);
    final lateralArea = (perimeter * slantHeight) / 2;
    return baseArea + lateralArea;
  }
}
