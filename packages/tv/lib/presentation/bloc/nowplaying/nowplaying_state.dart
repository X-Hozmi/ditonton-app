part of 'nowplaying_bloc.dart';

class NowPlayingTVState extends Equatable {
  final RequestState state;
  final List<TV> tv;
  final String message;

  const NowPlayingTVState({
    required this.state,
    required this.tv,
    required this.message,
  });

  NowPlayingTVState copyWith({
    RequestState? state,
    List<TV>? tv,
    String? message,
  }) {
    return NowPlayingTVState(
      state: state ?? this.state,
      tv: tv ?? this.tv,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, tv, message];

  factory NowPlayingTVState.initial() {
    return const NowPlayingTVState(
      state: RequestState.Initial,
      tv: [],
      message: '',
    );
  }
}
