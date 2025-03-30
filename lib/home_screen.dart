// home_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_screen.dart';
import 'pet_profile.dart';
import 'health_monitor.dart';
import 'location_finder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a full-screen container with a gradient background.
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top area with a welcome message and logout button.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Welcome, User!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () => _logout(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Central area with navigation buttons.
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PetProfileScreen()),
                          );
                        },
                        icon: const Icon(Icons.pets),
                        label: const Text('Manage Pet Profiles'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HealthMonitorScreen()),
                          );
                        },
                        icon: const Icon(Icons.favorite),
                        label: const Text('Monitor Pet Health'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LocationFinderScreen()),
                          );
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text('Find My Location'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
