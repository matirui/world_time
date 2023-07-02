import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';

class WorldTimeProvider extends ChangeNotifier {
  WorldTime worldTime = WorldTime(
      flag: 'argentina.png',
      location: 'Argentina',
      url: 'America/Argentina/Cordoba');

  Future<WorldTime> getTime() async {
    await worldTime.getTime();
    return worldTime;
  }

  void setWorldTime(WorldTime worldTime) {
    this.worldTime = worldTime;
    notifyListeners();
  }
}
