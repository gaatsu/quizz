import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../services/database_service.dart';
import '../services/firebase_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String playerName;
  final String category;

  const QuizScreen({
    super.key,
    required this.playerName,
    required this.category,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswerIndex;
  bool isAnswered = false;
  bool isLoading = true;
  DateTime? startTime;
  
  late AnimationController _progressController;
  late AnimationController _slideController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _loadQuestions();
    startTime = DateTime.now();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    try {
      final loadedQuestions = await DatabaseService.getQuestionsByCategory(widget.category);
      setState(() {
        questions = loadedQuestions..shuffle(); // Embaralhar perguntas
        isLoading = false;
      });
      _progressController.forward();
      _slideController.forward();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Erro ao carregar perguntas: $e');
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
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Voltar para home
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _selectAnswer(int index) {
    if (isAnswered) return;
    
    setState(() {
      selectedAnswerIndex = index;
      isAnswered = true;
      
      if (index == questions[currentQuestionIndex].correctAnswerIndex) {
        score++;
      }
    });

    // Aguardar um pouco antes de ir para próxima pergunta
    Future.delayed(const Duration(milliseconds: 1500), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        isAnswered = false;
      });
      
      // Resetar e animar para próxima pergunta
      _slideController.reset();
      _slideController.forward();
      _progressController.reset();
      _progressController.forward();
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    final endTime = DateTime.now();
    final timeSpent = endTime.difference(startTime!).inSeconds;
    
    final result = QuizResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      playerName: widget.playerName,
      score: score,
      totalQuestions: questions.length,
      category: widget.category,
      completedAt: endTime,
      timeSpent: timeSpent,
    );

    print('=== QUIZ FINALIZADO ===');
    print('Jogador: ${result.playerName}');
    print('Pontuação: ${result.score}/${result.totalQuestions}');
    print('Categoria: ${result.category}');
    print('Tempo: ${result.timeSpent}s');

    // 🚀 FIREBASE ATIVO - Salvando resultados online
    bool firebaseSaved = false;
    try {
      print('Tentando salvar no Firebase...');
      await FirebaseService.saveQuizResult(result);
      print('✅ Resultado salvo no Firebase com sucesso!');
      firebaseSaved = true;
    } catch (e) {
      print('❌ Erro ao salvar no Firebase: $e');
      print('Continuando sem Firebase...');
      firebaseSaved = false;
    }

    // Navegar para a tela de resultados (com proteção extra)
    try {
      if (mounted) {
        print('Navegando para tela de resultados...');
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              result: result,
              firebaseSaved: firebaseSaved,
            ),
          ),
        );
        print('✅ Navegação concluída!');
      } else {
        print('❌ Widget desmontado, não pode navegar');
      }
    } catch (e) {
      print('❌ Erro na navegação: $e');
      // Em caso de erro, tenta voltar para home
      if (mounted) {
        try {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } catch (e2) {
          print('❌ Erro crítico na navegação: $e2');
        }
      }
    }
  }

  Color _getOptionColor(int index) {
    if (!isAnswered) {
      return selectedAnswerIndex == index ? Colors.blue[100]! : Colors.grey[100]!;
    }
    
    if (index == questions[currentQuestionIndex].correctAnswerIndex) {
      return Colors.green[400]!;
    } else if (index == selectedAnswerIndex) {
      return Colors.red[400]!;
    } else {
      return Colors.grey[200]!;
    }
  }

  Color _getOptionTextColor(int index) {
    if (!isAnswered) {
      return selectedAnswerIndex == index ? Colors.blue[800]! : Colors.black87;
    }
    
    if (index == questions[currentQuestionIndex].correctAnswerIndex) {
      return Colors.white;
    } else if (index == selectedAnswerIndex) {
      return Colors.white;
    } else {
      return Colors.black54;
    }
  }

  IconData? _getOptionIcon(int index) {
    if (!isAnswered) return null;
    
    if (index == questions[currentQuestionIndex].correctAnswerIndex) {
      return Icons.check_circle;
    } else if (index == selectedAnswerIndex) {
      return Icons.cancel;
    } else {
      return null;
    }
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
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : questions.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            'Nenhuma pergunta encontrada para esta categoria.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Header com progresso
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${currentQuestionIndex + 1}/${questions.length}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Pontuação: $score',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              AnimatedBuilder(
                                animation: _progressAnimation,
                                builder: (context, child) {
                                  return LinearProgressIndicator(
                                    value: (currentQuestionIndex + _progressAnimation.value) / questions.length,
                                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                    minHeight: 6,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        
                        // Pergunta e opções
                        Expanded(
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Card(
                              margin: const EdgeInsets.all(24),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Pergunta
                                    Text(
                                      questions[currentQuestionIndex].text,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2d3748),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 32),
                                    
                                    // Opções
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: questions[currentQuestionIndex].options.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 12.0),
                                            child: GestureDetector(
                                              onTap: () => _selectAnswer(index),
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 300),
                                                padding: const EdgeInsets.all(16.0),
                                                decoration: BoxDecoration(
                                                  color: _getOptionColor(index),
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: selectedAnswerIndex == index
                                                        ? Colors.blue
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        color: _getOptionTextColor(index).withValues(alpha: 0.2),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          String.fromCharCode(65 + index), // A, B, C, D
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                            color: _getOptionTextColor(index),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Text(
                                                        questions[currentQuestionIndex].options[index],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                          color: _getOptionTextColor(index),
                                                        ),
                                                      ),
                                                    ),
                                                    if (_getOptionIcon(index) != null)
                                                      Icon(
                                                        _getOptionIcon(index),
                                                        color: _getOptionTextColor(index),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
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
    );
  }
} 