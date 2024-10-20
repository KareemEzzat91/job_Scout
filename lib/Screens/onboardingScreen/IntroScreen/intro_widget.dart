import 'package:flutter/material.dart';

import '../../../Helpers/responsive/responsive.dart';
import '../../Login&SignUp/LoginScreen.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({
    super.key,
    required this.isout,
    required this.color,
    required this.title,
    required this.description,
    required this.skip,
    required this.image,
    required this.onTab,
    required this.index,
  });

  final bool isout;
  final String color;
  final String title;
  final String description;
  final bool skip;
  final String image;
  final VoidCallback onTab;
  final int index;

  double getTextSize(BuildContext context, double mobileSize, double tabletSize, double desktopSize) {
    if (Responsive.isExtraSmall(context)) {
      return mobileSize;
    } else if (Responsive.isMobile(context)) {
      return mobileSize + 6; // Adjust if needed
    } else if (Responsive.isMobileLarge(context)) {
      return mobileSize + 11; // Adjust if needed
    } else if (Responsive.isIpad(context) || Responsive.isTablet(context)) {
      return tabletSize;
    } else {
      return desktopSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return ColoredBox(
      color: hexToColor(color),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.5),
            child: SizedBox(
              width: width,
              height: height / 1.86,
              child: AnimatedScale(
                scale: isout ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: Image.asset(
                  image,
                  fit: index == 0 ? BoxFit.fitHeight : BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: height / 2.16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: index == 0 ? const Radius.circular(100) : const Radius.circular(0),
                  topRight: index == 2 ? const Radius.circular(100) : const Radius.circular(0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Stack(
                  children: [
                    const SizedBox(height: 62),
                    AnimatedPositioned(
                      left: isout
                          ? width + 100
                          : Responsive.isExtraSmall(context) ? width * 0.12 :
                      Responsive.isMobile(context) ? width * 0.08 :
                      Responsive.isMobileLarge(context) ? width * 0.02 :
                      Responsive.isIpad(context) ? width * 0.20 :
                      Responsive.isTablet(context) ? width * 0.11 :
                      Responsive.isLargeTablet(context) ? width * 0.18 : width * 0.23,
                      top: height * 0.06,
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: getTextSize(context, 18, 40, 60),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 250),
                      top: height * 0.12,
                      right: isout ? width + 100 : -40,
                      child: Container(
                        width: width,
                        child: Text(
                          description,
                          maxLines: 5,
                          style: TextStyle(
                            fontSize: getTextSize(context, 14, 32, 42),
                            height: 1.5,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: skip
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Skip ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getTextSize(context, 16, 30, 40),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onTab,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: hexToColor(color),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.arrow_circle_right,
                        color: Colors.white,
                        size: getTextSize(context, 30, 60, 80),
                      ),
                    ),
                  ),
                ],
              )
                  : SizedBox(
                height: 46,
                child: MaterialButton(
                  color: hexToColor(color),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child:  Text('Get Started', style: TextStyle(color: Colors.white,fontSize: getTextSize(context, 20, 30, 50),),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex));
  return Color(int.parse(hex.substring(1), radix: 16) + (hex.length == 7 ? 0xFF000000 : 0x00000000));
}
