import 'package:flutter/material.dart';
import '../screen/moodCategory.dart';

class IrritabilityTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.deepOrange,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Mood of Autism: Irritability',
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
                        _buildExpansionTile('1. Verbal Expressions', [
                          'Intense emotional outburst and verbally expressing dissatisfaction.',
                          'Sreaming, crying, shouting and another physical reactions.',
                          'Aggressive behaviour such as hitting, bitting and other aggressive acrions.',
                          'Expressing frustration through words to convey frustration sush as "This is really irritating" .',
                        ]),
                        _buildExpansionTile('2. Body Language', [
                          'Exhibiting physical signs of tension, restlessness, fidgeting such as tapping fingers',
                          'Non verbal cues such as sighing, eye rolling or slumping shoulder',
                          'Physical discomfort signs such as holding their head, covering their ears.'
                              'Distancing oneself from a situation or conversation to avoid further frustration',
                        ]),
                        _buildExpansionTile('3. Vocalizations', [
                          'Changes in tone of voice (e.g., speak more sharply, raising voice.)',
                          'Using a tone that conveys irritation.',
                          'Become silence, quiet and less talkative.',
                        ]),
                        _buildSectionTitle('What can trigger anxiety and fear?'),
                        _buildExpansionTile('1. Social Situations', [
                          'Upset caused by unexpected changes in routine or environment.',
                          'Difficulty with social interactions, making friends, or understanding social cues.',
                        ]),
                        _buildExpansionTile('2. Sensory Issues', [
                          'Overstimulation from lights, sounds, textures, or smells.',
                          'Uncomfortable clothing, certain textures, or loud noises.',
                        ]),
                        _buildExpansionTile('3. Communication Challenges', [
                          'Frustration arising from difficulty expressing needs or understanding others.',
                          'Feeling isolated due to challenges in forming social connections.',
                        ]),
                        _buildSectionTitle('What can do to help them manage their emotion?:'),
                        _buildExpansionTile(
                          '1. Visual Support',
                          [
                            'Visual schedules, social stories, and visual cues can help children understand and anticipate changes.',
                          ],
                        ),
                        _buildExpansionTile(
                          '2. Communication Support',
                          [
                            'Use clear and concise language, visual aids, or alternative communication methods to enhance understanding.',
                            'Encourage self-expression to support them expressing their emotions'
                          ],
                        ),
                        _buildExpansionTile(
                          '3. Create Safe Spaces',
                          [
                            'Establish a designated safe space where the child can retreat when feeling overwhelmed.',

                          ],
                        ),
                        _buildExpansionTile(
                          '4. Offer Choice',
                          [
                            'Provide the child with options to promote a sense of control and reduce anxiety.',
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange[700]),
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