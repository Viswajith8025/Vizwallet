import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/dashboard/domain/monthly_summary.dart';
import 'package:rupee_track/features/jithu/domain/jithu_app_guide.dart';
import 'package:rupee_track/features/jithu/domain/jithu_branding.dart';
import 'package:rupee_track/features/safe_spend/domain/safe_spend_snapshot.dart';

/// Offline rule-based replies when Groq is unavailable.
abstract final class JithuFallbackAdvisor {
  static List<String> suggestions(CycleSummary summary) {
    if (!summary.salaryEntered) {
      return const [
        'Where do I add my salary?',
        'What should I set up first?',
        'How do I add an expense?',
        'How do budgets work?',
      ];
    }

    return const [
      'How am I doing?',
      'How much can I spend today?',
      'Where is my money going?',
      'Give me one saving tip',
    ];
  }

  static String reply({
    required String question,
    required CycleSummary summary,
    required SafeSpendSnapshot safeSpend,
  }) {
    final q = question.toLowerCase();

    if (q.contains('name') && (q.contains('your') || q.contains('who'))) {
      return 'I am ${JithuBranding.displayName}, your Viswallet money assistant. Ask me about spending, savings, budgets, or where to find anything in the app.';
    }

    if (q == 'hello' ||
        q == 'hi' ||
        q == 'hey' ||
        q.startsWith('hello ') ||
        q.startsWith('hi ')) {
      if (!summary.salaryEntered) {
        return 'Hello! I am ${JithuBranding.displayName}. To get started, add your monthly salary from Home → Salary tile (or Quick actions → Income). Then I can guide your daily spending.';
      }
      return 'Hello! I am ${JithuBranding.displayName}. I can help with today\'s safe spend, where your money is going, and quick saving tips.';
    }

    final nav = JithuAppGuide.navigationAnswer(question);
    if (nav != null) return nav.replaceAll('**', '');

    if (!summary.salaryEntered) {
      return 'Add your monthly salary first so I can calculate safe daily spending and savings. '
          'Go to Home → tap the Salary tile in the summary grid, or Quick actions → Income.';
    }

    if (q.contains('today') ||
        q.contains('spend') ||
        q.contains('safe') ||
        q.contains('can i')) {
      final left = safeSpend.remainingSafeSpendTodayPaise;
      if (left <= 0) {
        return 'For today, you have already used the safe guide. Best move: avoid non-essential spending and shift purchases to tomorrow.';
      }
      return 'You can spend about ${formatPaise(left)} more today and stay within today\'s suggested limit. Current status: ${safeSpend.riskLevel.label}.';
    }

    if (q.contains('where') ||
        q.contains('category') ||
        q.contains('money going') ||
        q.contains('top')) {
      if (summary.categoryBreakdown.isEmpty) {
        return 'No spending pattern yet this month. Add a few expenses with the + button and I will show your biggest category.';
      }
      final top = summary.categoryBreakdown.first;
      return 'Your biggest spending area this month is ${top.categoryName} at ${formatPaise(top.totalPaise)}. If you want quick control, try reducing this by 10-15%.';
    }

    if (q.contains('save') ||
        q.contains('saving') ||
        q.contains('advice') ||
        q.contains('tip')) {
      if (summary.savingsPercent < 0) {
        return 'You are over your available money by ${formatPaise(summary.moneyLeftPaise.abs())}. Pause optional spending first, then check your biggest spending area.';
      }
      if (summary.savingsPercent < 10) {
        return 'Your savings cushion is small right now. Try this: keep one day\'s spending limit untouched for the next 3 days.';
      }
      return 'You have a decent cushion. To improve it, save ${formatPaise((summary.safeDailyLimitPaise * 0.2).round())} from your daily limit each day.';
    }

    if (q.contains('how') ||
        q.contains('doing') ||
        q.contains('update') ||
        q.contains('summary')) {
      return 'This month you spent ${formatPaise(summary.spentPaise)} and have ${formatPaise(summary.moneyLeftPaise)} left. Your suggested daily limit is ${formatPaise(summary.safeDailyLimitPaise)} for the remaining ${summary.daysLeftInCycle} day(s).';
    }

    return 'Here is my quick view: money left is ${formatPaise(summary.moneyLeftPaise)}, today\'s remaining limit is ${formatPaise(safeSpend.remainingSafeSpendTodayPaise)}, and your current status is ${safeSpend.riskLevel.label}.';
  }
}
