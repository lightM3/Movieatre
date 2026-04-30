import 'package:isar/isar.dart';
import '../../domain/models/movie.dart';

part 'movie_entity.g.dart';

@collection
class MovieEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  int? tmdbId;

  String? title;
  String? posterPath;
  String? backdropPath;
  String? overview;
  double? voteAverage;
  String? releaseDate;
  List<int>? genreIds;

  // Mapper from Domain Model to Entity
  static MovieEntity fromDomain(Movie movie) {
    return MovieEntity()
      ..tmdbId = movie.id
      ..title = movie.title
      ..posterPath = movie.posterPath
      ..backdropPath = movie.backdropPath
      ..overview = movie.overview
      ..voteAverage = movie.voteAverage
      ..releaseDate = movie.releaseDate
      ..genreIds = movie.genreIds;
  }

  // Mapper from Entity to Domain Model
  Movie toDomain() {
    return Movie(
      id: tmdbId ?? 0,
      title: title ?? '',
      posterPath: posterPath,
      backdropPath: backdropPath,
      overview: overview ?? '',
      voteAverage: voteAverage ?? 0.0,
      releaseDate: releaseDate,
      genreIds: genreIds ?? [],
    );
  }
}
