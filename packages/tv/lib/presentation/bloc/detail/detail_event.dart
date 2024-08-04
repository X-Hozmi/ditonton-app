part of 'detail_bloc.dart';

abstract class TVDetailEvent extends Equatable {
  const TVDetailEvent();
}

class FetchTVDetail extends TVDetailEvent {
  final int id;

  const FetchTVDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class AddWatchlistTV extends TVDetailEvent {
  final TVDetail tvDetail;

  const AddWatchlistTV(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}

class RemoveFromWatchlistTV extends TVDetailEvent {
  final TVDetail tvDetail;

  const RemoveFromWatchlistTV(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}

class LoadWatchlistStatusTV extends TVDetailEvent {
  final int id;

  const LoadWatchlistStatusTV(this.id);

  @override
  List<Object?> get props => [id];
}
