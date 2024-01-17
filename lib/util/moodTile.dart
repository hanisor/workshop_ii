import '../screen/addMood.dart';
import 'package:flutter/material.dart';



class MoodTile extends StatelessWidget {
  final String mood;
  final String description;
  final Color moodColor;
  final String imageName;
  final double borderRadius = 12;

  const MoodTile({
    Key? key,
    required this.mood,
    required this.description,
    required this.moodColor,
    required this.imageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: () {
          // Navigate to the details screen when the tile is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMoodPage(currentUserId: ''),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: moodColor.withOpacity(0.9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
          ),
          child: Column(
            children: [
              // Description Header
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(color: moodColor),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      mood,
                      style: TextStyle(
                        color: moodColor.computeLuminance() < 0.5
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),

              // Mood Image
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 12),
                child: Image.asset(imageName),
              ),

              // Description Text
              Text(
                description,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),

              // Mood Label
              Text(
                "Mood",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),

              // Icons (Love and Forward)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.pink[400],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.pink[400],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}