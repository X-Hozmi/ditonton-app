part of 'search_bloc.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object?> get props => [];
}

class FetchMovieSearch extends MovieSearchEvent {
  final String query;

  const FetchMovieSearch(this.query);

  @override
  List<Object?> get props => [query];
}
