// Importing the necessary packages
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/journal_entry.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// A StatefulWidget that allows the user to create a new JournalEntry
// or edit an existing one
// The user can add a title, content, location and an image
// The user can save the entry or reset/clear the form

// It also allows for editing an existing entry
class JournalEntryScreen extends StatefulWidget {
  final JournalEntry? entry;

  const JournalEntryScreen({super.key, this.entry});

  @override
  JournalEntryScreenState createState() => JournalEntryScreenState();
}

// The State class for the JournalEntryScreen
// It contains the form key, text controllers for the title and content
// and the location of the entry
// It also contains the database reference and the image path
// It has methods to save the entry, add a photo, and a check and request permission
// to be able to get the current location
class JournalEntryScreenState extends State<JournalEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _location = '';
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child(
    'journal_entries',
  );

  String buttonText = 'Add Photo';
  XFile? _image;
  String _imagePath = '';

  // A method to initialize the state of the widget
  // It acts as a sort of constructor for the State class
  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.content;
      _location = widget.entry!.location;
      _imagePath = widget.entry!.imagePath;
      if (_imagePath.isNotEmpty) {
        _image = XFile(_imagePath);
        buttonText = 'Change Image';
      }
    }
  }

  // A method to save the entry
  // It validates the form, checks and requests permission
  // to get the current location, copies the image to the application directory
  // and saves the entry to the database
  Future<void> _saveEntry() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Validates every field of the form
    if (_formKey.currentState!.validate()) {
      final hasPermission = await _checkAndRequestPermission();

      if (hasPermission) {
        final position = await _getCurrentLocation();
        _location =
            '${position.latitude.toStringAsFixed(2)},${position.longitude.toStringAsFixed(2)}';
      }

      if (_image != null && _image!.path != _imagePath) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/${_image!.name}';
        await File(_image!.path).copy(imagePath);
        _imagePath = imagePath;
      }

      final newEntry = JournalEntry(
        id: widget.entry?.id ?? _database.push().key ?? '',
        title: _titleController.text,
        content: _contentController.text,
        location: _location,
        imagePath: _imagePath,
      );
      
      try {
        await _database.child(newEntry.id).set(newEntry.toJson());
        if (mounted) {
          Navigator.pop(context); // Dismiss the spinner
          Navigator.pop(context); // Navigate back to the previous screen
        }
      } catch (e) {
        Navigator.pop(context); // Dismiss the spinner in case of error
      }
    } else {
      Navigator.pop(context); // Dismiss the spinner if validation fails
    }
  }

  // A method to add a photo to the entry
  // It requests permission to use the camera
  // and allows the user to take a photo and set it as the image
  Future<void> _addPhoto() async {
    final PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        log('Photo added: ${image.path}');
        setState(() {
          _image = image;
          buttonText = 'Change Image';
        });
      } else {
        log('No photo was selected');
      }
    } else {
      log('Camera permission denied');
    }
  }

  // A method to check and request permission to get the current location
  Future<bool> _checkAndRequestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log('Location permissions are permanently denied.');
      return false;
    }

    return true;
  }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  // A method to build the JournalEntryScreen
  // It contains a form with text fields for the title and content
  // and buttons to add a photo, reset the form and save the entry
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.entry == null
              ? 'GEOJOURNAL - New Entry'
              : 'GEOJOURNAL - Edit Entry',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().isEmpty ||
                      value.trim().length > 50) {
                    return 'Title must be between 1 and 50 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Thoughts'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Content cannot be empty';
                  }
                  return null;
                },
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _addPhoto,
                icon: const Icon(Icons.photo_camera),
                label: Text(buttonText),
              ),
              const SizedBox(height: 10),
              if (_image != null)
                Image.file(File(_image!.path), width: 100, height: 100),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                      _titleController.clear();
                      _contentController.clear();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveEntry,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
