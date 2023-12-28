import 'package:flutter/material.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals ;
import '../../services/auth.dart';
import '../../shared/loading.dart';

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
  String error = '';
  bool loading = false;

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
                    'Register',
                    style: TextStyle(color: newpink),
                  ),
                  
                ),
                        centerTitle: true,

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
                            hintText: 'Name',
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
                              val!.isEmpty ? 'Enter Name' : null,
                          onChanged: (val) {
                            {
                              setState(() => name = val);
                              setState(() {
                                globals.tempuesname = name;
                              });
                            }
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
                          obscureText: true,
                          validator: (val) => val!.length < 6
                              ? 'Enter a password 6 + chars long'
                              : null,
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
                                        20), // Adjust the value for desired roundness
                                  ),
                                  backgroundColor: newpink),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  print(email);
                                  print(password);
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email, password, name);
                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'please enter a valid email and password';
                                      loading = false;
                                    });
                                  }
                                } else
                                  print("couldn't register");
                                // widget.toggleView();
                              },
                              child: Text(
                                'Register',
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
                                print(email);
                                print(password);
                              },
                              child: Text(
                                'Sign in',
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
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        )
                      ],
                    ))),
          );
  }
}
