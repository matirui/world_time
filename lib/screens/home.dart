import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:word_time/services/world_time_provider.dart';

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
            backgroundColor: (worldTime.isDayTime ?? true)
                ? Colors.blue
                : Colors.indigo.shade900,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
                child: Column(
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: () => context.go('/location'),
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
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      worldTime.url,
                      style: const TextStyle(
                          fontSize: 12, letterSpacing: 2, color: Colors.white),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      worldTime.time!,
                      style: const TextStyle(
                        fontSize: 66,
                        color: Colors.white,
                      ),
                    )
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
