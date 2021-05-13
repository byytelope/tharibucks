import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tharibucks/models/drink.dart';
import 'package:tharibucks/screens/home/drink_tile.dart';

class DrinkList extends StatefulWidget {
  @override
  _DrinkListState createState() => _DrinkListState();
}

class _DrinkListState extends State<DrinkList> {
  @override
  Widget build(BuildContext context) {
    final drinks = Provider.of<List<Drink>>(context) ?? [];

    return ListView.builder(
      itemCount: drinks.length,
      itemBuilder: (context, i) {
        return DrinkTile(drink: drinks[i]);
      },
    );
  }
}
