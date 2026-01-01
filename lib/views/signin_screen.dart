import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pf_project/core/utils.dart';
import 'package:pf_project/views/helper%20%20widgets/custom_widgets.dart';
import 'package:pf_project/views/homepage.dart';
import 'package:pf_project/views/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() {
    return _SignInScreen();
  }
}

class _SignInScreen extends State<SignInScreen> {
  CustomWidgets form = CustomWidgets();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode buttonFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  bool obsecure = true;
  String? message;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double heightX = MediaQuery.of(context).size.height;
    double widthX = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff136a8a), Color(0xff57C785)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            shadowColor: Colors.black,
            elevation: 3,
            child: Container(
              height: heightX * 0.85,
              width: widthX * 0.35,
              decoration: BoxDecoration(color: Colors.white70),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 45),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/logo.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(height: heightX * 0.03),
                  Form(
                    key: _formKey,
                    child: SizedBox(
                      width: widthX * 0.3,
                      child: Column(
                        children: [
                          form.signInTf(
                            focus: emailFocus,
                            taction: TextInputAction.next,
                            onsubmitted: (p0) {
                              FocusScope.of(
                                context,
                              ).requestFocus(passwordFocus);
                            },
                            controller: emailController,
                            icon: Icon(Icons.email_outlined, size: 18),
                            hint: 'Enter email',
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Email is required!';
                              }
                              if (!EmailValidator.validate(p0.trim())) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: heightX * 0.03),
                          form.signInTf(
                            focus: passwordFocus,
                            taction: TextInputAction.next,
                            onsubmitted: (p0) {
                              FocusScope.of(context).requestFocus(buttonFocus);
                            },
                            controller: passwordController,
                            obsecure: obsecure,
                            icon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obsecure = !obsecure;
                                });
                              },
                              icon: obsecure
                                  ? Icon(Icons.visibility_outlined, size: 18)
                                  : Icon(
                                      Icons.visibility_off_outlined,
                                      size: 18,
                                    ),
                            ),
                            hint: 'Enter password',
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Password is required!';
                              }
                              return null;
                            },
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: heightX * 0.04),
                          SizedBox(
                            width: widthX * 0.2,
                            child: form.button(
                              text: Text(
                                "Sign In",
                                style: TextStyle(color: Colors.black),
                              ),
                              loading: isLoading,
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                setState(() {
                                  isLoading = true;
                                });
                                await Future.delayed(Duration(seconds: 3));
                                await signin(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                                isLoading = false;
                              },
                            ),
                          ),
                        ],
                      ),
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

  Future<void> signin(String email, String password) async {
    try {
      final result = await Process.run('program.exe', [
        'signIn',
        email,
        password,
      ], workingDirectory: Directory.current.path);

      final int decide = result.exitCode;
      debugPrint("Return code: ${decide.toString()}");

      switch (decide) {
        case 0:
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homepage()),
            );
            setState(() {
              message = "SignIn successfully!";
            });
          }
          break;
        case 2:
          {
            setState(() {
              message = "User not found!";
            });
          }
          break;
        case -1:
          {
            setState(() {
              message = "FOE-Unexpected Error!"; //file opening error
            });
          }
          break;
        case 5:
          {
            setState(() {
              message = "Unexpected Error!";
            });
          }
          break;

        default:
          {
            setState(() {
              message = "Internal error!";
            });
          }
      }
      Utils().flutterToast(message.toString(), context);
    } catch (e) {
      debugPrint("Process error: $e");
      setState(() {
        message = "Failed to connect backend!";
      });
    }
  }
}
