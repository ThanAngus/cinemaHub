import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarkPage extends ConsumerStatefulWidget {
  const BookmarkPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends ConsumerState<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Bookmark page\nComing soon",
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
