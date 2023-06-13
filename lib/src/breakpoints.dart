class BreakPoint {
  const BreakPoint._(this.name, this.value);

  final String name;
  final double value;

  static const mobileSmall = BreakPoint._('mobileSmall', 275.0);
  static const mobileNormal = BreakPoint._('mobileNormal', 325.0);
  static const mobileLarge = BreakPoint._('mobileLarge', 350.0);
  static const mobileExtraLarge = BreakPoint._('mobileExtraLarge', 375.0);
  static const tabletSmall = BreakPoint._('tabletSmall', 400.0);
  static const tabletNormal = BreakPoint._('tabletNormal', 400.0);
  static const tabletLarge = BreakPoint._('tabletLarge', 450.0);
  static const tabletExtraLarge = BreakPoint._('tabletExtraLarge', 600.0);
  static const desktopSmall = BreakPoint._('desktopSmall', 950.0);
  static const desktopNormal = BreakPoint._('desktopNormal', 1150.0);
  static const desktopLarge = BreakPoint._('desktopLarge', 1500.0);
  static const desktopExtraLarge = BreakPoint._('desktopExtraLarge', 1800.0);

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
