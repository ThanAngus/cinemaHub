import 'dart:convert';
import 'dart:ui';

import 'package:cinemahub/models/movieModel.dart';
import 'package:cinemahub/screens/detailScreen.dart';
import 'package:cinemahub/screens/errorPage.dart';
import 'package:cinemahub/screens/genrePage.dart';
import 'package:cinemahub/screens/homePage.dart';
import 'package:cinemahub/screens/onBoardingPage.dart';
import 'package:cinemahub/screens/rootPage.dart';
import 'package:cinemahub/screens/searchPage.dart';
import 'package:cinemahub/screens/splashScreen.dart';
import 'package:cinemahub/services/movieService.dart';
import 'package:cinemahub/services/peopleService.dart';
import 'package:cinemahub/utils/colors.dart';
import 'package:cinemahub/utils/http_service.dart';
import 'package:cinemahub/utils/provider.dart';
import 'package:cinemahub/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'models/config.dart';

Future<void> _setUp() async {
  final getIt = GetIt.instance;
  final config = await rootBundle.loadString('assets/config/main.json');
  final configData = jsonDecode(config);
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
  getIt.registerSingleton<PeopleService>(
    PeopleService(),
  );
}

void main() {
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
  WidgetsFlutterBinding.ensureInitialized();
  _setUp().then((value){
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  });

}

class MyApp extends ConsumerWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(changeThemeProvider);
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/onBoardingPage',
          name: OnBoardingPage.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const OnBoardingPage(),
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeIn).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/homePage',
          name: HomePage.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const HomePage(),
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeIn).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/',
          name: SplashScreen.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const SplashScreen(),
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeIn).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/rootPage',
          name: RootPage.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const RootPage(),
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeIn).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/genrePage',
          name: GenrePage.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: GenrePage(
                genre: state.queryParams['genre']!,
              ),
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeIn).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/details',
          name: DetailScreen.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: DetailScreen(
                model: state.extra as MovieModel,
              ),
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeIn).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: SearchPage.routeName,
          name: SearchPage.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const SearchPage(),
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeIn).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
      errorBuilder: (context, state) {
        return ErrorPage(
          errorMessage: "NO PAGE FOUND\n${state.error}\n",
        );
      },
    );
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp.router(
          title: 'CinemaHub',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentTheme.darkMode ? ThemeMode.dark : ThemeMode.light,
          routerConfig: router,
          scrollBehavior: MyBehavior(),
        );
      },
    );
  }
}
