import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  LeaderboardPage({super.key});

  // Mock data structure for user scores from daily empathy challenge
  // In a real app, this would come from your backend/database
  List<Map<String, dynamic>> _getDailyEmpathyScores() {
    return [
      {
        'name': userNames[0],
        'score': 99,
        'image': 'assets/story0.png',
        'challengeCompleted': 'Helped a colleague in need'
      },
      {
        'name': userNames[1],
        'score': 98,
        'image': 'assets/story1.png',
        'challengeCompleted': 'Supported a friend through tough times'
      },
      {
        'name': userNames[2],
        'score': 96,
        'image': 'assets/story2.png',
        'challengeCompleted': 'Listened actively to family concerns'
      },
      {
        'name': userNames[3],
        'score': 84,
        'image': 'assets/story3.png',
        'challengeCompleted': 'Showed understanding to a stranger'
      },
      {
        'name': userNames[4],
        'score': 74,
        'image': 'assets/story4.png',
        'challengeCompleted': 'Provided emotional support'
      },
    ];
  }

  // Using the same userNames from HomePage for consistency
  final List<String> userNames = [
    'ash_4_ever',
    'pixel_ninja',
    'cosmic_wanderer',
    'neon_dreamer',
    'lunar_whisper',
  ];

  @override
  Widget build(BuildContext context) {
    final leaderboardData = _getDailyEmpathyScores();

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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Daily Empathy Challenge',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Today\'s Top Empaths',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: leaderboardData.length,
                itemBuilder: (context, index) {
                  final user = leaderboardData[index];
                  final isLeader = index == 0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isLeader
                          ? Colors.green.withOpacity(0.7)
                          : Color.lerp(
                              Colors.teal,
                              Colors.blue,
                              index / leaderboardData.length,
                            )!
                              .withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 25,
                              backgroundImage: AssetImage(user['image']),
                            ),
                          ),
                          title: Text(
                            user['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            user['challengeCompleted'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${user['score']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: 3,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index != 3) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined), label: 'Post'),
            BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard), label: 'Activity'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
