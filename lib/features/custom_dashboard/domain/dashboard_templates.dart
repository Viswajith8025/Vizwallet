import 'package:rupee_track/features/custom_dashboard/domain/dashboard_layout_models.dart';

abstract final class DashboardTemplates {
  static DashboardLayoutConfig defaults() => DashboardLayoutConfig(
        widgets: [
          DashboardWidgetInstance.create(DashboardWidgetType.cycleHeader),
          DashboardWidgetInstance.create(DashboardWidgetType.currentBalance),
          DashboardWidgetInstance.create(DashboardWidgetType.safeDailySpend),
          DashboardWidgetInstance.create(DashboardWidgetType.financialHealth),
          DashboardWidgetInstance.create(DashboardWidgetType.monthlyReport),
          DashboardWidgetInstance.create(DashboardWidgetType.calendar),
          DashboardWidgetInstance.create(DashboardWidgetType.budgetAlerts),
          DashboardWidgetInstance.create(DashboardWidgetType.summaryGrid),
          DashboardWidgetInstance.create(DashboardWidgetType.budgetProgress),
          DashboardWidgetInstance.create(DashboardWidgetType.expenseCategories),
          DashboardWidgetInstance.create(DashboardWidgetType.loanSummary),
          DashboardWidgetInstance.create(DashboardWidgetType.subscriptions),
        ],
      );

  static DashboardLayoutConfig minimal() => DashboardLayoutConfig(
        theme: DashboardThemePreset.minimal,
        layoutMode: DashboardLayoutMode.singleColumn,
        widgets: [
          DashboardWidgetInstance.create(DashboardWidgetType.currentBalance),
          DashboardWidgetInstance.create(DashboardWidgetType.todaySpending),
          DashboardWidgetInstance.create(DashboardWidgetType.quickActions),
        ],
      );

  static DashboardLayoutConfig student() => DashboardLayoutConfig(
        theme: DashboardThemePreset.student,
        widgets: [
          DashboardWidgetInstance.create(DashboardWidgetType.currentBalance),
          DashboardWidgetInstance.create(DashboardWidgetType.todaySpending),
          DashboardWidgetInstance.create(DashboardWidgetType.safeDailySpend),
          DashboardWidgetInstance.create(DashboardWidgetType.budgetProgress),
          DashboardWidgetInstance.create(DashboardWidgetType.quickActions),
          DashboardWidgetInstance.create(DashboardWidgetType.recentTransactions),
        ],
      );

  static DashboardLayoutConfig professional() => DashboardLayoutConfig(
        theme: DashboardThemePreset.professional,
        widgets: [
          DashboardWidgetInstance.create(DashboardWidgetType.cycleHeader),
          DashboardWidgetInstance.create(DashboardWidgetType.currentBalance),
          DashboardWidgetInstance.create(DashboardWidgetType.summaryGrid),
          DashboardWidgetInstance.create(DashboardWidgetType.safeDailySpend),
          DashboardWidgetInstance.create(DashboardWidgetType.budgetProgress),
          DashboardWidgetInstance.create(DashboardWidgetType.financialHealth),
          DashboardWidgetInstance.create(DashboardWidgetType.monthlyReport),
          DashboardWidgetInstance.create(DashboardWidgetType.insightsFeed),
        ],
      );

  static DashboardLayoutConfig family() => DashboardLayoutConfig(
        theme: DashboardThemePreset.goalsFocused,
        widgets: [
          DashboardWidgetInstance.create(DashboardWidgetType.currentBalance),
          DashboardWidgetInstance.create(DashboardWidgetType.budgetProgress),
          DashboardWidgetInstance.create(DashboardWidgetType.budgetAlerts),
          DashboardWidgetInstance.create(DashboardWidgetType.subscriptions),
          DashboardWidgetInstance.create(DashboardWidgetType.calendar),
          DashboardWidgetInstance.create(DashboardWidgetType.savingsForecast),
        ],
      );

  static DashboardLayoutConfig freelancer() => DashboardLayoutConfig(
        theme: DashboardThemePreset.analytics,
        widgets: [
          DashboardWidgetInstance.create(DashboardWidgetType.currentBalance),
          DashboardWidgetInstance.create(DashboardWidgetType.summaryGrid),
          DashboardWidgetInstance.create(DashboardWidgetType.expenseCategories),
          DashboardWidgetInstance.create(DashboardWidgetType.insightsFeed),
          DashboardWidgetInstance.create(DashboardWidgetType.loanSummary),
        ],
      );

  static DashboardLayoutConfig business() => DashboardLayoutConfig(
        theme: DashboardThemePreset.business,
        layoutMode: DashboardLayoutMode.twoColumn,
        widgets: [
          DashboardWidgetInstance.create(DashboardWidgetType.currentBalance),
          DashboardWidgetInstance.create(DashboardWidgetType.summaryGrid),
          DashboardWidgetInstance.create(DashboardWidgetType.budgetProgress),
          DashboardWidgetInstance.create(DashboardWidgetType.loanSummary),
          DashboardWidgetInstance.create(DashboardWidgetType.subscriptions),
          DashboardWidgetInstance.create(DashboardWidgetType.financialHealth),
          DashboardWidgetInstance.create(DashboardWidgetType.monthlyReport),
        ],
      );

  static DashboardLayoutConfig powerUser() => DashboardLayoutConfig(
        theme: DashboardThemePreset.analytics,
        layoutMode: DashboardLayoutMode.grid,
        density: DashboardDensity.compact,
        widgets: DashboardWidgetCatalog.allTypes
            .where(
              (t) =>
                  t != DashboardWidgetType.budgetSetup &&
                  t != DashboardWidgetType.wishlist,
            )
            .map(DashboardWidgetInstance.create)
            .toList(),
      );

  static List<({String id, String label, DashboardLayoutConfig config})>
      get presets => [
        (id: 'default', label: 'Default', config: defaults()),
        (id: 'minimal', label: 'Minimal', config: minimal()),
        (id: 'student', label: 'Student', config: student()),
        (id: 'professional', label: 'Working professional', config: professional()),
        (id: 'family', label: 'Family', config: family()),
        (id: 'freelancer', label: 'Freelancer', config: freelancer()),
        (id: 'business', label: 'Business owner', config: business()),
        (id: 'power', label: 'Power user', config: powerUser()),
      ];
}
