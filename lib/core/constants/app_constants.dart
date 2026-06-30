class AppConstants {
  static const appName = 'Viswallet';
  static const appTagline = 'Your money, clearly understood.';
  static const currencyCode = 'INR';
  static const currencySymbol = '₹';
  static const defaultSalaryDay = 1;

  static const defaultMajorExpenseThresholdRupees = 500;
  static const defaultLargeExpenseThresholdRupees = 2000;
  static const defaultVeryLargeExpenseThresholdRupees = 10000;
  static const defaultMajorPurchaseThresholdRupees = 5000;

  /// Hosted privacy policy — update before Play Store submission.
  static const privacyPolicyUrl =
      'https://github.com/Viswajith8025/Vizwallet/blob/main/PRIVACY.md';

  static const termsOfServiceUrl =
      'https://github.com/Viswajith8025/Vizwallet/blob/main/TERMS.md';

  /// Subscription cost as share of salary — warning thresholds.
  static const subscriptionBurdenWarningPercent = 10.0;
  static const subscriptionBurdenCriticalPercent = 15.0;
  static const subscriptionForecastRiskPercent = 12.0;

  /// Budget bucket usage — aligned with financial health score.
  static const budgetOnTrackMaxPercentUsed = 75.0;

  static const onboardingCompleteKey = 'onboarding_complete';
  static const selectedMonthKeyPref = 'selected_month_key';
  static const selectedCycleKeyPref = 'selected_cycle_key';
}
