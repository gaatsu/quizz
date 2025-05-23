class QuizResult {
  final String id;
  final String playerName;
  final int score;
  final int totalQuestions;
  final String category;
  final DateTime completedAt;
  final int timeSpent; // em segundos

  QuizResult({
    required this.id,
    required this.playerName,
    required this.score,
    required this.totalQuestions,
    required this.category,
    required this.completedAt,
    required this.timeSpent,
  });

  double get percentage => (score / totalQuestions) * 100;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playerName': playerName,
      'score': score,
      'totalQuestions': totalQuestions,
      'category': category,
      'completedAt': completedAt.millisecondsSinceEpoch,
      'timeSpent': timeSpent,
      'percentage': percentage,
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      id: map['id'],
      playerName: map['playerName'],
      score: map['score'],
      totalQuestions: map['totalQuestions'],
      category: map['category'],
      completedAt: DateTime.fromMillisecondsSinceEpoch(map['completedAt']),
      timeSpent: map['timeSpent'],
    );
  }

  @override
  String toString() {
    return 'QuizResult{playerName: $playerName, score: $score/$totalQuestions (${percentage.toStringAsFixed(1)}%), category: $category}';
  }
} 