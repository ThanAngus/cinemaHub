import 'package:cinemahub/utils/responsiveLayout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

import '../utils/colors.dart';
import '../utils/styles.dart';

class OnBoardingPage extends ConsumerStatefulWidget {
  static const routeName = '/onBoardingPage';

  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends ConsumerState<OnBoardingPage> {
  final key = GlobalKey<FormState>();
  late ScrollController _scrollController;
  late PageController _controller;
  int pageIndex = 0;
  late String email;
  late bool emailUsed;

  @override
  void initState() {
    _controller = PageController(
      initialPage: pageIndex,
    );
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ResponsiveLayout(
      mobileScreen: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.black.withOpacity(0.3),
          centerTitle: false,
          title: Text(
            "CINEMAHUB",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {},
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "SIGN IN",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                physics: const ClampingScrollPhysics(),
                onPageChanged: (value) {
                  setState(() {
                    pageIndex = value;
                  });
                },
                controller: _controller,
                children: [
                  Stack(
                    children: [
                      ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black, Colors.transparent],
                          ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height),
                          );
                        },
                        blendMode: BlendMode.dstIn,
                        child: Container(
                          height: size.height / 2,
                          width: size.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/onboardImage.jpg",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(50),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Unlimited entertainment, One low price",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "All of CinemaHub, starting at just \$10.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                        color: AppColors.black
                                            .withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: ScreenUtil().setHeight(250),
                                    width: ScreenUtil().screenWidth / 2.5,
                                    child: const Image(
                                      image: AssetImage(
                                        "assets/images/movies/movies7.jpeg",
                                      ),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(250),
                                    width: ScreenUtil().screenWidth / 2.5,
                                    child: const Image(
                                      image: AssetImage(
                                        "assets/images/movies/movies9.jpeg",
                                      ),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              height: ScreenUtil().setHeight(280),
                              width: ScreenUtil().setWidth(220),
                              child: const Image(
                                image: AssetImage(
                                  "assets/images/movies/movies8.jpeg",
                                ),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(50),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Download and\nwatch offline",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Something for your offline time",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                      color: AppColors.black
                                          .withOpacity(0.7),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Positioned.fill(
                            child: Icon(
                              FontAwesomeIcons.fileContract,
                              color: AppColors.black,
                              size: ScreenUtil().setSp(100),
                            ),
                          ),
                          Icon(
                            FontAwesomeIcons.ban,
                            color: AppColors.primary,
                            size: ScreenUtil().setSp(200),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(50),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "No annoying commitment",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Join and cancel anytime.",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                      color: AppColors.black
                                          .withOpacity(0.7),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StaticComponent.heightSizedBox(10),
            SizedBox(
              height: 15,
              child: ListView.separated(
                itemCount: 3,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pageIndex == index
                          ? AppColors.black
                          : AppColors.black.withOpacity(0.5),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 10,
                  );
                },
              ),
            ),
            StaticComponent.heightSizedBox(20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return Material(
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                color: AppColors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              size: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .fontSize,
                                              color: AppColors.black
                                                  .withOpacity(0.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    StaticComponent.heightSizedBox(20),
                                    Text(
                                      "Create your account now",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    StaticComponent.heightSizedBox(10),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        "Enter your email to create or sign in to your account",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    StaticComponent.heightSizedBox(10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Form(
                                        key: key,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Email is required";
                                            } else {
                                              bool emailValid = RegExp(
                                                  r'^.+@[a-zA-Z]+\.[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                                  .hasMatch(value);

                                              if (emailValid) {
                                                setState(() {
                                                  email = value;
                                                });
                                              } else {
                                                return "Invalid Email";
                                              }
                                              return null;
                                            }
                                          },
                                          textInputAction:
                                          TextInputAction.done,
                                          keyboardType:
                                          TextInputType.emailAddress,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            enabledBorder:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .blueGrey.shade800,
                                                width: 0.5,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                color: Colors.red.shade800,
                                                width: 0.5,
                                              ),
                                            ),
                                            focusedBorder:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .blueGrey.shade800,
                                                width: 0.5,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .blueGrey.shade800,
                                                width: 0.5,
                                              ),
                                            ),
                                            labelText: "Email",
                                          ),
                                          cursorColor: AppColors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          width: size.width,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0),
                                              child: Text(
                                                "GET STARTED",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                  color:
                                                  AppColors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: size.width,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "GET STARTED",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StaticComponent.heightSizedBox(20),
          ],
        ),
      ),
      webScreen: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "CINEMAHUB",
                    style:
                    Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      fontSize: ScreenUtil().setSp(12),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.primary,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(
                          "SIGN IN",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                            color: AppColors.white,
                            fontSize: ScreenUtil().setSp(5),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              StaticComponent.heightSizedBox(20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 5,
                    color: AppColors.grey.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height),
                        );
                      },
                      blendMode: BlendMode.dstIn,
                      child: Container(
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().screenHeight / 1.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage(
                              "assets/images/onboardImage.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(30),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width : ScreenUtil().screenWidth/2,
                                  child: Text(
                                    "Unlimited movies, TV shows and more",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                      fontSize: ScreenUtil().setSp(22),
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Watch, Sign up and Cancel Anytime",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Email is required";
                                      } else {
                                        bool emailValid = RegExp(
                                            r'^.+@[a-zA-Z]+\.[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                            .hasMatch(value);

                                        if (emailValid) {
                                          setState(() {
                                            email = value;
                                          });
                                        } else {
                                          return "Invalid Email";
                                        }
                                        return null;
                                      }
                                    },
                                    textInputAction: TextInputAction.done,
                                    keyboardType:
                                    TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                      AppColors.black.withOpacity(0.1),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                          color: AppColors.primary,
                                          width: 1,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Colors.red.shade800,
                                          width: 0.5,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                          color: AppColors.primary,
                                          width: 0.5,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                          color: AppColors.primary,
                                          width: 0.5,
                                        ),
                                      ),
                                      labelText: "Email",
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                        color: AppColors.white,
                                        fontSize: ScreenUtil().setSp(5),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal:
                                        ScreenUtil().setWidth(10),
                                        vertical:
                                        ScreenUtil().setHeight(15),
                                      ),
                                    ),
                                    cursorColor: AppColors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      color: AppColors.primary,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(10),
                                      vertical: ScreenUtil().setHeight(15),
                                    ),
                                    child: Text(
                                      "Get Started >",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                        color: AppColors.white,
                                        fontSize: ScreenUtil().setSp(5),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }
}
