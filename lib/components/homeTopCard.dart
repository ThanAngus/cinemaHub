import 'dart:async';

import 'package:cinemahub/components/shimmerComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../models/movieModel.dart';
import '../utils/colors.dart';
import 'homeHeroCard.dart';

class HomeTopCard extends StatefulWidget {
  final List<MovieModel> movies;
  final double height;

  const HomeTopCard({
    Key? key,
    required this.height,
    required this.movies,
  }) : super(key: key);

  @override
  State<HomeTopCard> createState() => _HomeTopCardState();
}

class _HomeTopCardState extends State<HomeTopCard> {
  late PageController _controller;
  Timer? timer;
  int pageIndex = 0;

  @override
  void initState() {
    _controller = PageController(
      initialPage: pageIndex,
    );
    animatedSlider();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void animatedSlider(){
    timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if(widget.movies.length == pageIndex + 1){
        if(_controller.hasClients) {
          _controller.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
        }
      }else {
        if(_controller.hasClients){
          _controller.animateToPage(pageIndex + 1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: widget.movies.isNotEmpty
          ? PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.movies.length,
              controller: _controller,
              onPageChanged: (index){
                setState(() {
                  pageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return HomeHeroCard(
                  model: widget.movies[index],
                );
              },
            )
          : ShimmerComponent(
        child: SizedBox(
          height: widget.height,
          width: ScreenUtil().screenWidth,
        ),
      ),
    );
  }
}
