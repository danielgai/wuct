import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService with ChangeNotifier {
  //firebase storage
  final firebaseStorage = FirebaseStorage.instance;

  //images are stored in firebase as download URLs
  List<String> _imageUrls = [];
  bool _isLoading = false;
  bool _isUploading = false;
  //loading status

  //uploading status

  //getters
  List<String> get getImageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  //delete image

  //upload image
}
