import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wuct/pages/Teams/teams.dart';

class Coach  {
  final String name;
  final String email;
  final String password;
  final Team? team;
  final String id;
 //_ (underscore) denotes private field only accessible within class
  //I have a String id for now in case we need that to access Coach in Firestore
  const Coach({
    Key? key,
    required this.name,
    required this.email,
    required this.password,
    required this.team,
    required this.id,
  }) ;
      //: super(key: key);
Map<String, dynamic> toFirestore(){
  return {
    //when we save a coach, we need to do in format savable to firestore database
    //do it with firebase sdk, using add or set method. They expect a map as argument
'name': name,
    'email': email,
  'password': password,
  //do not store password here, use Firebase authentication when you get to it (hashes)

    'team': team.toString()
    //might not be the best way to store this team data. Consider iterating
    //and trying to get an identifier. Maybe team name?

    //
  };
}


//character from firestore
factory Character.fromFirestore(
  DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions?options
    ) {

  //get data from snapshot
  final data = snapshot.data()!;
  //exclamation means we know this will not be null

  //make character instance
Coach coach = Coach(
  name: data['name'],
  email: data['email'],
  password: data['password'],
  id: snapshot.id,
  //the id is returned, inherent to Firestore. Not just something we made
  //even though we didn't save as field inside of map to Firstore, it comes back
  //as Document Snapshot (contained within).

  team: data['team'],
  //need to figure out how to store team

);

}

}
