import 'package:flutter/material.dart';
import 'package:tpm_tugas2/services/date_validator.dart';

class DateConverter extends StatefulWidget {
  const DateConverter({super.key});

  @override
  State<DateConverter> createState() => _DateConverterState();
}

class _DateConverterState extends State<DateConverter> {
  DateTime? selectedDateTime;

  String hasil = "";

  @override
  void dispose() {
    super.dispose();
  }

  
  Future<void> pickDateTime(BuildContext context) async {
    DateTime now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;
    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }


  void proses() {
    if(selectedDateTime == null){
      _showSnackBar("Pilih tanggal terlebih dahulu");
      return;
    }
    var date = DateHelper.parseValidDate(
      tahun: selectedDateTime!.year,
      bulan: selectedDateTime!.month,
      hari: selectedDateTime!.day,
      jam: selectedDateTime!.hour,
      menit: selectedDateTime!.minute,
    );
    if (date == null) {
      setState(() {
        hasil = "";
      });
      _showSnackBar("Input tidak valid");
      return;
    }

    var umur = DateHelper.hitungUmur(date);
    var hijri = DateHelper.toHijriyah(date);
    var weton = DateHelper.hitungWeton(date);

    setState(() {
      hasil = """
      Umur: ${umur['tahun']} tahun ${umur['bulan']} bulan
      Hijriyah: ${hijri['hari']}/${hijri['bulan']}/${hijri['tahun']}
      Weton: ${weton['weton']}
      """;
    });
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
        backgroundColor: const Color.fromARGB(255, 255, 165, 241),
        foregroundColor: Colors.white,
        title: const Text('Date Converter', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                  GestureDetector(
                    onTap: () => pickDateTime(context),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDateTime == null
                                ? "Pilih Tanggal & Jam"
                                : "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year} "
                                  "${selectedDateTime!.hour}:${selectedDateTime!.minute}",
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),

  
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: proses,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("PROSES"),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                    ),
                    child: Text(
                      hasil,
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}