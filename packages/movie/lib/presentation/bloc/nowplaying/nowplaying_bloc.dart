import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';

part 'nowplaying_event.dart';
part 'nowplaying_state.dart';

class NowPlayingMovieBloc
    extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMovieBloc({required this.getNowPlayingMovies})
      : super(NowPlayingMovieState.initial()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getNowPlayingMovies.execute();

      result.fold(
        (failure) {
          emit(state.copyWith(
            state: RequestState.Error,
            message: failure.message,
          ));
        },
        (moviesData) {
          if (moviesData.isEmpty) {
            emit(state.copyWith(
              state: RequestState.Empty,
            ));
          } else {
            emit(state.copyWith(
              state: RequestState.Loaded,
              movies: moviesData,
            ));
          }
        },
      );
    });
  }
}
