class JournalEntry {
  final String id;
  final String title;
  final String content;
  final String location;
  final String imagePath;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.location,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'location': location,
      'imagePath': imagePath,
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] ?? '',
      title: json['title'] ?? '', // Provide a default value if null
      content: json['content'] ?? '', // Provide a default value if null
      location: json['location'] ?? '', // Provide a default value if null
      imagePath: json['imagePath'] ?? '', // Provide a default value if null
    );
  }
}