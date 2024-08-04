import 'package:core/core.dart';
import 'package:movie/presentation/bloc/search/search_bloc.dart';
import 'package:tv/presentation/bloc/search/search_bloc.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cari'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.movie)),
              Tab(icon: Icon(Icons.live_tv_outlined)),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            children: [
              buildSearchView(
                context,
                hintText: 'Cari Film',
                onSubmitted: (query) {
                  context.read<MovieSearchBloc>().add(FetchMovieSearch(query));
                },
                child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
                  builder: (_, state) {
                    if (state.state == RequestState.Loading) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state.state == RequestState.Loaded) {
                      final result = state.searchResult;
                      return Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (_, index) {
                            final movie = result[index];
                            return MovieCard(movie);
                          },
                          itemCount: result.length,
                        ),
                      );
                    } else if (state.state == RequestState.Empty) {
                      return Container(
                        margin: const EdgeInsets.only(top: 32),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off, size: 72),
                              const SizedBox(height: 2),
                              Text('Search Not Found', style: kSubtitle),
                            ],
                          ),
                        ),
                      );
                    } else if (state.state == RequestState.Error) {
                      return Expanded(
                        child: Center(
                          key: const Key('error_message'),
                          child: Text(state.message),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Container(),
                      );
                    }
                  },
                ),
              ),
              buildSearchView(
                context,
                hintText: 'Cari Televisi',
                onSubmitted: (query) {
                  context.read<TVSearchBloc>().add(FetchTVSearch(query));
                },
                child: BlocBuilder<TVSearchBloc, TVSearchState>(
                  builder: (_, state) {
                    if (state.state == RequestState.Loading) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state.state == RequestState.Loaded) {
                      final result = state.searchResult;
                      return Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (_, index) {
                            final tv = result[index];
                            return TVCard(tv);
                          },
                          itemCount: result.length,
                        ),
                      );
                    } else if (state.state == RequestState.Empty) {
                      return Container(
                        margin: const EdgeInsets.only(top: 32),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off, size: 72),
                              const SizedBox(height: 2),
                              Text('Search Not Found', style: kSubtitle),
                            ],
                          ),
                        ),
                      );
                    } else if (state.state == RequestState.Error) {
                      return Expanded(
                        child: Center(
                          key: const Key('error_message'),
                          child: Text(state.message),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Container(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchView(
    BuildContext context, {
    required String hintText,
    required Function(String) onSubmitted,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color(0xFF211F30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16).copyWith(right: 20),
                child: const Icon(Icons.search, color: Color(0xFFBBBBBB)),
              ),
              Expanded(
                child: TextField(
                  onSubmitted: onSubmitted,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Color(0xFFBBBBBB)),
                  textInputAction: TextInputAction.search,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Hasil Pencarian',
          style: kHeading6,
        ),
        child,
      ],
    );
  }
}
