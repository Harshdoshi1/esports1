import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images and videos
import 'dart:io'; // For file operations
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage
import 'package:path/path.dart' as path; // To get the file name from the path
import './home.dart';
import 'community.dart'; // Import HomePage for navigation

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _videoTitleController = TextEditingController();
  File? _videoFile; // Holds the video file
  File? _thumbnailFile; // Holds the thumbnail image file
  bool _isUploading = false; // Upload status
  int _selectedIndex = 2; // Default to "Create" page

  // Video picker
  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  // Thumbnail picker
  Future<void> _pickThumbnail() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _thumbnailFile = File(pickedFile.path);
      });
    }
  }

  // File upload to Firebase
  Future<void> _uploadFiles(BuildContext context) async {
    if (_videoFile == null || _thumbnailFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a video and thumbnail.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload video to Firebase Storage
      final videoFileName = path.basename(_videoFile!.path); // Get file name from path
      final videoRef = FirebaseStorage.instance.ref().child('videos/$videoFileName');
      await videoRef.putFile(_videoFile!); // Upload the video
      final videoUrl = await videoRef.getDownloadURL(); // Get video URL after upload

      // Upload thumbnail to Firebase Storage
      final thumbnailFileName = path.basename(_thumbnailFile!.path); // Get thumbnail file name
      final thumbnailRef = FirebaseStorage.instance.ref().child('thumbnails/$thumbnailFileName');
      await thumbnailRef.putFile(_thumbnailFile!); // Upload the thumbnail
      final thumbnailUrl = await thumbnailRef.getDownloadURL(); // Get thumbnail URL after upload

      // Navigate back to HomePage and pass the new video data
      Navigator.pop(context, {
        'title': _videoTitleController.text,
        'thumbnail': thumbnailUrl,
        'url': videoUrl,
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading video: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Handle item selection in BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      // Navigate to CommunityPage when "Community" is clicked
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CommunityPage()),
      );
    } else if (index == 2) {
      // Stay on the "Create" page
      return;
    } 
    else {
      // Navigate to HomePage when Home or other tab is clicked
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(videos: [])), // Pass appropriate data
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Video'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _videoTitleController,
              decoration: const InputDecoration(
                labelText: 'Video Title',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickVideo,
              child: const Text('Pick Video'),
            ),
            const SizedBox(height: 10),
            _videoFile != null
                ? Text('Video Selected: ${_videoFile!.path.split('/').last}')
                : const Text('No video selected'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickThumbnail,
              child: const Text('Pick Thumbnail'),
            ),
            const SizedBox(height: 10),
            _thumbnailFile != null
                ? Text('Thumbnail Selected: ${_thumbnailFile!.path.split('/').last}')
                : const Text('No thumbnail selected'),
            const SizedBox(height: 20),
            _isUploading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _uploadFiles(context),
                    child: const Text('Upload Video'),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Active icon color
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
