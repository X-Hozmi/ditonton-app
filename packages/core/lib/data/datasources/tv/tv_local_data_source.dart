import 'package:core/core.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/models/tv/tv_table.dart';

abstract class TVLocalDataSource {
  Future<String> insertWatchlistTv(TVTable tv);
  Future<String> removeWatchlist(TVTable tv);
  Future<TVTable?> getTVById(int id);
  Future<List<TVTable>> getWatchlistTV();
}

class TVLocalDataSourceImpl implements TVLocalDataSource {
  final DatabaseHelper databaseHelper;

  TVLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlistTv(TVTable tv) async {
    try {
      await databaseHelper.insertWatchlistTv(tv);
      return 'Ditambahkan ke daftar tonton';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TVTable tv) async {
    try {
      await databaseHelper.removeWatchlistTv(tv);
      return 'Dihapus dari daftar tonton';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TVTable?> getTVById(int id) async {
    final result = await databaseHelper.getTVById(id);
    if (result != null) {
      return TVTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TVTable>> getWatchlistTV() async {
    final result = await databaseHelper.getWatchlistTV();
    return result.map((data) => TVTable.fromMap(data)).toList();
  }
}
