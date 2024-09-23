import 'package:flutter/material.dart';

class Team  {

  final int teamID;
  final List<String> competitors;
  final String name;
  final bool isTraditional;

  const Team({
    Key? key,
    required this.teamID,
    required this.competitors,
    required this.isTraditional,
    required this.name
  })
      //: super(key: key);


}
