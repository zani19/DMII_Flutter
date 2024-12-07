import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor de Temperatura',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Monitor de Temperatura'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double? currentTemperature;
  bool isLedOn = false;
  Timer? timer;
  Timer? countdownTimer;
  int cycleCount = 0;
  int countdown = 30;

  @override
  void initState() {
    super.initState();
    startCountdown();
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchTemperature();
      startCountdown();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }

  void startCountdown() {
    countdown = 30;
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> fetchTemperature() async {
    try {
      cycleCount++;
      double temperature;

      // Garantir que uma temperatura maior que 45 seja gerada após 3 ciclos
      if (cycleCount >= 3) {
        temperature = 46.0;
        cycleCount = 0;
      } else {
        temperature = Random().nextDouble() * 50;
      }

      setState(() {
        currentTemperature = temperature;
        isLedOn = currentTemperature! > 45;
      });
    } catch (e) {
      print('Erro ao buscar temperatura: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Temperatura Atual:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              currentTemperature != null
                  ? '${currentTemperature!.toStringAsFixed(1)} °C'
                  : 'Carregando...',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Icon(
              Icons.lightbulb,
              color: isLedOn ? Colors.yellow : Colors.grey,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              'Próxima atualização em: $countdown segundos',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchTemperature();
                startCountdown();
              },
              child: const Text('Atualizar Agora'),
            ),
          ],
        ),
      ),
    );
  }
}