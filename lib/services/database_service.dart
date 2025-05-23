import '../models/question.dart';

class DatabaseService {
  static List<Question> _questions = [];
  static bool _initialized = false;

  static Future<void> _initDatabase() async {
    if (_initialized) return;
    
    // Inserir perguntas de exemplo em memória
    _questions = [
      // Geografia (10 questões)
      Question(
        id: 1,
        text: "Qual é a capital do Brasil?",
        options: ["São Paulo", "Rio de Janeiro", "Brasília", "Salvador"],
        correctAnswerIndex: 2,
        category: "Geografia",
        difficulty: 1,
      ),
      Question(
        id: 2,
        text: "Qual o maior oceano do mundo?",
        options: ["Atlântico", "Índico", "Ártico", "Pacífico"],
        correctAnswerIndex: 3,
        category: "Geografia",
        difficulty: 1,
      ),
      Question(
        id: 3,
        text: "Em que continente fica o Egito?",
        options: ["Ásia", "África", "Europa", "América"],
        correctAnswerIndex: 1,
        category: "Geografia",
        difficulty: 2,
      ),
      Question(
        id: 31,
        text: "Qual é o menor país do mundo?",
        options: ["Mônaco", "Vaticano", "San Marino", "Liechtenstein"],
        correctAnswerIndex: 1,
        category: "Geografia",
        difficulty: 2,
      ),
      Question(
        id: 32,
        text: "Qual rio passa pela cidade de Paris?",
        options: ["Danúbio", "Tâmisa", "Sena", "Reno"],
        correctAnswerIndex: 2,
        category: "Geografia",
        difficulty: 1,
      ),
      Question(
        id: 33,
        text: "Qual é a montanha mais alta do mundo?",
        options: ["K2", "Everest", "Kilimanjaro", "Denali"],
        correctAnswerIndex: 1,
        category: "Geografia",
        difficulty: 1,
      ),
      Question(
        id: 34,
        text: "Em qual país fica a cidade de Machu Picchu?",
        options: ["Chile", "Bolívia", "Peru", "Equador"],
        correctAnswerIndex: 2,
        category: "Geografia",
        difficulty: 2,
      ),
      Question(
        id: 35,
        text: "Qual é o deserto mais quente do mundo?",
        options: ["Saara", "Atacama", "Gobi", "Kalahari"],
        correctAnswerIndex: 0,
        category: "Geografia",
        difficulty: 2,
      ),
      Question(
        id: 36,
        text: "Quantos estados tem o Brasil?",
        options: ["25", "26", "27", "28"],
        correctAnswerIndex: 1,
        category: "Geografia",
        difficulty: 1,
      ),
      Question(
        id: 37,
        text: "Qual país tem a forma de uma bota?",
        options: ["Espanha", "Portugal", "Itália", "Grécia"],
        correctAnswerIndex: 2,
        category: "Geografia",
        difficulty: 1,
      ),

      // História (10 questões)
      Question(
        id: 4,
        text: "Em que ano o Brasil foi descoberto?",
        options: ["1492", "1500", "1498", "1502"],
        correctAnswerIndex: 1,
        category: "História",
        difficulty: 1,
      ),
      Question(
        id: 5,
        text: "Quem pintou a Mona Lisa?",
        options: ["Van Gogh", "Picasso", "Leonardo da Vinci", "Michelangelo"],
        correctAnswerIndex: 2,
        category: "História",
        difficulty: 2,
      ),
      Question(
        id: 6,
        text: "Em que ano terminou a Segunda Guerra Mundial?",
        options: ["1944", "1945", "1946", "1947"],
        correctAnswerIndex: 1,
        category: "História",
        difficulty: 2,
      ),
      Question(
        id: 38,
        text: "Quem foi o primeiro presidente do Brasil?",
        options: ["Getúlio Vargas", "Deodoro da Fonseca", "Floriano Peixoto", "Prudente de Morais"],
        correctAnswerIndex: 1,
        category: "História",
        difficulty: 2,
      ),
      Question(
        id: 39,
        text: "Em que ano começou a Primeira Guerra Mundial?",
        options: ["1912", "1913", "1914", "1915"],
        correctAnswerIndex: 2,
        category: "História",
        difficulty: 2,
      ),
      Question(
        id: 40,
        text: "Quem descobriu o Brasil?",
        options: ["Vasco da Gama", "Pedro Álvares Cabral", "Cristóvão Colombo", "Américo Vespúcio"],
        correctAnswerIndex: 1,
        category: "História",
        difficulty: 1,
      ),
      Question(
        id: 41,
        text: "Em que século aconteceu a Revolução Francesa?",
        options: ["XVII", "XVIII", "XIX", "XX"],
        correctAnswerIndex: 1,
        category: "História",
        difficulty: 2,
      ),
      Question(
        id: 42,
        text: "Qual civilização construiu as pirâmides de Gizé?",
        options: ["Romana", "Grega", "Egípcia", "Maia"],
        correctAnswerIndex: 2,
        category: "História",
        difficulty: 1,
      ),
      Question(
        id: 43,
        text: "Em que ano o Brasil se tornou independente?",
        options: ["1820", "1821", "1822", "1823"],
        correctAnswerIndex: 2,
        category: "História",
        difficulty: 1,
      ),
      Question(
        id: 44,
        text: "Quem foi Napoleão Bonaparte?",
        options: ["Rei da França", "Imperador da França", "Presidente da França", "Papa"],
        correctAnswerIndex: 1,
        category: "História",
        difficulty: 1,
      ),

      // Ciências (10 questões)
      Question(
        id: 7,
        text: "Qual é o planeta mais próximo do Sol?",
        options: ["Vênus", "Terra", "Mercúrio", "Marte"],
        correctAnswerIndex: 2,
        category: "Ciências",
        difficulty: 1,
      ),
      Question(
        id: 8,
        text: "Quantos ossos tem o corpo humano adulto?",
        options: ["196", "206", "216", "226"],
        correctAnswerIndex: 1,
        category: "Ciências",
        difficulty: 2,
      ),
      Question(
        id: 9,
        text: "Qual é a fórmula química da água?",
        options: ["H2O", "CO2", "NaCl", "O2"],
        correctAnswerIndex: 0,
        category: "Ciências",
        difficulty: 1,
      ),
      Question(
        id: 45,
        text: "Qual é o maior planeta do sistema solar?",
        options: ["Saturno", "Júpiter", "Netuno", "Urano"],
        correctAnswerIndex: 1,
        category: "Ciências",
        difficulty: 1,
      ),
      Question(
        id: 46,
        text: "Quantos cromossomos tem o ser humano?",
        options: ["44", "45", "46", "47"],
        correctAnswerIndex: 2,
        category: "Ciências",
        difficulty: 2,
      ),
      Question(
        id: 47,
        text: "Qual gás é mais abundante na atmosfera terrestre?",
        options: ["Oxigênio", "Nitrogênio", "Dióxido de carbono", "Hidrogênio"],
        correctAnswerIndex: 1,
        category: "Ciências",
        difficulty: 2,
      ),
      Question(
        id: 48,
        text: "Qual é a velocidade da luz no vácuo?",
        options: ["250.000 km/s", "300.000 km/s", "350.000 km/s", "400.000 km/s"],
        correctAnswerIndex: 1,
        category: "Ciências",
        difficulty: 2,
      ),
      Question(
        id: 49,
        text: "Quantos corações tem uma minhoca?",
        options: ["1", "3", "5", "7"],
        correctAnswerIndex: 2,
        category: "Ciências",
        difficulty: 2,
      ),
      Question(
        id: 50,
        text: "Qual órgão do corpo humano produz insulina?",
        options: ["Fígado", "Pâncreas", "Estômago", "Intestino"],
        correctAnswerIndex: 1,
        category: "Ciências",
        difficulty: 2,
      ),
      Question(
        id: 51,
        text: "Qual é o animal terrestre mais rápido?",
        options: ["Leopardo", "Guepardo", "Leão", "Tigre"],
        correctAnswerIndex: 1,
        category: "Ciências",
        difficulty: 1,
      ),

      // Esportes (10 questões)
      Question(
        id: 10,
        text: "Quantos jogadores tem um time de futebol em campo?",
        options: ["10", "11", "12", "9"],
        correctAnswerIndex: 1,
        category: "Esportes",
        difficulty: 1,
      ),
      Question(
        id: 11,
        text: "Em que esporte se usa raquete?",
        options: ["Futebol", "Basquete", "Tênis", "Natação"],
        correctAnswerIndex: 2,
        category: "Esportes",
        difficulty: 1,
      ),
      Question(
        id: 12,
        text: "Qual país ganhou mais Copas do Mundo de futebol?",
        options: ["Argentina", "Alemanha", "Brasil", "Itália"],
        correctAnswerIndex: 2,
        category: "Esportes",
        difficulty: 2,
      ),
      Question(
        id: 52,
        text: "Quantos sets tem uma partida de vôlei masculino?",
        options: ["3", "4", "5", "6"],
        correctAnswerIndex: 2,
        category: "Esportes",
        difficulty: 2,
      ),
      Question(
        id: 53,
        text: "Em que ano foram realizadas as primeiras Olimpíadas modernas?",
        options: ["1894", "1896", "1898", "1900"],
        correctAnswerIndex: 1,
        category: "Esportes",
        difficulty: 2,
      ),
      Question(
        id: 54,
        text: "Qual é a distância oficial de uma maratona?",
        options: ["40,195 km", "41,195 km", "42,195 km", "43,195 km"],
        correctAnswerIndex: 2,
        category: "Esportes",
        difficulty: 2,
      ),
      Question(
        id: 55,
        text: "Quantos pontos vale um touchdown no futebol americano?",
        options: ["5", "6", "7", "8"],
        correctAnswerIndex: 1,
        category: "Esportes",
        difficulty: 2,
      ),
      Question(
        id: 56,
        text: "Em que esporte Michael Jordan ficou famoso?",
        options: ["Futebol", "Basquete", "Tênis", "Golf"],
        correctAnswerIndex: 1,
        category: "Esportes",
        difficulty: 1,
      ),
      Question(
        id: 57,
        text: "Quantos jogadores tem uma equipe de basquete em quadra?",
        options: ["4", "5", "6", "7"],
        correctAnswerIndex: 1,
        category: "Esportes",
        difficulty: 1,
      ),
      Question(
        id: 58,
        text: "Qual país sediou a Copa do Mundo de 2018?",
        options: ["Brasil", "Alemanha", "Rússia", "França"],
        correctAnswerIndex: 2,
        category: "Esportes",
        difficulty: 1,
      ),
    ];
    
    _initialized = true;
  }

  // Operações CRUD
  static Future<int> insertQuestion(Question question) async {
    await _initDatabase();
    _questions.add(question);
    return _questions.length;
  }

  static Future<List<Question>> getAllQuestions() async {
    await _initDatabase();
    return List.from(_questions);
  }

  static Future<List<Question>> getQuestionsByCategory(String category) async {
    await _initDatabase();
    return _questions.where((q) => q.category == category).toList();
  }

  static Future<List<Question>> getQuestionsByDifficulty(int difficulty) async {
    await _initDatabase();
    return _questions.where((q) => q.difficulty == difficulty).toList();
  }

  static Future<List<String>> getCategories() async {
    await _initDatabase();
    return _questions.map((q) => q.category).toSet().toList()..sort();
  }

  static Future<int> updateQuestion(Question question) async {
    await _initDatabase();
    final index = _questions.indexWhere((q) => q.id == question.id);
    if (index != -1) {
      _questions[index] = question;
      return 1;
    }
    return 0;
  }

  static Future<int> deleteQuestion(int id) async {
    await _initDatabase();
    final index = _questions.indexWhere((q) => q.id == id);
    if (index != -1) {
      _questions.removeAt(index);
      return 1;
    }
    return 0;
  }

  static Future<void> closeDatabase() async {
    // Nada a fazer na versão em memória
  }
} 