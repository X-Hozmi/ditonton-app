part of 'watchlist_bloc.dart';

abstract class WatchlistTVEvent extends Equatable {
  const WatchlistTVEvent();

  @override
  List<Object?> get props => [];
}

class FetchWatchlistTV extends WatchlistTVEvent {}
