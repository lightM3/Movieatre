import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/movies/data/models/movie_entity.dart';
import '../error/custom_exceptions.dart';

part 'isar_provider.g.dart';

class IsarInit {
  static late Isar _instance;

  static Future<void> initialize() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _instance = await Isar.open(
        [MovieEntitySchema],
        directory: dir.path,
      );
    } catch (e) {
      throw DatabaseException('Isar veritabanı başlatılamadı: $e');
    }
  }

  static Isar get instance => _instance;
}

@riverpod
Isar isar(IsarRef ref) {
  try {
    return IsarInit.instance;
  } catch (e) {
    throw DatabaseException('Isar instance bulunamadı. Lütfen initialize edin: $e');
  }
}
