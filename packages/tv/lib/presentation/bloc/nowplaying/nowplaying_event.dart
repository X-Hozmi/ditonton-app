part of 'nowplaying_bloc.dart';

abstract class NowPlayingTVEvent extends Equatable {
  const NowPlayingTVEvent();

  @override
  List<Object?> get props => [];
}

class FetchNowPlayingTV extends NowPlayingTVEvent {}
