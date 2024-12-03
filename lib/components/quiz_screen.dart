import 'package:flutter/material.dart';
import '../helpers/countdown_timer.dart';
import 'result_screen.dart';
import '../helpers/progress_indicator.dart';
import '../services/database.service.dart';

class QuizScreen extends StatefulWidget {
  final List<dynamic> quizQuestions;
  final String playerName;
  final String quizCategory;

  const QuizScreen({
    super.key,
    required this.quizQuestions,
    required this.playerName,
    required this.quizCategory,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int totalScore = 0;
  String resultMessage = '';

  final GlobalKey<CountdownTimerState> timerKey =
      GlobalKey<CountdownTimerState>();

  Future<void> saveScoreAndNavigate() async {
    await DatabaseService.updateScore(
        widget.playerName, widget.quizCategory, totalScore);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: totalScore,
          total: widget.quizQuestions.length,
        ),
      ),
    );
  }

  void evaluateAnswer(String userAnswer) {
    timerKey.currentState?.stopTimer();
    final correctAnswer =
        widget.quizQuestions[currentQuestionIndex]['correct_answer'];

    setState(() {
      if (userAnswer == correctAnswer) {
        resultMessage = 'Correct!';
        totalScore++;
      } else if (userAnswer == 'NOT_SELECTED') {
        resultMessage = 'Time Up! Correct Answer: $correctAnswer';
      } else {
        resultMessage = 'Incorrect! Correct Answer: $correctAnswer';
      }

      Future.delayed(const Duration(seconds: 2), () {
        if (currentQuestionIndex < widget.quizQuestions.length - 1) {
          setState(() {
            currentQuestionIndex++;
            resultMessage = '';
          });
          timerKey.currentState?.resetTimer();
          timerKey.currentState?.startTimer();
        } else {
          saveScoreAndNavigate();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final questionData = widget.quizQuestions[currentQuestionIndex];
    final List<String> answers =
        List.from(questionData['incorrect_answers'])..add(questionData['correct_answer']);
    answers.shuffle();

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProgressIndicatorWidget(
              currentQuestion: currentQuestionIndex,
              totalQuestions: widget.quizQuestions.length,
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  questionData['question'],
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (resultMessage.isNotEmpty)
              Text(
                resultMessage,
                style: TextStyle(
                    fontSize: 18,
                    color: resultMessage == 'Correct!'
                        ? Colors.green
                        : Colors.red),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            ...answers.map((option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ElevatedButton(
                    onPressed: () => evaluateAnswer(option),
                    child: Text(option, textAlign: TextAlign.center),
                  ),
                )),
            CountdownTimer(
              key: timerKey,
              initialSeconds: 30,
              onTimerComplete: () => evaluateAnswer('NOT_SELECTED'),
            ),
          ],
        ),
      ),
    );
  }
}
