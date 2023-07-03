import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:world_time/screens/counter.dart';
import 'package:world_time/services/world_time_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<WorldTimeProvider>().getTime(),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.waiting) {
          child = Scaffold(
            backgroundColor: Colors.black,
            key: UniqueKey(),
          );
        } else {
          var worldTime = snapshot.data!;
          child = Scaffold(
            backgroundColor:
                worldTime.isDayTime! ? Colors.blue : Colors.indigo.shade900,
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.push('/favorites'),
              backgroundColor: Colors.red,
              heroTag: UniqueKey(),
              child: const Icon(Icons.favorite),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
                child: Column(
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: () => context.push('/location'),
                      icon: Icon(
                        Icons.edit_location,
                        color: Colors.grey.shade300,
                      ),
                      label: Text(
                        "Edit location",
                        style: TextStyle(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          worldTime.location,
                          style: const TextStyle(
                            fontSize: 25,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      worldTime.url,
                      style: const TextStyle(
                        fontSize: 12,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Counter(
                      now: worldTime.time!,
                      size: 66.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10.0),
                    Column(
                      children: [
                        const Text(
                          'Current Location:',
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${context.read<WorldTimeProvider>().localTime.location},'
                              ' ${context.read<WorldTimeProvider>().localTime.city}',
                              style: const TextStyle(
                                fontSize: 20,
                                letterSpacing: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Counter(
                              now: context
                                  .read<WorldTimeProvider>()
                                  .localTime
                                  .time!,
                              size: 20.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            key: UniqueKey(),
          );
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: child,
        );
      },
    );
  }
}
