part of 'nowplaying_bloc.dart';

class NowPlayingMovieState extends Equatable {
  final RequestState state;
  final List<Movie> movies;
  final String message;

  const NowPlayingMovieState({
    required this.state,
    required this.movies,
    required this.message,
  });

  NowPlayingMovieState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return NowPlayingMovieState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, movies, message];

  factory NowPlayingMovieState.initial() {
    return const NowPlayingMovieState(
      state: RequestState.Initial,
      movies: [],
      message: '',
    );
  }
}
