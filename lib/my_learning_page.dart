import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyLearningPage extends StatefulWidget {
  @override
  _MyLearningPageState createState() => _MyLearningPageState();
}

class _MyLearningPageState extends State<MyLearningPage> {
  List<LearningSession> learningSessions = [];
  List<CompletedCourse> completedCourses = [];
  double totalStudyTime = 0;
  int totalSessions = 0;
  String learningStyle = "Visual"; // Default, should be fetched from user profile
  List<String> completedSubjects = [];
  List<String> watchedVideos = [];

  @override
  void initState() {
    super.initState();
    _loadLearningData();
  }

  Future<void> _loadLearningData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getStringList('learning_sessions') ?? [];
    final coursesJson = prefs.getStringList('completed_courses') ?? [];
    completedSubjects = prefs.getStringList('completed_subjects') ?? [];
    watchedVideos = prefs.getStringList('watched_videos') ?? [];
    setState(() {
      learningSessions = sessionsJson.map((json) => LearningSession.fromJson(jsonDecode(json))).toList();
      completedCourses = coursesJson.map((json) => CompletedCourse.fromJson(jsonDecode(json))).toList();
      totalStudyTime = learningSessions.fold(0, (sum, session) => sum + session.duration);
      totalSessions = learningSessions.length;
      learningStyle = prefs.getString('learning_style') ?? "Visual";
    });
  }

  Future<void> _addLearningSession(String subject, double duration) async {
    final session = LearningSession(
      subject: subject,
      duration: duration,
      date: DateTime.now(),
      notes: "Study session completed",
    );
    setState(() {
      learningSessions.add(session);
      totalStudyTime += duration;
      totalSessions++;
    });
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = learningSessions.map((session) => jsonEncode(session.toJson())).toList();
    await prefs.setStringList('learning_sessions', sessionsJson);
  }

  Future<void> _addCompletedCourse(String courseName, String subject, double duration) async {
    final course = CompletedCourse(
      name: courseName,
      subject: subject,
      duration: duration,
      completedDate: DateTime.now(),
      grade: "A",
    );
    setState(() {
      completedCourses.add(course);
    });
    final prefs = await SharedPreferences.getInstance();
    final coursesJson = completedCourses.map((course) => jsonEncode(course.toJson())).toList();
    await prefs.setStringList('completed_courses', coursesJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF48A9A6),
        title: Text(
          'My Learning',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Learning Stats Card
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learning Statistics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF002131),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Study Time',
                            '${totalStudyTime.toStringAsFixed(1)}h',
                            Icons.timer,
                            Colors.blue,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Total Sessions',
                            '$totalSessions',
                            Icons.book,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Learning Style',
                            learningStyle,
                            Icons.psychology,
                            Colors.orange,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Courses Completed',
                            '${completedCourses.length}',
                            Icons.school,
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Completed Subjects
            Text(
              'Completed Subjects',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002131),
              ),
            ),
            SizedBox(height: 10),
            if (completedSubjects.isEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No subjects completed yet. Mark subjects as completed from the Home page!',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: completedSubjects.length,
                itemBuilder: (context, index) {
                  final subject = completedSubjects[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.book, color: Colors.white),
                      ),
                      title: Text(subject),
                      trailing: Icon(Icons.check_circle, color: Colors.green),
                    ),
                  );
                },
              ),
            SizedBox(height: 20),

            // Watched Videos
            Text(
              'Watched Videos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002131),
              ),
            ),
            SizedBox(height: 10),
            if (watchedVideos.isEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No videos watched yet. Mark videos as watched from the Home page!',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: watchedVideos.length,
                itemBuilder: (context, index) {
                  final video = watchedVideos[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFF48A9A6),
                        child: Icon(Icons.play_circle_fill, color: Colors.white),
                      ),
                      title: Text(video),
                      trailing: Icon(Icons.visibility, color: Color(0xFF48A9A6)),
                    ),
                  );
                },
              ),
            SizedBox(height: 20),

            // Recent Learning Sessions
            Text(
              'Recent Learning Sessions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002131),
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: learningSessions.length,
              itemBuilder: (context, index) {
                final session = learningSessions[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF48A9A6),
                      child: Icon(Icons.book, color: Colors.white),
                    ),
                    title: Text(session.subject),
                    subtitle: Text(
                      '${session.date.day}/${session.date.month}/${session.date.year} - ${session.duration.toStringAsFixed(1)}h',
                    ),
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Completed Courses
            Text(
              'Completed Courses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002131),
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: completedCourses.length,
              itemBuilder: (context, index) {
                final course = completedCourses[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.school, color: Colors.white),
                    ),
                    title: Text(course.name),
                    subtitle: Text(
                      '${course.subject} • ${course.duration.toStringAsFixed(1)}h • Grade: ${course.grade}',
                    ),
                    trailing: Icon(Icons.verified, color: Colors.blue),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSessionDialog(context),
        backgroundColor: Color(0xFF48A9A6),
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Learning Session',
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAddSessionDialog(BuildContext context) {
    String subject = '';
    double duration = 1.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Learning Session'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      hintText: 'e.g., Mathematics, Science',
                    ),
                    onChanged: (value) => subject = value,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Duration: '),
                      Expanded(
                        child: Slider(
                          value: duration,
                          min: 0.5,
                          max: 8.0,
                          divisions: 15,
                          label: '${duration.toStringAsFixed(1)}h',
                          onChanged: (value) {
                            setState(() {
                              duration = value;
                            });
                          },
                        ),
                      ),
                      Text('${duration.toStringAsFixed(1)}h'),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (subject.isNotEmpty) {
                      _addLearningSession(subject, duration);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF48A9A6),
                  ),
                  child: Text('Add Session', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class LearningSession {
  final String subject;
  final double duration;
  final DateTime date;
  final String notes;

  LearningSession({
    required this.subject,
    required this.duration,
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'duration': duration,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory LearningSession.fromJson(Map<String, dynamic> json) {
    return LearningSession(
      subject: json['subject'],
      duration: json['duration'].toDouble(),
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }
}

class CompletedCourse {
  final String name;
  final String subject;
  final double duration;
  final DateTime completedDate;
  final String grade;

  CompletedCourse({
    required this.name,
    required this.subject,
    required this.duration,
    required this.completedDate,
    required this.grade,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subject': subject,
      'duration': duration,
      'completedDate': completedDate.toIso8601String(),
      'grade': grade,
    };
  }

  factory CompletedCourse.fromJson(Map<String, dynamic> json) {
    return CompletedCourse(
      name: json['name'],
      subject: json['subject'],
      duration: json['duration'].toDouble(),
      completedDate: DateTime.parse(json['completedDate']),
      grade: json['grade'],
    );
  }
} 