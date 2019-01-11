import 'dart:async';
import 'package:todo_app/model/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class crudMedthods {
  // bool isLoggedIn() {
  //   if (FirebaseAuth.instance.currentUser() != null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<void> addData(document, [String collectionName]) async {
    String collection;
    if (collectionName != null) {
      collection = collectionName;
    } else {
      collection = "expenses";
    }
    // if (isLoggedIn()) {
    Firestore.instance.collection(collection).add(document).catchError((e) {
      print(e);
    });
    //Using Transactions
    // Firestore.instance.runTransaction((Transaction crudTransaction) async {
    //   CollectionReference reference =
    //       await Firestore.instance.collection('testcrud');

    //   reference.add(carData);
    // });
    // } else {
    //   print('You need to be logged in');
    // }
  }

  getData([String collectionName]) async {
    String collection;
    if (collectionName != null) {
      collection = collectionName;
    } else {
      collection = "expenses";
    }

    return await Firestore.instance.collection(collection).snapshots();
  }

  updateData(selectedDocId, newValues, [String collectionName]) {
    String collection;
    if (collectionName != null) {
      collection = collectionName;
    } else {
      collection = "expenses";
    }

    Firestore.instance
        .collection(collection)
        .document(selectedDocId)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(docId, [String collectionName]) {
    String collection;
    if (collectionName != null) {
      collection = collectionName;
    } else {
      collection = "expenses";
    }

    Firestore.instance
        .collection(collection)
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
