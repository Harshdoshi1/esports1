import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images
import 'dart:io'; // For file operations
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage
import 'package:path/path.dart' as path;

import 'home.dart'; // For getting file names

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  int _selectedIndex = 2; // Set the default selected tab to "Create"
  TextEditingController _videoTitleController = TextEditingController();
  File? _videoFile; // Holds the video file
  File? _thumbnailFile; // Holds the thumbnail image file
  bool _isUploading = false; // Upload status

  // Navigation handler
  void _onItemTapped(int index) {
    if (index == 0) {
      // Redirect to Home Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

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
      final videoFileName = path.basename(_videoFile!.path); // Correct usage of basename
      final videoRef = FirebaseStorage.instance.ref().child('videos/$videoFileName');
      await videoRef.putFile(_videoFile!);
      final videoUrl = await videoRef.getDownloadURL();

      // Upload thumbnail to Firebase Storage
      final thumbnailFileName = path.basename(_thumbnailFile!.path);
      final thumbnailRef = FirebaseStorage.instance.ref().child('thumbnails/$thumbnailFileName');
      await thumbnailRef.putFile(_thumbnailFile!);
      final thumbnailUrl = await thumbnailRef.getDownloadURL();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video and thumbnail uploaded successfully!')),
      );

      // Reset state after upload
      setState(() {
        _videoFile = null;
        _thumbnailFile = null;
        _videoTitleController.clear();
      });

      print('Video URL: $videoUrl');
      print('Thumbnail URL: $thumbnailUrl');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: SizedBox(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 116, 116, 116)),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Video',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickVideo,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: _videoFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.upload_file, size: 40, color: Colors.grey),
                              Text(
                                'Tap to upload video',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                        : Text('Video selected: ${path.basename(_videoFile!.path)}'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Add Video Title'),
              const SizedBox(height: 10),
              TextField(
                controller: _videoTitleController,
                decoration: InputDecoration(
                  hintText: 'Enter a title for your video',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Upload Thumbnail',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickThumbnail,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _thumbnailFile == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.image, size: 40, color: Colors.grey),
                              SizedBox(height: 10),
                              Text(
                                'Tap to upload thumbnail',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : Image.file(
                          _thumbnailFile!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUploading ? null : () => _uploadFiles(context),
                child: _isUploading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Add'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
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
