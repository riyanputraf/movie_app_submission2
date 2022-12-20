import 'package:ditonton/presentation/provider/tv_provider/tv_on_showing_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/state_enum.dart';
import '../../widgets/tv_card.dart';

class OnShowingTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/onair-tv-series';

  const OnShowingTvPage({Key? key}) : super(key: key);

  @override
  State<OnShowingTvPage> createState() => _OnShowingTvPageState();
}

class _OnShowingTvPageState extends State<OnShowingTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<TvOnAirNotifier>(context, listen: false)
        .fetchOnAirTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On Air Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TvOnAirNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.tvSeries[index];
                  return TvCard(tv);
                },
                itemCount: data.tvSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
