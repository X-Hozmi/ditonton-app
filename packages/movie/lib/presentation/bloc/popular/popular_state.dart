part of 'popular_bloc.dart';

class PopularMovieState extends Equatable {
  final RequestState state;
  final List<Movie> movies;
  final String message;

  const PopularMovieState({
    required this.state,
    required this.movies,
    required this.message,
  });

  PopularMovieState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return PopularMovieState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, movies, message];

  factory PopularMovieState.initial() {
    return const PopularMovieState(
      state: RequestState.Initial,
      movies: [],
      message: '',
    );
  }
}
