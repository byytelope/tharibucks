import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tharibucks/models/user.dart';
import 'package:tharibucks/services/database.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List _sugars = ['0', '1', '2', '3', '4'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData;
          if (snapshot.hasData) {
            userData = snapshot.data;
          }

          bool _disableButton() {
            if (_currentName != null ||
                _currentSugars != null ||
                _currentStrength != null) {
              return false;
            } else
              return true;
          }

          void _submitForm() async {
            if (_formKey.currentState.validate()) {
              await DatabaseService(uid: user.uid).updateUserData(
                name: _currentName ?? userData.name,
                sugars: _currentSugars ?? userData.sugars,
                strength: _currentStrength ?? userData.strength,
              );
              Navigator.pop(context);
            }
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Update your drink preferences',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  initialValue: userData.name == null ? null : userData.name,
                  decoration: InputDecoration(
                    labelText: 'Your name',
                  ),
                  validator: (val) =>
                      val.isEmpty ? 'Please enter your name.' : null,
                  onChanged: (val) {
                    setState(() {
                      _currentName = val;
                    });
                  },
                  onFieldSubmitted: (val) => _submitForm(),
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Select sugars'),
                  value: _currentSugars ??
                      (snapshot.hasData ? userData.sugars : '0'),
                  items: _sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _currentSugars = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Drink strength'),
                Slider(
                  value: (_currentStrength ??
                          (snapshot.hasData ? userData.strength : 100.0))
                      .toDouble(),
                  activeColor: Colors.brown[_currentStrength ??
                      (snapshot.hasData ? userData.strength : 100)],
                  inactiveColor: Colors.grey[300],
                  min: 100,
                  max: 900,
                  divisions: 8,
                  onChanged: (val) {
                    setState(() {
                      _currentStrength = val.round();
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('Update'),
                  onPressed: _disableButton() ? null : () => _submitForm(),
                ),
              ],
            ),
          );
        });
  }
}
