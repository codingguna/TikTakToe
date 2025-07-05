import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import '../models/game_state.dart';
import '../services/storage_service.dart';

class GameScreen extends StatefulWidget {
  final GameState gameState;
  const GameScreen({super.key, required this.gameState});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState game;

  @override
  void initState() {
    super.initState();
    game = widget.gameState;
  }

  void _handleTap(int index) async {
    if (game.board[index] != '' || _hasRoundWinner()) return;

    setState(() {
      game.board[index] = game.currentPlayer;
      String? winner = _checkWinner();
      if (winner != null) {
        _updateWinCount(winner);
      } else if (!game.board.contains('')) {
        _advanceRound();
      } else {
        game.currentPlayer = game.currentPlayer == 'X' ? 'O' : 'X';
      }
    });

    await StorageService.saveGame(game);
  }

  String? _checkWinner() {
    const patterns = [
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6],
    ];
    for (var p in patterns) {
      if (game.board[p[0]]!='' &&
          game.board[p[0]]==game.board[p[1]] &&
          game.board[p[1]]==game.board[p[2]]) {
        return game.board[p[0]];
      }
    }
    return null;
  }

  bool _hasRoundWinner() =>
    _checkWinner()!=null || !game.board.contains('');

  void _updateWinCount(String winner) async {
    if (winner == 'X') game.player1Wins++;
    else game.player2Wins++;

    if (game.player1Wins==2 || game.player2Wins==2 || game.round==3) {
      await StorageService.deleteGame();
      _showCelebrationPopup(
        game.player1Wins>game.player2Wins ? game.player1 : game.player2);
    } else {
      _advanceRound();
    }
  }

  void _advanceRound() {
    setState(() {
      game.round++;
      game.board = List.filled(9, '');
      game.currentPlayer = game.round % 2 == 1 ? 'X' : 'O';
    });
  }

  void _showCelebrationPopup(String winnerName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/animations/winner.json', height: 150, repeat: true),
              SizedBox(height: 20),
              Text(
                '🏆 Match Winner 🏆',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              SizedBox(height: 10),
              Text(
                winnerName,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.orange),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Return to Home'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCell(int index) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Center(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Text(
              game.board[index],
              key: ValueKey(game.board[index]),
              style: TextStyle(
                fontSize: 42,
                color: game.board[index] == 'X' ? Colors.deepPurple : Colors.orange,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBoard() => Container(
    width: 300,
    height: 300,
    margin: EdgeInsets.symmetric(vertical: 16),
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: 9,
      itemBuilder: (_, i) => _buildCell(i),
    ),
  );

  Widget _buildPlayerInfo(String name, int wins) => AnimatedTextKit(
    animatedTexts: [
      FadeAnimatedText('$name (${wins}/3)',
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ],
    isRepeatingAnimation: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Round ${game.round}/3 • ${game.currentPlayer}\'s turn'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPlayerInfo(game.player1, game.player1Wins),
          _buildBoard(),
          _buildPlayerInfo(game.player2, game.player2Wins),
        ],
      ),
    );
  }
}
