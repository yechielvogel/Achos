import 'package:flutter/material.dart';
import '../../services/auth/auth.dart';
import '../../shared/widgets/input/input_field.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String name = '';
  String school = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Text('Register'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomInputField(
                      hintText: 'Name',
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter your name' : null,
                      onChanged: (val) => setState(() => name = val),
                    ),
                    SizedBox(height: 16),
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
                    CustomInputField(
                      hintText: 'School',
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter your school' : null,
                      onChanged: (val) => setState(() => school = val),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          int schoolId = int.tryParse(school) ?? 0;
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                            email,
                            password,
                            name,
                            schoolId,
                          );
                          if (result == null) {
                            setState(() {
                              error = 'Registration failed';
                              loading = false;
                            });
                          }
                        }
                      },
                      child: Text('Register'),
                    ),
                    SizedBox(height: 12),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
