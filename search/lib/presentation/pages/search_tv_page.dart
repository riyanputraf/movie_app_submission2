import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:search/presentation/bloc/tvsearch/tvsearch_bloc.dart';
import 'package:tvseries/presentation/widget/tv_card.dart';

class SearchTvPage extends StatefulWidget {
  const SearchTvPage({Key? key}) : super(key: key);

  @override
  State<SearchTvPage> createState() => _SearchTvPageState();
}

class _SearchTvPageState extends State<SearchTvPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (query) {
              context.read<TvsearchBloc>().add(OnTvQueryChanged(query));
            },
            decoration: const InputDecoration(
              hintText: 'Search title',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
          ),
          const SizedBox(height: 16),
          Text(
            'Search Result',
            style: kHeading6,
          ),
          BlocBuilder<TvsearchBloc, TvsearchState>(
            builder: (context, state) {
              if (state is TvSearchLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TvSearchHasData) {
                final result = state.result;
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final tv = state.result[index];
                      return TvCard(tv);
                    },
                    itemCount: result.length,
                  ),
                );
              } else if (state is TvSearchError) {
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
          ),
        ],
      ),
    );
  }
}
