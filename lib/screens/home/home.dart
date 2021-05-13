import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tharibucks/models/drink.dart';
import 'package:tharibucks/screens/home/settings_form.dart';
import 'package:tharibucks/screens/home/drink_list.dart';
import 'package:tharibucks/services/auth.dart';
import 'package:tharibucks/services/database.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  final DatabaseService _data = DatabaseService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (builder) {
            return new Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 60),
              child: SettingsForm(),
            );
          });
    }

    Future _checkFirstLogin() async {
      String name =
          await _data.getDrinkNameById(uid: _auth.getCurrentUserUid());
      if (name == null) {
        _showSettingsPanel();
      }
    }

    _checkFirstLogin();

    return StreamProvider<List<Drink>>.value(
      initialData: null,
      value: _data.drinks,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text('Tharibucks'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings_outlined),
              splashRadius: 22,
              onPressed: () => _showSettingsPanel(),
            ),
            IconButton(
              icon: Icon(Icons.logout),
              splashRadius: 22,
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: DrinkList(),
      ),
    );
  }
}
