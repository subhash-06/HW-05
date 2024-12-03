import 'package:flutter/material.dart';
import '../services/database.service.dart';
import '../services/api.service.dart';
import 'quiz_screen.dart';

class QuizSetupScreen extends StatefulWidget {
  const QuizSetupScreen({super.key});

  @override
  _QuizSetupScreenState createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  final TextEditingController nameController = TextEditingController();
  int questionCount = 5;
  String selectedCategory = 'Sports';
  String selectedDifficulty = 'easy';
  String selectedType = 'multiple';

  static const Map<String, int> categoryOptions = {
    'Sports': 21,
    'Geography': 22,
    'History': 23,
    'Computers': 18,
    'General Knowledge': 9,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Setup')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Configure Your Quiz',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categoryOptions.keys
                      .map((cat) => DropdownMenuItem(
                          value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => selectedCategory = value!),
                ),
                DropdownButtonFormField<int>(
                  value: questionCount,
                  decoration:
                      const InputDecoration(labelText: 'Number of Questions'),
                  items: [5, 10, 15]
                      .map((val) => DropdownMenuItem(value: val, child: Text('$val')))
                      .toList(),
                  onChanged: (value) => setState(() => questionCount = value!),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Enter Your Name'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty) {
                        return;
                      }
                      await DatabaseService.addUser(
                          nameController.text, selectedCategory);
                      final questions = await APIService.fetchQuestions(
                          questionCount,
                          categoryOptions[selectedCategory].toString(),
                          selectedDifficulty,
                          selectedType);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(
                            questions: questions,
                            userName: nameController.text,
                            category: selectedCategory,
                          ),
                        ),
                      );
                    },
                    child: const Text('Start Quiz'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
