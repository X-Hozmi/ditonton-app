import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';

part 'top_rated_event.dart';
part 'top_rated_state.dart';

class TopRatedTVBloc extends Bloc<TopRatedTVEvent, TopRatedTVState> {
  final GetTopRatedTV getTopRatedTV;

  TopRatedTVBloc({required this.getTopRatedTV})
      : super(TopRatedTVState.initial()) {
    on<FetchTopRatedTV>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getTopRatedTV.execute();

      result.fold(
        (failure) {
          emit(state.copyWith(
            state: RequestState.Error,
            message: failure.message,
          ));
        },
        (tvData) {
          emit(state.copyWith(
            state: RequestState.Loaded,
            tv: tvData,
          ));
        },
      );
    });
  }
}
