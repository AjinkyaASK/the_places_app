import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_places_app/src/util/url/url_utility.dart';

import '../../../../../util/navigation/router.dart';
import '../../../../../value/strings.dart';
import '../../../../auth/data/model/user.dart';

///[ProfileDialog] is the widget that contains
///user's details and an option to sign out
class ProfileDialog extends StatelessWidget {
  const ProfileDialog({
    Key? key,
    required this.user,
    required this.onSignOut,
  }) : super(key: key);

  ///[user] is the intance of PlacesAppUser containing user's details
  final PlacesAppUser user;

  ///[onSignOut] is called when user taps on the sign out button
  final void Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      /// Keeping all padding zero for end to end content space
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /// Dialog close button
          IconButton(
            onPressed: () {
              if (RouteManger.navigatorKey.currentState != null)
                RouteManger.navigatorKey.currentState!.pop();
            },
            icon: Icon(
              Icons.close,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      content: Container(
        width: 150.0,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: user.pictureUrl.isEmpty
                          ? null
                          : CachedNetworkImageProvider(user.pictureUrl),
                      child: user.pictureUrl.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 64.0,
                              color: Colors.white30,
                            )
                          : null,
                      backgroundColor: Colors.grey.shade800,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (user.email != null)
                    Text(
                      user.email!,
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                ],
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                Strings.aboutThisAppTitle,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.0,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    'v1.0.0',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Text(
                  '•',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.0,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      UrlUtility.launchUrl(Strings.githubRepositoryLink),
                  child: Text(Strings.githubRepositoryButton),
                ),
              ],
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
            ),
          ],
        ),
      ),
      actions: [
        /// Signout button
        TextButton(
          onPressed: onSignOut,
          child: Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              Strings.signOutButton,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}
