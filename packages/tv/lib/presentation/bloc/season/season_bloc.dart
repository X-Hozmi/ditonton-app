import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv_season_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_tv_season_detail.dart';

part 'season_event.dart';
part 'season_state.dart';

class TVSeasonDetailBloc
    extends Bloc<TVSeasonDetailEvent, TVSeasonDetailState> {
  final GetSeasonDetail getSeasonDetail;

  TVSeasonDetailBloc({
    required this.getSeasonDetail,
  }) : super(TVSeasonDetailState.initial()) {
    on<FetchTVSeasonDetail>((event, emit) async {
      emit(state.copyWith(seasonState: RequestState.Loading));

      final id = event.id;
      final seasonNumber = event.seasonNumber;

      final detailResult = await getSeasonDetail.execute(id, seasonNumber);
      detailResult.fold(
        (failure) {
          emit(state.copyWith(
            seasonState: RequestState.Error,
            message: failure.message,
          ));
        },
        (seasonDetail) {
          emit(state.copyWith(
            seasonDetail: seasonDetail,
            seasonState: RequestState.Loaded,
            message: '',
          ));
        },
      );
    });
  }
}
