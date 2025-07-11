import 'package:flutter/material.dart';
import 'ai_tutor.dart';
import 'focus_mode_page.dart'; // Import the Focus Mode page
import 'my_learning_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// Add a global key for navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _HomePageState extends State<HomePage> {
  String? _selectedPreference; // Initialize as null to avoid the initial value error

  // Dummy list of subjects for demonstration
  List<String> subjectNames = [
    'Maths', 'Science', 'History', 'Language', 'Arts',
    'Geography', 'Music', 'Computer', 'Physics', 'Biology',
  ];

  // Example data placeholders for recommended videos
  List<String> videoTitles = [
    'C++ Basics in One Shot - Strivers A2Z DSA Course - L1',
    'Introduction to JavaScript + Setup | JavaScript Tutorial in Hindi #1',
    'Python Tutorial for Beginners | Learn Python in 1.5 Hours',
    'ApnaCollegeOfficial which Coding Platform should I study from?',
    'Web Development Tutorial for Beginners (2024 Edition)',
  ];

  List<String> videoImageUrls = [
    'https://th.bing.com/th/id/OIP.0STrpvtmnpiN8MxYI-xUPwAAAA?rs=1&pid=ImgDetMain',
    'https://www.codewithharry.com/_next/image/?url=https:%2F%2Fcwh-full-next-space.fra1.digitaloceanspaces.com%2Fvideoseries%2Fultimate-js-tutorial-hindi-1%2FJS-Thumb.jpg&w=828&q=75',
    'https://th.bing.com/th/id/OIP.raiOFsxSpMFzOFwa2TXUmQAAAA?rs=1&pid=ImgDetMain',
    'https://i.ytimg.com/vi/qTph1pj_rCo/maxresdefault.jpg',
    'https://www.someurl.com/your-image4.jpg',
  ];

  int _selectedIndex = 0;

  // Add a map for recommendations
  Map<String, List<Map<String, String>>> recommendations = {
    'Visual': [
      {'title': 'Visual Learning Techniques', 'image': 'https://i.imgur.com/1.jpg'},
      {'title': 'Mind Mapping for Visual Learners', 'image': 'https://i.imgur.com/2.jpg'},
    ],
    'Auditory': [
      {'title': 'Auditory Study Tips', 'image': 'https://i.imgur.com/3.jpg'},
      {'title': 'Podcasts for Learning', 'image': 'https://i.imgur.com/4.jpg'},
    ],
    'Reading/Writing': [
      {'title': 'Effective Note Taking', 'image': 'https://i.imgur.com/5.jpg'},
      {'title': 'Reading Strategies', 'image': 'https://i.imgur.com/6.jpg'},
    ],
    'Kinesthetic': [
      {'title': 'Hands-on Science Experiments', 'image': 'https://i.imgur.com/7.jpg'},
      {'title': 'Active Learning Activities', 'image': 'https://i.imgur.com/8.jpg'},
    ],
  };

  List<String> completedSubjects = [];
  List<String> watchedVideos = [];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      completedSubjects = prefs.getStringList('completed_subjects') ?? [];
      watchedVideos = prefs.getStringList('watched_videos') ?? [];
    });
  }

  Future<void> _markSubjectCompleted(String subject) async {
    if (!completedSubjects.contains(subject)) {
      setState(() {
        completedSubjects.add(subject);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completed_subjects', completedSubjects);
      // Optionally, add to completed courses in MyLearningPage
      final completedCourse = {
        'name': subject + ' Mastery',
        'subject': subject,
        'duration': 10.0,
        'completedDate': DateTime.now().toIso8601String(),
        'grade': 'A',
      };
      List<String> completedCourses = prefs.getStringList('completed_courses') ?? [];
      completedCourses.add(jsonEncode(completedCourse));
      await prefs.setStringList('completed_courses', completedCourses);
    }
  }

  Future<void> _markVideoWatched(String videoTitle) async {
    if (!watchedVideos.contains(videoTitle)) {
      setState(() {
        watchedVideos.add(videoTitle);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('watched_videos', watchedVideos);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
      // Navigate to Home (current page)
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyLearningPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AiTutorPage()),
        );
        break;
    }
  }

  void _navigateToFocusMode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FocusModePage()),
    );
  }

  TextEditingController _taskController = TextEditingController();
  List<String> tasks = [];

  void _addTask(String task) {
    setState(() {
      tasks.add(task);
      _taskController.clear(); // Clear input field after adding task
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF48A9A6),
        title: Text('EduAI'),
        actions: [
          /*IconButton(
            icon: Image.asset(
              'lib/assets/profile_icon.jpg', // Replace with your asset image path
              width: 30,
              height: 30,
            ),
            onPressed: () {
              // Navigate to profile screen or show profile menu
            },
          ),*/
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF48A9A6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('lib/assets/profile_icon.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Harshita', // Replace with user's name
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Handle navigation to settings
              },
            ),
            ListTile(
              title: Text('FAQ'),
              onTap: () {
                // Handle navigation to FAQ
              },
            ),
            // Add more list items as needed
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search courses',
                        suffixStyle: TextStyle(color: Color(0xFF531002)),
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Adjust spacing between search bar and dropdown button
                  DropdownButton<String>(
                    hint: Text(
                      'Preference',
                      style: TextStyle(color: Color(0xFF531002)),
                    ),
                    value: _selectedPreference,
                    items: ['Visual', 'Auditory', 'Reading/Writing', 'Kinesthetic']
                        .map((String preference) {
                      return DropdownMenuItem<String>(
                        value: preference,
                        child: Text(
                          preference,
                          style: TextStyle(color: Colors.black87), // Adjust text color
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPreference = newValue;
                      });
                      // Implement logic to filter based on preference
                    },
                    icon: Icon(Icons.arrow_drop_down),
                    underline: Container(),
                    elevation: 0,
                    style: TextStyle(color: Color(0xFFFDB8AF)), // Set dropdown button text color
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Recommended for you',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF002131)),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendations[_selectedPreference]?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    final rec = recommendations[_selectedPreference]![index];
                    bool isWatched = watchedVideos.contains(rec['title']);
                    return Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: 200,
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                child: Image.network(
                                  rec['image']!,
                                  width: 200,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        rec['title']!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(isWatched ? Icons.check_circle : Icons.visibility),
                                      color: isWatched ? Colors.green : Color(0xFF48A9A6),
                                      onPressed: isWatched ? null : () => _markVideoWatched(rec['title']!),
                                      tooltip: isWatched ? 'Watched' : 'Mark as Watched',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Subjects',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF002131)),
              ),
              SizedBox(height: 10),
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: subjectNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    String subjectName = subjectNames[index];
                    bool isCompleted = completedSubjects.contains(subjectName);
                    return Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: 150,
                        child: Card(
                          color: isCompleted ? Colors.green[100] : Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.book,
                                  size: 40,
                                  color: isCompleted ? Colors.green : Color(0xFF48A9A6),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  subjectName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: isCompleted ? null : () => _markSubjectCompleted(subjectName),
                                  child: Text(isCompleted ? 'Completed' : 'Mark Completed'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isCompleted ? Colors.green : Color(0xFF48A9A6),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your Tasks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF002131)),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: 'Enter task',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _addTask(_taskController.text.trim());
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tasks[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTask(index);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          color: Color(0xFF48A9A6),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white, // Color of selected item's icon and text
          unselectedItemColor: Colors.white.withOpacity(0.6), // Color of unselected item's icon and text
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'My Learning',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'AI Tutor',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToFocusMode,
        backgroundColor: Color(0xFF48A9A6), // Change the background color of the floating action button
        tooltip: 'Focus Mode',
        child: Icon(Icons.timer, color: Colors.white), // Change the color of the icon
      ),
    );
  }
}
