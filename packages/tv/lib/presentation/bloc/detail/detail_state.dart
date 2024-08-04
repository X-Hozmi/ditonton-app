part of 'detail_bloc.dart';

class TVDetailState extends Equatable {
  final TVDetail? tvDetail;
  final RequestState tvDetailState;
  final List<TV> tvRecommendations;
  final RequestState tvRecommendationsState;
  final String message;
  final String watchlistMessage;
  final bool isAddedToWatchlist;

  const TVDetailState({
    required this.tvDetail,
    required this.tvDetailState,
    required this.tvRecommendations,
    required this.tvRecommendationsState,
    required this.message,
    required this.watchlistMessage,
    required this.isAddedToWatchlist,
  });

  @override
  List<Object?> get props {
    return [
      tvDetail,
      tvDetailState,
      tvRecommendations,
      tvRecommendationsState,
      message,
      watchlistMessage,
      isAddedToWatchlist,
    ];
  }

  TVDetailState copyWith({
    TVDetail? tvDetail,
    RequestState? tvDetailState,
    List<TV>? tvRecommendations,
    RequestState? tvRecommendationsState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return TVDetailState(
      tvDetail: tvDetail ?? this.tvDetail,
      tvDetailState: tvDetailState ?? this.tvDetailState,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      tvRecommendationsState:
          tvRecommendationsState ?? this.tvRecommendationsState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  factory TVDetailState.initial() {
    return const TVDetailState(
      tvDetail: null,
      tvDetailState: RequestState.Initial,
      tvRecommendations: [],
      tvRecommendationsState: RequestState.Initial,
      message: '',
      watchlistMessage: '',
      isAddedToWatchlist: false,
    );
  }
}
