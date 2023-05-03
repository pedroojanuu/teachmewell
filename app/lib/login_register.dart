import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teachmewell/faculty.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  // Login page
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFF2574A8), //#2574A8
        body: SingleChildScrollView(
            child: Column(
              children: [
                const Image(image: AssetImage('media/teachmewell_logo.png'),),
                TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.orange),
                      fillColor: Colors.white,
                      labelText: 'Email',
                    )
                ),
                const Padding(padding: EdgeInsets.only(top: 15.0)),
                TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.orange),
                      fillColor: Colors.white,
                      labelText: 'Password',
                    )
                ),
                TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;

                    if(email == '' || password == ''){
                      return;
                    }

                    try{
                      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        //print('No user found for that email.');
                        return;
                      } else if (e.code == 'wrong-password') {
                        //print('Wrong password provided for that user.');
                        return;
                      }
                    }
                    if(context.mounted) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Faculties()
                      ));
                    }
                  },
                  child: const Text('Login', style: TextStyle(color: Colors.white),),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RegisterPage()
                    ));
                  },
                  child: const Text('Registar', style: TextStyle(color: Colors.white),),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ForgotPassword()
                    ));
                  },
                  child: const Text('Esqueci-me da palavra-passe', style: TextStyle(color: Colors.white),),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Faculties()
                    ));
                  },
                  child: const Text('Entrar como convidado', style: TextStyle(color: Colors.white),),
                )
              ],
            )
        )
    );
  }
}

class RegisterPage extends StatefulWidget{
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  late final TextEditingController _up;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  @override
  void initState() {
    _up = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _up.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void createPopUp(int num) {
    String message = '';

    switch (num) {
      case 1:
        message = 'Todos os campos devem ser preenchidos';
        break;
      case 2:
        message = 'Insira um email @up.pt válido';
        break;
      case 3:
        message = 'O número UP é diferente do usado no email';
        break;
      case 4:
        message = 'A password deve ter entre 6 e 20 caracteres';
        break;
      case 5:
        message = 'As passwords não coincidem';
        break;
      case 6:
        message = 'Palavra-passe fraca';
        break;
      case 7:
        message = 'E-mail já em uso';
        break;
      case 8:
        message = 'Conta registada';
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  // Register page
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFF2574A8), //#2574A8
        appBar: AppBar(
          title: const Text('Registar'),
          backgroundColor: const Color(0xFF2574A8), //#2574A8
          shadowColor: const Color.fromARGB(48, 0, 0, 0),
        ),
        body: SingleChildScrollView(
            child : Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 15.0)),
                  SizedBox(
                    child: TextField(
                      controller: _up,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.orange),
                        fillColor: Colors.white,
                        labelText: 'UP',
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 25.0)),
                  SizedBox(
                    child: TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(color: Colors.orange),
                          fillColor: Colors.white,
                          labelText: 'Email (UP) -> up---------@up.pt',
                        )
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 25.0)),
                  SizedBox(
                    child: TextField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(color: Colors.orange),
                          fillColor: Colors.white,
                          labelText: 'Palavra-passe -> 6 a 20 caracteres',
                        )
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 25.0)),
                  SizedBox(
                    child: TextField(
                        controller: _confirmPassword,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(color: Colors.orange),
                          fillColor: Colors.white,
                          labelText: 'Confirmar Password',
                        )
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if(_up.text == '' || _email.text == '' || _password.text == '' || _confirmPassword.text == ''){
                        createPopUp(1);
                        return;
                      }
                      else if(_email.text.substring(11) != '@up.pt'){
                        createPopUp(2);
                        return;
                      }
                      else if(_up.text != _email.text.substring(2, 11)){
                        createPopUp(3);
                        return;
                      }
                      else if(_password.text.length < 6 || _password.text.length > 20){
                        createPopUp(4);
                        return;
                      }
                      else if(_password.text != _confirmPassword.text){
                        createPopUp(5);
                        return;
                      }
                      else{
                        final String up = _up.text;
                        final String email = _email.text;
                        final String password = _password.text;

                        try{
                          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
                            FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
                              'up': up,
                              'email': email,
                              'password': password,
                            });
                          });
                          createPopUp(8);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            createPopUp(6);
                            return;
                          } else if (e.code == 'email-already-in-use') {
                            createPopUp(7);
                            return;
                          }
                        }
                        if(context.mounted) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginPage()
                          ));
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        elevation: 4,
                        backgroundColor: Colors.blue),
                    child: const Text('Registar'),
                  ),
                ]
            )
        ));
  }
}

class ForgotPassword extends StatefulWidget{
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  // Forgot password page
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Esqueci-me da palavra-passe'),
        ),
        body: Column(
            children: [
              TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  )
              ),
              TextButton(
                onPressed: () async {

                  if(_email.text == ''){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Email vazio'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          )
                        ],
                      ),
                    );
                    return;
                  }

                  final String email = _email.text;

                  try{
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      //print('No user found for that email.');
                      return;
                    }
                  }
                  if(context.mounted) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginPage()
                    ));
                  }
                },
                child: const Text('Enviar email'),
              ),
            ]
        )
    );
  }
}
