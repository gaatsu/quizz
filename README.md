# 🧠 Quiz Master - Aplicativo de Quiz em Flutter

Um aplicativo de quiz moderno e interativo desenvolvido em Flutter com banco de dados SQLite local para perguntas e Firebase Realtime Database para ranking online.

## ✨ Funcionalidades

- 🎯 **Quiz de múltipla escolha** com diferentes categorias
- 🗄️ **SQLite** para armazenamento local das perguntas
- 🔥 **Firebase Realtime Database** para ranking online
- 🏆 **Sistema de ranking** com leaderboard
- ⏱️ **Cronômetro** e sistema de pontuação
- 🎨 **Interface moderna** com animações
- 📱 **Design responsivo** e Material Design 3

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK (versão 3.5.0 ou superior)
- Dart SDK
- Android Studio ou VS Code
- Conta no Firebase (para funcionalidade online)

### Passos para Configuração

1. **Clone ou baixe o projeto**
```bash
cd quiz_app
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Configure o Firebase** (Opcional - para funcionalidade online)
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
   - Ative o Realtime Database
   - Execute o FlutterFire CLI:
   ```bash
   firebase login
   flutterfire configure
   ```
   - Ou substitua as configurações em `lib/firebase_options.dart` com suas chaves

4. **Execute o aplicativo**
```bash
flutter run
```

## 📂 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── firebase_options.dart     # Configurações do Firebase
├── models/                   # Modelos de dados
│   ├── question.dart         # Modelo da pergunta
│   └── quiz_result.dart      # Modelo do resultado
├── services/                 # Serviços e lógica de negócio
│   ├── database_service.dart # Serviço SQLite
│   └── firebase_service.dart # Serviço Firebase
└── screens/                  # Telas da aplicação
    ├── home_screen.dart      # Tela inicial
    ├── quiz_screen.dart      # Tela do quiz
    ├── result_screen.dart    # Tela de resultados
    └── leaderboard_screen.dart # Tela de ranking
```

## 🎮 Como Usar

1. **Tela Inicial**: Digite seu nome e escolha uma categoria
2. **Quiz**: Responda as perguntas tocando nas opções
3. **Resultados**: Veja sua pontuação e tempo
4. **Ranking**: Compare seus resultados com outros jogadores

## 🗃️ Banco de Dados

### SQLite (Local)
- Armazena perguntas por categoria
- Perguntas incluem: texto, opções, resposta correta, categoria e dificuldade
- Dados iniciais pré-populados com perguntas de:
  - Geografia 🌍
  - História 📚
  - Ciências 🔬
  - Esportes ⚽

### Firebase Realtime Database (Online)
- Armazena resultados dos quizzes
- Ranking global e por categoria
- Estatísticas dos jogadores
- Sincronização em tempo real

## 🎨 Design

- **Cores**: Gradiente azul-roxo moderno
- **Tipografia**: Google Fonts (Poppins)
- **Animações**: Transições suaves entre telas
- **Ícones**: Material Design Icons com emojis
- **Layout**: Cards com bordas arredondadas e sombras

## 📱 Funcionalidades Offline

O aplicativo funciona completamente offline para:
- Visualizar e responder perguntas
- Calcular pontuação
- Navegar entre telas

A funcionalidade online (ranking) requer conexão com a internet.

## 🛠️ Tecnologias Utilizadas

- **Flutter** - Framework principal
- **SQLite** (sqflite) - Banco local
- **Firebase** - Backend online
- **Google Fonts** - Tipografia
- **UUID** - Geração de IDs únicos
- **Animações** - Flutter Animations

## 🔧 Configuração Avançada

### Adicionando Novas Perguntas

Edite o arquivo `lib/services/database_service.dart` na função `_insertSampleQuestions()`:

```dart
Question(
  text: "Sua pergunta aqui?",
  options: ["Opção A", "Opção B", "Opção C", "Opção D"],
  correctAnswerIndex: 0, // Índice da resposta correta (0-3)
  category: "Sua Categoria",
  difficulty: 1, // 1=Fácil, 2=Médio, 3=Difícil
),
```

### Personalizando Cores

Edite o `main.dart` para alterar as cores do tema:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF667eea), // Cor principal
  brightness: Brightness.light,
),
```

## 📄 Licença

Este projeto é desenvolvido para fins educacionais e de demonstração.

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para:
- Reportar bugs
- Sugerir novas funcionalidades
- Enviar pull requests
- Adicionar novas perguntas

## 📞 Suporte

Se você encontrar algum problema ou tiver dúvidas:
1. Verifique se todas as dependências estão instaladas
2. Execute `flutter doctor` para diagnosticar problemas
3. Verifique se o Firebase está configurado corretamente
4. Consulte a documentação do Flutter

---

Desenvolvido com ❤️ usando Flutter
