import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationSection extends StatefulWidget {
  @override
  _RegistrationSectionState createState() => _RegistrationSectionState();
}

class _RegistrationSectionState extends State<RegistrationSection> {
  @override
  Widget build(BuildContext context) {
    return FirebaseFieldsForm(); // Use the FirebaseFieldsForm directly in the widget build method
  }
}

class FirebaseFieldsForm extends StatefulWidget {
  @override
  _FirebaseFieldsFormState createState() => _FirebaseFieldsFormState();
}

class _FirebaseFieldsFormState extends State<FirebaseFieldsForm> {
  final reference = FirebaseDatabase.instance.reference();
  Map<dynamic, dynamic>? fields;
  String? selectedEvent;

  @override
  void initState() {
    super.initState();
    reference.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        setState(() {
          fields = event.snapshot.value as Map<dynamic, dynamic>?;
        });
      } else {
        print('No data received from Firebase');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (selectedEvent == null) ..._buildEventList(),
          if (selectedEvent != null) ..._buildForm(selectedEvent!),
        ],
      ),
    );
  }

  List<Widget> _buildEventList() {
    return fields?.keys.map<Widget>((collectionName) {
          if (fields![collectionName] is Map<dynamic, dynamic>) {
            var registrationDetails =
                fields![collectionName] as Map<dynamic, dynamic>;
            if (registrationDetails.isNotEmpty) {
              var hasTeamsize = registrationDetails.values
                  .any((details) => details.containsKey('Teamsize'));
              if (hasTeamsize) {
                var teamSize = registrationDetails.values.firstWhere(
                    (details) => details.containsKey('Teamsize'))['Teamsize'];
                var eventDate = registrationDetails.values.firstWhere(
                    (details) => details.containsKey('eventDate'))['eventDate'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedEvent = collectionName;
                    });
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event: $collectionName',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Team Size: $teamSize',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Event Date: $eventDate',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
          }
          return SizedBox.shrink();
        }).toList() ??
        [];
  }

  List<Widget> _buildForm(String collectionName) {
    var collectionFields =
        fields![collectionName].values.toList()[0].keys.toList();
    var formData = <String, dynamic>{};
    final _formKey = GlobalKey<FormState>(); // Add form key

    // Sort the collection fields alphabetically
    collectionFields.sort();

    return [
      AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selectedEvent = null;
            });
          },
        ),
        title: Text(
          'Collection: $collectionName',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(height: 10),
      Form(
        key: _formKey, // Assign the key to the Form widget
        child: Column(
          children: collectionFields.map<Widget>((fieldName) {
            // Skip event name and team size fields
            if (fieldName != 'eventDate' && fieldName != 'Teamsize') {
              return FormField(
                builder: (FormFieldState<dynamic> field) {
                  return TextFormField(
                    onChanged: (value) {
                      formData[fieldName.toString()] = value;
                    },
                    decoration: InputDecoration(
                      labelText: fieldName.toString(),
                      errorText: field.errorText, // Display error text
                    ),
                    validator: (value) {
                      // Added validator to check if field is empty
                      if (value == null || value.isEmpty) {
                        return 'Please enter $fieldName';
                      }
                      return null;
                    },
                  );
                },
              );
            } else {
              return SizedBox.shrink(); // Hide event name and team size fields
            }
          }).toList(),
        ),
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Validate the form
            final newRef = reference
                .child(collectionName)
                .push(); // Generate a new child reference
            newRef.set(formData).then((_) {
              print('Form data submitted to $collectionName');
              setState(() {
                selectedEvent = null; // Navigate back to events list
              });

              // Print values of fields ending with "roll"
              formData.forEach((key, value) async {
                if (key.toLowerCase().endsWith('roll')) {
                  FirebaseFirestore firestore = FirebaseFirestore.instance;
                  QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
                      .collection('students_details')
                      .where('rollno', isEqualTo: value)
                      .get();
                  if (snapshot.docs.isNotEmpty) {
                    DocumentReference docRef = snapshot.docs.first.reference;
                    await docRef.update({
                      'events_registered': 0, // Set 'events_registered' to 0
                    });
                    print('Events registered set to 0 for roll number $value');
                  } else {
                    print('No student found with roll number $value');
                  }
                }
              });
            }).catchError((error) {
              print('Error submitting form data: $error');
            });
          }
        },
        child: Text('Register'),
      ),
    ];
  }
}
