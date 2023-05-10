
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/index.dart';
import 'containers/index.dart';

class PictureDetails extends StatelessWidget {
  const PictureDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectedPictureContainer(builder: (BuildContext context, Picture picture) {
      return Scaffold(
        appBar: AppBar(
          title: Text(picture.user.name),
        ),
        body: Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: picture.urls.regular,
              fit: BoxFit.cover,
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
                    '${picture.likes} Likes \n${picture.description ?? ''}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  trailing: CircleAvatar(backgroundImage: NetworkImage(picture.user.profileImages.medium)),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
