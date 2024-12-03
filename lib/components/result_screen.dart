import 'package:flutter/material.dart';
import 'leaderboard_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    String feedbackMessage;
    if (score == total) {
      feedbackMessage = 'Perfect Score! 🎉';
    } else if (score > total * 0.7) {
      feedbackMessage = 'Great Job! 😊';
    } else if (score > total * 0.4) {
      feedbackMessage = 'Good Effort! 👍';
    } else {
      feedbackMessage = 'Keep Practicing! 💪';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              feedbackMessage,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Your Score: $score / $total',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
                  (route) => false,
                );
              },
              child: const Text('View Leaderboard'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
