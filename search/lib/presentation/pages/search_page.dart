import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/widget/movie_card_list.dart';
import 'package:provider/provider.dart';
import 'package:search/presentation/bloc/search/search_bloc.dart';
import 'package:search/presentation/pages/search_tv_page.dart';

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
                      onChanged: (query) {
                        context.read<SearchBloc>().add(OnQueryChanged(query));
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
                    BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (state is SearchLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is SearchHasData) {
                          final result = state.result;
                          return Expanded(
                              child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final movie = result[index];
                              return MovieCard(movie);
                            },
                            itemCount: result.length,
                          ));
                        } else if (state is SearchError) {
                          return Expanded(
                            child: Center(
                              child: Text(state.message),
                            ),
                          );
                        } else {
                          return Expanded(
                            child: Container(),
                          );
                        }
                      },
                    )
                  ],
                ),
              )
            : SearchTvPage());
  }
}
