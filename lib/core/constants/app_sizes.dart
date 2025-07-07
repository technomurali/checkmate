class AppSizes with AppLogoSize, AppTextLimiter {}

mixin AppLogoSize {
  final double height = 59;
  final double width = 48;
}

mixin AppTextLimiter {
  final double dashboardCardTextLimiter = 200;
  final int eventDescriptionMinLines = 3;
}
