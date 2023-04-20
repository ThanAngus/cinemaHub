import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemahub/models/movieModel.dart';
import 'package:cinemahub/provider/repositoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../components/shimmerComponent.dart';
import '../models/dataModel.dart';
import '../utils/colors.dart';
import 'detailScreen.dart';

class SearchPage extends ConsumerStatefulWidget {
  static const routeName = '/searchPage';
  const SearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  String? searchTerm;
  bool tags = false;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          onPressed: () {
            setState(() {
              searchTerm = "";
              searchController.clear();
            });
            Navigator.of(context).pop();
          },
          splashRadius: 20,
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.black,
            size: ScreenUtil().setSp(18),
          ),
        ),
        title: Text(
          "Search",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: AppColors.black,
              ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: AppColors.errorColor,
                      width: 1,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: AppColors.errorColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (searchController.text != "")
                        IconButton(
                          onPressed: () {
                            if (searchController.text != "") {
                              setState(() {
                                searchController.clear();
                                searchTerm = "";
                              });
                            }
                          },
                          splashRadius: 20,
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.primary,
                            size: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                          ),
                        )
                      else
                        Container(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            searchTerm = searchController.text;
                          });
                        },
                        splashRadius: 20,
                        icon: Icon(
                          Icons.search,
                          color: AppColors.primary,
                          size: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .fontSize,
                        ),
                      ),
                    ],
                  ),
                  hintText: "Search...",
                  hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).dividerColor.withOpacity(0.5)),
                  labelText: "Search",
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                ),
                onChanged: (value) {
                  setState(() {
                    searchTerm = value;
                  });
                },
                showCursor: true,
                style: Theme.of(context).textTheme.titleMedium,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                textCapitalization: TextCapitalization.words,
              ),
            ),
            if(searchTerm != "" && searchTerm != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder(
                  future: ref.read(repositoryProvider).searchMovies(
                    searchTerm,
                    page: 1,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            Text(
                              "Results for $searchTerm",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    context.pushNamed(
                                      DetailScreen.routeName,
                                      extra: snapshot.data![index],
                                      queryParams: {
                                        'id': "${snapshot.data![index].id}",
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: snapshot.data![index].posterPath != null ? CachedNetworkImage(
                                            imageUrl:
                                            snapshot.data![index].posterUrl(),
                                            imageBuilder:
                                                (context, imageCache) {
                                              return SizedBox(
                                                width: ScreenUtil()
                                                    .setHeight(100),
                                                height: ScreenUtil()
                                                    .setHeight(100),
                                                child: Image(
                                                  image: imageCache,
                                                  filterQuality:
                                                  FilterQuality.medium,
                                                  fit: BoxFit.contain,
                                                ),
                                              );
                                            },
                                            progressIndicatorBuilder:
                                                (context, _, progress) {
                                              return ShimmerComponent(
                                                child: SizedBox(
                                                  width: ScreenUtil()
                                                      .setHeight(30),
                                                  height: ScreenUtil()
                                                      .setHeight(30),
                                                ),
                                              );
                                            },
                                          ) : SizedBox(
                                            width: ScreenUtil()
                                                .setHeight(100),
                                            height: ScreenUtil()
                                                .setHeight(100),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(10),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data![index].title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                  fontWeight:
                                                  FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                snapshot.data![index].originalTitle,
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                  fontWeight:
                                                  FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 40,
                          ),
                          child: Center(
                            child: Text(
                              "No Search Result Found...",
                              style:
                              Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        );
                      }
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 40,
                        ),
                        child: Center(
                          child: Text(
                            "No Search Result Found...",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
