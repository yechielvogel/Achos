import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/general.dart';
import '../../services/auth/auth.dart';
import '../../shared/widgets/buttons/custom_button.dart';
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

  @override
  Widget build(BuildContext context) {
    final style = ref.read(styleProvider);

    return Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        widget.toggleView();
                      },
                      title: 'Register',
                      isOutline: true,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => ref
                              .watch(generalLoadingProvider.notifier)
                              .state = true);

                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password, ref);

                          if (result == null) {
                            setState(() {
                              error = 'Please enter a valid email and password';
                              ref.watch(generalLoadingProvider.notifier).state =
                                  false;
                            });
                          }
                        }
                      },
                      title: 'Sign In',
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  error,
                  style: TextStyle(color: style.errorColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
