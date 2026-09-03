import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  
  var _isAuthenticating = false;
  var _isLogin = true;
  var _enteredFirstName = '';
  var _enteredLastName = '';
  var _enteredUsername = '';
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final usercredentials = await _firebase
          .signInWithEmailAndPassword(email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase
          .createUserWithEmailAndPassword(email: _enteredEmail, password: _enteredPassword);
        await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
            'firstname': _enteredFirstName,
            'lastname': _enteredLastName,
            'username': _enteredUsername,
            'email': _enteredEmail,
          });
      }
    } on FirebaseAuthException catch(error) {
      if (error.code == 'email-already-in-use') {
        //
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authenticaled failed. Please try again later'))
        );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 2, 166, 195),
              Color.fromARGB(255, 8, 121, 155),
            ],
            begin: AlignmentGeometry.bottomLeft,
            end: AlignmentGeometry.topRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10, left: 24, right: 24),
                width: 150,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'First Name'
                              ),
                              autocorrect: false,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter first name';
                                }
                              return null;
                              },
                              onSaved: (value) {
                                _enteredFirstName = value!;
                              },
                            ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Last Name'
                              ),
                              autocorrect: false,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter last name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredLastName = value!;
                              },
                            ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Username'
                              ),
                              autocorrect: false,
                              enableSuggestions: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty || value.trim().length < 4) {
                                  return 'Please enter at least 4 characters';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address'
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            enableSuggestions: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password'
                            ),
                            obscureText: true,
                            autocorrect: false,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          if (_isAuthenticating)
                            CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.primaryContainer
                              ),
                              child: Text(_isLogin ? 'Sign In' : 'Sign Up'),
                            ),
                          if (!_isAuthenticating)  
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                            }, 
                            child: Text(_isLogin ? 'Create an account' : 'I already have an account. Sign In')
                          )
                        ]
                      )
                    )
                  )
                )
              ),
              const SizedBox(height: 48),
            ],
          )
        )
      ),
      ) 
    );
  }
}