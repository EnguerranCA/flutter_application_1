  import 'package:flutter/material.dart';
  import 'models.dart';
  import 'question_text.dart';
  import 'progression.dart';

  // Couleurs pastel
  const Color kBackgroundColor = Color(0xFFE8F4F8); // Bleu très clair
  const Color kCardColor = Color(0xFFF0F8FF); // Blanc bleuté
  const Color kPrimaryColor = Color(0xFFB8D4E8); // Bleu pastel
  const Color kSelectedColor = Color(0xFF9DBFD9); // Bleu pastel plus foncé
  const Color kShadowLight = Color(0xFFFFFFFF); // Blanc pour highlight
  const Color kShadowDark = Color(0xFFCBDDE9); // Gris-bleu pour ombre

  class QuizPage extends StatefulWidget {
    const QuizPage({super.key});

    @override
    State<QuizPage> createState() => _QuizPageState();
  }

  class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
    int currentQuestion = 0;
    int score = 0;
    Answer? selectedAnswer;
    late AnimationController _animationController;
    late Animation<double> _fadeAnimation;
    late Animation<Offset> _slideAnimation;

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

    @override
    void initState() {
      super.initState();
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
      );
      _slideAnimation = Tween<Offset>(
        begin: const Offset(0.3, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
      );
      _animationController.forward();
    }

    @override
    void dispose() {
      _animationController.dispose();
      super.dispose();
    }

    void answerQuestion(bool isCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isCorrect ? 'Bonne réponse !' : 'Mauvaise réponse...'),
          duration: const Duration(seconds: 1),
          backgroundColor: isCorrect ? const Color.fromARGB(255, 70, 214, 92) : const Color.fromARGB(255, 212, 72, 86),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
      
      setState(() {
        if (isCorrect) score++;
        currentQuestion++;
        selectedAnswer = null;
        _animationController.reset();
        _animationController.forward();
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
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            title: const Text('Résultat'),
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: kShadowLight,
                    offset: const Offset(-8, -8),
                    blurRadius: 15,
                  ),
                  BoxShadow(
                    color: kShadowDark,
                    offset: const Offset(8, 8),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ton score :',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$score / ${questions.length}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7BA8C4),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildNeomorphicButton(
                    text: 'Rejouer',
                    onPressed: () {
                      setState(() {
                        currentQuestion = 0;
                        score = 0;
                        selectedAnswer = null;
                        _animationController.reset();
                        _animationController.forward();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }

      final question = questions[currentQuestion];

      return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          title: const Text('Quiz Flutter'),
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
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
                  // On génère les boutons de réponse avec effet neomorphisme
                  ...question.answers.map((answer) {
                    final isSelected = selectedAnswer == answer;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: _buildNeomorphicAnswerButton(
                        answer: answer,
                        isSelected: isSelected,
                        onPressed: () => selectAnswer(answer),
                      ),
                    );
                  }),
                  // Bouton "Valider"
                  const SizedBox(height: 20),
                  _buildNeomorphicButton(
                    text: 'Valider',
                    onPressed: selectedAnswer == null
                        ? null
                        : () {
                            answerQuestion(selectedAnswer!.isCorrect);
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Widget bouton neomorphisme pour les réponses
    Widget _buildNeomorphicAnswerButton({
      required Answer answer,
      required bool isSelected,
      required VoidCallback onPressed,
    }) {
      return GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: isSelected ? 20 : 16,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: isSelected ? kSelectedColor : kCardColor,
            border: Border(
              top: BorderSide(
                width: isSelected ? 1 : 2,
                color: isSelected ? kShadowDark : kShadowLight,
              ),
              left: BorderSide(
                width: isSelected ? 1 : 2,
                color: isSelected ? kShadowDark : kShadowLight,
              ),
              right: BorderSide(
                width: isSelected ? 1 : 2,
                color: isSelected ? kShadowLight : kShadowDark,
              ),
              bottom: BorderSide(
                width: isSelected ? 1 : 2,
                color: isSelected ? kShadowLight : kShadowDark,
              ),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: kShadowDark.withOpacity(0.5),
                      offset: const Offset(4, 4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: kShadowLight,
                      offset: const Offset(-6, -6),
                      blurRadius: 12,
                    ),
                    BoxShadow(
                      color: kShadowDark,
                      offset: const Offset(6, 6),
                      blurRadius: 12,
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              answer.text,
              style: TextStyle(
                fontSize: isSelected ? 18 : 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF1A3A4A) : const Color(0xFF2C5F75),
              ),
            ),
          ),
        ),
      );
    }

    // Widget bouton neomorphisme générique
    Widget _buildNeomorphicButton({
      required String text,
      required VoidCallback? onPressed,
    }) {
      final isEnabled = onPressed != null;
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          decoration: BoxDecoration(
            color: isEnabled ? kPrimaryColor : kShadowDark,
            border: Border(
              top: BorderSide(
                width: 2,
                color: isEnabled ? kShadowLight : kShadowDark,
              ),
              left: BorderSide(
                width: 2,
                color: isEnabled ? kShadowLight : kShadowDark,
              ),
              right: BorderSide(
                width: 2,
                color: isEnabled ? kShadowDark : kShadowLight.withOpacity(0.5),
              ),
              bottom: BorderSide(
                width: 2,
                color: isEnabled ? kShadowDark : kShadowLight.withOpacity(0.5),
              ),
            ),
            boxShadow: isEnabled
                ? [
                    const BoxShadow(
                      color: kShadowLight,
                      offset: Offset(-6, -6),
                      blurRadius: 12,
                    ),
                    const BoxShadow(
                      color: kShadowDark,
                      offset: Offset(6, 6),
                      blurRadius: 12,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isEnabled ? const Color(0xFF1A3A4A) : const Color(0xFF94A3AD),
              ),
            ),
          ),
        ),
      );
    }
  }
