import 'package:flutter/material.dart';
import 'dart:math';

class HeartPosition {
  double x, y, speed;
  HeartPosition({required this.x, required this.y, required this.speed});
}

class Question {
  final String question;
  final List<String> options;
  final List<int> empathyPoints;
  final String explanation;
  final String badge;
  final int requiredPoints;

  Question({
    required this.question,
    required this.options,
    required this.empathyPoints,
    required this.explanation,
    required this.badge,
    required this.requiredPoints,
  });
}

class DailyQuestionsPage extends StatefulWidget {
  const DailyQuestionsPage({super.key});
  @override
  State<DailyQuestionsPage> createState() => _DailyQuestionsPageState();
}

class _DailyQuestionsPageState extends State<DailyQuestionsPage>
    with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int empathyScore = 0;
  int heartsCaught = 0;
  int likesReceived = 0;
  int honorScore = 0;
  double happinessLevel = 0.0;
  List<String> earnedBadges = [];
  List<HeartPosition> hearts = [];
  late AnimationController _heartController;
  final TextEditingController answerController = TextEditingController();
  String currentReflectiveQuestion = '';
  final random = Random();

  final List<Question> questions = [
    Question(
        question:
            'During a severe flood, you can only save one: a human or a cow. Which would you choose and why?',
        options: [
          'Save the human',
          'Save the cow',
          'Try to save both',
          'Choose closest'
        ],
        empathyPoints: [3, 2, 4, 1],
        explanation:
            'Prioritizing human life while showing concern for animals demonstrates balanced empathy.',
        badge: '🌟 Life Saver',
        requiredPoints: 3),
    Question(
        question:
            'You notice a colleague crying in the office. What would you do?',
        options: [
          'Keep walking',
          'Offer help',
          'Alert supervisor',
          'Sit silently'
        ],
        empathyPoints: [1, 4, 2, 3],
        explanation:
            'Offering support while respecting boundaries shows emotional intelligence.',
        badge: '❤️ Compassionate Soul',
        requiredPoints: 4),
    Question(
        question:
            'A friend is spreading rumors about another friend. What do you do?',
        options: [
          'Join in',
          'Confront them privately',
          'Ignore it',
          'Defend the person'
        ],
        empathyPoints: [1, 3, 2, 4],
        explanation:
            'Standing up for others while maintaining privacy shows true friendship.',
        badge: '🤝 True Friend',
        requiredPoints: 4)
  ];

  final List<Map<String, dynamic>> reflections = [
    {
      'question': 'What brought you joy today?',
      'honorPoints': 10,
      'badge': '😊 Joy Seeker'
    },
    {
      'question': 'How did you help someone today?',
      'honorPoints': 15,
      'badge': '🤲 Helper'
    },
    {
      'question': 'What are you grateful for today?',
      'honorPoints': 12,
      'badge': '🙏 Gratitude Master'
    }
  ];

  @override
  void initState() {
    super.initState();
    _setRandomReflectiveQuestion();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(_updateHeartsPosition);
    _startHeartGame();
  }

  void _startHeartGame() {
    _heartController.repeat();
    _addNewHeart();
  }

  void _addNewHeart() {
    if (!mounted) return;
    Future.delayed(Duration(milliseconds: random.nextInt(2000) + 1000), () {
      if (mounted) {
        setState(() {
          hearts.add(HeartPosition(
            x: random.nextDouble() * (MediaQuery.of(context).size.width - 30),
            y: -30,
            speed: random.nextDouble() * 2 + 1,
          ));
        });
        _addNewHeart();
      }
    });
  }

  void _updateHeartsPosition() {
    if (!mounted) return;
    setState(() {
      for (int i = hearts.length - 1; i >= 0; i--) {
        hearts[i].y += hearts[i].speed;
        if (hearts[i].y > MediaQuery.of(context).size.height) {
          hearts.removeAt(i);
        }
      }
    });
  }

  void _catchHeart(int index) {
    setState(() {
      hearts.removeAt(index);
      heartsCaught++;
      empathyScore++;
      happinessLevel = min(1.0, happinessLevel + 0.025);
    });
  }

  void _checkAnswer(int selectedOptionIndex) {
    Question currentQuestion = questions[currentQuestionIndex];
    int points = currentQuestion.empathyPoints[selectedOptionIndex];

    setState(() {
      empathyScore += points;
      happinessLevel = min(1.0, happinessLevel + (points * 0.05));

      if (points >= currentQuestion.requiredPoints &&
          !earnedBadges.contains(currentQuestion.badge)) {
        earnedBadges.add(currentQuestion.badge);
        _showBadgeEarnedDialog(currentQuestion.badge);
      }

      _showDialog('Understanding Empathy', currentQuestion.explanation);
      if (currentQuestionIndex < questions.length - 1) currentQuestionIndex++;
    });
  }

  void _submitReflection() {
    if (answerController.text.trim().isNotEmpty) {
      Map<String, dynamic> currentReflection = reflections.firstWhere(
          (reflection) => reflection['question'] == currentReflectiveQuestion);

      setState(() {
        // Fix: Explicitly cast honorPoints to int
        honorScore += (currentReflection['honorPoints'] as num).toInt();
        if (!earnedBadges.contains(currentReflection['badge'])) {
          earnedBadges.add(currentReflection['badge']);
        }
      });

      _showDialog(
          'Reflection Submitted!',
          'You earned ${currentReflection['honorPoints']} honor points!\n'
              'Total Honor Score: $honorScore\n'
              'Badge Earned: ${currentReflection['badge']}');

      answerController.clear();
      _setRandomReflectiveQuestion();
    }
  }

  void _setRandomReflectiveQuestion() {
    final random = Random();
    setState(() {
      currentReflectiveQuestion =
          reflections[random.nextInt(reflections.length)]['question'];
    });
  }

  void _showBadgeEarnedDialog(String badge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('New Badge Earned!',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(badge,
                style: const TextStyle(color: Colors.white, fontSize: 40)),
            const SizedBox(height: 16),
            const Text('Keep up the great work!',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Continue', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(content, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Continue', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF40E0D0), Color(0xFF7B68EE), Color(0xFFFF69B4)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Daily Empathy Challenge',
              style: TextStyle(color: Colors.white)),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Empathy Score: $empathyScore',
                              style: const TextStyle(color: Colors.white)),
                          Text('Honor Score: $honorScore',
                              style: const TextStyle(color: Colors.white)),
                          Text('Hearts: $heartsCaught',
                              style: const TextStyle(color: Colors.white)),
                          Text('Badges: ${earnedBadges.length}',
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                      Container(
                        width: 60,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 100 * happinessLevel,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [Colors.pink, Colors.purple],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Center(
                              child: Icon(Icons.favorite,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 30),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7B68EE), Color(0xFFFF69B4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Daily Reflection',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Text(currentReflectiveQuestion,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 16),
                        TextField(
                          controller: answerController,
                          style: const TextStyle(color: Colors.black),
                          maxLines: 3,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Share your thoughts...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: _submitReflection,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                            ),
                            child: const Text('Share',
                                style: TextStyle(color: Colors.purple)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (currentQuestionIndex < questions.length) ...[
                    const SizedBox(height: 20),
                    Text(questions[currentQuestionIndex].question,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 10),
                    ...List.generate(
                      questions[currentQuestionIndex].options.length,
                      (index) => Card(
                        color: Colors.white10,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          onTap: () => _checkAnswer(index),
                          title: Text(
                              questions[currentQuestionIndex].options[index],
                              style: const TextStyle(color: Colors.white)),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            ...hearts.asMap().entries.map((entry) => Positioned(
                  left: entry.value.x,
                  top: entry.value.y,
                  child: GestureDetector(
                    onTapDown: (_) => _catchHeart(entry.key),
                    child: const Icon(Icons.favorite,
                        color: Colors.pink, size: 30),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    answerController.dispose();
    super.dispose();
  }
}
