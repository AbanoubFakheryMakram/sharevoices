import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharevoices/services/theme/theme_service.dart';
import 'package:sharevoices/views/categories_list_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Voices'),
        centerTitle: false,
      ),
      drawer: Consumer(
        builder: (context, ref, child) => Drawer(
          child: DrawerHeader(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Theme'),
              subtitle: Text(ref.watch(themeProvider).isDarkTheme() ? 'Dark Theme' : 'Light Theme'),
              trailing: Transform.scale(
                scale: .7,
                child: CupertinoSwitch(
                  value: ref.watch(themeProvider).isDarkTheme(),
                  onChanged: (_) {
                    ref.watch(themeProvider).toggleTheme();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: const CategoriesListView(),
    );
  }
}
