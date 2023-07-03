import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:world_time/services/world_time.dart';

import '../services/world_time_provider.dart';
import 'counter.dart';

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

  void updateTime(BuildContext context, WorldTime worldTime) {
    if (context.mounted) {
      context.read<WorldTimeProvider>().setWorldTime(worldTime);
      context.go('/home');
    }
  }

  Widget buildFavoritesWorldTimesList(List<WorldTime> favoritesWorldTimes) {
    return favoritesWorldTimes.isNotEmpty
        ? Expanded(
            child: ListView.builder(
              itemCount: favoritesWorldTimes.length,
              itemBuilder: (context, index) {
                final currentFavorite = favoritesWorldTimes[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                  child: Card(
                    child: ListTile(
                      onTap: () => updateTime(context, currentFavorite),
                      title: Text(
                        currentFavorite.location,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(currentFavorite.url),
                      subtitleTextStyle: const TextStyle(fontSize: 12),
                      leading: CircleAvatar(
                        backgroundImage:
                            Image.network(currentFavorite.flag).image,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Counter(
                            now: currentFavorite.time!,
                            size: 20.0,
                            color: Colors.black,
                          ),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<WorldTimeProvider>()
                                  .removeFromFavorites(currentFavorite);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : Center(
            child: Column(
            children: [
              const Text(
                "You have no favorites!",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              TextButton(
                  onPressed: () {
                    context.push('/location');
                  },
                  child: const Text("Add some!"))
            ],
          ));
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
