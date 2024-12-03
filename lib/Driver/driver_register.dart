import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_button.dart';
import 'custom_textfield.dart';
import 'driver_login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false; // To manage loading state

  // Method to show loading dialog with GIF
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing the dialog
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/register_loading.gif', // Replace with your loading GIF path
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 16),
              const Text(
                'Registering...',
                style: TextStyle(fontSize: 16, color: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register(BuildContext context) async {
    if (nameController.text.isEmpty ||
        plateNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showMessageDialog(
        context,
        title: 'Error',
        message: 'All fields must be filled!',
      );
    } else if (passwordController.text != confirmPasswordController.text) {
      _showMessageDialog(
        context,
        title: 'Error',
        message: 'Passwords do not match!',
      );
    } else {
      setState(() {
        isLoading = true; // Show loading spinner
      });

      _showLoadingDialog(context); // Show loading GIF dialog

      try {
        // Register user using Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        User? user = userCredential.user;
        if (user != null) {
          // Save user data (excluding password) in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': nameController.text,
            'plateNumber': plateNumberController.text,
            'email': emailController.text,
            'registrationDate': Timestamp.now(),
          });

          // Send email verification
          await user.sendEmailVerification();

          Navigator.pop(context); // Close the loading dialog

          _showMessageDialog(
            context,
            title: 'Success',
            message:
                'Registration successful! Please check your email to verify your account.',
            isSuccess: true,
          );
        }
      } catch (e) {
        Navigator.pop(context); // Close the loading dialog
        _showMessageDialog(
          context,
          title: 'Error',
          message: 'Failed to register: ${e.toString()}',
        );
      } finally {
        setState(() {
          isLoading = false; // Hide loading spinner
        });
      }
    }
  }

  void _showMessageDialog(BuildContext context,
      {required String title,
      required String message,
      bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                label: 'Name',
                hint: 'Enter your full name',
                controller: nameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Plate Number',
                hint: 'Enter your plate number',
                controller: plateNumberController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email',
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                hint: 'Enter your password',
                isPassword: true,
                controller: passwordController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Confirm Password',
                hint: 'Re-enter your password',
                isPassword: true,
                controller: confirmPasswordController,
              ),
              const SizedBox(height: 32),
              // Register Button
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    )
                  : CustomButton(
                      text: 'Register',
                      onPressed: () => _register(context),
                    ),
              const SizedBox(height: 20),
              // Already have an account? Login Button
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
