import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tharibucks/models/user.dart';
import 'package:tharibucks/screens/authenticate/authenticate.dart';
import 'package:tharibucks/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
