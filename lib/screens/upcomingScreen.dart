import 'package:cinemahub/provider/repositoryProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/movieModel.dart';
import '../components/shimmerComponent.dart';
import '../components/upcomingCard.dart';
import '../models/dataModel.dart';
import '../utils/colors.dart';

class UpcomingScreen extends ConsumerWidget {
  const UpcomingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body : SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: ref.watch(repositoryProvider).getMovies(DataModel(
              movies: [],
              page: 1,
              searchCategory: "upcoming",
              searchText: '',
            ),),
            builder: (context, snapshot){
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
                      padding: const EdgeInsets.all(10.0),
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
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
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
                                          4,
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
                                          4,
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
                                          4,
                                      height: 180,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  List<MovieModel> movieList = snapshot.data!.map((e) => e).toList();
                  movieList.sort((a,b) => a.releaseDate.compareTo(b.releaseDate));
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        child: Text(
                          "Discover",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: movieList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return UpcomingCard(
                            model: movieList[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 20,
                          );
                        },
                      ),
                    ],
                  );
                }
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
