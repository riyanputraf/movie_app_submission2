import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/pages/tv_pages/watchlist_tv_page.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  String _indexValue = 'Movie';
  List<String> _pageList = ['Movie', 'Tv Series'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistMovieNotifier>(context, listen: false)
            .fetchWatchlistMovies());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(context, listen: false)
        .fetchWatchlistMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                icon: const Icon(Icons.arrow_downward),
                value: _indexValue,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                items: _pageList
                    .map((valueItem) => DropdownMenuItem(
                  child: Text(
                    valueItem,
                    style: kHeading6,
                  ),
                  value: valueItem,
                ))
                    .toList(),
                onChanged: (String? val) {
                  setState(() {
                    _indexValue = val!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: _indexValue == 'Movie'
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchlistMovieNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.watchlistState == RequestState.Loaded) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final movie = data.watchlistMovies[index];
                  return MovieCard(movie);
                },
                itemCount: data.watchlistMovies.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      )
          : WatchlistTvPage(),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
