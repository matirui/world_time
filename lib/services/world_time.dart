import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class WorldTime {
  String location; // location name for the UI
  DateTime? time; // the time in that location
  String flag; // url to an asset flag icon
  String url; // location url for api endpoint
  String? code;
  bool? isDayTime;
  String? city;

  WorldTime({required this.flag, required this.location, required this.url});

  Future<WorldTime> getTime() async {
    try {
      //await Future.delayed(const Duration(seconds: 1));
      Response respose =
          await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(respose.body);

      // get properties from data
      String datetime = data['datetime'];
      String offset = data['utc_offset'];

      // create DateTime object
      List<String> durations = offset.substring(1).split(':');
      Duration durationOffset = Duration(
            hours: int.parse(durations[0]),
            minutes: int.parse(durations[1]),
          ) *
          (offset.contains('-') ? -1 : 1);
      DateTime now = DateTime.parse(datetime);
      now = now.add(durationOffset);

      // set time property
      isDayTime = now.hour > 6 && now.hour < 20;

      time = now;
      return this;
    } catch (e) {
      time = null;
    }
    return Future(() => this);
  }

  Future<WorldTime> getLocalTime() async {
    try {
      Response respose = await get(Uri.parse('https://ipinfo.io'), headers: {
        HttpHeaders.acceptHeader: 'application/json',
      });
      Map data = jsonDecode(respose.body);
      String timezone = data['timezone'];
      code = data['country'];
      city = data['city'];

      List<String> list = await File('assets/country.csv').readAsLines();
      List<List<String>> countries = list.map((e) => e.split(';')).toList();

      location = countries.where((e) => e[0].contains(code!)).toList()[0][1];
      flag = 'https://flagcdn.com/w160/${code!.toLowerCase()}.png';
      url = timezone;
      return await getTime();
    } catch (e) {
      rethrow;
    }
  }
}
