import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/watchlist_provider.dart';
import 'screens/home_screen.dart';
import 'screens/watchlist_screen.dart';
import 'screens/search_screen.dart';

// Entry point of the Flutter application. Sets up providers and main navigation.
void main() {
  runApp(const MainApp());
}

// MainApp sets up the Provider tree and MaterialApp.
// Uses MultiProvider to inject app-wide state (e.g., WatchlistProvider).
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provides the watchlist state to the widget tree
        ChangeNotifierProvider(
          create: (_) => WatchlistProvider()..loadWatchlist(),
        ),
      ],
      child: const MaterialApp(home: MainNavigation()),
    );
  }
}

// MainNavigation manages the bottom navigation bar and screen switching.
// Holds the list of main screens and tracks the selected index.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  // List of main screens in the app
  final List<Widget> _screens = [
    HomeScreen(),
    WatchlistScreen(),
    SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 1) {
              Provider.of<WatchlistProvider>(
                context,
                listen: false,
              ).loadWatchlist();
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }
}
