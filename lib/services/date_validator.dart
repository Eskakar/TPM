class DateHelper {
  /// VALIDASI + PARSE
  static DateTime? parseValidDate({
    required int tahun,
    required int bulan,
    required int hari,
    required int jam,
    required int menit,
  }) {
    try {
      // validasi range dasar
      if (tahun <= 0 ||
          bulan < 1 || bulan > 12 ||
          hari < 1 || hari > 31 ||
          jam < 0 || jam > 23 ||
          menit < 0 || menit > 59) {
        return null;
      }

      DateTime date = DateTime(tahun, bulan, hari, jam, menit);

      // cegah auto-correction (contoh: 32 Jan jadi 1 Feb)
      if (date.year != tahun ||
          date.month != bulan ||
          date.day != hari) {
        return null;
      }

      // tidak boleh masa depan
      if (date.isAfter(DateTime.now())) return null;

      return date;
    } catch (e) {
      return null;
    }
  }


  /// HITUNG UMUR
  static Map<String, int> hitungUmur(DateTime lahir) {
    DateTime now = DateTime.now();

    int tahun = now.year - lahir.year;
    int bulan = now.month - lahir.month;
    int hari = now.day - lahir.day;
    int jam = now.hour - lahir.hour;
    int menit = now.minute - lahir.minute;

    if (menit < 0) {
      jam--;
      menit += 60;
    }

    if (jam < 0) {
      hari--;
      jam += 24;
    }

    if (hari < 0) {
      bulan--;
      hari += DateTime(now.year, now.month, 0).day;
    }

    if (bulan < 0) {
      tahun--;
      bulan += 12;
    }

    return {
      "tahun": tahun,
      "bulan": bulan,
      "hari": hari,
      "jam": jam,
      "menit": menit,
    };
  }


  /// KONVERSI HIJRIYAH (APPROX)
  static Map<String, int> toHijriyah(DateTime date) {
    int jd = _julianDay(date);

    int l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;

    int j = ((10985 - l) / 5316).floor() *
            ((50 * l) / 17719).floor() +
        (l / 5670).floor() *
            ((43 * l) / 15238).floor();

    l = l -
        ((30 - j) / 15).floor() *
            ((17719 * j) / 50).floor() -
        (j / 16).floor() *
            ((15238 * j) / 43).floor() +
        29;

    int bulan = (24 * l / 709).floor();
    int hari = l - (709 * bulan / 24).floor();
    int tahun = 30 * n + j - 30;

    return {
      "tahun": tahun,
      "bulan": bulan,
      "hari": hari,
    };
  }

  static int _julianDay(DateTime date) {
    int y = date.year;
    int m = date.month;
    int d = date.day;

    if (m <= 2) {
      y -= 1;
      m += 12;
    }

    int a = (y / 100).floor();
    int b = 2 - a + (a / 4).floor();

    return (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        d +
        b -
        1524;
  }

  /// HITUNG WETON 
  static Map<String, String> hitungWeton(DateTime date) {
    List<String> hariMasehi = [
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu"
    ];

    List<String> pasaran = [
      "Legi",
      "Pahing",
      "Pon",
      "Wage",
      "Kliwon"
    ];

    DateTime base = DateTime(1900, 1, 1);
    int selisihHari = date.difference(base).inDays;

    String hari = hariMasehi[date.weekday - 1];

    String pas = pasaran[(selisihHari + 1) % 5 ];

    return {
      "hari": hari,
      "pasaran": pas,
      "weton": "$hari $pas",
    };
  }
}