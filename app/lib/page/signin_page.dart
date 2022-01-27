import 'dart:developer';

import 'package:app/util/hex_color.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  FirebaseFunctions functions = FirebaseFunctions.instance;

  void _launchURL() async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getSpotifyOAuthUrl');
    dynamic result = await callable({'state': 'app'});
    if (!await launch(result.data)) throw "Could not launch ${result.data}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 40),
                child: const Text(
                    'If you want to listen to the entire music, you have to sign in with a premium Spotify account.',
                    style: TextStyle(
                      height: 1.5,
                      color: Color(0xffffffff),
                    ))),
            MaterialButton(
                minWidth: double.infinity,
                height: 64,
                color: HexColor('#1DB954'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                onPressed: _launchURL,
                padding: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MdiIcons.spotify,
                      color: HexColor('#ffffff'),
                      size: 24,
                    ),
                    Container(width: 8),
                    Text(
                      'Sign in with spotify',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: HexColor('#ffffff'),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
