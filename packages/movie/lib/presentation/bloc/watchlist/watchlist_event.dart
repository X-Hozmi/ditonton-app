part of 'watchlist_bloc.dart';

abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  List<Object?> get props => [];
}

class FetchWatchlistMovies extends WatchlistMovieEvent {}
