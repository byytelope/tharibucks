import 'package:flutter/material.dart';

import 'package:tharibucks/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  Map emailData = {
    'value': '',
    'firebaseError': '',
  };
  Map passwordData = {
    'value': '',
    'firebaseError': '',
  };

  bool loading = false;

  bool _disableButton() {
    if (emailData['value'].isEmpty ||
        passwordData['value'].isEmpty ||
        loading) {
      return true;
    } else
      return false;
  }

  void _submitForm() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
        emailData['firebaseError'] = '';
        passwordData['firebaseError'] = '';
      });
      List res = await _auth.signInWithEmailPass(
          email: emailData['value'], password: passwordData['value']);
      Map err = await res[1];
      if (err != null) {
        setState(() {
          loading = false;
        });
        if (err['errType'] == 'email') {
          setState(() {
            emailData['firebaseError'] = err['errMsg'];
          });
        } else if (err['errType'] == 'password') {
          setState(() {
            passwordData['firebaseError'] = err['errMsg'];
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Sign In'),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz_outlined),
            onPressed: () => widget.toggleView(),
            splashRadius: 22,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: !emailData['firebaseError'].isEmpty
                      ? emailData['firebaseError']
                      : null,
                ),
                onChanged: (val) {
                  setState(() {
                    emailData['value'] = val;
                  });
                },
                onFieldSubmitted: (val) => _submitForm(),
                validator: (val) =>
                    val.isEmpty ? 'Email should not be empty.' : null,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: !passwordData['firebaseError'].isEmpty
                      ? passwordData['firebaseError']
                      : null,
                ),
                onChanged: (val) {
                  setState(() {
                    passwordData['value'] = val;
                  });
                },
                onFieldSubmitted: (val) => _submitForm(),
                validator: (val) =>
                    val.isEmpty ? 'Password should not be empty.' : null,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: loading
                    ? SizedBox(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.grey[500],
                          ),
                        ),
                        height: 20,
                        width: 20,
                      )
                    : Text('Sign In'),
                onPressed: _disableButton() ? null : () => _submitForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
