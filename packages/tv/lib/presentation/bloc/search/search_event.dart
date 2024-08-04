part of 'search_bloc.dart';

abstract class TVSearchEvent extends Equatable {
  const TVSearchEvent();

  @override
  List<Object?> get props => [];
}

class FetchTVSearch extends TVSearchEvent {
  final String query;

  const FetchTVSearch(this.query);

  @override
  List<Object?> get props => [query];
}
