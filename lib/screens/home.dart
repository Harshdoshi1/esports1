import 'package:flutter/material.dart';
import 'create.dart'; // Import CreatePage here

class HomePage extends StatefulWidget {
  final List<Map<String, String>> videos; // Accept list of video data

  const HomePage({super.key, required this.videos}); // Constructor to receive videos

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Index of the active navigation bar item
  List<bool> isFollowing = [false, false]; // For two gamers in this example
  List<int> viewCounts = [0, 0]; // Initializing view count for each gamer

  // Handle item selection in BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 2) {
      // Navigate to CreatePage when "Create" is clicked
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreatePage()),
      ).then((newVideo) {
        if (newVideo != null) {
          // Add the new video data to the list and update the UI
          setState(() {
            widget.videos.add(newVideo);
          });
        }
      });
    }
  }

  // Increment view count for a video
  void _incrementViewCount(int index) {
    setState(() {
      viewCounts[index] += 1; // Increment the view count
    });
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
            ? [Center(child: Text("No videos yet!"))] // Display a message if there are no videos
            : widget.videos.map((video) {
                return buildVideoCard(video['title']!, video['thumbnail']!, video['url']!);
              }).toList(),
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

  // Method to build the individual video card with title below video
  Widget buildVideoCard(String title, String thumbnailUrl, String videoUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // This is where you can add functionality for tapping the video
                print('Video tapped: $title');
                // You can add code to navigate to a video detail page or play video here
              },
              child: Image.network(
                thumbnailUrl,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            ),
            // Display video title below the image
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
                  Text('User'), // You can add username if needed
                  const Spacer(),
                  Text('Views: ${viewCounts[widget.videos.indexOf({'title': title, 'thumbnail': thumbnailUrl, 'url': videoUrl})]}'), // Display the current view count
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        // Simulate a follow/unfollow functionality here
                        isFollowing[0] = !isFollowing[0];
                      });
                    },
                    icon: Icon(
                      isFollowing[0] ? Icons.person_remove : Icons.person_add,
                      size: 16,
                    ),
                    label: Text(isFollowing[0] ? 'Following' : 'Follow'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: isFollowing[0]
                          ? const Color.fromARGB(255, 54, 162, 244)
                          : Colors.green,
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
