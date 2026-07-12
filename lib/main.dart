import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController answerController = TextEditingController();
  late Timer _timer;
  int score = 0;
  int timeLeft = 60;
  int numbr1 = 0;
  int numbr2 = 0;
  int correctAnswer = 0;

  @override
  void initState() {
    super.initState();
    generateNewQuestion();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          _timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Time is up! Final Score: $score')),
          );

          // 🔁 Restart automatically after 2 seconds
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              score = 0;
              timeLeft = 60;
              generateNewQuestion();
            });
            startTimer(); // restart timer cleanly
          });
        }
      });
    });
  }

  void generateNewQuestion() {
    Random random = Random();
    numbr1 = random.nextInt(100);
    numbr2 = random.nextInt(100);
    correctAnswer = numbr1 + numbr2;
  }

  @override
  void dispose() {
    _timer.cancel();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GAMING QUIZ'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Time Left: $timeLeft seconds',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Score: $score',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'What is the sum of?',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '$numbr1 + $numbr2 = ?',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                height: 50,
                width: 400,
                child: TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    labelText: 'Enter your answer',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  int? userAnswer = int.tryParse(answerController.text);
                  if (userAnswer == correctAnswer) {
                    setState(() {
                      score += 10;
                      generateNewQuestion();
                      answerController.clear();
                    });
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Correct! 🎉')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Wrong! Try again.')),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
