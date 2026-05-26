import 'package:flutter/material.dart';

import '../../../app_view.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String email;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    const String phone = '+84 123 456 789';
    const String address = 'Da Nang, Viet Nam';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 58,
              backgroundColor: Color(0xFFD7B899),
              child: Icon(
                Icons.person,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              email,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 30),
            _profileItem(
              icon: Icons.phone,
              title: 'Phone Number',
              subtitle: phone,
            ),
            _profileItem(
              icon: Icons.location_on,
              title: 'Address',
              subtitle: address,
            ),
            _profileItem(
              icon: Icons.history,
              title: 'Order History',
              subtitle: 'View your previous coffee orders',
            ),
            _profileItem(
              icon: Icons.payment,
              title: 'Payment Method',
              subtitle: 'Manage your payment options',
            ),
            _profileItem(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'Manage your account settings',
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const AuthPage(),
                    ),
                        (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: const Color(0xFFFFEFE8),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF6F4E37),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }
}