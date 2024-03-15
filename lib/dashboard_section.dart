import 'package:flutter/material.dart';

class DashboardSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock student progress (percentage completion)
    double studentProgress =
        75.0; // Change this value to reflect actual student progress
    int eventsParticipated =
        10; // Change these values to reflect actual statistics
    int eventsWon = 5;
    int eventsRegistered = 15;
    int assignmentsCompleted = 8;
    int quizzesTaken = 20;
    int attendancePercentage = 90;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildCircularProgressCard(context, studentProgress),
                SizedBox(height: 20),
                _buildRowOfCards(
                  context,
                  [
                    _buildStatCard(
                      context,
                      'Events Participated',
                      eventsParticipated.toString(),
                      Icons.event,
                      Colors.blue,
                    ),
                    _buildStatCard(
                      context,
                      'Events Won',
                      eventsWon.toString(),
                      Icons.emoji_events,
                      Colors.green,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildRowOfCards(
                  context,
                  [
                    _buildStatCard(
                      context,
                      'Events Registered',
                      eventsRegistered.toString(),
                      Icons.playlist_add_check,
                      Colors.orange,
                    ),
                    _buildStatCard(
                      context,
                      'Assignments Completed',
                      assignmentsCompleted.toString(),
                      Icons.assignment_turned_in,
                      Colors.purple,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildRowOfCards(
                  context,
                  [
                    _buildStatCard(
                      context,
                      'Quizzes Taken',
                      quizzesTaken.toString(),
                      Icons.quiz,
                      Colors.pink,
                    ),
                    _buildStatCard(
                      context,
                      'Attendance',
                      '$attendancePercentage%',
                      Icons.event_available,
                      Colors.teal,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40.0,
                color: color,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowOfCards(BuildContext context, List<Widget> cards) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: cards.map((card) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: card,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCircularProgressCard(
      BuildContext context, double studentProgress) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Progress',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Stack(
                children: [
                  SizedBox(
                    height: 200.0,
                    width: 200.0,
                    child: CircularProgressIndicator(
                      value: studentProgress / 100,
                      strokeWidth: 10,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        '$studentProgress%',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
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
