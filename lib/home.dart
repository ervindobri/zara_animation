import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class ZaraHome extends StatefulWidget {
  const ZaraHome({Key? key}) : super(key: key);

  @override
  State<ZaraHome> createState() => _ZaraHomeState();
}

class _ZaraHomeState extends State<ZaraHome> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final icons = [
      const Icon(LineIcons.home, color: Colors.white),
      const Icon(CupertinoIcons.search, color: Colors.white),
      Text(
        "MENU",
        style: GoogleFonts.lato().copyWith(
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
      const Icon(LineIcons.user, color: Colors.white),
      const Icon(LineIcons.shoppingBag, color: Colors.white),
    ];
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: false,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            SizedBox(
              height: height,
              child: CubePageView(
                scrollDirection: Axis.vertical,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                children: List.generate(
                  5,
                  (index) => Image.asset(
                    "assets/${index + 1}.jpeg",
                    height: height,
                    width: width,
                    fit: BoxFit.cover,
                    cacheHeight: height.toInt(),
                    // cacheWidth: width.toInt(),
                  ),
                ).toList(),
              ),
            ),
            Positioned(
              bottom: 128,
              left: 48,
              right: 48,
              child: AnimatedSwitcher(
                duration: kThemeAnimationDuration,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  [
                    "MATCHING OUTFITS",
                    "WOMEN'S CASUAL",
                    "CLASSY ELEGANCE",
                    "MENS BUSINESS",
                    "ON THE STREETS"
                  ][_currentPage],
                  key: Key(_currentPage.toString()),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito().copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                    letterSpacing: 10,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 48,
              left: 48,
              child: Text(
                "ZARA",
                style: GoogleFonts.elsie().copyWith(
                  color: _currentPage == 0 || _currentPage == 4
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 94,
                ),
              ),
            ),
            Positioned(
              top: 128,
              right: 20,
              child: Text(
                "STORES",
                style: GoogleFonts.lato().copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: 0,
        items: List.generate(
          5,
          (index) => BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: icons[index],
            label: "• ",
          ),
        ),
      ),
    );
  }
}
