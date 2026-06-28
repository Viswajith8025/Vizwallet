/// How spending trends are compared on the Insights screen.
enum TrendsComparisonMode {
  currentVsPreviousCycle('Current vs previous cycle'),
  currentVsPreviousCalendarMonth('Current vs previous month'),
  lastSixCycles('Last 6 salary cycles'),
  lastTwelveCycles('Last 12 salary cycles');

  const TrendsComparisonMode(this.label);

  final String label;
}
