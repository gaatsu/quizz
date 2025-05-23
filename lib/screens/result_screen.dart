import 'package:flutter/material.dart';
import '../models/quiz_result.dart';
import 'home_screen.dart';
import 'leaderboard_screen.dart';

class ResultScreen extends StatefulWidget {
  final QuizResult result;
  final bool firebaseSaved; // Indica se foi salvo no Firebase

  const ResultScreen({
    super.key,
    required this.result,
    this.firebaseSaved = false, // Padrão false
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  void _viewLeaderboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
    );
  }

  String _getPerformanceMessage() {
    final percentage = widget.result.percentage;
    if (percentage >= 90) {
      return 'Excelente! 🏆';
    } else if (percentage >= 70) {
      return 'Muito Bom! 👏';
    } else if (percentage >= 50) {
      return 'Bom Trabalho! 👍';
    } else {
      return 'Continue Praticando! 💪';
    }
  }

  Color _getPerformanceColor() {
    final percentage = widget.result.percentage;
    if (percentage >= 90) {
      return Colors.amber;
    } else if (percentage >= 70) {
      return Colors.green;
    } else if (percentage >= 50) {
      return Colors.blue;
    } else {
      return Colors.orange;
    }
  }

  IconData _getPerformanceIcon() {
    final percentage = widget.result.percentage;
    if (percentage >= 90) {
      return Icons.emoji_events;
    } else if (percentage >= 70) {
      return Icons.thumb_up;
    } else if (percentage >= 50) {
      return Icons.sentiment_satisfied;
    } else {
      return Icons.sentiment_neutral;
    }
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                
                // Título compacto
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Quiz Finalizado!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Card de resultados - SEM SCROLL
                Expanded(
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Ícone de performance (ainda menor)
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _getPerformanceColor().withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getPerformanceIcon(),
                                size: 26,
                                color: _getPerformanceColor(),
                              ),
                            ),
                            
                            // Mensagem de performance
                            Text(
                              _getPerformanceMessage(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _getPerformanceColor(),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            // Estatísticas (grid mais compacto)
                            _buildCompactStatsGrid(),
                            
                            // Botões (mais compactos)
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Column(
                                children: [
                                  // Botão Ranking
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: _viewLeaderboard,
                                      icon: const Icon(Icons.leaderboard, size: 18),
                                      label: Text(
                                        widget.firebaseSaved ? 'Ver Ranking' : 'Ver Ranking (Offline)',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF667eea),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Botão Home
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: _goHome,
                                      icon: const Icon(Icons.home, size: 18),
                                      label: const Text(
                                        'Voltar ao Início',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF667eea),
                                        side: const BorderSide(color: Color(0xFF667eea)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Nova função super compacta para as estatísticas
  Widget _buildCompactStatsGrid() {
    return Column(
      children: [
        // Primeira linha
        Row(
          children: [
            Expanded(child: _buildMiniStatCard(
              'Score',
              '${widget.result.score}/${widget.result.totalQuestions}',
              Icons.score,
              Colors.blue,
            )),
            const SizedBox(width: 8), // Reduzido
            Expanded(child: _buildMiniStatCard(
              'Acertos',
              '${widget.result.percentage.toStringAsFixed(1)}%',
              Icons.percent,
              Colors.green,
            )),
          ],
        ),
        const SizedBox(height: 8), // Reduzido
        // Segunda linha
        Row(
          children: [
            Expanded(child: _buildMiniStatCard(
              'Tempo',
              _formatTime(widget.result.timeSpent),
              Icons.timer,
              Colors.orange,
            )),
            const SizedBox(width: 8), // Reduzido
            Expanded(child: _buildMiniStatCard(
              widget.result.category,
              widget.firebaseSaved ? 'Online ✅' : 'Offline ⚠️',
              widget.firebaseSaved ? Icons.cloud_done : Icons.cloud_off,
              widget.firebaseSaved ? Colors.green : Colors.grey,
            )),
          ],
        ),
      ],
    );
  }

  // Versão mini do stat card
  Widget _buildMiniStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8), // Reduzido de 12
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8), // Reduzido de 12
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16), // Reduzido de 18
          const SizedBox(height: 2), // Reduzido
          Text(
            label,
            style: TextStyle(
              fontSize: 10, // Reduzido de 12
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14, // Reduzido de 16
              fontWeight: FontWeight.bold,
              color: Color(0xFF2d3748),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
} 