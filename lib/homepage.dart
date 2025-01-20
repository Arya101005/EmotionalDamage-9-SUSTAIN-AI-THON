import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userNames = [
    'ash_4_ever',
    'pixel_ninja',
    'cosmic_wanderer',
    'neon_dreamer'
  ];

  final locations = [
    'Tokyo Drift',
    'Neon City',
    'Cosmic Valley',
    'Digital Haven'
  ];

  final Map<int, dynamic> _postData = {};
  int _selectedIndex = 0;
  final String currentUser = 'pixel_ninja';
  final storyImages = List.generate(13, (i) => 'assets/story${i + 1}.png');
  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();
    _posts = List.generate(
      3,
      (i) => {
        'type': 'asset',
        'path': 'assets/post${i + 11}.png',
        'imageBytes': null,
      },
    );
    _initializePostData();
  }

  void _initializePostData() {
    for (int i = 0; i < _posts.length; i++) {
      _postData[i] = {
        'controller': ConfettiController(duration: const Duration(seconds: 1)),
        'commentController': TextEditingController(),
        'description': '',
        'comments': [],
        'isLiked': false,
        'likeCount': Random().nextInt(1000) + 100,
        'username': userNames[i % userNames.length],
        'location': locations[i % locations.length],
        'isUserPost': false,
        'timestamp': DateTime.now().subtract(Duration(days: i)).toString(),
      };
    }
  }

  Widget _buildStoryItem(int index) {
    return Container(
      width: 85,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF40E0D0), Color(0xFFFF69B4)],
              ),
              borderRadius: BorderRadius.circular(35),
            ),
            padding: const EdgeInsets.all(2),
            child: CircleAvatar(
              backgroundImage: AssetImage(storyImages[index]),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userNames[index % userNames.length],
            style: const TextStyle(color: Colors.white, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPostItem(int index) {
    var data = _postData[index];
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      AssetImage(storyImages[index % storyImages.length]),
                ),
                title: Text(
                  data['username'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  data['location'],
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              _buildPostImage(_posts[index]),
              _buildPostActions(index, data),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data['likeCount']} smiles',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (data['description'].isNotEmpty)
                      Text(
                        data['description'],
                        style: const TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 200,
          child: ConfettiWidget(
            confettiController: data['controller'],
            blastDirection: 0,
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.2,
            colors: const [
              Colors.yellow,
              Colors.pink,
              Colors.blue,
              Colors.green,
              Colors.purple
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostImage(Map<String, dynamic> post) {
    if (post['type'] == 'asset') {
      return Image.asset(
        post['path'],
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (post['type'] == 'web' && post['imageBytes'] != null) {
      return Image.memory(
        post['imageBytes'],
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (post['type'] == 'file') {
      return Image.file(
        File(post['path']),
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return const SizedBox();
  }

  Widget _buildPostActions(int index, Map<String, dynamic> data) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            data['isLiked']
                ? Icons.sentiment_very_satisfied
                : Icons.sentiment_very_satisfied_outlined,
            color: data['isLiked'] ? Colors.yellow : Colors.white,
          ),
          onPressed: () => setState(() {
            data['isLiked'] = !data['isLiked'];
            data['likeCount'] += data['isLiked'] ? 1 : -1;
            if (data['isLiked']) data['controller'].play();
          }),
        ),
        IconButton(
          icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          onPressed: () => _showCommentDialog(index),
        ),
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.paperPlane,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {},
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  void _showCommentDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text('Comments', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_postData[index]['comments'].isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: _postData[index]['comments'].length,
                  itemBuilder: (context, i) => ListTile(
                    title: Text(
                      _postData[index]['comments'][i],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            TextField(
              controller: _postData[index]['commentController'],
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_postData[index]['commentController'].text.isNotEmpty) {
                  setState(() {
                    _postData[index]['comments']
                        .add(_postData[index]['commentController'].text);
                    _postData[index]['commentController'].clear();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Post', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePostNavigation() async {
    final result = await Navigator.pushNamed(context, '/post');
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _posts.insert(0, {
          'type': kIsWeb ? 'web' : 'file',
          'path': result['imagePath'],
          'imageBytes': result['imageBytes'],
        });
        _postData[0] = {
          'controller':
              ConfettiController(duration: const Duration(seconds: 1)),
          'commentController': TextEditingController(),
          'description': result['description'] ?? '',
          'comments': [],
          'isLiked': false,
          'likeCount': 0,
          'username': currentUser,
          'location': 'Your Location',
          'isUserPost': true,
          'timestamp': result['timestamp'],
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF40E0D0), Color(0xFF7B68EE)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {},
          ),
          title: const Text('Nexus', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: const Icon(Icons.quiz_rounded, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/daily-questions'),
            ),
            IconButton(
              icon: const Icon(Icons.groups_rounded, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/community'),
            ),
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.paperPlane,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: userNames.length,
                itemBuilder: (_, i) => _buildStoryItem(i),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (_, i) => _buildPostItem(i),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            if (index == 1) {
              Navigator.pushNamed(context, '/search');
            } else if (index == 2) {
              _handlePostNavigation();
            } else if (index == 3) {
              Navigator.pushNamed(context, '/leaderboard');
            } else if (index == 4) {
              Navigator.pushNamed(context, '/profile');
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
