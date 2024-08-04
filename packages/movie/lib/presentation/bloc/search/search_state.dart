part of 'search_bloc.dart';

class MovieSearchState extends Equatable {
  final RequestState state;
  final List<Movie> searchResult;
  final String message;

  const MovieSearchState({
    required this.state,
    required this.searchResult,
    required this.message,
  });

  MovieSearchState copyWith({
    RequestState? state,
    List<Movie>? searchResult,
    String? message,
  }) {
    return MovieSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, searchResult, message];

  factory MovieSearchState.initial() {
    return const MovieSearchState(
      state: RequestState.Initial,
      searchResult: [],
      message: '',
    );
  }
}
