import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; //
import 'package:anthology_app/controller/Auth_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login/Sign Up Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Global key for the form to enable validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for text input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // State to toggle between login and sign-up forms
  bool _isLogin = true;
  bool _isPasswordVisible = false;

  // Function to handle login/sign-up button press
  void _authenticate() {
    // Validate all fields in the form
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false); // Get AuthService instance
      if (_isLogin) {
        // Handle login logic
        print('Login button pressed!');
        print('Email: ${_emailController.text}and ${_passwordController.text}');
        print('Password: ${_passwordController.text}and ${_passwordController.text}');
        // In a real app, you would send these credentials to an authentication service
        _showMessage(context, 'Logging in with ${_emailController.text}');
        authService.signIn();
        Navigator.pop(context);
      } else {
        // Handle sign-up logic
        print('Sign Up button pressed!');
        print('Email: ${_emailController.text}');
        print('Password: ${_passwordController.text}');
        print('Confirm Password: ${_confirmPasswordController.text}');
        if (_passwordController.text == _confirmPasswordController.text) {
          // In a real app, you would send these credentials to a registration service
          _showMessage(context, 'Signing up with ${_emailController.text}');
          authService.signIn();
        } else {
          _showMessage(context, 'Passwords do not match!', isError: true);
        }
      }
      // Clear the text fields after authentication attempt (only if successful or if you want to clear on any attempt)
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    }
  }

  // Function to show a message using a SnackBar
  void _showMessage(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),

            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    _isLogin ?Icons.lock_open_rounded : Icons.person,
                    size: 100,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                  const SizedBox(height: 48.0),

                  // Email Input Field
                  TextFormField( // Use TextFormField for validation
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Simple email validation regex
                      if (!RegExp(
                          r'^(?=[a-zA-Z0-9._%+-]*[a-zA-Z])[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Password Input Field
                  TextFormField( // Use TextFormField for validation
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible, // Hide password text
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton( // Add the eye icon
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!])[A-Za-z\d@#$%^&+=!]{8,}$').hasMatch(value)) {
                        return 'Password must be strong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Confirm Password Input Field (only for Sign Up)
                  if (!_isLogin)
                    Column(
                      children: [
                        TextFormField( // Use TextFormField for validation
                          controller: _confirmPasswordController,
                          obscureText: true, // Hide password text
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: 'Re-enter your password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            prefixIcon: const Icon(Icons.lock_open_rounded),
                            /*
                            suffixIcon: IconButton( // Add the eye icon
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                                });
                              },
                            ),*/
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),

                  // Login/Sign Up Button
                  ElevatedButton(
                    onPressed: _authenticate,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      _isLogin ? 'Login' : 'Sign Up',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Toggle between Login and Sign Up
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        // Clear fields and reset form validation when toggling
                        _emailController.clear();
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                        _formKey.currentState
                            ?.reset();
                        _isPasswordVisible = false; // Reset form validation state
                      });
                    },
                    child: Text(
                      _isLogin
                          ? 'Don\'t have an account? Sign Up'
                          : 'Already have an account? Login',
                      style: TextStyle(color: Theme
                          .of(context)
                          .primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}