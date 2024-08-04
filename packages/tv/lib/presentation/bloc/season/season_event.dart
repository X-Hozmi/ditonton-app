part of 'season_bloc.dart';

abstract class TVSeasonDetailEvent extends Equatable {
  const TVSeasonDetailEvent();
}

class FetchTVSeasonDetail extends TVSeasonDetailEvent {
  final int id;
  final int seasonNumber;

  const FetchTVSeasonDetail(this.id, this.seasonNumber);

  @override
  List<Object?> get props => [id, seasonNumber];
}
