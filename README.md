# flutter_app

A cross-platform Flutter application to browse trending movies, search for titles, and manage a personal watchlist. Built with Flutter, Provider, and TMDB API integration.

## Features

- Browse trending movies
- View detailed movie information
- Search movies by title or genre
- Add/remove movies to a personal watchlist (locally stored)
- Rate movies
- Responsive UI for mobile and desktop

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK (comes with Flutter)
- Android Studio/Xcode/VS Code (for emulators or device deployment)

### Installation

1. Clone the repository:
   ```sh
   git clone <repo-url>
   cd flutter_app
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

## Folder Structure

```
lib/
  main.dart                # App entry point
  models/                  # Data models (e.g., Movie)
  providers/               # State management (e.g., WatchlistProvider)
  repositories/            # Data fetching logic (e.g., MovieRepository)
  screens/                 # UI screens (Home, Details, Search, Watchlist)
  services/                # API/database services (e.g., tmdb_service.dart)
```

## Dependencies

- flutter
- provider
- sqflite
- path_provider
- http
- flutter_rating_bar

## API

This app uses [The Movie Database (TMDB) API](https://www.themoviedb.org/documentation/api) for movie data. You may need to add your TMDB API key in the appropriate service file.

## License

This project is for educational purposes.

## Contact

For questions or feedback, please open an issue or contact the maintainer.
