import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

class StorageService {
  static const _key = 'saved_game';

  static Future<void> saveGame(GameState game) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(game.toJson()));
  }

  static Future<GameState?> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return null;
    return GameState.fromJson(jsonDecode(json));
  }

  static Future<void> deleteGame() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_key);
  }
}
