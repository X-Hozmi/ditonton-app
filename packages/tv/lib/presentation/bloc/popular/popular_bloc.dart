import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';

part 'popular_event.dart';
part 'popular_state.dart';

class PopularTVBloc extends Bloc<PopularTVEvent, PopularTVState> {
  final GetPopularTV getPopularTV;

  PopularTVBloc({required this.getPopularTV})
      : super(PopularTVState.initial()) {
    on<FetchPopularTV>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getPopularTV.execute();

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
