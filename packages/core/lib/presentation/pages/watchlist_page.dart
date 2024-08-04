import 'package:core/core.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:tv/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/material.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _listTabs.length,
      vsync: this,
      initialIndex: 0,
    );
  }

  final List<Widget> _listTabs = [
    const Text('Film'),
    const Text(
      'Serial TV',
      key: Key('tabTvDaftarTonton'),
    ),
  ];

  final List<Widget> _listWidget = [
    const WatchlistMoviesPage(),
    const WatchlistTVPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daftar Tonton',
                style: kHeading5.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TabBar(
                labelPadding: const EdgeInsets.all(16),
                controller: _tabController,
                tabs: _listTabs,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _listWidget,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
