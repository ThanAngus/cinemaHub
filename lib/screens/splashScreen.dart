import 'dart:convert';

import 'package:cinemahub/screens/homePage.dart';
import 'package:cinemahub/screens/rootPage.dart';
import 'package:cinemahub/services/responsive.dart';
import 'package:cinemahub/utils/responsiveLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../models/config.dart';
import '../services/movieService.dart';
import '../utils/colors.dart';
import '../utils/http_service.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 10),).then((value){
      context.pushNamed(
        RootPage.routeName,
      );
    });
    /*_setUp().then((value) {
      context.pushNamed(
        RootPage.routeName,
      );
    });*/
    super.initState();
    /* _videoPlayerController =
        VideoPlayerController.asset('assets/video/videoDark.mp4');
    _videoPlayerController.initialize().then(
      (value) {

        setState(() {});
      },
    );*/
  }

  Future<void> _setUp() async {
    final getIt = GetIt.instance;
    final config = await rootBundle.loadString('assets/config/main.json');
    final configData = jsonDecode(config);
    if(!GetIt.instance.isRegistered<AppConfig>()) {
      getIt.registerSingleton<AppConfig>(
        AppConfig(
          apiKey: configData['API_KEY'],
          baseApUrl: configData['BASE_API_URL'],
          baseImageApiUrl: configData['BASE_IMAGE_API_URL'],
        ),
      );
      getIt.registerSingleton<HTTPService>(
        HTTPService(),
      );
      getIt.registerSingleton<MovieService>(
        MovieService(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.white,
        ),
        /*child: _videoPlayerController.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(
                    _videoPlayerController,
                  ),
                )
              : Container(),*/
      ),
    );
  }
}
