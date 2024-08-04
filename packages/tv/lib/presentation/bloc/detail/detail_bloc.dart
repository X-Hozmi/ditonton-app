import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:core/domain/entities/tv/tv_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class TVDetailBloc extends Bloc<TVDetailEvent, TVDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVDetail getTVDetail;
  final GetTVRecommendations getTVRecommendations;
  final GetWatchListStatusTV getWatchListStatus;
  final SaveWatchlistTV saveWatchlist;
  final RemoveWatchlistTV removeWatchlist;

  TVDetailBloc({
    required this.getTVDetail,
    required this.getTVRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TVDetailState.initial()) {
    on<FetchTVDetail>((event, emit) async {
      emit(state.copyWith(tvDetailState: RequestState.Loading));

      final id = event.id;

      final detailTVResult = await getTVDetail.execute(id);
      final recommendationTVResult = await getTVRecommendations.execute(id);

      detailTVResult.fold(
        (failure) => emit(
          state.copyWith(
            tvDetailState: RequestState.Error,
            message: failure.message,
          ),
        ),
        (tvDetail) {
          emit(
            state.copyWith(
              tvRecommendationsState: RequestState.Loading,
              tvDetailState: RequestState.Loaded,
              tvDetail: tvDetail,
              watchlistMessage: '',
            ),
          );
          recommendationTVResult.fold(
            (failure) => emit(
              state.copyWith(
                tvRecommendationsState: RequestState.Error,
                message: failure.message,
              ),
            ),
            (tvRecommendations) {
              if (tvRecommendations.isEmpty) {
                emit(
                  state.copyWith(
                    tvRecommendationsState: RequestState.Empty,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    tvRecommendationsState: RequestState.Loaded,
                    tvRecommendations: tvRecommendations,
                  ),
                );
              }
            },
          );
        },
      );
    });

    on<AddWatchlistTV>((event, emit) async {
      final tvDetail = event.tvDetail;
      final result = await saveWatchlist.execute(tvDetail);

      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusTV(tvDetail.id));
    });

    on<RemoveFromWatchlistTV>((event, emit) async {
      final tvDetail = event.tvDetail;
      final result = await removeWatchlist.execute(tvDetail);

      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusTV(tvDetail.id));
    });

    on<LoadWatchlistStatusTV>((event, emit) async {
      final status = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });
  }
}
