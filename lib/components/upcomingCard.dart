import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemahub/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../models/movieModel.dart';

class UpcomingCard extends StatelessWidget {
  final MovieModel model;

  const UpcomingCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  String releaseDate(String inputString) {
    DateTime dateTime = DateTime.parse(inputString);
    return DateFormat('dd').format(dateTime);
  }

  String releaseMonth(String inputString) {
    DateTime dateTime = DateTime.parse(inputString);
    return DateFormat(DateFormat.MONTH).format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Text(
                releaseMonth(model.releaseDate).substring(0,3),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.black,
                ),
              ),
              Text(
                releaseDate(model.releaseDate),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 150,
                  child: CachedNetworkImage(
                    imageUrl: model.backdropUrl(),
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
                        height: 150,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Coming on ${releaseDate(model.releaseDate)} ${releaseMonth(model.releaseDate)}",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      model.overview,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
