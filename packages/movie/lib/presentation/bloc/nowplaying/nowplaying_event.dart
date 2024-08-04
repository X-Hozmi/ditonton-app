part of 'nowplaying_bloc.dart';

abstract class NowPlayingMovieEvent extends Equatable {
  const NowPlayingMovieEvent();

  @override
  List<Object?> get props => [];
}

class FetchNowPlayingMovies extends NowPlayingMovieEvent {}
