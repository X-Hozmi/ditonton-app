part of 'popular_bloc.dart';

abstract class PopularMovieEvent extends Equatable {
  const PopularMovieEvent();

  @override
  List<Object?> get props => [];
}

class FetchPopularMovies extends PopularMovieEvent {}
