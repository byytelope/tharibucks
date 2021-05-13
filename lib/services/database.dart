import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tharibucks/models/drink.dart';
import 'package:tharibucks/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference drinkCollection =
      FirebaseFirestore.instance.collection('drinks');

  List<Drink> _drinkListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => Drink(
              name: doc['name'] ?? '',
              sugars: doc['sugars'] ?? '0',
              strength: doc['strength'] ?? 100,
            ))
        .toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot['name'],
      sugars: snapshot['sugars'],
      strength: snapshot['strength'],
    );
  }

  Future updateUserData({String name, String sugars, int strength}) async {
    return await drinkCollection.doc(uid).set({
      'name': name,
      'sugars': sugars,
      'strength': strength,
    });
  }

  dynamic getDrinkNameById({String uid}) {
    return drinkCollection.doc(uid).get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map drink = snapshot.data();
        return drink['name'];
      } else {
        return null;
      }
    });
  }

  Stream<List<Drink>> get drinks {
    return drinkCollection.snapshots().map(_drinkListFromSnapshot);
  }

  Stream<UserData> get userData {
    return drinkCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
