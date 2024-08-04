part of 'list_bloc.dart';

class TVListState extends Equatable {
  final List<TV> nowPlayingTV;
  final RequestState nowPlayingState;
  final List<TV> popularTV;
  final RequestState popularTVState;
  final List<TV> topRatedTV;
  final RequestState topRatedTVState;
  final String message;

  const TVListState({
    required this.nowPlayingTV,
    required this.nowPlayingState,
    required this.popularTV,
    required this.popularTVState,
    required this.topRatedTV,
    required this.topRatedTVState,
    required this.message,
  });

  TVListState copyWith({
    List<TV>? nowPlayingTV,
    RequestState? nowPlayingState,
    List<TV>? popularTV,
    RequestState? popularTVState,
    List<TV>? topRatedTV,
    RequestState? topRatedTVState,
    String? message,
  }) {
    return TVListState(
      nowPlayingTV: nowPlayingTV ?? this.nowPlayingTV,
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      popularTV: popularTV ?? this.popularTV,
      popularTVState: popularTVState ?? this.popularTVState,
      topRatedTV: topRatedTV ?? this.topRatedTV,
      topRatedTVState: topRatedTVState ?? this.topRatedTVState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        nowPlayingTV,
        nowPlayingState,
        popularTV,
        popularTVState,
        topRatedTV,
        topRatedTVState,
        message,
      ];

  factory TVListState.initial() {
    return const TVListState(
      nowPlayingTV: [],
      nowPlayingState: RequestState.Initial,
      popularTV: [],
      popularTVState: RequestState.Initial,
      topRatedTV: [],
      topRatedTVState: RequestState.Initial,
      message: '',
    );
  }
}
