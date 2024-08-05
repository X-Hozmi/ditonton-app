import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv/tv_season_model.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:core/domain/entities/tv/tv_detail.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/detail/detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TVDetailPage extends StatefulWidget {
  final int id;

  const TVDetailPage({super.key, required this.id});

  @override
  State<TVDetailPage> createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TVDetailBloc>().add(FetchTVDetail(widget.id));
      context.read<TVDetailBloc>().add(LoadWatchlistStatusTV(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        key: GlobalKey<ScaffoldState>(),
        body: BlocConsumer<TVDetailBloc, TVDetailState>(
          listener: (context, state) {
            final message = state.watchlistMessage;
            if (message == TVDetailBloc.watchlistAddSuccessMessage ||
                message == TVDetailBloc.watchlistRemoveSuccessMessage) {
              _scaffoldMessengerKey.currentState!.showSnackBar(
                SnackBar(
                  content: Text(message),
                ),
              );
            } else {
              _scaffoldMessengerKey.currentState!.showSnackBar(
                SnackBar(
                  content: Text(message),
                ),
              );
            }
          },
          listenWhen: (oldState, newState) {
            return oldState.watchlistMessage != newState.watchlistMessage &&
                newState.watchlistMessage != '';
          },
          builder: (_, state) {
            final tvDetailState = state.tvDetailState;
            if (tvDetailState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (tvDetailState == RequestState.Loaded) {
              return SafeArea(
                child: DetailContent(
                  state.tvDetail!,
                  state.tvRecommendations,
                  state.isAddedToWatchlist,
                ),
              );
            } else if (tvDetailState == RequestState.Error) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TVDetail tv;
  final List<TV> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(
    this.tv,
    this.recommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              key: const Key('watchlistButton'),
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<TVDetailBloc>()
                                      .add(AddWatchlistTV(tv));
                                } else {
                                  context
                                      .read<TVDetailBloc>()
                                      .add(RemoveFromWatchlistTV(
                                        tv,
                                      ));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Daftar Tonton'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            TvSeriesSeasonList(
                              tvId: tv.id,
                              seasons: tv.seasons,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Rekomendasi',
                              style: kHeading6,
                            ),
                            BlocBuilder<TVDetailBloc, TVDetailState>(
                              builder: (context, state) {
                                final recommendationsState =
                                    state.tvRecommendationsState;
                                if (recommendationsState ==
                                    RequestState.Loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (recommendationsState ==
                                    RequestState.Loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = recommendations[index];

                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TV_DETAIL_ROUTE,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$BASE_IMAGE_URL${tv.posterPath}',
                                                placeholder: (_, __) =>
                                                    const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget: (_, __, ___) =>
                                                    const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else if (recommendationsState ==
                                    RequestState.Error) {
                                  return Text(state.message);
                                } else {
                                  return const Text('No Recommendations');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              key: const Key('iconBack'),
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<GenreModel> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}

class TvSeriesSeasonList extends StatelessWidget {
  final int tvId;
  final List<SeasonModel> seasons;

  const TvSeriesSeasonList({
    required this.tvId,
    required this.seasons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final season = seasons[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                SEASON_DETAIL_ROUTE,
                arguments: {
                  'id': tvId,
                  'seasonNumber': season.seasonNumber,
                },
              ),
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF211F30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Flexible(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: season.posterPath != null
                              ? '$BASE_IMAGE_URL${season.posterPath}'
                              : 'https://i.ibb.co/TWLKGMY/No-Image-Available.jpg',
                          width: 100,
                          height: 300,
                          fit: BoxFit.cover,
                          placeholder: (_, __) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorWidget: (_, __, error) {
                            return Container(
                              color: Colors.black26,
                              child: const Center(
                                child: Text('No Image'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Center(
                          child: Text(
                            season.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: seasons.length,
      ),
    );
  }
}
