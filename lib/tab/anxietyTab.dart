import 'package:flutter/material.dart';
import '../screen/moodCategory.dart';

class AnxietyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.deepPurple,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Mood of Autism: Anxiety',
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

                        _buildSectionTitle('Anxiety can be expressed through:'),
                        _buildExpansionTile('1. Verbal Expression', [
                          'Asking repetitive questions such as are you sure everything will be okay?".',
                          'Withdrawal or silence, choose not to speak to anyone.',
                          'Directly stating feelings of fear such "I feel scared".',
                          'Expressing frustration through words to convey the dissapointment.',
                        ]),
                        _buildExpansionTile('2. Body Language', [
                          'Facial expressions like frowning, Limited eye contact or atypical facial expressions, such as a lack of emotional responsiveness',
                          'Changes in posture, Unusual postures, repetitive movements (e.g., hand-flapping, rocking), ',

                        ]),
                        _buildExpansionTile('3. Vocalizations', [
                          'Changes in tone of voice (e.g., speak in a monotone manner, while others may demonstrate a heightened or reduced pitch..',
                          'Repetitive sounds, noises, or phrases, serving as a form of self-soothing or expression of distress.',
                        ]),
                        _buildSectionTitle('What can trigger anxiety and fear?'),
                        _buildExpansionTile('1. Social Situations', [
                          'Upset caused by unexpected changes in routine or environment.',
                          'Difficulty adapting to new situations.',
                        ]),
                        _buildExpansionTile('2. Unfamiliar Environment', [
                          'Struggling with social interactions and facing rejection or bullying.',
                          'Feeling misunderstood or isolated from peers.',
                        ]),
                        _buildExpansionTile('3. Communication Challengges', [
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
                          '2. Communication Support',
                          [
                            'Use alternative communication methods, such as visual aids or AAC devices, to facilitate expression and understanding.',
                          ],
                        ),
                        _buildExpansionTile(
                          '3. Create Safe Spaces',
                          [
                            'Establish a designated safe space where the child can retreat when feeling overwhelmed.',

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
                              _handleAddAnxiety(context);
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple[700]),
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

  void _handleAddAnxiety(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(),
      ),
    );
  }
}