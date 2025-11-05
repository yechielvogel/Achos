import 'package:flutter/material.dart';
import '../../services/auth/auth.dart';
import '../../shared/widgets/input_field.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Text('Sign In'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomInputField(
                      hintText: 'Email',
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter your email' : null,
                      onChanged: (val) => setState(() => email = val),
                    ),
                    SizedBox(height: 16),
                    CustomInputField(
                      hintText: 'Password',
                      isPassword: true,
                      validator: (val) => val!.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                      onChanged: (val) => setState(() => password = val),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);

                          if (result == null) {
                            setState(() {
                              error = 'Please enter a valid email and password';
                              loading = false;
                            });
                          }
                        }
                      },
                      child: Text('Sign In'),
                    ),
                    SizedBox(height: 12),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        widget.toggleView();
                      },
                      child: Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
