import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Create an account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                validator: (value) => value!.contains("@") ? null : "Please enter a valid email",
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                validator: (value) => value!.length < 6 ? "Password must be 6+ characters" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Za CP2 samo simuliramo prelazak na RootScreen
                    Navigator.pushReplacementNamed(context, '/root');
                  }
                },
                child: const Text("Register"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Already have an account? Sign in"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
