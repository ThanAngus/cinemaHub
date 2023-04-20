import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemahub/screens/detailScreen.dart';
import 'package:cinemahub/utils/responsiveLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../models/movieModel.dart';
import '../utils/colors.dart';

class MovieCard extends StatefulWidget {
  final bool mainExtend;
  final bool isWatched;
  final String image;
  final MovieModel? movieModel;
  final VoidCallback? onPressed;
  final double width;

  const MovieCard({
    Key? key,
    required this.image,
    required this.width,
    this.isWatched = false,
    this.movieModel,
    required this.mainExtend,
    this.onPressed,
  }) : super(key: key);

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  late bool isAddedToList;

  @override
  void initState() {
    super.initState();
  }

  DateTime _parseDateStr(String inputString) {
    DateFormat format = DateFormat.y();
    return format.parse(inputString);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScreen: InkWell(
        onTap: widget.mainExtend
            ? () {
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
                    return StatefulBuilder(builder: (context, setState) {
                      return Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 40,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: 180,
                                        width: 120,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              widget.movieModel!.posterUrl(),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: AppColors.black
                                                .withOpacity(0.5),
                                            highlightColor: AppColors.white
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
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      widget.movieModel!.title,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            color:
                                                                AppColors.white,
                                                          ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
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
                                                              .withOpacity(0.2),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Icon(
                                                            Icons.close,
                                                            color:
                                                                AppColors.white,
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
                                                    DateFormat('yyyy').format(
                                                      _parseDateStr(
                                                        widget.movieModel!
                                                            .releaseDate,
                                                      ),
                                                    ),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          color:
                                                              AppColors.white,
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
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                              top: 10,
                                            ),
                                            child: Text(
                                              widget.movieModel!.overview,
                                              maxLines: 4,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    color: AppColors.white,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
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
                                              BorderRadius.circular(100),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                                color: AppColors.white,
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
                                              BorderRadius.circular(100),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.white
                                                    .withOpacity(0.1),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                                                color: AppColors.white,
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
                                              BorderRadius.circular(100),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.white
                                                    .withOpacity(0.1),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                                                color: AppColors.white,
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
                                              BorderRadius.circular(100),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.white
                                                    .withOpacity(0.1),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                                                color: AppColors.white,
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
                                    color: AppColors.white.withOpacity(0.1),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    context.pushNamed(DetailScreen.routeName,
                                        extra: widget.movieModel,
                                        queryParams: {
                                          'id': "${widget.movieModel!.id}",
                                        });
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                    color: AppColors.white,
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
              }
            : widget.onPressed,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            width: widget.width,
            height: 180,
            child: CachedNetworkImage(
              imageUrl: widget.image,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.black.withOpacity(0.5),
                highlightColor: AppColors.white.withOpacity(0.5),
                child: Container(
                  width: 130,
                ),
              ),
            ),
          ),
        ),
      ),
      webScreen: InkWell(
        onTap: widget.mainExtend
            ? () {
                context.pushNamed(
                  DetailScreen.routeName,
                  extra: widget.movieModel,
                  queryParams: {
                    'id': "${widget.movieModel!.id}",
                  },
                );
              }
            : widget.onPressed,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            width: widget.width,
            height: 400,
            child: CachedNetworkImage(
              imageUrl: widget.image,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.black.withOpacity(0.5),
                highlightColor: AppColors.white.withOpacity(0.5),
                child: Container(
                  width: 130,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
