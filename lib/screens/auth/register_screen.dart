// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:en_career/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _domainController = TextEditingController();
  final _streamController = TextEditingController();
  final _stageController = TextEditingController();

  void _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.signUp(
        _emailController.text.trim(),
        _passwordController.text,
        _usernameController.text.trim(),
        _domainController.text.trim(),
        _streamController.text.trim(),
        _stageController.text.trim(),
      );

      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Successful")));
        Navigator.pop(context); // back to login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Failed")));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _domainController.dispose();
    _streamController.dispose();
    _stageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (value) => value?.isEmpty ?? true ? "Enter username" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) => value?.isEmpty ?? true ? "Enter email" : null,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (value) => value?.isEmpty ?? true ? "Enter password" : null,
              ),
              TextFormField(controller: _domainController, decoration: const InputDecoration(labelText: "Domain")),
              TextFormField(controller: _streamController, decoration: const InputDecoration(labelText: "Stream")),
              TextFormField(controller: _stageController, decoration: const InputDecoration(labelText: "Current Stage")),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => _register(context), child: const Text("Register")),
            ],
          ),
        ),
      ),
    );
  }
}