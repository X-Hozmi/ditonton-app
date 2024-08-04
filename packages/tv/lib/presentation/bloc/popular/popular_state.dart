part of 'popular_bloc.dart';

class PopularTVState extends Equatable {
  final RequestState state;
  final List<TV> tv;
  final String message;

  const PopularTVState({
    required this.state,
    required this.tv,
    required this.message,
  });

  PopularTVState copyWith({
    RequestState? state,
    List<TV>? tv,
    String? message,
  }) {
    return PopularTVState(
      state: state ?? this.state,
      tv: tv ?? this.tv,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, tv, message];

  factory PopularTVState.initial() {
    return const PopularTVState(
      state: RequestState.Initial,
      tv: [],
      message: '',
    );
  }
}
