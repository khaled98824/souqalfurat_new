// @dart=2.9

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth.dart';
import '../models/http_exception.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth-screen';
  @override
  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'التسجيل',
            style: TextStyle(fontFamily: 'Montserrat-Arabic Regular'),
          ),
          backgroundColor: Color.fromRGBO(243, 110, 41, 1),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(243, 110, 41, 0.5),
                      Color.fromRGBO(239, 71, 35, 0.9)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1]),
              ),
              child: SingleChildScrollView(
                child: Container(
                  height: devicesize.height,
                  width: devicesize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image.asset('assets/images/1024.jpg'),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 95),
                          transform: Matrix4.rotationZ(-8 * pi / 180)
                            ..translate(-10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.deepOrange.shade800,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.black26,
                                    offset: Offset(0, 4))
                              ]),
                          child: Text('سوق الفرات',
                              style: TextStyle(fontSize: 32,fontFamily: 'Montserrat-Arabic Regular',color: Colors.white)),
                        ),
                      ), 
                      Flexible(
                        flex: devicesize.width > 600 ? 1.5 : 1,
                        child: AuthCard(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { Login, SignUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formlKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'area': ''
  };

  var _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 400), () {
      autoFillFields();
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.15),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  autoFillFields() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('info')) return false;

    final extractedData =
        json.decode(prefs.getString('info')) as Map<String, Object>;
    setState(() {
      _emailController = TextEditingController(text: extractedData['email']);
      _passwordController =
          TextEditingController(text: extractedData['password']);
    });
  }

  Future<void> _submit() async {
    print('sup1');
    if (!_formlKey.currentState.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formlKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).logIn(
          _authData['email'],
          _authData['password'],
        );
      }
      await Provider.of<Auth>(context, listen: false).signUp(
        _authData['email'],
        _authData['password'],
        _authData['name'],
        _authData['area'],
      );
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';

      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'EMAIL IS ALREADY USE';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'invalid email';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'weak password';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'invalid PASSWORD';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find user with that email';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      const errorMessage = 'PLEASE TRY AGAIN LATER';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _passwordController.dispose();
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('An Error Occurred !'),
        content: Text(errorMessage),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(microseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.SignUp ? 777 : 230,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.SignUp ? 777 : 250,
          maxHeight: _authMode == AuthMode.SignUp ? 888 : 280,
        ),
        width: devicesize.width * 0.75,
        padding: EdgeInsets.only(top: 5, right: 20, left: 20),
        child: Form(
          key: _formlKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                    decoration: InputDecoration(labelText: 'E-mail'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val.isEmpty || !val.contains('@')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _authData['email'] = val;
                    }),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: _passwordController,
                    obscureText: true,
                    validator: (val) {
                      if (val.isEmpty || val.length < 5) {
                        return 'Invalid Sort Password';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _authData['password'] = val;
                    }),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 50 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 50 : 0,
                  ),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
                          enabled: true,
                          controller: _emailController,
                          validator: AuthMode == AuthMode.SignUp
                              ? (val) {
                                  if (val != _passwordController.text) {
                                    return ' Password do not Match';
                                  }
                                  return null;
                                }
                              : null,
                          onSaved: (val) {
                            _authData['pa'] = val;
                          }),
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 50 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 50 : 0,
                  ),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Enter Yor Name'),
                          enabled: true,
                          validator: AuthMode == AuthMode.SignUp
                              ? (val) {
                                  if (val.length < 4) {
                                    return 'name so short';
                                  }
                                  return null;
                                }
                              : null,
                          onSaved: (val) {
                            _authData['name'] = val;
                          }),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 50 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 50 : 0,
                  ),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Enter Your Area'),
                          enabled: true,
                          validator: AuthMode == AuthMode.SignUp
                              ? (val) {
                                  if (val.length < 4) {
                                    return ' area so short';
                                  }
                                  return null;
                                }
                              : null,
                          onSaved: (val) {
                            _authData['area'] = val;
                          }),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                if (_isLoading) CircularProgressIndicator(),
                RaisedButton(
                  child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP'),
                  onPressed: _submit,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.bodyText2.color,
                ),
                FlatButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  textColor: Colors.black.withOpacity(0.6),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
