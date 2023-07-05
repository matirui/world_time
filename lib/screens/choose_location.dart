import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:world_time/services/world_time.dart';
import 'package:world_time/services/world_time_provider.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  Future<List<WorldTime>> _filteredWorldTimes = Future(() => []);
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _filteredWorldTimes = context.read<WorldTimeProvider>().worldTimes;
    super.initState();
  }

  void _filter(String filter) async {
    List<WorldTime> result = [];
    if (filter.isEmpty) {
      result = await context.read<WorldTimeProvider>().worldTimes;
    } else {
      result = await context.read<WorldTimeProvider>().worldTimes;
      result = result
          .where((e) => e.location.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredWorldTimes = Future(() => result);
    });
  }

  Widget buildWorldTimesList(List<WorldTime> worldTimes) {
    List<WorldTime> favorites = context.watch<WorldTimeProvider>().favorites;
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
                subtitle: Text(worldTimes[index].url),
                subtitleTextStyle: const TextStyle(fontSize: 12),
                leading: CircleAvatar(
                  backgroundImage: Image.network(worldTimes[index].flag).image,
                ),
                trailing: IconButton(
                  onPressed: () {
                    if (!favorites.contains(worldTimes[index])) {
                      context
                          .read<WorldTimeProvider>()
                          .addToFavorites(worldTimes[index]);
                    } else {
                      context
                          .read<WorldTimeProvider>()
                          .removeFromFavorites(worldTimes[index]);
                    }
                  },
                  icon: Icon(Icons.favorite,
                      color: favorites.contains(worldTimes[index])
                          ? Colors.red
                          : Colors.grey),
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
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () => context.push('/favorites'),
            )
          ],
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
