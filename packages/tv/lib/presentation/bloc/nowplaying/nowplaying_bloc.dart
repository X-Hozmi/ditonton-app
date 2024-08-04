import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';

part 'nowplaying_event.dart';
part 'nowplaying_state.dart';

class NowPlayingTVBloc extends Bloc<NowPlayingTVEvent, NowPlayingTVState> {
  final GetNowPlayingTV getNowPlayingTV;

  NowPlayingTVBloc({required this.getNowPlayingTV})
      : super(NowPlayingTVState.initial()) {
    on<FetchNowPlayingTV>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getNowPlayingTV.execute();

      result.fold(
        (failure) {
          emit(state.copyWith(
            state: RequestState.Error,
            message: failure.message,
          ));
        },
        (tvData) {
          if (tvData.isEmpty) {
            emit(state.copyWith(
              state: RequestState.Empty,
            ));
          } else {
            emit(state.copyWith(
              state: RequestState.Loaded,
              tv: tvData,
            ));
          }
        },
      );
    });
  }
}
