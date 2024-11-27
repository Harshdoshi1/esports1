// video_upload_helper.dart

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class VideoUploadHelper {

  // Request permission
  Future<bool> requestPermissions() async {
    PermissionStatus status = await Permission.storage.request();
    return status.isGranted;
  }

  // Pick video
  Future<File?> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      String filePath = result.files.single.path!;
      return File(filePath);
    }
    return null;
  }

  // Upload video to Firebase
  Future<String?> uploadVideo(File videoFile) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("videos/${DateTime.now().millisecondsSinceEpoch}.mp4");
      UploadTask uploadTask = ref.putFile(videoFile);

      await uploadTask.whenComplete(() async {
        String videoUrl = await ref.getDownloadURL();
        return videoUrl;
      });
    } catch (e) {
      print("Error uploading video: $e");
      return null;
    }
    return null;
  }

  // Pick thumbnail
  Future<File?> pickThumbnail() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
