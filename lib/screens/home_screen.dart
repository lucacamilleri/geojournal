import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/journal_entry.dart';
import 'journal_entry_screen.dart';
import 'view_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child(
    'journal_entries',
  );
  List<JournalEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _database.onValue.listen((event) {
      final List<JournalEntry> loadedEntries = [];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        data.forEach((key, value) {
          loadedEntries.add(
            JournalEntry.fromJson(Map<String, dynamic>.from(value)),
          );
        });
      }
      setState(() {
        _entries = loadedEntries;
      });
    });
  }

  void _addEntry() async {
    final newEntry = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute(builder: (ctx) => const JournalEntryScreen()),
    );

    if (newEntry == null) {
      return;
    }

    setState(() {
      _entries.add(newEntry);
    });

    log('Entry successfully added!');
  }

  void _removeEntry(JournalEntry entry) {
    setState(() {
      _entries.remove(entry);
    });

    _database.child(entry.id).remove();
    log('Entry successfully removed!');
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No journal entries found!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Add a new entry by tapping the + button below.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

    if (_entries.isNotEmpty) {
      content = ListView.builder(
        itemCount: _entries.length,
        itemBuilder:
            (ctx, index) => Dismissible(
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  _removeEntry(_entries[index]);
                }
              },
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  Navigator.of(context).push<JournalEntry>(
                    MaterialPageRoute(
                      builder: (ctx) => JournalEntryScreen(entry: _entries[index]),
                    ),
                  );
                  return false;
                }
                return true;
              },
              key: ValueKey(_entries[index].id),
              background: Container(
                color: Colors.orange,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.edit, color: Colors.white),
                
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    _entries[index].title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(_entries[index].content),
                      const SizedBox(height: 4),
                      Text(
                        _entries[index].location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  leading:
                      _entries[index].imagePath.isNotEmpty
                          ? Image.file(
                            File(_entries[index].imagePath),
                            width: 50,
                            height: 50,
                          )
                          : null,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ViewScreen(entry: _entries[index]),
                      ),
                    );
                  },
                ),
              ),
            ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GEOJOURNAL - Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        child: const Icon(Icons.add),
      ),
    );
  }
}
