class Question {
  final int? id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String category;
  final int difficulty; // 1 = fácil, 2 = médio, 3 = difícil

  Question({
    this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.category,
    this.difficulty = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'options': options.join('|'), // Separando opções com |
      'correctAnswerIndex': correctAnswerIndex,
      'category': category,
      'difficulty': difficulty,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      text: map['text'],
      options: map['options'].split('|'),
      correctAnswerIndex: map['correctAnswerIndex'],
      category: map['category'],
      difficulty: map['difficulty'] ?? 1,
    );
  }

  @override
  String toString() {
    return 'Question{id: $id, text: $text, category: $category, difficulty: $difficulty}';
  }
} 