// auth_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

enum AuthMode { login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthMode _authMode = AuthMode.login;

  Future<void> _submit() async {
    try {
      if (_authMode == AuthMode.login) {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'))
      );
    }
  }

  void _toggleAuthMode() {
    setState(() {
      _authMode = _authMode == AuthMode.login ? AuthMode.register : AuthMode.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a Stack to add a background image/color overlay
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login_bg.jpg'), // add a background image in assets and update pubspec.yaml accordingly
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _authMode == AuthMode.login ? 'Login' : 'Register',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submit,
                        child: Text(_authMode == AuthMode.login ? 'Login' : 'Register'),
                      ),
                      TextButton(
                        onPressed: _toggleAuthMode,
                        child: Text(_authMode == AuthMode.login
                            ? 'Don\'t have an account? Register'
                            : 'Already have an account? Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
