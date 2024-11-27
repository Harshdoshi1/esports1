import 'package:flutter/material.dart';
import './home.dart';
import 'create.dart'; // Import HomePage for navigation

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int _selectedIndex = 1; // Default to "Community" page

  // Handle item selection in BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Navigate to the HomePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(videos: [])),
      );
    } else if (index == 1) {
      // Stay on the CommunityPage
      return;
    } else if (index == 2) {
      // Navigate to the CreatePage (Replace with your actual CreatePage)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreatePage()), // Make sure CreatePage exists
      );
    } else {
      // Navigate to Account page (replace with actual AccountPage)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search Community...',
              prefixIcon: Icon(Icons.search, color: Colors.black54),
              border: InputBorder.none,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          buildCard(
            game: "BGMI",
            organizer: "Soul Esports",
            time: "12:00 PM - 12:30 PM",
            entryFee: "10 rs",
            prizePool: "899 rs",
            players: "25/100",
          ),
          const SizedBox(height: 10),
          buildCard(
            game: "PUBG",
            organizer: "GodL Esports",
            time: "01:00 PM - 01:30 PM",
            entryFee: "20 rs",
            prizePool: "1889 rs",
            players: "25/100",
          ),
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

  Widget buildCard({
    required String game,
    required String organizer,
    required String time,
    required String entryFee,
    required String prizePool,
    required String players,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.grey[300],
                height: 60,
                width: 60,
                child: const Icon(Icons.videogame_asset, size: 30),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Organized by: $organizer",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    "Time: $time",
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    "Entry Fee: $entryFee",
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    "Prize Pool: $prizePool",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  players,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Join'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
