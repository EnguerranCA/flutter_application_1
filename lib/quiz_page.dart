  import 'package:flutter/material.dart';
  import 'models.dart';
  import 'question_text.dart';
  import 'progression.dart';

  class QuizPage extends StatefulWidget {
    const QuizPage({super.key});

    @override
    State<QuizPage> createState() => _QuizPageState();
  }

  class _QuizPageState extends State<QuizPage> {
    int currentQuestion = 0;
    int score = 0;
    Answer? selectedAnswer;

    final List<Question> questions = [
      Question(
        question: 'Qui a écrit Frigiel et Fluffy ?',
        answers: [
          Answer(text: 'Frigiel', isCorrect: true),
          Answer(text: 'Fluffy', isCorrect: false),
          Answer(text: 'JK Rowling', isCorrect: false),
        ],
      ),
      Question(
        question:
            'Quel youtubeur a le même nom qu\'un langage de programmation ?',
        answers: [
          Answer(text: 'Siphano', isCorrect: false),
          Answer(text: 'Dart', isCorrect: true),
          Answer(text: 'Aurélien Sama', isCorrect: false),
        ],
      ),
    ];

    void answerQuestion(bool isCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isCorrect ? 'Bonne réponse !' : 'Mauvaise réponse...'),
          duration: const Duration(seconds: 1),
        ),
      );
      
      setState(() {
        if (isCorrect) score++;
        currentQuestion++;
        selectedAnswer = null; // Réinitialiser la sélection
      });
    }

    void selectAnswer(Answer answer) {
      setState(() {
        selectedAnswer = answer;
      });
    }

    @override
    Widget build(BuildContext context) {
      if (currentQuestion >= questions.length) {
        return Scaffold(
          appBar: AppBar(title: const Text('Résultat')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ton score : $score / ${questions.length}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentQuestion = 0;
                      score = 0;
                    });
                  },
                  child: const Text('Rejouer'),
                ),
              ],
            ),
          ),
        );
      }

      final question = questions[currentQuestion];

      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Flutter'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProgressionBar(
                current: currentQuestion.toDouble(),
                total: questions.length.toDouble(),
              ),
              QuestionText(questionText: question.question),
              const SizedBox(height: 30),
              // On génère les boutons de réponse directement ici
              ...question.answers.map((answer) {
                final isSelected = selectedAnswer == answer;
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.red[900] : Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isSelected ? 20 : 16,
                        horizontal: 16,
                      ),
                    ),
                    onPressed: () => selectAnswer(answer),
                    child: Text(
                      answer.text,
                      style: TextStyle(
                        fontSize: isSelected ? 18 : 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
              // Bouton "Valider"
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectedAnswer == null
                    ? null
                    : () {
                        answerQuestion(selectedAnswer!.isCorrect);
                      },
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      );
    }
  }
