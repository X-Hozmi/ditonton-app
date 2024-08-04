import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';

part 'list_event.dart';
part 'list_state.dart';

class TVListBloc extends Bloc<TVListEvent, TVListState> {
  final GetNowPlayingTV getNowPlayingTV;
  final GetPopularTV getPopularTV;
  final GetTopRatedTV getTopRatedTV;

  TVListBloc({
    required this.getNowPlayingTV,
    required this.getPopularTV,
    required this.getTopRatedTV,
  }) : super(TVListState.initial()) {
    on<FetchNowPlayingTV>((event, emit) async {
      emit(state.copyWith(nowPlayingState: RequestState.Loading));

      final result = await getNowPlayingTV.execute();
      result.fold(
        (failure) {
          emit(state.copyWith(
            nowPlayingState: RequestState.Error,
            message: failure.message,
          ));
        },
        (tvData) {
          if (tvData.isEmpty) {
            emit(state.copyWith(
              nowPlayingState: RequestState.Empty,
            ));
          } else {
            emit(state.copyWith(
              nowPlayingState: RequestState.Loaded,
              nowPlayingTV: tvData,
            ));
          }
        },
      );
    });

    on<FetchPopularTV>((event, emit) async {
      emit(state.copyWith(popularTVState: RequestState.Loading));

      final result = await getPopularTV.execute();
      result.fold(
        (failure) {
          emit(state.copyWith(
            popularTVState: RequestState.Error,
            message: failure.message,
          ));
        },
        (tvData) {
          if (tvData.isEmpty) {
            emit(state.copyWith(
              popularTVState: RequestState.Empty,
            ));
          } else {
            emit(state.copyWith(
              popularTVState: RequestState.Loaded,
              popularTV: tvData,
            ));
          }
        },
      );
    });

    on<FetchTopRatedTV>((event, emit) async {
      emit(state.copyWith(topRatedTVState: RequestState.Loading));

      final result = await getTopRatedTV.execute();
      result.fold(
        (failure) {
          emit(state.copyWith(
            topRatedTVState: RequestState.Error,
            message: failure.message,
          ));
        },
        (tvData) {
          if (tvData.isEmpty) {
            emit(state.copyWith(
              topRatedTVState: RequestState.Empty,
            ));
          } else {
            emit(state.copyWith(
              topRatedTVState: RequestState.Loaded,
              topRatedTV: tvData,
            ));
          }
        },
      );
    });
  }
}
