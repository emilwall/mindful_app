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
    getSettings().then((value) {
      String message = value
          ? 'The settings have been fetched'
          : 'The settings were not fetched';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ));
    });
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
                  selectedImage = newValue!;
                });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveSettings().then((value) {
            String message = value
                ? 'The settings have been saved'
                : 'The settings were not saved';
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 3),
            ));
          });
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Future<bool> saveSettings() async {
    return await helper.setSettings(txtName.text, selectedImage);
  }

  Future getSettings() async {
    Map<String, String> settings = await helper.getSettings();
    selectedImage = settings['image'] ?? 'Country';
    txtName.text = settings['name'] ?? '';
    setState(() {});
    return true;
  }

  @override
  void dispose() {
    txtName.dispose();
    super.dispose();
  }
}
