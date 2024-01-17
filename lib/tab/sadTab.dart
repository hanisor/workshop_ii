import 'package:flutter/material.dart';
import '../screen/moodCategory.dart';

class SadTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Mood of Autism: Sadness',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        _buildSectionTitle('Sadness can be expressed through:'),
                        _buildExpansionTile('1. Verbal Expression', [
                          'Crying and sobbing.',
                          'Withdrawal or silence, choose not to speak to anyone.',
                          'Directly stating feelings of sadness such "I feel sad".',
                          'Expressing frustration through words to convey the dissapointment.',
                        ]),
                        _buildExpansionTile('2. Body Language', [
                          'Facial expressions like frowning or crying.',
                          'Changes in posture, such as slumping or avoiding eye contact.',
                          'Limited or repetitive movements.',
                        ]),
                        _buildExpansionTile('3. Vocalizations', [
                          'Changes in tone of voice (e.g., speaking softly or crying).',
                          'Repetitive vocal sounds or words expressing distress.',
                        ]),
                        _buildSectionTitle('What can trigger sadness?'),
                        _buildExpansionTile('1. Change in Routine', [
                          'Upset caused by unexpected changes in routine or environment.',
                          'Difficulty adapting to new situations.',
                        ]),
                        _buildExpansionTile('2. Social Challenges', [
                          'Struggling with social interactions and facing rejection or bullying.',
                          'Feeling misunderstood or isolated from peers.',
                        ]),
                        _buildExpansionTile('3. Difficulties in Communication', [
                          'Frustration arising from difficulty expressing needs or understanding others.',
                          'Feeling isolated due to challenges in forming social connections.',
                        ]),
                        _buildSectionTitle('What can do to help them manage their emotion?:'),
                        _buildExpansionTile(
                          '1. Visual Support',
                          [
                            'Use visual schedules, emotion charts, and social stories to help the child understand and navigate daily activities.',
                          ],
                        ),
                        _buildExpansionTile(
                          '2. Communication Tools',
                          [
                            'Explore alternative communication methods, such as visual supports, sign language, or communication devices.',
                          ],
                        ),
                        _buildExpansionTile(
                          '3. Predictability and Routine',
                          [
                            'Maintain a structured routine and prepare the child in advance for any changes.',
                          ],
                        ),
                        _buildExpansionTile(
                          '4. Therapeutic Support',
                          [
                            'Consider behavioral therapy, occupational therapy, or counseling to address specific challenges.',
                          ],
                        ),

                        // Add more symptoms and triggers as needed
                        SizedBox(height: 40),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _handleAddSadness(context);
                            },
                            child: Text("Add Mood"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[700]),
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, List<String> details) {
    return ExpansionTile(
      title: Text(title),
      children: [
        for (String detail in details)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            title: Text('- $detail'),
          ),
      ],
    );
  }

  void _handleAddSadness(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(),
      ),
    );
  }
}