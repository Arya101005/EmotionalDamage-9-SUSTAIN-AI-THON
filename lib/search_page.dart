import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allProfiles = [
    {
      'username': 'ash_4_ever',
      'fullName': 'Ashley Smith',
      'avatar': 'assets/story0.png'
    },
    {
      'username': 'pixel_ninja',
      'fullName': 'Chris Wong',
      'avatar': 'assets/story1.png'
    },
    {
      'username': 'cosmic_wanderer',
      'fullName': 'Emma Space',
      'avatar': 'assets/story2.png'
    },
    {
      'username': 'neon_dreamer',
      'fullName': 'Alex Neon',
      'avatar': 'assets/story3.png'
    },
    {
      'username': 'lunar_whisper',
      'fullName': 'Luna Moon',
      'avatar': 'assets/story4.png'
    },
    {
      'username': 'chaos_phoenix',
      'fullName': 'Phoenix Rise',
      'avatar': 'assets/story5.png'
    },
  ];
  List<Map<String, dynamic>> filteredProfiles = [];

  @override
  void initState() {
    super.initState();
    filteredProfiles = allProfiles;
  }

  void _filterProfiles(String query) {
    setState(() {
      filteredProfiles = allProfiles.where((profile) {
        final username = profile['username'].toLowerCase();
        final fullName = profile['fullName'].toLowerCase();
        final searchQuery = query.toLowerCase();
        return username.contains(searchQuery) || fullName.contains(searchQuery);
      }).toList();
    });
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search profiles...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white70),
                icon: Icon(Icons.search, color: Colors.white),
              ),
              style: const TextStyle(
                  color: Colors.black), // Changed from white to black
              onChanged: _filterProfiles,
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: filteredProfiles.length,
          itemBuilder: (context, index) {
            final profile = filteredProfiles[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(profile['avatar']),
                ),
                title: Text(
                  profile['username'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  profile['fullName'],
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  // Handle profile selection
                  print('Selected profile: ${profile['username']}');
                },
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
