import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({
    Key? key,
    required this.desktop,
    this.tablet,
    this.mobileLarge,
    required this.mobile,
  }) : super(key: key);

  final Widget desktop;
  final Widget? tablet;
  final Widget? mobileLarge;
  final Widget mobile;

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static bool isLargeTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024 && MediaQuery.of(context).size.width < 1280;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1024; // Adjusted for iPad
  }
  static bool isIpad(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1024; // Adjusted for iPad
  }

  static bool isMobileLarge(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 768;
  }

  static bool isMedium(BuildContext context) {
    return MediaQuery.of(context).size.width >= 450 && MediaQuery.of(context).size.width < 600;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 450;
  }

  static bool isExtraSmall(BuildContext context) {
    return MediaQuery.of(context).size.width < 375; // Define your criteria for extra small devices
  }
  static double TextSize(context,{required double isExtraSmallSize , required double isMobileSize,required double isMobileLarge,required double isIpadSize,required double isTabletSize,required double isLargeTabletSize,required double defaultSize} ){ return Responsive.isExtraSmall(context) ? isExtraSmallSize :
  Responsive.isMobile(context) ?isMobileSize:
  Responsive.isMobileLarge(context) ? isMobileLarge:
  Responsive.isIpad(context) ? isIpadSize:
  Responsive.isTablet(context) ? isTabletSize :
  Responsive.isLargeTablet(context) ? isLargeTabletSize : isLargeTabletSize;}

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width >= 1024) {
      return desktop;
    } else if (_size.width >= 700 && tablet != null) {
      return tablet!;
    } else if (_size.width >= 450 && mobileLarge != null) {
      return mobileLarge!;
    } else {
      return mobile;
    }
  }
}

enum DeviceType {
  Mobile,
  Tablet,  // Corrected typo
  Desktop,
}

DeviceType getDeviceType(MediaQueryData mediaQueryData) {
  double width = mediaQueryData.size.width;

  if (width >= 950) {
    return DeviceType.Desktop;
  } else if (width >= 600) {
    return DeviceType.Tablet;
  } else {
    return DeviceType.Mobile;
  }
}
