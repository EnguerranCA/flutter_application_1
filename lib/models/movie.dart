// Modèle simplifié pour la liste des films
class MovieListItem {
  final int id;
  final String title;
  final int year;

  MovieListItem({
    required this.id,
    required this.title,
    required this.year,
  });

  factory MovieListItem.fromJson(Map<String, dynamic> json) {
    return MovieListItem(
      id: json['id'],
      title: json['title'] ?? 'Sans titre',
      year: json['year'] ?? 0,
    );
  }

  // Convertir en Movie avec des valeurs par défaut
  // Note: l'API list-titles ne retourne pas les posters, seulement les détails complets
  Movie toMovie() {
    return Movie(
      id: id,
      title: title,
      plotOverview: 'Aucune description disponible',
      year: year,
      poster: null, // Pas de poster dans la liste, seulement dans les détails
      backdrop: null,
      userRating: 0.0,
      genreNames: [],
      trailer: null,
    );
  }
}

// Modèle complet pour les détails d'un film
class Movie {
  final int id;
  final String title;
  final String plotOverview;
  final int year;
  final String? poster;
  final String? backdrop;
  final double userRating;
  final List<String> genreNames;
  final String? trailer;

  Movie({
    required this.id,
    required this.title,
    required this.plotOverview,
    required this.year,
    this.poster,
    this.backdrop,
    required this.userRating,
    required this.genreNames,
    this.trailer,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // Nettoyer et valider les URLs
    String? posterUrl = json['poster'] as String?;
    String? backdropUrl = json['backdrop'] as String?;
    
    // Vérifier que les URLs ne sont pas vides et sont valides
    if (posterUrl != null && posterUrl.trim().isEmpty) {
      posterUrl = null;
    }
    if (backdropUrl != null && backdropUrl.trim().isEmpty) {
      backdropUrl = null;
    }
    
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'Sans titre',
      plotOverview: json['plot_overview'] ?? 'Aucune description disponible',
      year: json['year'] ?? 0,
      poster: posterUrl,
      backdrop: backdropUrl,
      userRating: (json['user_rating'] ?? 0).toDouble(),
      genreNames: (json['genre_names'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      trailer: json['trailer'],
    );
  }

  bool get hasPoster {
    if (poster == null || poster!.trim().isEmpty) return false;
    // Vérifier que c'est une URL valide (commence par http)
    return poster!.startsWith('http://') || poster!.startsWith('https://');
  }
  
  bool get hasBackdrop {
    if (backdrop == null || backdrop!.trim().isEmpty) return false;
    return backdrop!.startsWith('http://') || backdrop!.startsWith('https://');
  }

  String get posterUrl => hasPoster ? poster! : '';
  String get backdropUrl => hasBackdrop ? backdrop! : '';

  // Alias pour la description
  String get description => plotOverview;
}