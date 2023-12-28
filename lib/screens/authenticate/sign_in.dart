import 'package:flutter/material.dart';
import 'package:tzivos_hashem_milwaukee/services/auth.dart';
import 'package:tzivos_hashem_milwaukee/shared/loading.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart';

class signIn extends StatefulWidget {
  final Function toggleView;
  const signIn({super.key, required this.toggleView});
  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: bage,
            appBar: AppBar(
                backgroundColor: bage,
                elevation: 0.0,
                title: Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: newpink),
                  ),
                ),        centerTitle: true,
),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          cursorColor: doneHachlata,
                          decoration: InputDecoration(
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: lightGreen)),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: bage),
                            fillColor: lightGreen,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: lightGreen, width: 3.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: lightGreen, width: 3.0)),
                            errorStyle: TextStyle(
                              color: newpink,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: lightGreen, width: 3.0),
                            ),
                          ),
                          style: TextStyle(color: bage),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter Email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          cursorColor: doneHachlata,
                          decoration: InputDecoration(
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: lightGreen)),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: bage),
                            fillColor: lightGreen,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: lightGreen, width: 3.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: lightGreen, width: 3.0)),
                            errorStyle: TextStyle(
                              color: newpink,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: lightGreen, width: 3.0),
                            ),
                          ),
                          style: TextStyle(color: bage),
                          validator: (val) => val!.length < 6
                              ? 'Enter a password 6 + chars long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            {
                              setState(() => password = val);
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20), 
                                  ),
                                  backgroundColor: newpink),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);

                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'please enter a valid email and password';
                                      loading = false;
                                    });
                                  }
                                } else
                                  print('couldnt sign in');
                                print(email);
                                print(password);
                              },
                              child: Text(
                                'Sign in',
                                style: TextStyle(color: bage),
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20), 
                                  ),
                                  backgroundColor: newpink),
                              onPressed: () async {
                                widget.toggleView();
                                print('register');                     
                                print(email);
                                print(password);
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(color: bage),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: newpink, fontSize: 14),
                        )
                      ],
                    ))),
          );
  }
}
