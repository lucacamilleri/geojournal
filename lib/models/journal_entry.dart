class JournalEntry {
  final String id;
  final String title;
  final String content;
  final String location;
  final String imagePath;

  // A constructor that initializes the properties of the class
  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.location,
    required this.imagePath,
  });

  // A method that converts the class properties to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'location': location,
      'imagePath': imagePath,
    };
  }

  // A factory method that creates a JournalEntry object from a map
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      location: json['location'] ?? '',
      imagePath: json['imagePath'] ?? '',
    );
  }
}
