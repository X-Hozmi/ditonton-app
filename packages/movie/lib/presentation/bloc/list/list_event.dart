part of 'list_bloc.dart';

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object?> get props => [];
}

class FetchNowPlayingMovies extends MovieListEvent {}

class FetchPopularMovies extends MovieListEvent {}

class FetchTopRatedMovies extends MovieListEvent {}
