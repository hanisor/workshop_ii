import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controller/moodActivityController.dart';
import '../screen/moodlist.dart';

class AddMoodPage extends StatefulWidget {
  final currentUserId;

  const AddMoodPage({required this.currentUserId});

  @override
  _AddMoodPageState createState() => _AddMoodPageState();
}

class _AddMoodPageState extends State<AddMoodPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _controller = MoodActivityController();

  TextEditingController placeEditingController = TextEditingController();
  TextEditingController dateEditingController = TextEditingController();
  TextEditingController beforeEditingController = TextEditingController();
  TextEditingController afterEditingController = TextEditingController();
  TextEditingController triggerEditingController = TextEditingController();

  String selectedBehavior = 'None';
  List<String> behaviorOptions = [
    'None',
    'Anger',
    'Sad',
    'Anxiety',
    'Irritability',
    'Fear',
    'Dissatisfaction',
    'Hurt',
    'Happy',
    'Others'
  ];

  String selectedTrigger = 'None';
  List<String> triggerOptions = [
    'None',
    'Communication Challenges',
    'Sensory Overload',
    'Unfamiliar Environment',
    'Social Challenges',
    'Transition and Change in Routine',
    'Crowded or Busy Environment',
    'Physical Discomfort',
    'Others'
  ];

  void addMood() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String userId = user.uid;

      Map<String, dynamic> moodData = {
        'userId': userId,
        'behavior': selectedBehavior,
        'place': placeEditingController.text,
        'date': dateEditingController.text,
        'symptomBefore': beforeEditingController.text,
        'symptomAfter': afterEditingController.text,
        'trigger': selectedTrigger,
      };

      try {
        await _firestore.collection('mood').add(moodData);

        placeEditingController.clear();
        dateEditingController.clear();
        beforeEditingController.clear();
        afterEditingController.clear();
        triggerEditingController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MoodList()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mood data saved successfully!'),
          ),
        );
      } catch (error) {
        print('Error adding mood data: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to save mood data. Please try again. Error: $error'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[100],
        title: const Center(
          child: Text(
            'Mood Record',
            style: TextStyle(
                fontSize: 32, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdown(
                  'Select Behavior', behaviorOptions, selectedBehavior),
              const SizedBox(height: 16),
              _buildDropdown('Select Trigger', triggerOptions, selectedTrigger),
              const SizedBox(height: 16),
              _buildTextField(
                  'Insert Place', placeEditingController, Icons.location_on),
              const SizedBox(height: 16),
              _buildDateTextField(
                  'Insert Date', dateEditingController, Icons.calendar_today),
              const SizedBox(height: 16),
              _buildTextField('Insert Symptom Before', beforeEditingController,
                  Icons.warning),
              const SizedBox(height: 16),
              _buildTextField(
                  'Insert Symptom After', afterEditingController, Icons.warning),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: addMood,
                style: ElevatedButton.styleFrom(
                  primary: Colors.amberAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String selectedValue) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          onChanged: (newValue) {
            setState(() {
              if (label == 'Select Behavior') {
                selectedBehavior = newValue!;
              } else if (label == 'Select Trigger') {
                selectedTrigger = newValue!;
              }
            });
          },
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ),
    );
  }
  Widget _buildTextField(String label, TextEditingController controller,
      IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Colors.deepOrangeAccent,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildDateTextField(String label, TextEditingController controller,
      IconData icon) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: _selectDate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Colors.deepOrangeAccent,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedDate != null && pickedTime != null) {
      setState(() {
        dateEditingController.text =
        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day} "
            "${pickedTime.hour}:${pickedTime.minute}:00";
      });
    }
  }
}