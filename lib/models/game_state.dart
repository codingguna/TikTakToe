class GameState {
  List<String> board;
  String currentPlayer;
  String player1;
  String player2;
  int player1Wins;
  int player2Wins;
  int round;

  GameState({
    required this.board,
    required this.currentPlayer,
    required this.player1,
    required this.player2,
    required this.player1Wins,
    required this.player2Wins,
    required this.round,
  });

  factory GameState.initial(String p1, String p2) {
    return GameState(
      board: List.filled(9, ''),
      currentPlayer: 'X',
      player1: p1,
      player2: p2,
      player1Wins: 0,
      player2Wins: 0,
      round: 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'board': board,
        'currentPlayer': currentPlayer,
        'player1': player1,
        'player2': player2,
        'player1Wins': player1Wins,
        'player2Wins': player2Wins,
        'round': round,
      };

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      board: List<String>.from(json['board']),
      currentPlayer: json['currentPlayer'],
      player1: json['player1'],
      player2: json['player2'],
      player1Wins: json['player1Wins'],
      player2Wins: json['player2Wins'],
      round: json['round'],
    );
  }
}
