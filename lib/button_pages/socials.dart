// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class Socials extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Follow Us'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: Image.asset('assets/youtube_icon.png'), // Change the asset path
//               iconSize: 50,
//               onPressed: () => _launchUrl('https://www.youtube.com/yourPage'),
//             ),
//             IconButton(
//               icon: Image.asset('assets/twitter_icon.png'), // Change the asset path
//               iconSize: 50,
//               onPressed: () => _launchUrl('https://twitter.com/yourPage'),
//             ),
//             IconButton(
//               icon: Image.asset('assets/instagram_icon.png'), // Change the asset path
//               iconSize: 50,
//               onPressed: () => _launchUrl('https://www.instagram.com/yourPage'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Function to launch URLs
//   void _launchUrl(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       // If the URL can't be launched, handle the error (e.g., show a message)
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Could not launch URL.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
