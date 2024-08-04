import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv_season_detail.dart';
import 'package:core/domain/repositories/tv/tv_repository.dart';
import 'package:dartz/dartz.dart';

class GetSeasonDetail {
  final TVRepository repository;

  GetSeasonDetail(this.repository);

  Future<Either<Failure, SeasonDetail>> execute(int id, int seasonNumber) {
    return repository.getTVSeasonDetail(id, seasonNumber);
  }
}
