import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

import 'actions/index.dart';
import 'data/unsplash_api.dart';
import 'epics/app_epics.dart';
import 'models/index.dart';
import 'presentation/ui/home_page.dart';
import 'reducer/app_reducer.dart';

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
        home: MyHomePage(
          title: 'Photos from Unsplash',
          store: store,
        ),
      ),
    );
  }
}
