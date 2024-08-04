part of 'top_rated_bloc.dart';

class TopRatedMoviesState extends Equatable {
  final RequestState state;
  final List<Movie> movies;
  final String message;

  const TopRatedMoviesState({
    required this.state,
    required this.movies,
    required this.message,
  });

  TopRatedMoviesState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return TopRatedMoviesState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, movies, message];

  factory TopRatedMoviesState.initial() {
    return const TopRatedMoviesState(
      state: RequestState.Empty,
      movies: [],
      message: '',
    );
  }
}
