class AppSizes with AppLogoSize, AppTextLimiter, HeaderSizes {}

mixin AppLogoSize {
  final double height = 59;
  final double width = 48;
}

mixin AppTextLimiter {
  final double dashboardCardTextLimiter = 200;
  final int eventDescriptionMinLines = 3;
}

mixin HeaderSizes {
  final double headerHeight = 90;
  final double headerIconSize = 36;
}