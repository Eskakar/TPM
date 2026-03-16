import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0; // inisialisasi waktu
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    if (_isRunning) return; 

    setState(() => _isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _elapsedSeconds++);
      }
    });
  }

  /// Stop
  void _stop() {
    if (!_isRunning) return;
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  /// Resets
  void _reset() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _elapsedSeconds = 0;
    });
  }

  /// format waktu hh:mm:ss, kalau lebih dari 24 jam bakal nambah terus 24++
  String _formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${_pad(hours)} : ${_pad(minutes)} : ${_pad(seconds)}';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFAA00),
        foregroundColor: Colors.white,
        title: const Text('Stopwatch', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFAA00).withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('HH', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        SizedBox(width: 8),
                        Text('MM', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        SizedBox(width: 8),
                        Text('SS', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(_elapsedSeconds),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 6,
                      width: _isRunning ? 60 : 6,
                      decoration: BoxDecoration(
                        color: _isRunning ? const Color(0xFFFFAA00) : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _controlButton(
                    label: 'Start',
                    icon: Icons.play_arrow_rounded,
                    color: const Color(0xFF43B89C),
                    onPressed: _isRunning ? null : _start,
                  ),
                  const SizedBox(width: 16),
                  _controlButton(
                    label: 'Stop',
                    icon: Icons.pause_rounded,
                    color: const Color(0xFFFF6584),
                    onPressed: _isRunning ? _stop : null,
                  ),
                  const SizedBox(width: 16),
                  _controlButton(
                    label: 'Reset',
                    icon: Icons.replay_rounded,
                    color: Colors.grey,
                    onPressed: _reset,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controlButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Column(
      children: [
        Material(
          color: onPressed != null ? color.withOpacity(0.15) : Colors.grey.shade100,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Icon(
                icon,
                color: onPressed != null ? color : Colors.grey.shade400,
                size: 30,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: onPressed != null ? color : Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
