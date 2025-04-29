import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pulsetime/models/lap_record.dart';

class ChronometerScreen extends StatefulWidget {
  const ChronometerScreen({Key? key}) : super(key: key);

  @override
  State<ChronometerScreen> createState() => _ChronometerScreenState();
}

class _ChronometerScreenState extends State<ChronometerScreen> {
  bool isRunning = false;
  int milliseconds = 0;
  Timer? timer;
  List<LapRecord> laps = [];

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (!isRunning) {
      setState(() {
        isRunning = true;
      });
      timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          milliseconds += 10;
        });
      });
    }
  }

  void pauseTimer() {
    if (isRunning) {
      setState(() {
        isRunning = false;
        timer?.cancel();
      });
    }
  }

  void resetTimer() {
    setState(() {
      isRunning = false;
      milliseconds = 0;
      laps.clear();
      timer?.cancel();
    });
  }

  void recordLap() {
    if (isRunning) {
      setState(() {
        laps.add(
          LapRecord(
            lapNumber: laps.length + 1,
            timeInMilliseconds: milliseconds,
          ),
        );
        milliseconds = 0;
      });
    }
  }

  String formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).floor() % 100;
    int seconds = (milliseconds / 1000).floor() % 60;
    int minutes = (milliseconds / 60000).floor() % 60;
    int hours = (milliseconds / 3600000).floor();

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    String hundredsStr = hundreds.toString().padLeft(2, '0');

    if (hours > 0) {
      return "$hoursStr:$minutesStr:$secondsStr.$hundredsStr";
    } else {
      return "$minutesStr:$secondsStr.$hundredsStr";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cronómetro'), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Text(
              formatTime(milliseconds),
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: isRunning ? pauseTimer : startTimer,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                child: Text(isRunning ? 'Pausar' : 'Iniciar'),
              ),
              const SizedBox(width: 20),
              OutlinedButton(
                onPressed: recordLap,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                child: const Text('Vuelta'),
              ),
              const SizedBox(width: 20),
              FilledButton.tonal(
                onPressed: resetTimer,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                child: const Text('Reiniciar'),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Expanded(
            child:
                laps.isEmpty
                    ? const Center(
                      child: Text(
                        'No hay vueltas registradas',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: laps.length,
                      itemBuilder: (context, index) {
                        final reversedIndex = laps.length - 1 - index;
                        final lap = laps[reversedIndex];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text('${lap.lapNumber}'),
                          ),
                          title: Text('Vuelta ${lap.lapNumber}'),
                          trailing: Text(
                            formatTime(lap.timeInMilliseconds),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
