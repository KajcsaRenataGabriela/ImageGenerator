import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions/index.dart';
import '../models/index.dart';
import 'containers/index.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final double height = MediaQuery.of(context).size.height;
    final double offset = _scrollController.position.pixels;
    final double maxScrollExtent = _scrollController.position.maxScrollExtent;

    if (store.state.hasMore && !store.state.isLoading && maxScrollExtent - offset < 3 * height) {
      store.dispatch(GetImages.start(page: store.state.page, search: store.state.searchTerm));
    }
  }

  void _search() {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    if (_searchController.text != store.state.searchTerm) {
      store.dispatch(GetImages.start(page: 1, search: _searchController.text));
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IsLoadingContainer(builder: (BuildContext context, bool isLoading) {
            if (isLoading) {
              return const Center(
                child: FittedBox(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
        ],
      ),
      body: IsLoadingContainer(builder: (BuildContext context, bool isLoading) {
        return ImagesContainer(
          builder: (BuildContext context, List<Picture> images) {
            return Column(
              children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _searchController.clear(),
                        ),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.pinkAccent),
                          onPressed: () {},
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _search();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: const Text('Search'),
                  ),
                ]),
                Expanded(
                  child: CustomScrollView(
                    shrinkWrap: true,
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final Picture picture = images[index];
                            return GestureDetector(
                              onTap: () {
                                StoreProvider.of<AppState>(context).dispatch(SetSelectedImage(picture.id));
                                Navigator.pushNamed(context, '/details');
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  GridTile(
                                    child: CachedNetworkImage(
                                        imageUrl: picture.urls.smallS3.isNotEmpty
                                            ? picture.urls.smallS3.isNotEmpty
                                                ? picture.urls.smallS3
                                                : picture.urls.small
                                            : picture.urls.regular,
                                        fit: BoxFit.cover),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: AlignmentDirectional.bottomCenter,
                                          end: AlignmentDirectional.topCenter,
                                          colors: <Color>[Colors.white54, Colors.transparent],
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          picture.user.name,
                                          style: const TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                                        ),
                                        trailing: CircleAvatar(
                                            backgroundImage: NetworkImage(picture.user.profileImages.medium)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          childCount: images.length,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                      ),
                      if (isLoading)
                        const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                    ],
                  ),
                )
              ],
            );
          },
        );
      }),
    );
  }
}
