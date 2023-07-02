import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WorldTime {
  String location; // location name for the UI
  String? time; // the time in that location
  String flag; // url to an asset flag icon
  String url; // location url for api endpoint
  String? code;
  bool? isDayTime;

  WorldTime({required this.flag, required this.location, required this.url});

  Future<WorldTime> getTime() async {
    try {
      //await Future.delayed(const Duration(seconds: 1));
      Response respose =
          await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(respose.body);

      // get properties from data
      String datetime = data['datetime'];
      int offset = data['raw_offset'];

      // create DateTime object
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(seconds: offset));

      // set time property
      isDayTime = now.hour > 6 && now.hour < 20;
      time = DateFormat.jm().format(now);
      return this;
    } catch (e) {
      time = 'an error has ocurred, could not get the data :(';
    }
    return Future(() => this);
  }
}
