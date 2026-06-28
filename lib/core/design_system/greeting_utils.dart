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
      return 'Tight cycle — small steps bring balance back.';
    }
    if (isOverBudget) {
      return 'You\'re spending faster than planned. A pause helps.';
    }
    if (savingsPercent >= 20) {
      return 'Strong savings rhythm. Keep it up.';
    }
    if (savingsPercent >= 10) {
      return 'Steady progress — you\'re on track.';
    }
    return 'Every rupee tracked is a step toward control.';
  }
}
