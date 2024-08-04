part of 'watchlist_bloc.dart';

class WatchlistTVState extends Equatable {
  final RequestState state;
  final List<TV> watchlistTV;
  final String message;

  const WatchlistTVState({
    required this.state,
    required this.watchlistTV,
    required this.message,
  });

  WatchlistTVState copyWith({
    RequestState? state,
    List<TV>? watchlistTV,
    String? message,
  }) {
    return WatchlistTVState(
      state: state ?? this.state,
      watchlistTV: watchlistTV ?? this.watchlistTV,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, watchlistTV, message];

  factory WatchlistTVState.initial() {
    return const WatchlistTVState(
      state: RequestState.Initial,
      watchlistTV: [],
      message: '',
    );
  }
}
