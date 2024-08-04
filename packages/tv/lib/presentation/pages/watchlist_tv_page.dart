import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';

class WatchlistTVPage extends StatefulWidget {
  const WatchlistTVPage({super.key});

  @override
  State<WatchlistTVPage> createState() => _WatchlistTVPageState();
}

class _WatchlistTVPageState extends State<WatchlistTVPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<WatchlistTVBloc>().add(FetchWatchlistTV()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTVBloc>().add(FetchWatchlistTV());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistTVBloc, WatchlistTVState>(
      builder: (context, state) {
        if (state.state == RequestState.Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == RequestState.Loaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = state.watchlistTV[index];
              return TVCard(movie);
            },
            itemCount: state.watchlistTV.length,
          );
        } else if (state.state == RequestState.Error) {
          return Center(
            key: const Key('error_message'),
            child: Text(state.message),
          );
        } else if (state.state == RequestState.Empty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.visibility_off, size: 72),
                const SizedBox(height: 2),
                Text('Empty Watchlist', style: kSubtitle),
              ],
            ),
          );
        } else {
          return const Center();
        }
      },
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
