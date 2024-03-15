import 'package:flutter/material.dart';

class IdeaSubmissionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Idea Submission'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Submit your ideas here!',
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _showSubmitIdeaDialog(context);
                },
                child: Text('Submit'),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  _showViewIdeasDialog(context);
                },
                child: Text('View Ideas'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubmitIdeaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit Idea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Enter your idea'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle idea submission
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Idea submitted successfully!'),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showViewIdeasDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('View Ideas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIdeaCard(
                imageUrl: 'https://via.placeholder.com/150',
                idea: 'This is a great idea!',
              ),
              SizedBox(height: 10),
              _buildIdeaCard(
                imageUrl: 'https://via.placeholder.com/150',
                idea: 'Another amazing idea!',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIdeaCard({required String imageUrl, required String idea}) {
    return Card(
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(idea),
            ),
          ),
        ],
      ),
    );
  }
}
