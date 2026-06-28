/// How spending trends are compared on the Insights screen.
enum TrendsComparisonMode {
  currentVsPreviousCycle('This month vs last'),
  currentVsPreviousCalendarMonth('This month vs calendar month'),
  lastSixCycles('Last 6 months'),
  lastTwelveCycles('Last 12 months');

  const TrendsComparisonMode(this.label);

  final String label;
}
