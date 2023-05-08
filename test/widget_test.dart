// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:image_generator/actions/index.dart';
import 'package:image_generator/data/unsplash_api.dart';
import 'package:image_generator/epics/app_epics.dart';

import 'package:image_generator/main.dart';
import 'package:image_generator/models/index.dart';
import 'package:image_generator/reducer/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
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

    await tester.pumpWidget(MyApp(store: store));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
