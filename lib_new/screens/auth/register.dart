import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/general.dart';
import '../../services/auth/auth.dart';
import '../../shared/widgets/buttons/custom_button.dart';
import '../../shared/widgets/input/input_field.dart';

// Define a provider for AuthService
final authServiceProvider = Provider((ref) => AuthService());

class Register extends ConsumerStatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  // String school = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    // Access the AuthService instance from the provider
    final authService = ref.watch(authServiceProvider);
    final style = ref.read(styleProvider);

    return Scaffold(
      backgroundColor: style.backgroundColor,
      appBar: AppBar(
        backgroundColor: style.backgroundColor,
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomInputField(
                hintText: 'First name',
                validator: (val) =>
                    val!.isEmpty ? 'Please enter your First name' : null,
                onChanged: (val) => setState(() => firstName = val),
              ),
              SizedBox(height: 16),
              CustomInputField(
                hintText: 'Last name',
                validator: (val) =>
                    val!.isEmpty ? 'Please enter your Last name' : null,
                onChanged: (val) => setState(() => lastName = val),
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
              // SizedBox(height: 16),
              // CustomInputField(
              //   hintText: 'School',
              //   validator: (val) =>
              //       val!.isEmpty ? 'Please enter your school' : null,
              //   onChanged: (val) => setState(() => school = val),
              // ),
              SizedBox(height: 16),
              CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => ref
                          .watch(generalLoadingProvider.notifier)
                          .state = true);
                      int schoolId = 1;
                      // int schoolId = int.tryParse(school) ?? 0;

                      await authService.registerWithEmailAndPassword(
                          email, password, firstName, lastName, schoolId, ref);

                      // if (result == null) {
                      //   setState(() {
                      //     error = 'Registration failed';
                      //     ref.watch(generalLoadingProvider.notifier).state =
                      //         false;
                      //   });
                      // }
                    }
                  },
                  title: 'Register'),
              SizedBox(height: 12),
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
