import 'package:flutter/material.dart';
import 'package:wuct/services/constants.dart';
import 'package:wuct/shared/custom_app_bar.dart';

class MapMenuPage extends StatefulWidget {
  const MapMenuPage({super.key});

  @override
  State<MapMenuPage> createState() => _MapMenuPageState();
}

class _MapMenuPageState extends State<MapMenuPage> {

  String query = ""; // User's search query

  @override
  Widget build(BuildContext context) {
    // Filtered list based on the query
    final filteredLocations = mapLocations.entries
        .where((entry) => entry.key.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 160, 233, 162),
      appBar: const CustomAppBar(
        label: 'Locations',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search for a location...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  query = value; // Update the query
                });
              },
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: filteredLocations.length,
            itemBuilder: (context, index) {
              final entry = filteredLocations[index];
              return Column(
                children: [
                  ListTile(
                    title: Text(entry.key),
                    onTap: () {
                      Navigator.pop(context, [entry.value, entry.key]);
                      print(entry.value);
                    },
                  ),
                  const Divider(
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Colors.green,
                  )
                ],
              );
            },
          )),
        ],
      ),
    );
  }
}
