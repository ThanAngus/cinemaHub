import 'package:cinemahub/components/homeTopCard.dart';
import 'package:cinemahub/components/movieCard.dart';
import 'package:cinemahub/components/shimmerComponent.dart';
import 'package:cinemahub/models/dataModel.dart';
import 'package:cinemahub/provider/repositoryProvider.dart';
import 'package:cinemahub/screens/detailScreen.dart';
import 'package:cinemahub/screens/genrePage.dart';
import 'package:cinemahub/screens/searchPage.dart';
import 'package:cinemahub/utils/constants.dart';
import 'package:cinemahub/utils/responsiveLayout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

import '../models/movieModel.dart';
import '../utils/colors.dart';

class HomePage extends ConsumerStatefulWidget {
  static const routeName = '/homePage';

  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late ScrollController _scrollController;
  List<MovieModel> movieList = [];
  String? selectedOption;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  void fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScreen: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.white.withOpacity(0.1),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Container(
                height: ScreenUtil().setHeight(45),
                width: ScreenUtil().setHeight(45),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/icons/logoDark.png",
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Movies",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "TV Shows",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              PopupMenuButton(
                color: AppColors.black.withOpacity(0.1),
                itemBuilder: (context) {
                  return genres.map((e) {
                    return PopupMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: AppColors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    );
                  }).toList();
                },
                onSelected: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                  context.pushNamed(GenrePage.routeName, queryParams: {
                    'genre': value,
                  });
                },
                child: Row(
                  children: [
                    Text(
                      "Category",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Icon(
                      Icons.arrow_drop_down_sharp,
                      color: AppColors.white.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.pushNamed(
                  SearchPage.routeName,
                );
              },
              icon: Icon(
                Icons.search,
                size: Theme.of(context).textTheme.headlineLarge!.fontSize,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              FutureBuilder(
                future: ref.watch(repositoryProvider).getMovies(
                      DataModel(
                        movies: [],
                        page: 1,
                        searchCategory: "now_playing",
                        searchText: '',
                      ),
                    ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    if (kDebugMode) {
                      print(snapshot.error);
                    }
                  } else {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ShimmerComponent(
                        child: SizedBox(
                          width: ScreenUtil().screenWidth,
                          height: ScreenUtil().screenHeight / 1.4,
                        ),
                      );
                    } else {
                      return HomeTopCard(
                        movies: snapshot.data!,
                        height: ScreenUtil().screenHeight / 1.4,
                      );
                    }
                  }
                  return Container();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    FutureBuilder(
                      future: ref.watch(repositoryProvider).getMovies(
                            DataModel(
                              movies: [],
                              page: 1,
                              searchCategory: "",
                              searchText: '',
                            ),
                          ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          if (kDebugMode) {
                            print(snapshot.error);
                          }
                        }
                        else {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ShimmerComponent(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        "Discover",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 200,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            ShimmerComponent(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width:
                                                      ScreenUtil().screenWidth /
                                                          3.5,
                                                  height: 180,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            ShimmerComponent(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width:
                                                      ScreenUtil().screenWidth /
                                                          3.5,
                                                  height: 180,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            ShimmerComponent(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width:
                                                      ScreenUtil().screenWidth /
                                                          3.5,
                                                  height: 180,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    "Discover",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  height: 200,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return MovieCard(
                                        image: "${Constants.imageBaseUrl}${snapshot.data![index].posterPath}",
                                        movieModel: snapshot.data![index],
                                        mainExtend: true,
                                        width: ScreenUtil().screenWidth / 3.5,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        width: 10,
                                      );
                                    },
                                    itemCount: snapshot.data!.length,
                                  ),
                                ),
                              ],
                            );
                          }
                        }
                        return Container();
                      },
                    ),
                    FutureBuilder(
                      future: ref.watch(repositoryProvider).getGenreMovies(
                            'Horror',
                            'discover/movie',
                            1,
                          ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          if (kDebugMode) {
                            print(snapshot.error);
                          }
                        } else {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ShimmerComponent(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        "Discover",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 200,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            ShimmerComponent(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width:
                                                      ScreenUtil().screenWidth /
                                                          3.5,
                                                  height: 180,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            ShimmerComponent(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width:
                                                      ScreenUtil().screenWidth /
                                                          3.5,
                                                  height: 180,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            ShimmerComponent(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width:
                                                      ScreenUtil().screenWidth /
                                                          3.5,
                                                  height: 180,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            if (snapshot.data != null) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 10,
                                    ),
                                    child: Text(
                                      "Horror Movies",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return MovieCard(
                                          width: ScreenUtil().screenWidth / 3.5,
                                          image:
                                              snapshot.data![index].posterUrl(),
                                          movieModel: snapshot.data![index],
                                          mainExtend: true,
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          width: 10,
                                        );
                                      },
                                      itemCount: snapshot.data!.length,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }
                        }
                        return Container();
                      },
                    ),
                    FutureBuilder(
                      future: ref.watch(repositoryProvider).getGenreMovies(
                            'Fantasy',
                            'discover/movie',
                            1,
                          ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          if (kDebugMode) {
                            print(snapshot.error);
                          }
                        } else {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ShimmerComponent(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        "Discover",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 200,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            ShimmerComponent(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width:
                                                      ScreenUtil().screenWidth /
                                                          3.5,
                                                  height: 180,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            ShimmerComponent(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width:
                                                      ScreenUtil().screenWidth /
                                                          3.5,
                                                  height: 180,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            ShimmerComponent(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width:
                                                      ScreenUtil().screenWidth /
                                                          3.5,
                                                  height: 180,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            if (snapshot.data != null) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 10,
                                    ),
                                    child: Text(
                                      "Fantasy World",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return MovieCard(
                                          width: ScreenUtil().screenWidth / 3.5,
                                          image:
                                              snapshot.data![index].posterUrl(),
                                          movieModel: snapshot.data![index],
                                          mainExtend: true,
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          width: 10,
                                        );
                                      },
                                      itemCount: snapshot.data!.length,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      webScreen: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.black.withOpacity(0.1),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Container(
                height: ScreenUtil().setHeight(50),
                width: ScreenUtil().setHeight(50),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/icons/logoDark.png",
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Home",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: ScreenUtil().setSp(4),
                        color: AppColors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "TV Shows",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: ScreenUtil().setSp(4),
                        color: AppColors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Movies",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: ScreenUtil().setSp(4),
                        color: AppColors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        body: WebSmoothScroll(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                FutureBuilder(
                  future: ref.watch(repositoryProvider).getMovies(
                        DataModel(
                          movies: [],
                          page: 1,
                          searchCategory: "now_playing",
                          searchText: '',
                        ),
                      ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      if (kDebugMode) {
                        print(snapshot.error);
                      }
                    } else {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ShimmerComponent(
                          child: SizedBox(
                            width: ScreenUtil().screenWidth,
                            height: ScreenUtil().screenHeight / 1.2,
                          ),
                        );
                      } else {
                        return HomeTopCard(
                          movies: snapshot.data!,
                          height: ScreenUtil().screenHeight / 1.2,
                        );
                      }
                    }
                    return Container();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: ref.watch(repositoryProvider).getMovies(
                              DataModel(
                                movies: [],
                                page: 1,
                                searchCategory: "popular",
                                searchText: '',
                              ),
                            ),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            if (kDebugMode) {
                              print(snapshot.error);
                            }
                          } else {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ShimmerComponent(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        "Discover",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 400,
                                            width:
                                                ScreenUtil().screenWidth / 3.5,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            height: 400,
                                            width:
                                                ScreenUtil().screenWidth / 3.5,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            height: 400,
                                            width:
                                                ScreenUtil().screenWidth / 3.5,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            height: 400,
                                            width:
                                                ScreenUtil().screenWidth / 3.5,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            height: 400,
                                            width:
                                                ScreenUtil().screenWidth / 3.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      "Discover",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      height: 400,
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return MovieCard(
                                            image: snapshot.data![index]
                                                .posterUrl(),
                                            movieModel: snapshot.data![index],
                                            mainExtend: true,
                                            width: ScreenUtil().screenWidth / 6,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            width: 20,
                                          );
                                        },
                                        itemCount: snapshot.data!.length,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                          return Container();
                        },
                      ),
                      FutureBuilder(
                        future: ref.watch(repositoryProvider).getGenreMovies(
                              'Horror',
                              'discover/movie',
                              1,
                            ),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            if (kDebugMode) {
                              print(snapshot.error);
                            }
                          } else {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ShimmerComponent(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Text(
                                          "Discover",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 400,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              ShimmerComponent(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    width: ScreenUtil()
                                                            .screenWidth /
                                                        6,
                                                    height: 400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ShimmerComponent(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    width: ScreenUtil()
                                                            .screenWidth /
                                                        6,
                                                    height: 400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ShimmerComponent(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    width: ScreenUtil()
                                                            .screenWidth /
                                                        6,
                                                    height: 400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ShimmerComponent(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    width: ScreenUtil()
                                                            .screenWidth /
                                                        6,
                                                    height: 400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              if (snapshot.data != null) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        "Horror Movies",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 400,
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return MovieCard(
                                            width: ScreenUtil().screenWidth / 6,
                                            image: snapshot.data![index]
                                                .posterUrl(),
                                            movieModel: snapshot.data![index],
                                            mainExtend: true,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            width: 10,
                                          );
                                        },
                                        itemCount: snapshot.data!.length,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }
                          }
                          return Container();
                        },
                      ),
                      FutureBuilder(
                        future: ref.watch(repositoryProvider).getGenreMovies(
                          'Fantasy',
                          'discover/movie',
                          1,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            if (kDebugMode) {
                              print(snapshot.error);
                            }
                          } else {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ShimmerComponent(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Text(
                                          "Discover",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 400,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              ShimmerComponent(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                    ),
                                                    width: ScreenUtil()
                                                        .screenWidth /
                                                        6,
                                                    height: 400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ShimmerComponent(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                    ),
                                                    width: ScreenUtil()
                                                        .screenWidth /
                                                        6,
                                                    height: 400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ShimmerComponent(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                    ),
                                                    width: ScreenUtil()
                                                        .screenWidth /
                                                        6,
                                                    height: 400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ShimmerComponent(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                    ),
                                                    width: ScreenUtil()
                                                        .screenWidth /
                                                        6,
                                                    height: 400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              if (snapshot.data != null) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        "Fantasy world",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 400,
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return MovieCard(
                                            width: ScreenUtil().screenWidth / 6,
                                            image: snapshot.data![index]
                                                .posterUrl(),
                                            movieModel: snapshot.data![index],
                                            mainExtend: true,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            width: 10,
                                          );
                                        },
                                        itemCount: snapshot.data!.length,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
