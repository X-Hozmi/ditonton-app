part of 'search_bloc.dart';

class TVSearchState extends Equatable {
  final RequestState state;
  final List<TV> searchResult;
  final String message;

  const TVSearchState({
    required this.state,
    required this.searchResult,
    required this.message,
  });

  TVSearchState copyWith({
    RequestState? state,
    List<TV>? searchResult,
    String? message,
  }) {
    return TVSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, searchResult, message];

  factory TVSearchState.initial() {
    return const TVSearchState(
      state: RequestState.Initial,
      searchResult: [],
      message: '',
    );
  }
}
