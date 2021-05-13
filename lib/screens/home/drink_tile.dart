import 'package:flutter/material.dart';

import 'package:tharibucks/models/drink.dart';

class DrinkTile extends StatelessWidget {
  final Drink drink;

  DrinkTile({this.drink});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.grey[300],
            width: 1,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.brown[drink.strength],
            backgroundImage: AssetImage('assets/coffee_icon.png'),
          ),
          title: Text(drink.name),
          subtitle: Text('Takes ${drink.sugars} sugars'),
        ),
      ),
    );
  }
}
