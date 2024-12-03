import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice/Passenger/pass_button.dart';
import 'package:practice/Passenger/pass_textfield.dart';
import 'package:practice/Passenger/passenger_login.dart';

class PassengerRegister extends StatefulWidget {
  const PassengerRegister({Key? key}) : super(key: key);

  @override
  _PassengerRegisterState createState() => _PassengerRegisterState();
}

class _PassengerRegisterState extends State<PassengerRegister> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false; // Loading state flag

  // Register method
  void _register(BuildContext context) async {
    if (nameController.text.isEmpty ||
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
        _isLoading = true; // Show the loading indicator
      });

      // Show the loading GIF dialog
      _showLoadingDialog(context);

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        User? user = userCredential.user;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection(
                  'userspassenger') // Store data in userspassenger collection
              .doc(user.uid)
              .set({
            'name': nameController.text,
            'email': emailController.text,
            'registrationDate': Timestamp.now(),
          });

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
          _isLoading = false; // Hide the loading indicator
        });
      }
    }
  }

  // Show loading dialog with GIF
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/register_loading.gif', // Path to your loading GIF
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
        );
      },
    );
  }

  // Show success or error dialog
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
                  MaterialPageRoute(builder: (_) => const PassengerLogin()),
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
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 245, 204, 151),
                  Colors.deepOrangeAccent
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Registration Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  CustomField(
                    label: 'Name',
                    hint: 'Enter your full name',
                    controller: nameController,
                  ),
                  const SizedBox(height: 16),
                  CustomField(
                    label: 'Email',
                    hint: 'Enter your email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 16),
                  CustomField(
                    label: 'Password',
                    hint: 'Enter your password',
                    isPassword: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 16),
                  CustomField(
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    isPassword: true,
                    controller: confirmPasswordController,
                  ),
                  const SizedBox(height: 32),
                  // Register Button
                  _isLoading
                      ? Column(
                          children: [
                            // Loading GIF
                            Image.asset(
                              'assets/register_loading.gif',
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Registering...',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        )
                      : CusButton(
                          text: 'Register',
                          onPressed: () => _register(context),
                        ),
                  const SizedBox(height: 20),
                  // Already have an account? Login Button
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const PassengerLogin()),
                    ),
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
