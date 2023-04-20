import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemahub/components/movieCard.dart';
import 'package:cinemahub/models/mediaModel.dart';
import 'package:cinemahub/models/peopleModel.dart';
import 'package:cinemahub/utils/responsiveLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/genreModel.dart';
import '../models/movieModel.dart';
import '../provider/repositoryProvider.dart';
import '../provider/utilProvider.dart';
import '../utils/colors.dart';

class DetailScreen extends ConsumerStatefulWidget {
  static const routeName = '/details';
  final MovieModel model;

  const DetailScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  late YoutubePlayerController youtubePlayerController;
  bool? videoDone = false;
  List<Genre> genres = [];
  List<PeopleModel> casts = [];
  List<PeopleModel> fullCasts = [];
  List<PeopleModel> crews = [];
  List<MovieModel> recommendList = [];
  List<VideoModel>? trailers = [];
  List<VideoModel>? teasers = [];
  List<VideoModel>? behindTheScenes = [];
  List<VideoModel>? bloopers = [];
  List<VideoModel>? featurette = [];
  List<VideoModel>? clips = [];
  List<VideoModel>? videos = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  DateTime _parseDateStr(String inputString) {
    DateFormat format = DateFormat.y();
    return format.parse(inputString);
  }

  void fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref
          .read(repositoryProvider)
          .fetchGenres(widget.model.genreId)
          .then((value) {
        setState(() {
          genres = value!;
        });
      });
      await ref
          .read(repositoryProvider)
          .getPeopleList(
            widget.model.id,
            'cast',
          )
          .then((value) {
        setState(() {
          fullCasts = value!;
          for (PeopleModel e in value) {
            if (e.profilePath != null && casts.length < 4) {
              casts.add(e);
            }
          }
        });
      });
      await ref
          .read(repositoryProvider)
          .getPeopleList(
            widget.model.id,
            'crew',
          )
          .then((value) {
        setState(() {
          crews = value!;
        });
      });
      await ref
          .read(repositoryProvider)
          .getVideos(widget.model.id)
          .then((value) {
        setState(() {
          videos = value;
        });
        if (value!.isNotEmpty) {
          videoList(value);
        }
      });
      List<MovieModel>? list =
          await ref.read(repositoryProvider).fetchSimilarMovies(
                widget.model.id,
              );
      for (MovieModel e in list!) {
        if (recommendList.length < 6 && e.posterPath != null) {
          setState(() {
            recommendList.add(e);
          });
        }
      }
    });
  }

  void videoList(List<VideoModel>? videos) {
    setState(() {
      for (VideoModel e in videos!) {
        if (e.type == 'Trailer') {
          trailers!.add(e);
        } else if (e.type == 'Teaser') {
          teasers!.add(e);
        } else if (e.type == 'Featurette') {
          featurette!.add(e);
        } else if (e.type == 'Behind the Scenes') {
          behindTheScenes!.add(e);
        } else if (e.type == 'Bloopers') {
          bloopers!.add(e);
        } else {
          clips!.add(e);
        }
      }
      if (trailers!.isNotEmpty) {
        youtubePlayerController = YoutubePlayerController(
            initialVideoId: trailers!.last.key,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: true,
            ));
      } else if (teasers!.isNotEmpty) {
        youtubePlayerController = YoutubePlayerController(
            initialVideoId: teasers!.last.key,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: true,
            ));
      } else {
        youtubePlayerController = YoutubePlayerController(
            initialVideoId: videos.first.key,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: true,
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ResponsiveLayout(
      mobileScreen: Scaffold(
        extendBody: true,
        appBar: AppBar(
          elevation: 5,
          backgroundColor: AppColors.black,
          leading: IconButton(
            color: AppColors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              videos!.isNotEmpty
                  ? YoutubePlayer(
                      controller: youtubePlayerController,
                      showVideoProgressIndicator: false,
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height / 2.8,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.model.backdropUrl(),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: AppColors.black.withOpacity(0.5),
                              highlightColor: AppColors.white.withOpacity(0.5),
                              child: Container(
                                width: size.width,
                              ),
                            ),
                          ),
                          Center(
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.black.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Icon(
                                    Icons.replay,
                                    size: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.title,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Text(
                            DateFormat('yyyy').format(
                              _parseDateStr(widget.model.releaseDate),
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: AppColors.black.withOpacity(0.7),
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Text(
                                  genres[index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: AppColors.black.withOpacity(0.7),
                                      ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Container(
                                    height: 3,
                                    width: 3,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.black.withOpacity(0.5),
                                    ),
                                  ),
                                );
                              },
                              itemCount: genres.length < 2 ? genres.length : 2,
                              shrinkWrap: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                          Text(
                            "02h 30m",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: AppColors.black.withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.black,
                            border: Border.all(
                              color: AppColors.black,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              size: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.fontSize,
                              color: AppColors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Play",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: AppColors.white,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.black,
                            border: Border.all(
                              color: AppColors.black,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.download,
                              size: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.fontSize,
                              color: AppColors.black,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Download",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: AppColors.white,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.model.overview,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.black.withOpacity(0.7),
                          ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    videos!.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Videos',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (trailers!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: Text(
                                              'Trailers',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              VideoModel model =
                                                  trailers![index];
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      ref
                                                          .read(appProvider)
                                                          .launchLink(
                                                            'https://youtu.be/${model.key}',
                                                          );
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .center,
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl:
                                                              "https://img.youtube.com/vi/${model.key}/0.jpg",
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            height: ScreenUtil()
                                                                .setHeight(160),
                                                            width: ScreenUtil()
                                                                .screenWidth,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              Shimmer
                                                                  .fromColors(
                                                            baseColor: AppColors
                                                                .black
                                                                .withOpacity(
                                                                    0.5),
                                                            highlightColor:
                                                                AppColors.white
                                                                    .withOpacity(
                                                                        0.5),
                                                            child: Container(
                                                              width: size.width,
                                                            ),
                                                          ),
                                                        ),
                                                        Image(
                                                          width: ScreenUtil()
                                                              .setWidth(50),
                                                          height: ScreenUtil()
                                                              .setWidth(50),
                                                          image:
                                                              const AssetImage(
                                                            "assets/icons/youtube_social_icon_red.png",
                                                          ),
                                                          fit: BoxFit.contain,
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 10,
                                                    ),
                                                    child: Text(
                                                      model.name!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            itemCount: trailers!.length,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              if (teasers!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: Text(
                                              'Teasers',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              VideoModel model =
                                                  teasers![index];
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      ref
                                                          .read(appProvider)
                                                          .launchLink(
                                                            'https://youtu.be/${model.key}',
                                                          );
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .center,
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl:
                                                              "https://img.youtube.com/vi/${model.key}/0.jpg",
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            height: ScreenUtil()
                                                                .setHeight(160),
                                                            width: ScreenUtil()
                                                                .screenWidth,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              Shimmer
                                                                  .fromColors(
                                                            baseColor: AppColors
                                                                .black
                                                                .withOpacity(
                                                                    0.5),
                                                            highlightColor:
                                                                AppColors.white
                                                                    .withOpacity(
                                                                        0.5),
                                                            child: Container(
                                                              width: size.width,
                                                            ),
                                                          ),
                                                        ),
                                                        Image(
                                                          width: ScreenUtil()
                                                              .setWidth(50),
                                                          height: ScreenUtil()
                                                              .setWidth(50),
                                                          image:
                                                              const AssetImage(
                                                            "assets/icons/youtube_social_icon_red.png",
                                                          ),
                                                          fit: BoxFit.contain,
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 10,
                                                    ),
                                                    child: Text(
                                                      model.name!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            itemCount: teasers!.length,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              if (featurette!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: Text(
                                              'Featurette',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              VideoModel model =
                                                  featurette![index];
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      ref
                                                          .read(appProvider)
                                                          .launchLink(
                                                            'https://youtu.be/${model.key}',
                                                          );
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .center,
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl:
                                                              "https://img.youtube.com/vi/${model.key}/0.jpg",
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            height: ScreenUtil()
                                                                .setHeight(160),
                                                            width: ScreenUtil()
                                                                .screenWidth,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              Shimmer
                                                                  .fromColors(
                                                            baseColor: AppColors
                                                                .black
                                                                .withOpacity(
                                                                    0.5),
                                                            highlightColor:
                                                                AppColors.white
                                                                    .withOpacity(
                                                                        0.5),
                                                            child: Container(
                                                              width: size.width,
                                                            ),
                                                          ),
                                                        ),
                                                        Image(
                                                          width: ScreenUtil()
                                                              .setWidth(50),
                                                          height: ScreenUtil()
                                                              .setWidth(50),
                                                          image:
                                                              const AssetImage(
                                                            "assets/icons/youtube_social_icon_red.png",
                                                          ),
                                                          fit: BoxFit.contain,
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 10,
                                                    ),
                                                    child: Text(
                                                      model.name!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            itemCount: featurette!.length,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              if (behindTheScenes!.isNotEmpty)
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: Text(
                                              'Behind The Scenes',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              VideoModel model =
                                                  behindTheScenes![index];
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .center,
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl:
                                                            "https://img.youtube.com/vi/${model.key}/0.jpg",
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          height: ScreenUtil()
                                                              .setHeight(160),
                                                          width: ScreenUtil()
                                                              .screenWidth,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            Shimmer.fromColors(
                                                          baseColor: AppColors
                                                              .black
                                                              .withOpacity(0.5),
                                                          highlightColor:
                                                              AppColors.white
                                                                  .withOpacity(
                                                                      0.5),
                                                          child: Container(
                                                            width: size.width,
                                                          ),
                                                        ),
                                                      ),
                                                      Image(
                                                        width: ScreenUtil()
                                                            .setWidth(50),
                                                        height: ScreenUtil()
                                                            .setWidth(50),
                                                        image: const AssetImage(
                                                          "assets/icons/youtube_social_icon_red.png",
                                                        ),
                                                        fit: BoxFit.contain,
                                                        filterQuality:
                                                            FilterQuality.high,
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 10,
                                                    ),
                                                    child: Text(
                                                      model.name!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            itemCount: behindTheScenes!.length,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              if (bloopers!.isNotEmpty)
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: Text(
                                              'Bloopers',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              VideoModel model =
                                                  bloopers![index];
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .center,
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl:
                                                            "https://img.youtube.com/vi/${model.key}/0.jpg",
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          height: ScreenUtil()
                                                              .setHeight(160),
                                                          width: ScreenUtil()
                                                              .screenWidth,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            Shimmer.fromColors(
                                                          baseColor: AppColors
                                                              .black
                                                              .withOpacity(0.5),
                                                          highlightColor:
                                                              AppColors.white
                                                                  .withOpacity(
                                                                      0.5),
                                                          child: Container(
                                                            width: size.width,
                                                          ),
                                                        ),
                                                      ),
                                                      Image(
                                                        width: ScreenUtil()
                                                            .setWidth(50),
                                                        height: ScreenUtil()
                                                            .setWidth(50),
                                                        image: const AssetImage(
                                                          "assets/icons/youtube_social_icon_red.png",
                                                        ),
                                                        fit: BoxFit.contain,
                                                        filterQuality:
                                                            FilterQuality.high,
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 10,
                                                    ),
                                                    child: Text(
                                                      model.name!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            itemCount: bloopers!.length,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              if (clips!.isNotEmpty)
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: Text(
                                              'Clips',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              VideoModel model = clips![index];
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .center,
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl:
                                                            "https://img.youtube.com/vi/${model.key}/0.jpg",
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          height: ScreenUtil()
                                                              .setHeight(160),
                                                          width: ScreenUtil()
                                                              .screenWidth,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            Shimmer.fromColors(
                                                          baseColor: AppColors
                                                              .black
                                                              .withOpacity(0.5),
                                                          highlightColor:
                                                              AppColors.white
                                                                  .withOpacity(
                                                                      0.5),
                                                          child: Container(
                                                            width: size.width,
                                                          ),
                                                        ),
                                                      ),
                                                      Image(
                                                        width: ScreenUtil()
                                                            .setWidth(50),
                                                        height: ScreenUtil()
                                                            .setWidth(50),
                                                        image: const AssetImage(
                                                          "assets/icons/youtube_social_icon_red.png",
                                                        ),
                                                        fit: BoxFit.contain,
                                                        filterQuality:
                                                            FilterQuality.high,
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 10,
                                                    ),
                                                    child: Text(
                                                      model.name!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            itemCount: clips!.length,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                            ],
                          )
                        : Container(),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(100),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.add,
                                      color: AppColors.white,
                                      size: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .fontSize,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "My List",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: AppColors.black,
                                  ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(100),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.share_outlined,
                                      color: AppColors.white,
                                      size: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .fontSize,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Share",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: AppColors.black,
                                  ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(100),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.download,
                                      color: AppColors.white,
                                      size: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .fontSize,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Download",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: AppColors.black,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              recommendList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 2,
                            color: AppColors.primary,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: Text(
                              "See more like this",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                          Center(
                            child: Wrap(
                              children: recommendList.map((e) {
                                return MovieCard(
                                  image: e.posterUrl(),
                                  mainExtend: false,
                                  width: ScreenUtil().screenWidth / 3.5,
                                  movieModel: e,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    context.pushNamed(DetailScreen.routeName,
                                        extra: e,
                                        queryParams: {
                                          'id': "${e.id}",
                                        });
                                    fetchData();
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(
                      height: 20,
                    ),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.black,
                ),
                width: ScreenUtil().screenWidth,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About ${widget.model.title}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.white,
                                ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (crews.isNotEmpty)
                            RichText(
                              text: TextSpan(
                                text: 'Director: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: AppColors.white.withOpacity(0.3),
                                    ),
                                children: [
                                  WidgetSpan(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Text(
                                        crews[crews.indexWhere((element) =>
                                                element.job == 'Director')]
                                            .name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: AppColors.white
                                                  .withOpacity(0.8),
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Genres:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: AppColors.white.withOpacity(0.3),
                                    ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                runSpacing: 10,
                                spacing: 10,
                                children: genres.map((e) {
                                  return InkWell(
                                    onTap: () {},
                                    child: Text(
                                      e.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: AppColors.white
                                                .withOpacity(0.7),
                                          ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Text(
                                  'Cast:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: AppColors.white.withOpacity(0.3),
                                      ),
                                ),
                              ),
                              Wrap(
                                spacing: 10,
                                children: fullCasts.map((e) {
                                  return InkWell(
                                    onTap: () {},
                                    child: Text(
                                      e.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: AppColors.white
                                                .withOpacity(0.7),
                                          ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      webScreen: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            color: AppColors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.black.withOpacity(0.5),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  videos!.isNotEmpty
                      ? YoutubePlayer(
                          controller: youtubePlayerController,
                          showVideoProgressIndicator: false,
                          aspectRatio: 21 / 9,
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 2.8,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: widget.model.backdropUrl(),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: AppColors.black.withOpacity(0.5),
                                  highlightColor:
                                      AppColors.white.withOpacity(0.5),
                                  child: Container(
                                    width: size.width,
                                  ),
                                ),
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.black.withOpacity(0.4),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
                                      child: Icon(
                                        Icons.replay,
                                        size: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .fontSize,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  Container(
                    width: ScreenUtil().screenWidth / 2,
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.model.title,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: size.width / 4,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.black,
                                border: Border.all(
                                  color: AppColors.black,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  size: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.fontSize,
                                  color: AppColors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Play",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: AppColors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            DateFormat('yyyy').format(
                                              _parseDateStr(
                                                  widget.model.releaseDate),
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  color: AppColors.black
                                                      .withOpacity(0.7),
                                                ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Container(
                                              width: 3,
                                              height: 3,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.black
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "02h 30m",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  color: AppColors.black
                                                      .withOpacity(0.7),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      widget.model.overview,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.black
                                                .withOpacity(0.7),
                                          ),
                                      textAlign: TextAlign.justify,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                flex: 1,
                                child: SizedBox(
                                  width: 20,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Genres:',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                      color: AppColors.black
                                                          .withOpacity(0.3),
                                                    ),
                                              ),
                                              SizedBox(
                                                width:
                                                    ScreenUtil().screenWidth /
                                                        3,
                                                height: 20,
                                                child: Wrap(
                                                  runSpacing: 10,
                                                  spacing: 10,
                                                  children: genres.map((e) {
                                                    return InkWell(
                                                      onTap: () {},
                                                      child: Text(
                                                        e.name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                              color: AppColors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.7),
                                                            ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 20,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Cast:',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                            color: AppColors
                                                                .black
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {},
                                                      child: Text(
                                                        "See All >",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                              color: AppColors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    ScreenUtil().screenWidth /
                                                        2.5,
                                                child: Wrap(
                                                  runSpacing: 10,
                                                  spacing: 10,
                                                  children: casts.map((e) {
                                                    return InkWell(
                                                      onTap: () {},
                                                      child: Column(
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl:
                                                                e.profileUrl(),
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              height: 120,
                                                              width: 120,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                Shimmer
                                                                    .fromColors(
                                                              baseColor: AppColors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              highlightColor:
                                                                  AppColors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.5),
                                                              child: Container(
                                                                width: 130,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            e.name,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall!
                                                                .copyWith(
                                                                  color: AppColors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.7),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          videos!.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Videos',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (trailers!.isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 10,
                                                  ),
                                                  child: Text(
                                                    'Trailers',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                ),
                                                Wrap(
                                                  runSpacing: 10,
                                                  spacing: 10,
                                                  children: trailers!.map((e) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            ref
                                                                .read(
                                                                    appProvider)
                                                                .launchLink(
                                                                  'https://youtu.be/${e.key}',
                                                                );
                                                          },
                                                          child: Stack(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .center,
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl:
                                                                    "https://img.youtube.com/vi/${e.key}/0.jpg",
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          200),
                                                                  width: ScreenUtil()
                                                                          .screenWidth /
                                                                      4,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Shimmer
                                                                        .fromColors(
                                                                  baseColor: AppColors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  highlightColor:
                                                                      AppColors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.5),
                                                                  child:
                                                                      Container(
                                                                    width: size
                                                                        .width,
                                                                  ),
                                                                ),
                                                              ),
                                                              Image(
                                                                width:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            20),
                                                                height:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            20),
                                                                image:
                                                                    const AssetImage(
                                                                  "assets/icons/youtube_social_icon_red.png",
                                                                ),
                                                                fit: BoxFit
                                                                    .contain,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .high,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 10,
                                                          ),
                                                          child: Text(
                                                            e.name!,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    if (teasers!.isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 10,
                                                  ),
                                                  child: Text(
                                                    'Teasers',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                ),
                                                Wrap(
                                                  runSpacing: 10,
                                                  spacing: 10,
                                                  children: teasers!.map((e) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            ref
                                                                .read(
                                                                    appProvider)
                                                                .launchLink(
                                                                  'https://youtu.be/${e.key}',
                                                                );
                                                          },
                                                          child: Stack(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .center,
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl:
                                                                    "https://img.youtube.com/vi/${e.key}/0.jpg",
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          200),
                                                                  width: ScreenUtil()
                                                                          .screenWidth /
                                                                      4,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Shimmer
                                                                        .fromColors(
                                                                  baseColor: AppColors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  highlightColor:
                                                                      AppColors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.5),
                                                                  child:
                                                                      Container(
                                                                    width: size
                                                                        .width,
                                                                  ),
                                                                ),
                                                              ),
                                                              Image(
                                                                width:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            20),
                                                                height:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            20),
                                                                image:
                                                                    const AssetImage(
                                                                  "assets/icons/youtube_social_icon_red.png",
                                                                ),
                                                                fit: BoxFit
                                                                    .contain,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .high,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 10,
                                                          ),
                                                          child: Text(
                                                            e.name!,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    if (featurette!.isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 10,
                                                  ),
                                                  child: Text(
                                                    'Featurette',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                ),
                                                Wrap(
                                                  runSpacing: 10,
                                                  spacing: 10,
                                                  children:
                                                      featurette!.map((e) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            ref
                                                                .read(
                                                                    appProvider)
                                                                .launchLink(
                                                                  'https://youtu.be/${e.key}',
                                                                );
                                                          },
                                                          child: Stack(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .center,
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl:
                                                                    "https://img.youtube.com/vi/${e.key}/0.jpg",
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          200),
                                                                  width: ScreenUtil()
                                                                          .screenWidth /
                                                                      4,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Shimmer
                                                                        .fromColors(
                                                                  baseColor: AppColors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  highlightColor:
                                                                      AppColors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.5),
                                                                  child:
                                                                      Container(
                                                                    width: size
                                                                        .width,
                                                                  ),
                                                                ),
                                                              ),
                                                              Image(
                                                                width:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            20),
                                                                height:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            20),
                                                                image:
                                                                    const AssetImage(
                                                                  "assets/icons/youtube_social_icon_red.png",
                                                                ),
                                                                fit: BoxFit
                                                                    .contain,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .high,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 10,
                                                          ),
                                                          child: Text(
                                                            e.name!,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    if (behindTheScenes!.isNotEmpty)
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 10,
                                                  ),
                                                  child: Text(
                                                    'Behind The Scenes',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                ),
                                                Wrap(
                                                  runSpacing: 10,
                                                  spacing: 10,
                                                  children:
                                                      behindTheScenes!.map((e) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            ref
                                                                .read(
                                                                    appProvider)
                                                                .launchLink(
                                                                  'https://youtu.be/${e.key}',
                                                                );
                                                          },
                                                          child: Stack(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .center,
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl:
                                                                    "https://img.youtube.com/vi/${e.key}/0.jpg",
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          200),
                                                                  width: ScreenUtil()
                                                                          .screenWidth /
                                                                      4,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Shimmer
                                                                        .fromColors(
                                                                  baseColor: AppColors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  highlightColor:
                                                                      AppColors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.5),
                                                                  child:
                                                                      Container(
                                                                    width: size
                                                                        .width,
                                                                  ),
                                                                ),
                                                              ),
                                                              Image(
                                                                width:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            20),
                                                                height:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            20),
                                                                image:
                                                                    const AssetImage(
                                                                  "assets/icons/youtube_social_icon_red.png",
                                                                ),
                                                                fit: BoxFit
                                                                    .contain,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .high,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 10,
                                                          ),
                                                          child: Text(
                                                            e.name!,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    if (bloopers!.isNotEmpty)
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 10,
                                                  ),
                                                  child: Text(
                                                    'Bloopers',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                ),
                                                Wrap(
                                                  runSpacing: 10,
                                                  spacing: 10,
                                                  children: bloopers!.map((e) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            ref
                                                                .read(
                                                                    appProvider)
                                                                .launchLink(
                                                                  'https://youtu.be/${e.key}',
                                                                );
                                                          },
                                                          child: Stack(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .center,
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl:
                                                                    "https://img.youtube.com/vi/${e.key}/0.jpg",
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          200),
                                                                  width: ScreenUtil()
                                                                          .screenWidth /
                                                                      4,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Shimmer
                                                                        .fromColors(
                                                                  baseColor: AppColors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  highlightColor:
                                                                      AppColors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.5),
                                                                  child:
                                                                      Container(
                                                                    width: size
                                                                        .width,
                                                                  ),
                                                                ),
                                                              ),
                                                              Image(
                                                                width:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            20),
                                                                height:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            20),
                                                                image:
                                                                    const AssetImage(
                                                                  "assets/icons/youtube_social_icon_red.png",
                                                                ),
                                                                fit: BoxFit
                                                                    .contain,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .high,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 10,
                                                          ),
                                                          child: Text(
                                                            e.name!,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    if (clips!.isNotEmpty)
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 10,
                                                  ),
                                                  child: Text(
                                                    'Clips',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                ),
                                                Wrap(
                                                  runSpacing: 10,
                                                  spacing: 10,
                                                  children: clips!.map((e) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            ref
                                                                .read(
                                                                    appProvider)
                                                                .launchLink(
                                                                  'https://youtu.be/${e.key}',
                                                                );
                                                          },
                                                          child: Stack(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .center,
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl:
                                                                    "https://img.youtube.com/vi/${e.key}/0.jpg",
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          200),
                                                                  width: ScreenUtil()
                                                                          .screenWidth /
                                                                      4,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Shimmer
                                                                        .fromColors(
                                                                  baseColor: AppColors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  highlightColor:
                                                                      AppColors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.5),
                                                                  child:
                                                                      Container(
                                                                    width: size
                                                                        .width,
                                                                  ),
                                                                ),
                                                              ),
                                                              Image(
                                                                width:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            20),
                                                                height:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            20),
                                                                image:
                                                                    const AssetImage(
                                                                  "assets/icons/youtube_social_icon_red.png",
                                                                ),
                                                                fit: BoxFit
                                                                    .contain,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .high,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 10,
                                                          ),
                                                          child: Text(
                                                            e.name!,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    borderRadius: BorderRadius.circular(100),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.add,
                                            color: AppColors.white,
                                            size: Theme.of(context)
                                                .textTheme
                                                .headlineMedium!
                                                .fontSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "My List",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          color: AppColors.black,
                                        ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    borderRadius: BorderRadius.circular(100),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.share_outlined,
                                            color: AppColors.white,
                                            size: Theme.of(context)
                                                .textTheme
                                                .headlineMedium!
                                                .fontSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Share",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          color: AppColors.black,
                                        ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    borderRadius: BorderRadius.circular(100),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.download,
                                            color: AppColors.white,
                                            size: Theme.of(context)
                                                .textTheme
                                                .headlineMedium!
                                                .fontSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Download",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          color: AppColors.black,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    recommendList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 2,
                                  color: AppColors.primary,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 15,
                                  ),
                                  child: Text(
                                    "See more like this",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ),
                                Center(
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    alignment: WrapAlignment.center,
                                    children: recommendList.map((e) {
                                      return MovieCard(
                                        image: e.posterUrl(),
                                        mainExtend: false,
                                        width: ScreenUtil().screenWidth / 5,
                                        movieModel: e,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          context.pushNamed(
                                              DetailScreen.routeName,
                                              extra: e,
                                              queryParams: {
                                                'id': "${e.id}",
                                              });
                                          fetchData();
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(
                            height: 20,
                          ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.black,
                ),
                width: ScreenUtil().screenWidth,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About ${widget.model.title}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.white,
                                ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (crews.isNotEmpty)
                            RichText(
                              text: TextSpan(
                                text: 'Director: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: AppColors.white.withOpacity(0.3),
                                    ),
                                children: [
                                  WidgetSpan(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Text(
                                        crews[crews.indexWhere((element) =>
                                                element.job == 'Director')]
                                            .name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: AppColors.white
                                                  .withOpacity(0.8),
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Genres:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: AppColors.white.withOpacity(0.3),
                                    ),
                              ),
                              SizedBox(
                                width: ScreenUtil().screenWidth / 3,
                                height: 20,
                                child: Wrap(
                                  runSpacing: 10,
                                  spacing: 10,
                                  children: genres.map((e) {
                                    return InkWell(
                                      onTap: () {},
                                      child: Text(
                                        e.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: AppColors.white
                                                  .withOpacity(0.7),
                                            ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Text(
                                  'Cast:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: AppColors.white.withOpacity(0.3),
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().screenWidth / 2,
                                child: Wrap(
                                  spacing: 10,
                                  children: fullCasts.map((e) {
                                    return InkWell(
                                      onTap: () {},
                                      child: Text(
                                        e.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: AppColors.white
                                                  .withOpacity(0.7),
                                            ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
