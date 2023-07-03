import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:world_time/screens/counter.dart';
import 'package:world_time/services/world_time.dart';

import '../services/world_time_provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  Future<List<WorldTime>> getFavoritesWorldTimes() async {
    var favorites = context.watch<WorldTimeProvider>().favorites;
    for (var element in favorites) {
      await element.getTime();
    }
    return favorites;
  }

  Widget buildFavoritesWorldTimesList(List<WorldTime> favoritesWorldTimes) {
    return Expanded(
      child: ListView.builder(
        itemCount: favoritesWorldTimes.length,
        itemBuilder: (context, index) {
          final currentFavorite = favoritesWorldTimes[index];
          return Card(
            child: ListTile(
              title: Text(
                currentFavorite.location,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Counter(
                now: currentFavorite.time!,
                size: 20.0,
                color: Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.red.shade600,
        title: const Text("Favorites"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: getFavoritesWorldTimes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Algo salió mal 😫');
              } else if (snapshot.hasData) {
                final favoritesWorldTimes = snapshot.data!;
                return buildFavoritesWorldTimesList(favoritesWorldTimes);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
