import 'dart:io';

import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';

class WorldTimeProvider extends ChangeNotifier {
  WorldTime _worldTime = WorldTime(
      flag: 'argentina.png',
      location: 'Argentina',
      url: 'America/Argentina/Cordoba');
  late WorldTime _localTime;
  final Future<List<WorldTime>> _worldTimes = generateWorldTimes();
  final List<WorldTime> _favorites = [];
  static bool _init = true;

  WorldTime get worldTime => _worldTime;
  WorldTime get localTime => _localTime;
  Future<List<WorldTime>> get worldTimes => _worldTimes;
  List<WorldTime> get favorites => _favorites;

  Future<WorldTime> getTime() async {
    if (_init) {
      _init = false;
      _localTime = await _worldTime.getLocalTime();
      return _localTime;
    }
    await _localTime.getTime();
    await _worldTime.getTime();
    return _worldTime;
  }

  Future<List<WorldTime>> loadFavoritesWorldTimes() async {
    for (var element in _favorites) {
      await element.getTime();
    }
    return _favorites;
  }

  static Future<List<WorldTime>> generateWorldTimes() async {
    List<String> list = await File('assets/country.csv').readAsLines();
    List<List<String>> countries = list.map((e) => e.split(';')).toList();
    List<WorldTime> worldTimes = countries
        .map(
          (e) => WorldTime(
            flag: 'https://flagcdn.com/w160/${e[0].toLowerCase()}.png',
            location: e[1],
            url: e[2],
          ),
        )
        .toList();
    return worldTimes;
  }

  void setWorldTime(WorldTime worldTime) {
    _worldTime = worldTime;
    notifyListeners();
  }

  void addToFavorites(WorldTime worldTime) {
    _favorites.add(worldTime);
    notifyListeners();
  }

  void removeFromFavorites(WorldTime worldTime) {
    _favorites.remove(worldTime);
    notifyListeners();
  }
}
