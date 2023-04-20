import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemahub/models/genreModel.dart';
import 'package:cinemahub/services/responsive.dart';
import 'package:cinemahub/utils/responsiveLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../models/movieModel.dart';
import '../provider/repositoryProvider.dart';
import '../screens/detailScreen.dart';
import '../utils/colors.dart';

class HomeHeroCard extends ConsumerStatefulWidget {
  final MovieModel model;

  const HomeHeroCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  ConsumerState<HomeHeroCard> createState() => _HomeHeroCardState();
}

class _HomeHeroCardState extends ConsumerState<HomeHeroCard> {
  List<Genre> genres = [];

  @override
  void initState() {
    fetchGenre();
    super.initState();
  }

  void fetchGenre() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref
          .read(repositoryProvider)
          .fetchGenres(widget.model.genreId)
          .then((value) {
        setState(() {
          genres = value!;
        });
      });
    });
  }

  DateTime _parseDateStr(String inputString) {
    DateFormat format = DateFormat.y();
    return format.parse(inputString);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ResponsiveLayout(
      mobileScreen: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.transparent],
              ).createShader(
                Rect.fromLTRB(0, 0, rect.width, rect.height),
              );
            },
            blendMode: BlendMode.dstATop,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: CachedNetworkImage(
                imageUrl: widget.model.posterUrl(),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      alignment: AlignmentDirectional.bottomCenter,
                    ),
                  ),
                ),
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.white,
                  highlightColor: AppColors.white,
                  child: Container(
                    width: 130,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    height: 30,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                        return Text(
                          genres[index].name,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        );
                      },
                      separatorBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                            left: 10,
                            right: 10,
                          ),
                          child: Container(
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.black.withOpacity(0.5),
                            ),
                          ),
                        );
                      },
                      itemCount: genres.length < 3 ? genres.length : 3,
                      shrinkWrap: true,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        context.pushNamed(
                            DetailScreen.routeName,
                            extra: widget.model,
                            queryParams: {
                              'id' : "${widget.model.id}",
                            }
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.primary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.play_arrow,
                                color: AppColors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "View Details",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              elevation: 10,
                              useRootNavigator: true,
                              backgroundColor: AppColors.black,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                              ),
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                      return Wrap(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 20,
                                              bottom: 40,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Card(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                      ),
                                                      margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                      ),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                        ),
                                                        height: 180,
                                                        width: 120,
                                                        child: CachedNetworkImage(
                                                          imageUrl: widget.model
                                                              .posterUrl(),
                                                          imageBuilder: (context,
                                                              imageProvider) =>
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(10),
                                                                  image: DecorationImage(
                                                                    image: imageProvider,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ),
                                                          placeholder:
                                                              (context, url) =>
                                                              Shimmer.fromColors(
                                                                baseColor: AppColors.black
                                                                    .withOpacity(0.5),
                                                                highlightColor: AppColors
                                                                    .white
                                                                    .withOpacity(0.5),
                                                                child: Container(
                                                                  width: 130,
                                                                ),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      widget.model
                                                                          .title,
                                                                      style: Theme.of(
                                                                          context)
                                                                          .textTheme
                                                                          .titleLarge!
                                                                          .copyWith(
                                                                        color: AppColors
                                                                            .white,
                                                                      ),
                                                                      maxLines: 2,
                                                                      overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        100),
                                                                    child: Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                      Container(
                                                                        decoration:
                                                                        BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: AppColors
                                                                              .white
                                                                              .withOpacity(
                                                                              0.2),
                                                                        ),
                                                                        child:
                                                                        Padding(
                                                                          padding:
                                                                          const EdgeInsets.all(
                                                                              5.0),
                                                                          child: Icon(
                                                                            Icons
                                                                                .close,
                                                                            color: AppColors
                                                                                .white,
                                                                            size: Theme.of(
                                                                                context)
                                                                                .textTheme
                                                                                .headlineSmall!
                                                                                .fontSize,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    DateFormat('yyyy')
                                                                        .format(
                                                                      _parseDateStr(
                                                                        widget.model
                                                                            .releaseDate,
                                                                      ),
                                                                    ),
                                                                    style: Theme.of(
                                                                        context)
                                                                        .textTheme
                                                                        .titleSmall!
                                                                        .copyWith(
                                                                      color: AppColors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                              right: 10,
                                                              top: 10,
                                                            ),
                                                            child: Text(
                                                              widget.model.overview,
                                                              maxLines: 4,
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                color: AppColors
                                                                    .white,
                                                              ),
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              textAlign:
                                                              TextAlign.start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {},
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                            child: Icon(
                                                              Icons.play_circle,
                                                              color: AppColors.white,
                                                              size: Theme.of(context)
                                                                  .textTheme
                                                                  .displayMedium!
                                                                  .fontSize,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Play",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .labelLarge!
                                                              .copyWith(
                                                            color:
                                                            AppColors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pop(context);
                                                          },
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                            child: Container(
                                                              decoration:
                                                              BoxDecoration(
                                                                shape:
                                                                BoxShape.circle,
                                                                color: AppColors.white
                                                                    .withOpacity(0.1),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                                child: Icon(
                                                                  Icons.download,
                                                                  color:
                                                                  AppColors.white,
                                                                  size: Theme.of(
                                                                      context)
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
                                                            color:
                                                            AppColors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {},
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                            child: Container(
                                                              decoration:
                                                              BoxDecoration(
                                                                shape:
                                                                BoxShape.circle,
                                                                color: AppColors.white
                                                                    .withOpacity(0.1),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color:
                                                                  AppColors.white,
                                                                  size: Theme.of(
                                                                      context)
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
                                                            color:
                                                            AppColors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pop(context);
                                                          },
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                            child: Container(
                                                              decoration:
                                                              BoxDecoration(
                                                                shape:
                                                                BoxShape.circle,
                                                                color: AppColors.white
                                                                    .withOpacity(0.1),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .share_outlined,
                                                                  color:
                                                                  AppColors.white,
                                                                  size: Theme.of(
                                                                      context)
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
                                                            color:
                                                            AppColors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 10,
                                                  ),
                                                  child: Divider(
                                                    color: AppColors.white
                                                        .withOpacity(0.1),
                                                    height: 1,
                                                    thickness: 1,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.info_outline,
                                                              size: Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .fontSize,
                                                              color: AppColors.white,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "Details & More",
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                color: AppColors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Icon(
                                                          Icons.chevron_right,
                                                          size: Theme.of(context)
                                                              .textTheme
                                                              .titleLarge!
                                                              .fontSize,
                                                          color: AppColors.white,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(100),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white.withOpacity(0.1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.info_outline,
                                  color: AppColors.black,
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
                          "Info",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
        ],
      ),
      webScreen: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.transparent],
              ).createShader(
                Rect.fromLTRB(0, 0, rect.width, rect.height),
              );
            },
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: CachedNetworkImage(
                imageUrl: widget.model.backdropUrl(),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      alignment: AlignmentDirectional.bottomCenter,
                    ),
                  ),
                ),
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.white,
                  highlightColor: AppColors.white,
                  child: Container(
                    width: 130,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 50,
            bottom: 0,
            top: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.model.title,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: SizedBox(
                    width: ScreenUtil().screenWidth/3,
                    child: Text(
                      widget.model.overview,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.white,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: 30,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                        return Text(
                          genres[index].name,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                          ),
                        );
                      },
                      separatorBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                            left: 10,
                            right: 10,
                          ),
                          child: Container(
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withOpacity(0.5),
                            ),
                          ),
                        );
                      },
                      itemCount: genres.length < 3 ? genres.length : 3,
                      shrinkWrap: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        context.pushNamed(
                            DetailScreen.routeName,
                            extra: widget.model,
                            queryParams: {
                              'id' : "${widget.model.id}",
                            }
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.primary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.play_arrow,
                                color: AppColors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "View Details",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          elevation: 10,
                          useRootNavigator: true,
                          backgroundColor: AppColors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                                  return Wrap(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20,
                                          bottom: 40,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                  ),
                                                  margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                    ),
                                                    height: 180,
                                                    width: 120,
                                                    child: CachedNetworkImage(
                                                      imageUrl: widget.model
                                                          .posterUrl(),
                                                      imageBuilder: (context,
                                                          imageProvider) =>
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                              image: DecorationImage(
                                                                image: imageProvider,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                      placeholder:
                                                          (context, url) =>
                                                          Shimmer.fromColors(
                                                            baseColor: AppColors.black
                                                                .withOpacity(0.5),
                                                            highlightColor: AppColors
                                                                .white
                                                                .withOpacity(0.5),
                                                            child: Container(
                                                              width: 130,
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  widget.model
                                                                      .title,
                                                                  style: Theme.of(
                                                                      context)
                                                                      .textTheme
                                                                      .titleLarge!
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .white,
                                                                  ),
                                                                  maxLines: 2,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    100),
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      8.0),
                                                                  child:
                                                                  Container(
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: AppColors
                                                                          .white
                                                                          .withOpacity(
                                                                          0.2),
                                                                    ),
                                                                    child:
                                                                    Padding(
                                                                      padding:
                                                                      const EdgeInsets.all(
                                                                          5.0),
                                                                      child: Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: AppColors
                                                                            .white,
                                                                        size: Theme.of(
                                                                            context)
                                                                            .textTheme
                                                                            .headlineSmall!
                                                                            .fontSize,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                DateFormat('yyyy')
                                                                    .format(
                                                                  _parseDateStr(
                                                                    widget.model
                                                                        .releaseDate,
                                                                  ),
                                                                ),
                                                                style: Theme.of(
                                                                    context)
                                                                    .textTheme
                                                                    .titleSmall!
                                                                    .copyWith(
                                                                  color: AppColors
                                                                      .white,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                          right: 10,
                                                          top: 10,
                                                        ),
                                                        child: Text(
                                                          widget.model.overview,
                                                          maxLines: 4,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                            color: AppColors
                                                                .white,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                          TextAlign.start,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                        child: Icon(
                                                          Icons.play_circle,
                                                          color: AppColors.white,
                                                          size: Theme.of(context)
                                                              .textTheme
                                                              .displayMedium!
                                                              .fontSize,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "Play",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge!
                                                          .copyWith(
                                                        color:
                                                        AppColors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                        child: Container(
                                                          decoration:
                                                          BoxDecoration(
                                                            shape:
                                                            BoxShape.circle,
                                                            color: AppColors.white
                                                                .withOpacity(0.1),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                            child: Icon(
                                                              Icons.download,
                                                              color:
                                                              AppColors.white,
                                                              size: Theme.of(
                                                                  context)
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
                                                        color:
                                                        AppColors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                        child: Container(
                                                          decoration:
                                                          BoxDecoration(
                                                            shape:
                                                            BoxShape.circle,
                                                            color: AppColors.white
                                                                .withOpacity(0.1),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                            child: Icon(
                                                              Icons.add,
                                                              color:
                                                              AppColors.white,
                                                              size: Theme.of(
                                                                  context)
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
                                                        color:
                                                        AppColors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                        child: Container(
                                                          decoration:
                                                          BoxDecoration(
                                                            shape:
                                                            BoxShape.circle,
                                                            color: AppColors.white
                                                                .withOpacity(0.1),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                            child: Icon(
                                                              Icons
                                                                  .share_outlined,
                                                              color:
                                                              AppColors.white,
                                                              size: Theme.of(
                                                                  context)
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
                                                        color:
                                                        AppColors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Divider(
                                                color: AppColors.white
                                                    .withOpacity(0.1),
                                                height: 1,
                                                thickness: 1,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.info_outline,
                                                          size: Theme.of(context)
                                                              .textTheme
                                                              .titleLarge!
                                                              .fontSize,
                                                          color: AppColors.white,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "Details & More",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                            color: AppColors
                                                                .white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Icon(
                                                      Icons.chevron_right,
                                                      size: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .fontSize,
                                                      color: AppColors.white,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.white.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info,
                                color: AppColors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "More Info",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
