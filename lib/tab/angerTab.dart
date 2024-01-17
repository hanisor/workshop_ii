import 'package:flutter/material.dart';
import '../screen/moodCategory.dart';

class AngerTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Mood of Autism: Anger',
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
                        _buildSectionTitle('Anger can be expressed through:'),
                        _buildExpansionTile(
                          '1. Verbal Expression',
                          [
                            'Yelling or shouting.',
                            'Using harsh or aggressive language.',
                            'Criticizing or blaming others.',
                            'Expressing frustration through words.',
                          ],
                        ),
                        _buildExpansionTile(
                          '2. Physical Expression',
                          [
                            'Physically lashing out.',
                            'Hitting or kicking objects.',
                            'Physical restlessness.',
                          ],
                        ),
                        _buildExpansionTile(
                          '3. Facial Expression',
                          [
                            'Frowning or scowling.',
                            'Intense or angry facial expressions.',
                            'Limited eye contact.',
                          ],
                        ),
                        _buildSectionTitle('What can trigger anger:'),
                        _buildExpansionTile(
                          '1. Communication Challenges',
                          [
                            'Difficulty expressing needs or desires.',
                            'Misunderstandings in communication.',
                            'Frustration with speech or language difficulties.',
                          ],
                        ),
                        _buildExpansionTile(
                          '2. Sensory Overload',
                          [
                            'Overstimulation from loud noises, bright lights, or strong smells.',
                            'Sensitivity to certain textures or clothing.',
                            'Changes in the environment that disrupt routine.',
                          ],
                        ),
                        _buildExpansionTile(
                          '3. Transitions and Change',
                          [
                            'Difficulty coping with changes in routine or unexpected transitions.',
                            'Anxiety related to new environments or activities.',
                          ],
                        ),
                        _buildExpansionTile(
                          '4. Social Challenges',
                          [
                            'Difficulty understanding social cues.',
                            'Feeling isolated or left out in social situations.',
                            'Challenges in making and maintaining friendships.',
                          ],
                        ),
                        _buildSectionTitle('What can do to help them manage their emotion?:'),
                        _buildExpansionTile(
                          '1. Stay Calm',
                          [
                            'Model calm and composed behavior. Children often look to their parents for guidance on how to handle emotions. If you remain calm, it can help the child feel more secure.',
                          ],
                        ),
                        _buildExpansionTile(
                          '2. Identify Triggers',
                          [
                            'Observe and identify specific triggers that lead to anger in your child. Understanding these triggers can help you address and manage situations proactively.',
                          ],
                        ),
                        _buildExpansionTile(
                          '3. Establish Predictable Routines',
                          [
                            'Maintain consistent daily routines to provide structure and predictability. Changes in routine can be challenging for children with autism, so try to prepare them for any upcoming transitions.',
                          ],
                        ),
                        _buildExpansionTile(
                          '4. Teach Coping Strategies',
                          [
                            'Work with your child to develop and teach coping strategies. This might include deep breathing exercises, sensory breaks, or using a designated safe space when feeling overwhelmed.',
                          ],
                        ),
                        _buildExpansionTile(
                          '5. Visual Supports',
                          [
                            'Use visual aids, such as schedules, charts, or social stories, to help your child understand expectations and navigate daily activities.',
                          ],
                        ),
                        SizedBox(height: 40),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _handleAddAnger(context);
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
        //color: Colors.yellow[100], // Set the background color of the title

        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
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

  void _handleAddAnger(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(),
      ),
    );
  }
}