import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../services/storage_service.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();

  Future<void> _startNewGame() async {
    final p1 = _player1Controller.text.trim();
    final p2 = _player2Controller.text.trim();
    if (p1.isEmpty || p2.isEmpty) return;

    final newGame = GameState.initial(p1, p2);
    await StorageService.saveGame(newGame);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GameScreen(gameState: newGame)),
    );
  }

  Future<void> _continueGame() async {
    final savedGame = await StorageService.loadGame();
    if (savedGame != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GameScreen(gameState: savedGame)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('XOX Game')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _player1Controller,
              decoration: InputDecoration(labelText: 'Player 1 Name (X)'),
            ),
            TextField(
              controller: _player2Controller,
              decoration: InputDecoration(labelText: 'Player 2 Name (O)'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _startNewGame,
              child: Text('Start New Game'),
            ),
            ElevatedButton(
              onPressed: _continueGame,
              child: Text('Continue Game'),
            ),
          ],
        ),
      ),
    );
  }
}
