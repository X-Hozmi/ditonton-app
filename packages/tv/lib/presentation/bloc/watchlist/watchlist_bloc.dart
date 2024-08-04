import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_watchlist_tv.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistTVBloc extends Bloc<WatchlistTVEvent, WatchlistTVState> {
  final GetWatchlistTV getWatchlistTV;

  WatchlistTVBloc({required this.getWatchlistTV})
      : super(WatchlistTVState.initial()) {
    on<FetchWatchlistTV>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getWatchlistTV.execute();

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
              watchlistTV: moviesData,
            ));
          }
        },
      );
    });
  }
}
