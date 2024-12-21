import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wuct/services/auth_service.dart';

class StorageService {
  //firebase storage
  static final firebaseStorage = FirebaseStorage.instance;

  //images are stored in firebase as download URLs

  //delete image

  static Future<void> deleteImage(String imageUrl, String userId) async {
    try {
      final String path = extractPathFromUrl(imageUrl);
      await AuthService.changeValue(userId, "scheduleImageURL", "");
      await firebaseStorage.ref(path).delete();
    } catch (err) {
      print("Error deleting image: $err");
    }
  }

  //upload image
  static Future<void> uploadImage(String userId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return; //user cancelled the picker

    File file = File(image.path);
    String safeTimeString =
        DateTime.now().toIso8601String().replaceAll(':', '-');
    String filePath = 'schedules/$safeTimeString.png';

    try {
      //define the path in storage

      //upload the file to firebase storage
      await firebaseStorage.ref(filePath).putFile(file);
      // You can also inspect uploadTask for more info, e.g. uploadTask.state
      final downloadUrl = await firebaseStorage.ref(filePath).getDownloadURL();
      //put this new download URL in firebase storage
      await AuthService.changeValue(userId, "scheduleImageURL", downloadUrl);
    } catch (err) {
      print("Error uploading: $err");
    }
  }

  static String extractPathFromUrl(String url) {
    Uri uri = Uri.parse(url);
    String encodedPath = uri.pathSegments.last;
    return Uri.decodeComponent(encodedPath);
  }
}
