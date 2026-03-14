
class AuthService {
  // Data username & password
  static const String _validUsername = 'KingNabil';
  static const String _validPassword = 'nabiltampan123';


  static String? login(String username, String password) {
    final trimmedUsername = username.trim();
    final trimmedPassword = password.trim();

    // Error handling field kosong
    if (trimmedUsername.isEmpty || trimmedPassword.isEmpty) {
      return 'Username dan password tidak boleh kosong';
    }

    // Field harus sama
    if (trimmedUsername != _validUsername || trimmedPassword != _validPassword) {
      return 'Login gagal. Username atau password salah';
    }

    return null; 
  }
}
