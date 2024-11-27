import 'package:flutter/material.dart';
import 'create.dart'; // Import CreatePage here
import 'community.dart'; // Import CommunityPage here

class HomePage extends StatefulWidget {
  final List<Map<String, String>> videos;

  const HomePage({super.key, required this.videos});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      // Navigate to CommunityPage when "Community" is clicked
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CommunityPage()),
      );
    } else if (index == 2) {
      // Navigate to CreatePage when "Create" is clicked
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreatePage()),
      ).then((newVideo) {
        if (newVideo != null) {
          setState(() {
            widget.videos.add(newVideo);
          });
        }
      });
    } else {
      // Handle other navigation
      setState(() {
        _selectedIndex = index;
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
              hintText: 'Gamer..Videos',
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
      body: ListView(
        children: widget.videos.isEmpty
            ? [const Center(child: Text("No videos yet!"))]
            : widget.videos.map((video) {
                return buildVideoCard(video['title']!, video['thumbnail']!, video['url']!);
              }).toList(),
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

  Widget buildVideoCard(String title, String thumbnailUrl, String videoUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                print('Video tapped: $title');
              },
              child: Image.network(
                thumbnailUrl,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Text('User'),
                  const Spacer(),
                  const Text('Views: 0'),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person_add, size: 16),
                    label: const Text('Follow'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
