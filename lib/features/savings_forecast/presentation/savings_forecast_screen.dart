import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/savings_forecast/data/savings_forecast_repository.dart';
import 'package:rupee_track/features/savings_forecast/data/savings_goals_repository.dart';
import 'package:rupee_track/features/savings_forecast/domain/savings_forecast_engine.dart';
import 'package:rupee_track/features/savings_forecast/domain/savings_forecast_models.dart';
import 'package:rupee_track/features/savings_forecast/presentation/widgets/savings_forecast_charts.dart';

class SavingsForecastScreen extends ConsumerWidget {
  const SavingsForecastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(savingsForecastReportProvider);
    final period = ref.watch(selectedForecastPeriodProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Savings Forecast',
        subtitle: 'Your financial GPS',
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: 'Add goal',
            onPressed: () => _showAddGoalSheet(context, ref),
          ),
        ],
      ),
      body: ResponsiveBody(
        child: reportAsync.when(
          loading: () => ListView(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.xxl,
            ),
            children: const [
              SkeletonCard(height: 100),
              SizedBox(height: AppSpacing.sm),
              SkeletonCard(height: 200),
            ],
          ),
          error: (_, __) => ErrorState(
            message: 'We couldn\'t build your savings forecast.',
            onRetry: () => ref.invalidate(savingsForecastReportProvider),
          ),
          data: (report) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(savingsForecastReportProvider);
            },
            child: ListView(
              padding: const EdgeInsets.only(
                top: AppSpacing.md,
                bottom: AppSpacing.xxl,
              ),
              children: [
                _PeriodSelector(
                  selected: period,
                  onSelected: (p) => ref
                      .read(selectedForecastPeriodProvider.notifier)
                      .setPeriod(p),
                ),
                const SizedBox(height: AppSpacing.sm),
                _HeroCard(summary: report.periodSummary),
                const SizedBox(height: AppSpacing.sm),
                _MetricsGrid(summary: report.periodSummary),
                const SizedBox(height: AppSpacing.lg),
                _SectionTitle('Savings curve'),
                PremiumCard(
                  child: SavingsForecastCurveChart(points: report.savingsCurve),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionTitle('Income vs expenses'),
                PremiumCard(
                  child: Column(
                    children: [
                      ForecastTrendChart(
                        income: report.incomeTrend,
                        expenses: report.expenseTrend,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          _LegendDot(
                            color: Colors.teal,
                            label: 'Income',
                          ),
                          const SizedBox(width: AppSpacing.md),
                          _LegendDot(
                            color: theme.colorScheme.error,
                            label: 'Expenses',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (report.goalForecasts.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  _SectionTitle('Goal completion'),
                  PremiumCard(
                    child: GoalProjectionBar(goals: report.goalForecasts),
                  ),
                ],
                if (report.risks.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  _SectionTitle('Risk analysis'),
                  ...report.risks.map((r) => _RiskTile(risk: r)),
                ],
                const SizedBox(height: AppSpacing.lg),
                _SectionTitle('Smart insights'),
                ...report.insights.map((i) => _InsightTile(insight: i)),
                const SizedBox(height: AppSpacing.lg),
                _SectionTitle('Scenario simulator'),
                _ScenarioBar(
                  presets: report.scenarioPresets,
                  onSimulate: (preset) async {
                    ref
                        .read(activeForecastAdjustmentsProvider.notifier)
                        .apply(preset);
                    if (!context.mounted) return;
                    final repo = ref.read(savingsForecastRepositoryProvider);
                    final result = await repo.simulate(preset: preset);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result.headline)),
                    );
                  },
                  onReset: () {
                    ref
                        .read(activeForecastAdjustmentsProvider.notifier)
                        .reset();
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionTitle('Recommendations'),
                ...report.recommendations.map(
                  (r) => _RecommendationTile(
                    rec: r,
                    onTap: () => _openRecommendation(context, r.actionKind),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _FutureBanner(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openRecommendation(BuildContext context, String kind) {
    switch (kind) {
      case 'subscriptions':
        context.push(AppRoutes.subscriptions);
      case 'health_score':
        context.push(AppRoutes.financialHealth);
      case 'emergency_fund':
      case 'increase_savings':
      case 'reduce_category':
      case 'invest':
        break;
    }
  }

  Future<void> _showAddGoalSheet(BuildContext context, WidgetRef ref) {
    return showPremiumBottomSheet<void>(
      context: context,
      initialSize: 0.55,
      child: _AddGoalSheet(
        onSaved: () {
          ref.invalidate(savingsForecastReportProvider);
          ref.invalidate(activeSavingsGoalsProvider);
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.selected,
    required this.onSelected,
  });

  final ForecastPeriod selected;
  final ValueChanged<ForecastPeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    const options = [
      (ForecastPeriod.days30, '30D'),
      (ForecastPeriod.months3, '3M'),
      (ForecastPeriod.months6, '6M'),
      (ForecastPeriod.year1, '1Y'),
      (ForecastPeriod.years3, '3Y'),
      (ForecastPeriod.years5, '5Y'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<ForecastPeriod>(
        segments: options
            .map((o) => ButtonSegment(value: o.$1, label: Text(o.$2)))
            .toList(),
        selected: {selected},
        onSelectionChanged: (v) => onSelected(v.first),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.summary});

  final ForecastPeriodSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumCard(
      accentColor: theme.colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projected savings',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            SavingsForecastEngine.formatPaiseCompact(
              summary.projectedSavingsPaise,
            ),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Net cash flow ${formatPaise(summary.netCashFlowPaise)} · '
            'Emergency fund ${summary.emergencyFundMonths.toStringAsFixed(1)} mo',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.summary});

  final ForecastPeriodSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _Metric(
                label: 'Expected income',
                value: formatPaise(summary.expectedIncomePaise),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _Metric(
                label: 'Expected expenses',
                value: formatPaise(summary.expectedExpensesPaise),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _Metric(
                label: 'Investment potential',
                value: formatPaise(summary.investmentPotentialPaise),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _Metric(
                label: 'Horizon',
                value: '${summary.horizonMonths} mo',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({required this.insight});

  final ForecastInsight insight;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: Icon(
          Icons.auto_awesome_outlined,
          color: insight.severity == 'warning'
              ? Colors.orange
              : Theme.of(context).colorScheme.primary,
        ),
        title: Text(insight.message),
      ),
    );
  }
}

class _RiskTile extends StatelessWidget {
  const _RiskTile({required this.risk});

  final ForecastRisk risk;

  @override
  Widget build(BuildContext context) {
    final color = switch (risk.severity) {
      'critical' => Colors.red,
      'warning' => Colors.orange,
      _ => Colors.amber,
    };
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: Icon(Icons.shield_outlined, color: color),
        title: Text(risk.title),
        subtitle: Text(risk.detail),
      ),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({required this.rec, this.onTap});

  final ForecastRecommendation rec;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: const Icon(Icons.lightbulb_outline),
        title: Text(rec.title),
        subtitle: Text(rec.detail),
        onTap: onTap,
      ),
    );
  }
}

class _ScenarioBar extends StatelessWidget {
  const _ScenarioBar({
    required this.presets,
    required this.onSimulate,
    required this.onReset,
  });

  final List<ScenarioPreset> presets;
  final ValueChanged<ScenarioPreset> onSimulate;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: presets
              .map(
                (p) => ActionChip(
                  label: Text(p.label),
                  onPressed: () => onSimulate(p),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(onPressed: onReset, child: const Text('Reset scenarios')),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _FutureBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Text(
        'Coming soon: AI forecasting · inflation adjustment · investment returns · '
        'mutual funds · retirement & tax planning · bank integration',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

class _AddGoalSheet extends ConsumerStatefulWidget {
  const _AddGoalSheet({required this.onSaved});

  final VoidCallback onSaved;

  @override
  ConsumerState<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends ConsumerState<_AddGoalSheet> {
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final _contribController = TextEditingController();
  bool _wishlist = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _contribController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final target = rupeesToPaise(_targetController.text);
    if (name.isEmpty || target <= 0) return;

    setState(() => _saving = true);
    try {
      await ref.read(savingsGoalsRepositoryProvider).addGoal(
            name: name,
            targetPaise: target,
            monthlyContributionPaise:
                rupeesToPaise(_contribController.text),
            isWishlist: _wishlist,
          );
      widget.onSaved();
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('Add savings goal', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Goal name'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _targetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Target amount',
            prefixText: '₹ ',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _contribController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Monthly contribution (optional)',
            prefixText: '₹ ',
          ),
        ),
        SwitchListTile(
          title: const Text('Wishlist item'),
          value: _wishlist,
          onChanged: (v) => setState(() => _wishlist = v),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Saving…' : 'Save goal'),
        ),
      ],
    );
  }
}
