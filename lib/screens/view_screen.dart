// Importing the necessary packages
import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import 'dart:io';

// A StatelessWidget that displays the details of a JournalEntry
// including the title, content, location and image
// The user can view the details of the entry
// or go back to the previous screen
class ViewScreen extends StatelessWidget {
  final JournalEntry entry;

  const ViewScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GEOJOURNAL - View Entry',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
              entry.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(entry.content, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(entry.location, style: const TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 8),
            // Display the image if the entry has an image
            // otherwise display nothing
            if (entry.imagePath.isNotEmpty)
              Image.file(
                File(entry.imagePath),
                width: double.infinity,
                height: 300,
              ),
          ],
        ),
      ),
    );
  }
}
