import 'package:flutter/material.dart';
import 'create.dart'; // Import the CreatePage here

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Index of the active navigation bar item
  List<bool> isFollowing = [false, false]; // For two gamers in this example
  List<int> viewCounts = [0, 0]; // Initializing view count for each gamer

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 2) {
      // Navigate to CreatePage when "Create" is clicked
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreatePage()),
      );
    }
  }

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
        children: [
          buildGamerTile(0, 'Harsh', viewCounts[0], 'assets/images/bgmi1.jpg'),
          buildGamerTile(1, 'Malhar', viewCounts[1], 'assets/images/gtav.jpg'),
        ],
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

  // Method to build the individual gamer tile with title below video
  Widget buildGamerTile(int index, String username, int views, String imageUrl) {
    // Titles for the videos
    final titles = ['BGMI Video', 'GTA V Video'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _incrementViewCount(index), // Increment views when image is tapped
              child: Image.asset(
                imageUrl,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            ),
            // Display video title below the image
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                titles[index], // Display title based on index
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
                  Text(username),
                  const Spacer(),
                  Text('Views: $views'), // Display the current view count
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isFollowing[index] = !isFollowing[index];
                      });
                    },
                    icon: Icon(
                      isFollowing[index] ? Icons.person_remove : Icons.person_add,
                      size: 16,
                    ),
                    label: Text(isFollowing[index] ? 'Following' : 'Follow'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: isFollowing[index]
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
