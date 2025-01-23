import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cooking_screen.dart';
import 'package:intl/intl.dart';

class IngredientSelectionScreen extends StatefulWidget {
  @override
  _IngredientSelectionScreenState createState() =>
      _IngredientSelectionScreenState();
}

class _IngredientSelectionScreenState extends State<IngredientSelectionScreen> {
  String selectedRiceType = 'White Rice';
  List<String> selectedIngredients = [];
  String spiceLevel = 'Medium';

  final List<String> riceTypes = ['White Rice', 'Brown Rice'];
  final List<String> availableIngredients = [
    'Carrots',
    'Chicken',
    'Eggs',
    'Green Onions',
  ];

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveToFirestore() async {
    // Generate the current timestamp
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    try {
      // Save data to Firestore
      DocumentReference docRef = await _firestore.collection('cooking_sessions').add({
        'riceType': selectedRiceType,
        'ingredients': selectedIngredients,
        'spiceLevel': spiceLevel,
        'timestamp': formattedDate,
      });

      // Update document ID field with the auto-generated ID
      await docRef.update({'documentId': docRef.id});

      print("Data saved with ID: ${docRef.id}");
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Ingredients',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.orange.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --Rice Type
            buildCard(
              context,
              'Rice Type',
              DropdownButton<String>(
                value: selectedRiceType,
                isExpanded: true,
                items: riceTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRiceType = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            // --Ingredients Selection
            buildCard(
              context,
              'Ingredients',
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableIngredients.map((ingredient) {
                  final isSelected = selectedIngredients.contains(ingredient);
                  return FilterChip(
                    label: Text(
                      ingredient,
                      style: const TextStyle(fontSize: 14),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.orange.shade200,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedIngredients.add(ingredient);
                        } else {
                          selectedIngredients.remove(ingredient);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            // --Spice Level select
            buildCard(
              context,
              'Spice Level',
              Slider(
                value: ['Mild', 'Medium', 'Hot'].indexOf(spiceLevel).toDouble(),
                min: 0,
                max: 2,
                divisions: 2,
                label: spiceLevel,
                activeColor: Colors.orange,
                onChanged: (value) {
                  setState(() {
                    spiceLevel = ['Mild', 'Medium', 'Hot'][value.toInt()];
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: selectedIngredients.isNotEmpty
              ? () async {
                  // Save data to Firestore before navigation
                  await saveToFirestore();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CookingScreen(
                        riceType: selectedRiceType,
                        ingredients: selectedIngredients,
                        spiceLevel: spiceLevel,
                      ),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.orange,
            disabledBackgroundColor: Colors.orange.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Start Cooking',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, String title, Widget content) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade800,
              ),
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }
}
