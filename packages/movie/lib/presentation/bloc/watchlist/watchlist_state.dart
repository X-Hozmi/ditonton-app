part of 'watchlist_bloc.dart';

class WatchlistMovieState extends Equatable {
  final RequestState state;
  final List<Movie> watchlistMovies;
  final String message;

  const WatchlistMovieState({
    required this.state,
    required this.watchlistMovies,
    required this.message,
  });

  WatchlistMovieState copyWith({
    RequestState? state,
    List<Movie>? watchlistMovies,
    String? message,
  }) {
    return WatchlistMovieState(
      state: state ?? this.state,
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, watchlistMovies, message];

  factory WatchlistMovieState.initial() {
    return const WatchlistMovieState(
      state: RequestState.Initial,
      watchlistMovies: [],
      message: '',
    );
  }
}
