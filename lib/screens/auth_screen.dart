import 'package:flutter/material.dart';
import 'package:proapptive/models/http_exception.dart';
import 'package:proapptive/providers/auth.dart';
import 'package:provider/provider.dart';

enum AuthMode {
  Login,
  Signup,
}

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _imageAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 2,
      ),
    );

    _imageAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.2,
          0.4,
          curve: Curves.easeIn,
        ),
      ),
    );

    _slideAnimation = Tween(
      begin: Offset(0, 20),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      //bottom: 20.0,
                      right: 20.0,
                      left: 20.0,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 30.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                    ),
                    child: FadeTransition(
                      opacity: _imageAnimation,
                      child: Container(
                        height: deviceSize.height * 0.35,
                        padding: EdgeInsets.only(top: 50),
                        child: Image.asset(
                          'assets/images/original.png',
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: AuthCard(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  AuthCard({Key key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLoading = false;

  final _passwordController = TextEditingController();

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;
  FocusNode _password = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linearToEaseOut,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpCustomException catch (error) {
      print('caught it:' + error.toString());
      String errorMessage = 'Autenticación falló\n';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage += 'Email ya está en uso';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage += 'Email invalido';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage += 'Contraseña muy débil';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage += 'Email o contraseña incorrecta';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage += 'No se encontró el email';
      }
      _showErrorDialog(errorMessage);
    } catch (err) {
      final errorMessage = 'No se pudo autenticar.\nIntente de nuevo más tarde';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ocurrió un error'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
      height: _authMode == AuthMode.Signup
          ? deviceSize.height * 0.525
          : deviceSize.height * 0.38,
      constraints: BoxConstraints(
        minHeight: _authMode == AuthMode.Signup
            ? deviceSize.height * 0.525
            : deviceSize.height * 0.38,
      ),
      margin: EdgeInsets.only(bottom: 30),
      width: deviceSize.width * 0.8,
      padding: EdgeInsets.only(
        top: 10,
        right: 10,
        left: 10,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.trim().isEmpty || (!value.contains('@'))) {
                    return 'Email inválido';
                  }
                  if (!(value.trim().endsWith('@kof.com.mx'))) {
                    return 'Solo dominios de Coca-Cola FEMSA';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value.trim();
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_password);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                ),
                style: TextStyle(color: Colors.black),
                obscureText: true,
                controller: _passwordController,
                focusNode: _password,
                validator: (value) {
                  if (value.isEmpty || value.length < 0) {
                    return 'Muy corta';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
              AnimatedContainer(
                duration: Duration(
                  milliseconds: 500,
                ),
                curve: Curves.easeIn,
                constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.Signup
                      ? deviceSize.height * 0.15
                      : deviceSize.height * 0.01,
                  maxHeight: _authMode == AuthMode.Signup
                      ? deviceSize.height * 0.25
                      : deviceSize.height * 0.01,
                ),
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            enabled: _authMode == AuthMode.Signup,
                            decoration: InputDecoration(
                              labelText: 'Confirmar',
                            ),
                            style: TextStyle(color: Colors.black),
                            obscureText: true,
                            validator: _authMode == AuthMode.Signup
                                ? (value) {
                                    if (value != _passwordController.text) {
                                      return 'No coinciden';
                                    }
                                    return null;
                                  }
                                : null,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  child: Text(
                    _authMode == AuthMode.Signup ? 'Registrarse' : 'Ingresar',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: _submit,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  ),
                  color: Theme.of(context).buttonColor,
                  textColor: Colors.white,
                ),
              if (!_isLoading)
                FlatButton(
                  child: Text(
                    _authMode == AuthMode.Signup ? 'Ingresar' : 'Registrarse',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 4,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).buttonColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
