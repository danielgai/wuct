import 'package:flutter/material.dart';
import 'package:wuct/pages/map_page.dart';

void main(){
  runApp(const CampusMap());
}

class CampusMap extends StatelessWidget {
  const CampusMap({super.key}); // Corrected constructor syntax

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Campus Map',
      home: MapPage(),
    );
  }
}
