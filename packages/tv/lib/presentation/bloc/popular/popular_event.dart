part of 'popular_bloc.dart';

abstract class PopularTVEvent extends Equatable {
  const PopularTVEvent();

  @override
  List<Object?> get props => [];
}

class FetchPopularTV extends PopularTVEvent {}
