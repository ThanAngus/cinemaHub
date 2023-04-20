import 'package:cinemahub/components/loadingCard.dart';
import 'package:cinemahub/provider/repositoryProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../components/movieCard.dart';
import '../models/movieModel.dart';
import '../utils/colors.dart';

class GenrePage extends ConsumerStatefulWidget {
  static const routeName = '/genrePage';

  final String genre;

  const GenrePage({
    Key? key,
    required this.genre,
  }) : super(key: key);

  @override
  ConsumerState createState() => _GenrePageState();
}

class _GenrePageState extends ConsumerState<GenrePage> {
  List<MovieModel> genreMovieList = [];
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  List<Widget> movieList = [];
  bool loading = false;

  @override
  void initState() {
    fetchList();
    _scrollController.addListener(() {
      if(_scrollController.position.atEdge){
        bool isTop = _scrollController.position.pixels == 0;
        if(!isTop){
          setState(() {
            loading = true;
            page++;
            fetchList();
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void fetchList() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      List<MovieModel>? list = await ref.read(repositoryProvider).getGenreMovies(
                widget.genre,
                'discover/movie',
                page,
              );
      for (MovieModel e in list!) {
        setState(() {
          genreMovieList.add(e);
          movieList.add(
            MovieCard(
              width: ScreenUtil().screenWidth/3.5,
              image: e.posterUrl(),
              mainExtend: true,
              movieModel: e,
            ),
          );
          loading = false;
        });
      }
      if (loading == true) {
        for (Widget w in loadingList) {
          setState(() {
            movieList.add(w);
          });
        }
      } else {
        setState(() {
          movieList.removeWhere(
                (element) => element == const LoadingCard(),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          widget.genre,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: Wrap(
            children: movieList,
          ),
        ),
      ),
    );
  }
}
