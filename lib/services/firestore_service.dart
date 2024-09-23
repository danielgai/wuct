//this is logic to
//interact with database
//and do things like fetch, delete, add, update data

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wuct/pages/Teams/coach.dart';

class FirestoreService{
  //make reference object for collection within Firestore database
  //like a table in SQL database.
  //collection of records/documents

static final ref = FirebaseFirestore.instance.collection('coaches').withConverter(
    fromFirestore: Coach.fromFirestore,
    toFirestore: (Coach c, _)=> c.toFirestore());
    //static so we can access ref directly on firestore service class elsewjere
//in application if we need it without creating instance of class
//Recall, static properties and methods aren't accessed on instance of classes, on class itself.

//add a new coach
static Future<void> addCoach(Coach coach) async{
  await ref.doc(coach.id).set(coach);
  //not just doing ref.add because we want to use our own id, not the
  //firestore generated one??

  //will grab onto doc if id is there, if id not there, it will
  //add as we intend to do now

  //converters come in clutch, don't have to manually convert anything
  //doesn't matter that "coaches" collection doesn't exist yet
}

}