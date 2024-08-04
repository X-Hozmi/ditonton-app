part of 'season_bloc.dart';

class TVSeasonDetailState extends Equatable {
  final SeasonDetail? seasonDetail;
  final RequestState seasonState;
  final String message;

  const TVSeasonDetailState({
    required this.seasonDetail,
    required this.seasonState,
    required this.message,
  });

  @override
  List<Object?> get props => [seasonDetail, seasonState, message];

  TVSeasonDetailState copyWith({
    SeasonDetail? seasonDetail,
    RequestState? seasonState,
    String? message,
  }) {
    return TVSeasonDetailState(
      seasonDetail: seasonDetail ?? this.seasonDetail,
      seasonState: seasonState ?? this.seasonState,
      message: message ?? this.message,
    );
  }

  factory TVSeasonDetailState.initial() {
    return const TVSeasonDetailState(
      seasonDetail: null,
      seasonState: RequestState.Initial,
      message: '',
    );
  }
}
