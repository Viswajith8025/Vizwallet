import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/bootstrap.dart';
import 'package:rupee_track/core/constants/app_constants.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/features/dashboard/presentation/dashboard_screen.dart';
import 'package:rupee_track/features/expenses/presentation/expense_list_screen.dart';
import 'package:rupee_track/features/expenses/presentation/quick_add_expense_screen.dart';
import 'package:rupee_track/features/insights/presentation/insights_screen.dart';
import 'package:rupee_track/features/loans/presentation/loans_screen.dart';
import 'package:rupee_track/features/monthly_report/presentation/monthly_report_screen.dart';
import 'package:rupee_track/features/monthly_report/presentation/widgets/monthly_report_listener.dart';
import 'package:rupee_track/features/more/presentation/more_screen.dart';
import 'package:rupee_track/features/onboarding/presentation/onboarding_screen.dart';
import 'package:rupee_track/features/salary/presentation/salary_screen.dart';
import 'package:rupee_track/features/settings/presentation/settings_screen.dart';
import 'package:rupee_track/features/shell/presentation/main_shell.dart';
import 'package:rupee_track/features/subscriptions/presentation/subscriptions_screen.dart';
import 'package:rupee_track/features/about/presentation/about_screen.dart';
import 'package:rupee_track/features/budget/presentation/budget_planner_screen.dart';
import 'package:rupee_track/features/budget/presentation/budget_setup_screen.dart';
import 'package:rupee_track/features/budget_alerts/presentation/widgets/budget_alerts_panel.dart';
import 'package:rupee_track/features/health_score/presentation/widgets/financial_health_card.dart';
import 'package:rupee_track/features/calendar/presentation/calendar_screen.dart';
import 'package:rupee_track/features/search/presentation/search_screen.dart';
import 'package:rupee_track/features/auth/presentation/auth_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingComplete =
      sharedPreferences.getBool(AppConstants.onboardingCompleteKey) ?? false;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation:
        onboardingComplete ? AppRoutes.home : AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MonthlyReportListener(
          child: BudgetAlertsListener(
            child: MainShell(child: child),
          ),
        ),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.expenses,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ExpenseListScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.insights,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: InsightsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.more,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MoreScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.expenseAdd,
        builder: (context, state) => const QuickAddExpenseScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.salary,
        builder: (context, state) => const SalaryScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.subscriptions,
        builder: (context, state) => const SubscriptionsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.loans,
        builder: (context, state) => const LoansScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.calendar,
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.budget,
        builder: (context, state) => const BudgetPlannerScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.budgetSetup,
        builder: (context, state) => const BudgetSetupScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.monthlyReport,
        builder: (context, state) => MonthlyReportScreen(
          initialCycleKey: state.extra as String?,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.financialHealth,
        builder: (context, state) => const FinancialHealthScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.budgetAlerts,
        builder: (context, state) => const BudgetAlertsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.auth,
        builder: (context, state) {
          final signUp = state.uri.queryParameters['signup'] == '1';
          return AuthScreen(initialSignUp: signUp);
        },
      ),
    ],
  );
});
