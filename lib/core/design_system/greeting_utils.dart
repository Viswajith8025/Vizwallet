abstract final class GreetingUtils {
  static String timeOfDayGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 5) return 'Good night';
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    if (hour < 21) return 'Good evening';
    return 'Good night';
  }

  static String motivationalLine({
    required int moneyLeftPaise,
    required double savingsPercent,
    required bool isOverBudget,
  }) {
    if (moneyLeftPaise < 0) {
      return 'A tight cycle — you\'re still in control. Small choices add up.';
    }
    if (isOverBudget) {
      return 'Spending picked up lately. A lighter day helps you reset.';
    }
    if (savingsPercent >= 20) {
      return 'Excellent rhythm — you\'re building real momentum.';
    }
    if (savingsPercent >= 10) {
      return 'Steady progress. You\'re moving in the right direction.';
    }
    if (savingsPercent > 0) {
      return 'You\'re saving this cycle. Keep tracking — awareness is power.';
    }
    return 'Every rupee you track is a step toward clarity.';
  }
}
