import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }

  Widget _buildCommunityCard({
    required String name,
    required String location,
    required String phone,
    required String email,
    required String description,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade100, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 32, color: Colors.purple.shade700),
                  const SizedBox(width: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    location,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.phone),
                    label: Text(phone),
                    onPressed: () => _makePhoneCall(phone),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.email),
                    label: Text(email),
                    onPressed: () => _sendEmail(email),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
          colors: [Color(0xFF40E0D0), Color(0xFF7B68EE)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Communities',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          children: [
            _buildCommunityCard(
              name: 'Hope Foundation NGO',
              location: '123 Hope Street, New York',
              phone: '+1234567890',
              email: 'contact@hopefoundation.org',
              description:
                  'Dedicated to providing education and healthcare to underprivileged children.',
              icon: Icons.volunteer_activism,
            ),
            _buildCommunityCard(
              name: 'Kindness Warriors',
              location: '456 Peace Avenue, Los Angeles',
              phone: '+1987654321',
              email: 'info@kindnesswarriors.org',
              description:
                  'Spreading kindness through community service and social initiatives.',
              icon: Icons.favorite,
            ),
            _buildCommunityCard(
              name: 'Green Earth Initiative',
              location: '789 Nature Boulevard, San Francisco',
              phone: '+1122334455',
              email: 'support@greenearth.org',
              description:
                  'Working towards environmental conservation and sustainability.',
              icon: Icons.eco,
            ),
          ],
        ),
      ),
    );
  }
}
