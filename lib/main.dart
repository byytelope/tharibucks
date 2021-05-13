import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:tharibucks/models/user.dart';
import 'package:tharibucks/screens/wrapper.dart';
import 'package:tharibucks/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
          ),
          primarySwatch: Colors.brown,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            errorMaxLines: 2,
          ),
        ),
      ),
    );
  }
}
