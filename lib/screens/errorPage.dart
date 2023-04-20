import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/colors.dart';

class ErrorPage extends ConsumerStatefulWidget {
  static const routeName = '/errorPage';
  final String errorMessage;

  const ErrorPage({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ErrorPageState();
}

class _ErrorPageState extends ConsumerState<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Error",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: Theme.of(context).textTheme.displayMedium!.fontSize,
              color: AppColors.errorColor,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(),
            ),
            SizedBox(height: 10),
            Text(
              widget.errorMessage,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Do something when the button is pressed
              },
              child: Text(
                'Retry',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
