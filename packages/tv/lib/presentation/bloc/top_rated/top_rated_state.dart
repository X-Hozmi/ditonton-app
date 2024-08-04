part of 'top_rated_bloc.dart';

class TopRatedTVState extends Equatable {
  final RequestState state;
  final List<TV> tv;
  final String message;

  const TopRatedTVState({
    required this.state,
    required this.tv,
    required this.message,
  });

  TopRatedTVState copyWith({
    RequestState? state,
    List<TV>? tv,
    String? message,
  }) {
    return TopRatedTVState(
      state: state ?? this.state,
      tv: tv ?? this.tv,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, tv, message];

  factory TopRatedTVState.initial() {
    return const TopRatedTVState(
      state: RequestState.Empty,
      tv: [],
      message: '',
    );
  }
}
