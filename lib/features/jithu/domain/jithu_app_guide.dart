import 'package:rupee_track/features/jithu/domain/jithu_branding.dart';

/// In-app navigation map so ${JithuBranding.displayName} can answer "where do I…?" accurately.
abstract final class JithuAppGuide {
  /// Injected into the Groq system prompt — keep in sync with [navigationAnswer].
  static String get promptBlock => '''
Viswallet app navigation (use these exact paths when users ask how to do something in the app):
- Add or change monthly salary: Home tab → scroll to the summary grid → tap the "Salary" tile; OR Home → Quick actions → "Income"; OR More tab → Settings → Money cycle → "Monthly salary".
- Salary pay date (cycle): More → Settings → Money cycle → "Salary cycle" slider (not the salary amount).
- Add an expense: tap the floating + button on any main tab, enter amount, pick a category.
- View all expenses: Home → Recent transactions, or More → Activity history.
- Budget / spending groups: More → Budget planner, or tap "Set up your budget" on Home after salary is set.
- Category budgets: More → Category budgets.
- Today's spending guide: Home → "Safe daily spend" card.
- ${JithuBranding.displayName} (this chat): bottom navigation → ${JithuBranding.displayName}.
- Insights & charts: bottom navigation → Insights.
- More tools (reports, loans, calendar): bottom navigation → More.
- Settings (theme, lock, export): More → Settings.
- Help articles: More → Settings → Help & support.
- Subscriptions: Home summary grid → Subscriptions, or More → Subscriptions.
- Loans: More → Loans.
- Savings goals / forecast: More → Savings forecast, or Home Quick actions → Goals.
- Search anything: Home Quick actions → Search, or universal search from More.
- Sign out: More → Settings → Account section.

When salary is not set, always tell the user the clearest path: Home → Salary tile or Quick actions → Income.
Do not say "Settings" alone for salary amount — Settings only has salary date unless they use "Monthly salary" there.
''';

  /// Offline rule-based navigation replies. Returns null if not a navigation question.
  static String? navigationAnswer(String question) {
    final q = question.toLowerCase();

    if (_asksSalaryPath(q)) {
      return 'To add or change your monthly salary, open Home and tap the **Salary** tile in the summary grid, '
          'or use Quick actions → **Income**. You can also go to More → Settings → Money cycle → **Monthly salary**.';
    }

    if (_asksExpensePath(q)) {
      return 'Tap the **+** button (floating action button), enter the amount, then choose a category like Food or Travel. '
          'It saves right away. To see past expenses, open More → **Activity history**.';
    }

    if (q.contains('budget') &&
        (q.contains('where') ||
            q.contains('how') ||
            q.contains('set') ||
            q.contains('setup') ||
            q.contains('plan'))) {
      return 'Open **More** → **Budget planner** to split your salary into spending groups like Food and Bills. '
          'For limits per category, use More → **Category budgets**.';
    }

    if ((q.contains('salary date') ||
            q.contains('salary cycle') ||
            q.contains('pay date') ||
            q.contains('when do i get paid')) &&
        (q.contains('where') || q.contains('how') || q.contains('change') || q.contains('set'))) {
      return 'Your salary **date** (which day defines each month) is in More → Settings → Money cycle → **Salary cycle**. '
          'That is different from your salary **amount**, which is on the Home Salary tile.';
    }

    if (q.contains('setting') &&
        (q.contains('where') || q.contains('open') || q.contains('find'))) {
      return 'Open the **More** tab at the bottom, then tap **Settings**. '
          'There you will find theme, app lock, salary cycle, budget alerts, export, and help.';
    }

    if (q.contains('help') &&
        (q.contains('where') || q.contains('faq') || q.contains('support'))) {
      return 'Go to More → Settings → **Help & support** for step-by-step answers to common questions.';
    }

    if (q.contains('subscription') &&
        (q.contains('where') || q.contains('add') || q.contains('manage'))) {
      return 'Open **More** → **Subscriptions**, or tap **Subscriptions** on the Home summary grid.';
    }

    if (q.contains('loan') &&
        (q.contains('where') || q.contains('add') || q.contains('borrow'))) {
      return 'Loans are under **More** → **Loans**. You can track money you borrowed or lent there.';
    }

    if ((q.contains('insight') || q.contains('chart') || q.contains('report')) &&
        (q.contains('where') || q.contains('see') || q.contains('open'))) {
      return 'Tap **Insights** in the bottom bar for spending charts. '
          'For a month-end summary, open More → **Monthly closing report**.';
    }

    if (q.contains('safe') &&
        q.contains('spend') &&
        (q.contains('where') || q.contains('see') || q.contains('find'))) {
      return 'On **Home**, look for the **Safe daily spend** card — it shows how much you can spend today and stay on track.';
    }

    if (q.contains('sign out') || q.contains('log out') || q.contains('logout')) {
      return 'More → Settings → **Account** section → sign out.';
    }

    if (_asksStartTracking(q)) {
      return 'Start with your monthly salary: Home → **Salary** tile (or Quick actions → **Income**). '
          'Then log spending with the **+** button. I can help more once salary is set.';
    }

    if (_asksWhatToSetUp(q)) {
      return 'First add your **monthly salary** (Home → Salary tile). '
          'Then add a few **expenses** with the + button. '
          'Optional next step: More → **Budget planner** to split salary into groups.';
    }

    return null;
  }

  static bool _asksSalaryPath(String q) {
    if (!q.contains('salary') && !q.contains('income')) return false;
    return q.contains('where') ||
        q.contains('how') ||
        q.contains('add') ||
        q.contains('enter') ||
        q.contains('set') ||
        q.contains('change') ||
        q.contains('update') ||
        q.contains('find') ||
        q.contains('skip');
  }

  static bool _asksExpensePath(String q) {
    if (!q.contains('expense') && !q.contains('spending') && !q.contains('spend')) {
      return false;
    }
    return q.contains('where') ||
        q.contains('how') ||
        q.contains('add') ||
        q.contains('log') ||
        q.contains('record') ||
        q.contains('track');
  }

  static bool _asksStartTracking(String q) {
    return q.contains('start') &&
        (q.contains('track') || q.contains('using') || q.contains('app'));
  }

  static bool _asksWhatToSetUp(String q) {
    return q.contains('set up') ||
        q.contains('setup') ||
        q.contains('first') && q.contains('what');
  }
}
