import 'package:firebase_database/firebase_database.dart';
import '../models/quiz_result.dart';

class FirebaseService {
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Salvar resultado do quiz
  static Future<void> saveQuizResult(QuizResult result) async {
    try {
      print('Conectando ao Firebase...');
      await _database.child('quiz_results').child(result.id).set(result.toMap());
      print('✅ Resultado salvo no Firebase: ${result.toString()}');
    } catch (e) {
      print('❌ Erro detalhado ao salvar no Firebase: $e');
      print('Tipo do erro: ${e.runtimeType}');
      
      // Re-throw para o chamador saber que falhou
      throw Exception('Falha ao salvar no Firebase: ${e.toString()}');
    }
  }

  // Buscar todos os resultados
  static Future<List<QuizResult>> getAllResults() async {
    try {
      final snapshot = await _database.child('quiz_results').get();
      
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        List<QuizResult> results = [];
        
        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            Map<String, dynamic> resultMap = Map<String, dynamic>.from(value);
            results.add(QuizResult.fromMap(resultMap));
          }
        });
        
        // Ordenar por data (mais recente primeiro)
        results.sort((a, b) => b.completedAt.compareTo(a.completedAt));
        return results;
      }
      
      return [];
    } catch (e) {
      print('Erro ao buscar resultados do Firebase: $e');
      return [];
    }
  }

  // Buscar melhores resultados por categoria
  static Future<List<QuizResult>> getTopResultsByCategory(String category, {int limit = 10}) async {
    try {
      final snapshot = await _database
          .child('quiz_results')
          .orderByChild('category')
          .equalTo(category)
          .get();
      
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        List<QuizResult> results = [];
        
        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            Map<String, dynamic> resultMap = Map<String, dynamic>.from(value);
            results.add(QuizResult.fromMap(resultMap));
          }
        });
        
        // Ordenar por pontuação (maior primeiro)
        results.sort((a, b) => b.score.compareTo(a.score));
        
        // Retornar apenas o limite especificado
        return results.take(limit).toList();
      }
      
      return [];
    } catch (e) {
      print('Erro ao buscar top resultados do Firebase: $e');
      return [];
    }
  }

  // Buscar ranking geral (melhores pontuações)
  static Future<List<QuizResult>> getGlobalRanking({int limit = 10}) async {
    try {
      final results = await getAllResults();
      
      // Ordenar por pontuação e depois por tempo (menor tempo para mesma pontuação)
      results.sort((a, b) {
        if (a.score != b.score) {
          return b.score.compareTo(a.score); // Maior pontuação primeiro
        } else {
          return a.timeSpent.compareTo(b.timeSpent); // Menor tempo primeiro
        }
      });
      
      return results.take(limit).toList();
    } catch (e) {
      print('Erro ao buscar ranking global: $e');
      return [];
    }
  }

  // Buscar estatísticas do jogador
  static Future<Map<String, dynamic>> getPlayerStats(String playerName) async {
    try {
      final results = await getAllResults();
      final playerResults = results.where((r) => r.playerName == playerName).toList();
      
      if (playerResults.isEmpty) {
        return {
          'totalQuizzes': 0,
          'totalScore': 0,
          'averageScore': 0.0,
          'averagePercentage': 0.0,
          'bestScore': 0,
          'categoriesPlayed': <String>[],
        };
      }
      
      int totalQuizzes = playerResults.length;
      int totalScore = playerResults.fold(0, (sum, result) => sum + result.score);
      double averageScore = totalScore / totalQuizzes;
      double averagePercentage = playerResults.fold(0.0, (sum, result) => sum + result.percentage) / totalQuizzes;
      int bestScore = playerResults.map((r) => r.score).reduce((a, b) => a > b ? a : b);
      List<String> categoriesPlayed = playerResults.map((r) => r.category).toSet().toList();
      
      return {
        'totalQuizzes': totalQuizzes,
        'totalScore': totalScore,
        'averageScore': averageScore,
        'averagePercentage': averagePercentage,
        'bestScore': bestScore,
        'categoriesPlayed': categoriesPlayed,
      };
    } catch (e) {
      print('Erro ao buscar estatísticas do jogador: $e');
      return {};
    }
  }

  // Deletar resultado específico
  static Future<void> deleteResult(String resultId) async {
    try {
      await _database.child('quiz_results').child(resultId).remove();
      print('Resultado deletado do Firebase: $resultId');
    } catch (e) {
      print('Erro ao deletar resultado do Firebase: $e');
      throw e;
    }
  }
} 