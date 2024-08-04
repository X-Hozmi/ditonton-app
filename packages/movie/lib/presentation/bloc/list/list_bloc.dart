import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';

part 'list_event.dart';
part 'list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(MovieListState.initial()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(state.copyWith(nowPlayingState: RequestState.Loading));

      final result = await getNowPlayingMovies.execute();
      result.fold(
        (failure) {
          emit(state.copyWith(
            nowPlayingState: RequestState.Error,
            message: failure.message,
          ));
        },
        (moviesData) {
          if (moviesData.isEmpty) {
            emit(state.copyWith(
              nowPlayingState: RequestState.Empty,
            ));
          } else {
            emit(state.copyWith(
              nowPlayingState: RequestState.Loaded,
              nowPlayingMovies: moviesData,
            ));
          }
        },
      );
    });

    on<FetchPopularMovies>((event, emit) async {
      emit(state.copyWith(popularMoviesState: RequestState.Loading));

      final result = await getPopularMovies.execute();
      result.fold(
        (failure) {
          emit(state.copyWith(
            popularMoviesState: RequestState.Error,
            message: failure.message,
          ));
        },
        (moviesData) {
          if (moviesData.isEmpty) {
            emit(state.copyWith(
              popularMoviesState: RequestState.Empty,
            ));
          } else {
            emit(state.copyWith(
              popularMoviesState: RequestState.Loaded,
              popularMovies: moviesData,
            ));
          }
        },
      );
    });

    on<FetchTopRatedMovies>((event, emit) async {
      emit(state.copyWith(topRatedMoviesState: RequestState.Loading));

      final result = await getTopRatedMovies.execute();
      result.fold(
        (failure) {
          emit(state.copyWith(
            topRatedMoviesState: RequestState.Error,
            message: failure.message,
          ));
        },
        (moviesData) {
          if (moviesData.isEmpty) {
            emit(state.copyWith(
              topRatedMoviesState: RequestState.Empty,
            ));
          } else {
            emit(state.copyWith(
              topRatedMoviesState: RequestState.Loaded,
              topRatedMovies: moviesData,
            ));
          }
        },
      );
    });
  }
}
