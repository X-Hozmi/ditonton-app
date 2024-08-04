import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/search_tv.dart';

part 'search_event.dart';
part 'search_state.dart';

class TVSearchBloc extends Bloc<TVSearchEvent, TVSearchState> {
  final SearchTV searchTV;

  TVSearchBloc({required this.searchTV}) : super(TVSearchState.initial()) {
    on<FetchTVSearch>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await searchTV.execute(event.query);

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
              searchResult: tvData,
            ));
          }
        },
      );
    });
  }
}
