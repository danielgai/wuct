//this is logic to
//interact with database
//and do things like fetch, delete, add, update data

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  //make reference object for collection within Firestore database
  //like a table in SQL database.
  //collection of records/documents

static final ref = FirebaseFirestore.instance.collection('teams');
    //static so we can access ref directly on firestore service class elsewjere
//in application if we need it without creating instance of class
//Recall, static properties and methods aren't accessed on instance of classes, on class itself.
}