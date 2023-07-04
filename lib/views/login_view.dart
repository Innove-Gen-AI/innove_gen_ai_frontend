// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:innove_gen_ai_frontend/util/decoration_util.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with DecorationUtil {
  final TextEditingController _controller = TextEditingController();

  late String passValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          //Empty container for spacing
          Expanded(
              child: Container(
            width: 411,
            height: 823,
            child: Stack(
              children: [
                Positioned(
                  left: 25,
                  top: 293,
                  child: Container(
                    width: 360,
                    height: 450,
                    child: Stack(
                      children: [
                        //Login Box and text
                        Positioned(
                          left: 200,
                          top: 340,
                          child: TextButton(
                            onPressed: () {
                              print("button click");

                              // get password value from controller

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => withScreenDecoration(
                                    const Home(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              decoration: ShapeDecoration(
                                color: Color(0x002F80ED),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 0.50, color: Color(0xFF2F80ED)),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blueAccent.shade200,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),

                        //Login headline
                        Positioned(
                          left: 0,
                          top: 0,
                          child: SizedBox(
                            width: 338,
                            height: 67,
                            child: Text(
                              'Login',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                        ),
                        //Forgot password
                        Positioned(
                          left: 196,
                          top: 233,
                          child: SizedBox(
                            width: 161,
                            height: 34,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color(0xFF2F80ED),
                                fontSize: 14,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        //Username
                        Positioned(
                          left: 4,
                          top: 77,
                          child: SizedBox(
                            width: 338,
                            height: 20,
                            child: Text(
                              'Username',
                              style: TextStyle(
                                color: Color(0xFF2F80ED),
                                fontSize: 14,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        //Password
                        Positioned(
                          left: 4,
                          top: 158,
                          child: SizedBox(
                            width: 338,
                            height: 20,
                            child: Text(
                              'Password',
                              style: TextStyle(
                                color: Color(0xFF2F80ED),
                                fontSize: 14,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        //Username box
                        Positioned(
                          left: 4,
                          top: 99,
                          child: Container(
                            width: 309,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: Color(0x002F80ED),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFF2F80ED),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        //Set username
                        Positioned(
                          left: 20,
                          top: 109,
                          child: SizedBox(
                            width: 338,
                            height: 20,
                            child: Text(
                              'Innove Gen AI',
                              style: TextStyle(
                                color: Color(0xFF2F80ED),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        //Password box
                        Positioned(
                          left: 4,
                          top: 180,
                          child: Container(
                            width: 309,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: Color(0x002F80ED),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFF2F80ED),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        //Password input box
                        Positioned(
                          left: 19,
                          top: 174,
                          child: Container(
                            width: 280,
                            height: 40,
                            child: TextField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                color: Colors.blueAccent,
                              ),
                              controller: _controller,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ))
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
