import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tv_pages/search_tv_page.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static const ROUTE_NAME = '/search';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _indexValue = 'Movie';
  List<String> _pageList = ['Movie', 'Tv Series'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                Provider.of<MovieSearchNotifier>(context, listen: false)
                    .fetchMovieSearch(query);
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            Consumer<MovieSearchNotifier>(
              builder: (context, data, child) {
                if (data.state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (data.state == RequestState.Loaded) {
                  final result = data.searchResult;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = data.searchResult[index];
                        return MovieCard(movie);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      )
          : SearchTvPage(),
    );
  }
}
