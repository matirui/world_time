import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:word_time/services/world_time.dart';
import 'package:word_time/services/world_time_provider.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  final Future<List<WorldTime>> _worldTimes = getWorldTimes();
  Future<List<WorldTime>> _filteredWorldTimes = Future(() => []);
  final TextEditingController _textController = TextEditingController();

  static Future<List<WorldTime>> getWorldTimes() async {
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

  @override
  void initState() {
    _filteredWorldTimes = _worldTimes;
    super.initState();
  }

  void _filter(String filter) async {
    List<WorldTime> result = [];
    if (filter.isEmpty) {
      result = await _worldTimes;
    } else {
      result = await _worldTimes;
      result = result
          .where((e) => e.location.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredWorldTimes = Future(() => result);
    });
  }

  Widget buildWorldTimesList(List<WorldTime> worldTimes) {
    return Expanded(
      child: ListView.builder(
        itemCount: worldTimes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            child: Card(
              child: ListTile(
                onTap: () => updateTime(context, worldTimes[index]),
                title: Text(worldTimes[index].location),
                leading: CircleAvatar(
                  backgroundImage: Image.network(worldTimes[index].flag).image,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void updateTime(BuildContext context, WorldTime worldTime) {
    if (context.mounted) {
      context.read<WorldTimeProvider>().setWorldTime(worldTime);
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          title: const Text("Choose a location"),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => {_filter(value)},
                decoration: const InputDecoration(
                  labelText: 'Search location',
                  suffixIcon: Icon(Icons.search),
                ),
                controller: _textController,
              ),
            ),
            FutureBuilder(
              future: _filteredWorldTimes,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Algo salió mal 😫');
                } else if (snapshot.hasData) {
                  final filteredWorldTimes = snapshot.data!;
                  return buildWorldTimesList(filteredWorldTimes);
                } else {
                  return const Text("No data...");
                }
              },
            ),
          ],
        ));
  }
}
