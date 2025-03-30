// pet_profile.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'pet_monitor.dart';

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  _PetProfileScreenState createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  final CollectionReference petsCollection =
  FirebaseFirestore.instance.collection('pets');

  final TextEditingController _nameController = TextEditingController();
  String _selectedBreed = 'Golden Retriever';
  final List<String> _breedOptions = [
    'Golden Retriever',
    'Labrador',
    'Poodle',
    'Bulldog',
    'Beagle',
    'Other'
  ];

  Future<void> _addPet() async {
    String petName = _nameController.text.trim();
    if (petName.isEmpty) return;

    await petsCollection.add({
      'name': petName,
      'breed': _selectedBreed,
      // Optionally, add additional fields (like a pet ID) if needed.
    });
    _nameController.clear();
  }

  Future<void> _deletePet(String petId) async {
    await petsCollection.doc(petId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Profiles')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form for adding a new pet profile.
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Pet Name'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedBreed,
              items: _breedOptions.map((breed) {
                return DropdownMenuItem(
                  value: breed,
                  child: Text(breed),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedBreed = value;
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Breed'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addPet,
              child: const Text('Add Pet Profile'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Existing Pets:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: StreamBuilder(
                stream: petsCollection.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      String petId = doc.id;
                      String petName = doc['name'];
                      String petBreed = doc['breed'];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text('$petName ($petBreed)'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.monitor_heart, color: Colors.blue),
                                onPressed: () {
                                  // Navigate to the pet-specific monitor screen.
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PetMonitorScreen(
                                        petId: petId,
                                        petName: petName,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deletePet(petId),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
