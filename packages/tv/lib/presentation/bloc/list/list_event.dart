part of 'list_bloc.dart';

abstract class TVListEvent extends Equatable {
  const TVListEvent();

  @override
  List<Object?> get props => [];
}

class FetchNowPlayingTV extends TVListEvent {}

class FetchPopularTV extends TVListEvent {}

class FetchTopRatedTV extends TVListEvent {}
