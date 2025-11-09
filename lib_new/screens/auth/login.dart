import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth/auth.dart';
import '../../shared/widgets/buttons/theme_button.dart';
import '../../shared/widgets/input/input_field.dart';

class SignIn extends ConsumerStatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final style = ref.read(styleProvider);

    return loading
        ? CircularProgressIndicator()
        : Scaffold(
            backgroundColor: style.backgroundColor,
            appBar: AppBar(
              backgroundColor: style.backgroundColor,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Align buttons with space between
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);

                                if (result == null) {
                                  setState(() {
                                    error =
                                        'Please enter a valid email and password';
                                    loading = false;
                                  });
                                }
                              }
                            },
                            title: 'Sign In',
                          ),
                        ),
                        SizedBox(width: 16), // Add spacing between the buttons
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              widget.toggleView();
                            },
                            title: 'Register',
                          ),
                        ),
                      ],
                    ),
                    Text(
                      error,
                      style: TextStyle(color: style.errorColor),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
