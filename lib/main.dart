import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

import 'src/actions/index.dart';
import 'src/data/unsplash_api.dart';
import 'src/epics/app_epics.dart';
import 'src/models/index.dart';
import 'src/presentation/home_page.dart';
import 'src/presentation/picure_page.dart';
import 'src/reducer/app_reducer.dart';

void main() async {
  await dotenv.load();
  final String apiKey = dotenv.env['API_KEY']!;
  final Client client = Client();
  final UnsplashApi api = UnsplashApi(client, apiKey);
  final AppEpics epic = AppEpics(api);

  final Store<AppState> store =
      Store<AppState>(reducer, initialState: const AppState(), middleware: <Middleware<AppState>>[
    EpicMiddleware<AppState>(epic.call).call,
  ]);

  store.dispatch(GetImages.start(page: store.state.page, search: store.state.searchTerm));

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.store});

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Photos from Unsplash',
        theme: ThemeData(primarySwatch: Colors.pink),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => const MyHomePage(title: 'Photos from Unsplash'),
          '/details': (BuildContext context) => const PictureDetails(),
        },
      ),
    );
  }
}
