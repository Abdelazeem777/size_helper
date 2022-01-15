class BreakPoint {
  const BreakPoint._(this.name, this.value);

  final String name;
  final double value;

  static const mobileSmall = BreakPoint._('mobileSmall', 375.0);
  static const mobileNormal = BreakPoint._('mobileNormal', 410.0);
  static const mobileLarge = BreakPoint._('mobileLarge', 450.0);
  static const mobileExtraLarge = BreakPoint._('mobileExtraLarge', 550.0);
  static const tabletSmall = BreakPoint._('tabletSmall', 650.0);
  static const tabletNormal = BreakPoint._('tabletNormal', 780.0);
  static const tabletLarge = BreakPoint._('tabletLarge', 880.0);
  static const tabletExtraLarge = BreakPoint._('tabletExtraLarge', 1180.0);
  static const desktopSmall = BreakPoint._('desktopSmall', 1270.0);
  static const desktopNormal = BreakPoint._('desktopNormal', 1780.0);
  static const desktopLarge = BreakPoint._('desktopLarge', 3540.0);
  static const desktopExtraLarge = BreakPoint._('desktopExtraLarge', 4096.0);

  static List<BreakPoint> get values => [
        mobileSmall,
        mobileNormal,
        mobileLarge,
        mobileExtraLarge,
        tabletSmall,
        tabletNormal,
        tabletLarge,
        tabletExtraLarge,
        desktopSmall,
        desktopNormal,
        desktopLarge,
        desktopExtraLarge,
      ];
}
