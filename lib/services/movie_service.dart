import 'package:dio/dio.dart';
import '../models/movie.dart';

class MovieService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://api.watchmode.com/v1';

  // Récupère la clé API depuis les variables d'environnement
  static const String _apiKey = String.fromEnvironment(
    'WATCHMODE_API_KEY',
    defaultValue: '', // Valeur par défaut si la clé n'est pas fournie
  );

  Future<List<MovieListItem>> getMovies({int limit = 20}) async {
    // Vérifie que la clé API est bien fournie
    if (_apiKey.isEmpty) {
      throw Exception(
        'Clé API manquante ! Lance l\'app avec --dart-define=WATCHMODE_API_KEY=ta_clé'
      );
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/list-titles/',
        queryParameters: {
          'apiKey': _apiKey,
          'types': 'movie',
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> titles = response.data['titles'];
        return titles.map((json) => MovieListItem.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors du chargement des films');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  // Récupère les détails complets pour plusieurs films (avec images)
  // Charge les films en PARALLÈLE pour ne pas bloquer l'UI
  Future<List<Movie>> getMoviesWithDetails({int limit = 10}) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'Clé API manquante ! Lance l\'app avec --dart-define=WATCHMODE_API_KEY=ta_clé'
      );
    }

    try {
      // Récupérer la liste des IDs
      final listItems = await getMovies(limit: limit);
      
      // Charger les détails de TOUS les films EN PARALLÈLE
      final movieFutures = listItems.map((item) async {
        try {
          return await getMovieDetails(item.id);
        } catch (e) {
          // Si un film échoue, on utilise les données de base
          print('Erreur détails film ${item.id}: $e');
          return item.toMovie();
        }
      }).toList();
      
      // Attendre que tous les films soient chargés
      final movies = await Future.wait(movieFutures);
      
      return movies;
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'Clé API manquante ! Lance l\'app avec --dart-define=WATCHMODE_API_KEY=ta_clé'
      );
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/title/$movieId/details/',
        queryParameters: {
          'apiKey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        return Movie.fromJson(response.data);
      } else {
        throw Exception('Erreur lors du chargement des détails');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

}
// exemple de réponse JSON pour un film

// {
//   "titles": [
//     {
//       "id": 1634288,
//       "title": "Wake Up Dead Man: A Knives Out Mystery",
//       "year": 2025,
//       "imdb_id": "tt14364480",
//       "tmdb_id": 812583,
//       "type": "movie"
//     },
//     {
//       "id": 1886541,
//       "title": "The Great Flood",
//       "year": 2025,
//       "imdb_id": "tt29927663",
//       "tmdb_id": 982843,
//       "type": "movie"
//     }
//   ]
// }


// détail d'un film (/title/1874486/details/) :

// {
//   "id": 1874486,
//   "title": "Predator: Killer of Killers",
//   "plot_overview": "While three of the fiercest warriors in human history...",
//   "year": 2025,
//   "user_rating": 7.6,
//   "genre_names": ["Animation", "Action", "Science Fiction"],
//   "poster": "https://cdn.watchmode.com/posters/01874486_poster_w342.jpg",
//   "backdrop": null,
//   "trailer": "https://www.youtube.com/watch?v=s2XXEbtT1fo"
// }