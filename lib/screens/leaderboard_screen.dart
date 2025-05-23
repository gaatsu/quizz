import 'package:flutter/material.dart';
import '../models/quiz_result.dart';
import '../services/firebase_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with TickerProviderStateMixin {
  List<QuizResult> allResults = [];
  String selectedCategory = 'Todos';
  bool isLoading = true;
  late AnimationController _listController;
  late Animation<double> _listAnimation;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _listAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _listController,
      curve: Curves.easeInOut,
    ));
    _loadResults();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  Future<void> _loadResults() async {
    setState(() {
      isLoading = true;
    });

    try {
      print('🔄 Carregando resultados do Firebase...');
      final results = await FirebaseService.getAllResults();
      print('✅ Carregados ${results.length} resultados');
      setState(() {
        allResults = results;
        isLoading = false;
      });
      _listController.forward();
    } catch (e) {
      print('❌ Erro ao carregar resultados: $e');
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Erro ao carregar ranking: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  List<QuizResult> get filteredResults {
    if (selectedCategory == 'Todos') {
      return allResults;
    }
    return allResults.where((result) => result.category == selectedCategory).toList();
  }

  List<String> get availableCategories {
    final categories = allResults.map((r) => r.category).toSet().toList();
    categories.sort();
    return ['Todos', ...categories];
  }

  Color _getRankColor(int position) {
    switch (position) {
      case 0:
        return Colors.amber; // Ouro
      case 1:
        return Colors.grey[400]!; // Prata
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey[300]!;
    }
  }

  IconData _getRankIcon(int position) {
    switch (position) {
      case 0:
        return Icons.emoji_events; // Troféu
      case 1:
        return Icons.military_tech; // Medalha
      case 2:
        return Icons.workspace_premium; // Prêmio
      default:
        return Icons.person;
    }
  }

  Widget _buildRankCard(QuizResult result, int index) {
    return AnimatedBuilder(
      animation: _listAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _listAnimation.value)),
          child: Opacity(
            opacity: _listAnimation.value,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // Reduzido vertical
              elevation: index < 3 ? 8 : 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: index < 3
                      ? LinearGradient(
                          colors: [
                            _getRankColor(index).withValues(alpha: 0.1),
                            _getRankColor(index).withValues(alpha: 0.05),
                          ],
                        )
                      : null,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Reduzido vertical
                  leading: Container(
                    width: 45, // Reduzido
                    height: 45, // Reduzido
                    decoration: BoxDecoration(
                      color: _getRankColor(index),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getRankIcon(index),
                          color: Colors.white,
                          size: index < 3 ? 18 : 14, // Reduzido
                        ),
                        if (index >= 3)
                          Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8, // Reduzido
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                  title: Text(
                    result.playerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15, // Reduzido
                      color: Color(0xFF2d3748),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${result.category} • ${_formatDate(result.completedAt)}',
                        style: TextStyle(
                          fontSize: 11, // Reduzido
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 12, color: Colors.grey[600]), // Reduzido
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(result.timeSpent),
                            style: TextStyle(
                              fontSize: 11, // Reduzido
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${result.score}/${result.totalQuestions}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15, // Reduzido
                          color: Color(0xFF2d3748),
                        ),
                      ),
                      Text(
                        '${result.percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 13, // Reduzido
                          color: _getPerformanceColor(result.percentage),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getPerformanceColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 70) return Colors.blue;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0), // Reduzido
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        '🏆 Ranking',
                        style: TextStyle(
                          fontSize: 24, // Reduzido
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: _loadResults,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Filtro de categoria
              if (availableCategories.length > 1)
                Container(
                  height: 45, // Reduzido
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: availableCategories.length,
                    itemBuilder: (context, index) {
                      final category = availableCategories[index];
                      final isSelected = selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                selectedCategory = category;
                              });
                            }
                          },
                          selectedColor: Colors.white,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF667eea) : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12, // Reduzido
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 12), // Reduzido

              // Lista de resultados
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Carregando ranking...'),
                            ],
                          ),
                        )
                      : filteredResults.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.emoji_events_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Nenhum resultado encontrado',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Seja o primeiro a jogar!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    '${filteredResults.length} resultado${filteredResults.length != 1 ? 's' : ''}',
                                    style: const TextStyle(
                                      fontSize: 14, // Reduzido
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredResults.length,
                                    itemBuilder: (context, index) {
                                      return _buildRankCard(filteredResults[index], index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 