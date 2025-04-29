import 'dart:async';
import 'package:flutter/material.dart';
import '../models/timer_record.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final TextEditingController _nameController = TextEditingController();
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int remainingSeconds = 0;
  bool isRunning = false;
  Timer? timer;
  List<TimerRecord> timerHistory = [];

  @override
  void dispose() {
    timer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  void startTimer() {
    if (!isRunning) {
      if (remainingSeconds == 0) {
        remainingSeconds = (hours * 3600) + (minutes * 60) + seconds;
      }

      if (remainingSeconds > 0) {
        setState(() {
          isRunning = true;
        });

        final currentTimer = TimerRecord(
          name: _nameController.text.isNotEmpty
              ? _nameController.text
              : 'Timer sin nombre',
          durationInSeconds: remainingSeconds,
        );

        if (!timerHistory.contains(currentTimer)) {
          addToHistory(currentTimer);
        }

        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            if (remainingSeconds > 0) {
              remainingSeconds--;
            } else {
              timer.cancel();
              isRunning = false;
              _showTimerCompleteDialog();
            }
          });
        });
      }
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
      hours = 0;
      minutes = 0;
      seconds = 0;
      remainingSeconds = 0;
      timer?.cancel();
    });
  }

  void addToHistory(TimerRecord record) {
    setState(() {
      timerHistory.insert(0, record);
      if (timerHistory.length > 5) {
        timerHistory.removeLast();
      }
    });
  }

  String formatTime(int totalSeconds) {
    int h = totalSeconds ~/ 3600;
    int m = (totalSeconds % 3600) ~/ 60;
    int s = totalSeconds % 60;

    String hoursStr = h.toString().padLeft(2, '0');
    String minutesStr = m.toString().padLeft(2, '0');
    String secondsStr = s.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  void _showTimerCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Timer Completado!'),
        content: Text(
            'Tu timer "${_nameController.text.isNotEmpty ? _nameController.text : 'Timer sin nombre'}" ha terminado.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isRunning) ...[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Timer',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Configurar Timer:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Horas'),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 50,
                              perspective: 0.005,
                              diameterRatio: 1.2,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  hours = index;
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 24,
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: hours == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(':', style: TextStyle(fontSize: 24)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Minutos'),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 50,
                              perspective: 0.005,
                              diameterRatio: 1.2,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  minutes = index;
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 60,
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: minutes == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(':', style: TextStyle(fontSize: 24)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Segundos'),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 50,
                              perspective: 0.005,
                              diameterRatio: 1.2,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  seconds = index;
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 60,
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: seconds == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              if (isRunning || remainingSeconds > 0) ...[
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      if (_nameController.text.isNotEmpty)
                        Text(
                          _nameController.text,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        formatTime(remainingSeconds),
                        style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: isRunning ? pauseTimer : startTimer,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: Text(isRunning ? 'Pausar' : 'Iniciar'),
                  ),
                  const SizedBox(width: 20),
                  FilledButton.tonal(
                    onPressed: resetTimer,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: const Text('Reiniciar'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Historial de Timers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              timerHistory.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay timers en el historial',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: timerHistory.length,
                      itemBuilder: (context, index) {
                        final timer = timerHistory[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.access_time),
                            ),
                            title: Text(timer.name),
                            subtitle: Text(formatTime(timer.durationInSeconds)),
                            trailing: IconButton(
                              icon: const Icon(Icons.replay),
                              onPressed: () {
                                setState(() {
                                  _nameController.text = timer.name;
                                  remainingSeconds = timer.durationInSeconds;
                                  hours = remainingSeconds ~/ 3600;
                                  minutes = (remainingSeconds % 3600) ~/ 60;
                                  seconds = remainingSeconds % 60;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}