import 'package:flutter/material.dart';
import 'package:mindful_app/data/sp_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SPHelper helper = SPHelper();
  final TextEditingController txtName = TextEditingController();
  final List<String> images = ['Lake', 'Mountain', 'Sea', 'Country'];
  String selectedImage = 'Lake';

  @override
  void initState() {
    super.initState();
    getSettings();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: 'Enter your name'),
            ),
            DropdownButton(
              value: selectedImage,
              items: images
                  .map((String value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedImage = newValue ?? images.first;
                });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          helper.setSettings(txtName.text, selectedImage).then((value) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('The settings were ${value ? '' : 'not '}saved'),
                duration: const Duration(seconds: 3),
              ));
            }
          });
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Future getSettings() async {
    Map<String, String> settings = await helper.getSettings();
    selectedImage = settings['image'] ?? '';
    txtName.text = settings['name'] ?? '';
    if (selectedImage == '') {
      selectedImage = 'Lake';
    }
    setState(() {});
    return true;
  }

  @override
  void dispose() {
    txtName.dispose();
    super.dispose();
  }
}
