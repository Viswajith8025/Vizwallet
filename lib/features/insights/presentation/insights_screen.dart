import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/design_system/shell_bottom_inset.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/insights/data/insights_feed_repository.dart';
import 'package:rupee_track/features/insights/presentation/widgets/insights_analytics_panel.dart';
import 'package:rupee_track/features/insights/presentation/widgets/insights_feed_section.dart';
import 'package:rupee_track/features/smart_tagging/data/tagging_repository.dart';
import 'package:rupee_track/features/trends/data/spending_trends_repository.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendsAsync = ref.watch(spendingTrendsProvider);
    final feedAsync = ref.watch(insightsFeedProvider);

    if (feedAsync.isLoading && trendsAsync.isLoading && !feedAsync.hasValue) {
      return Scaffold(
        appBar: const PremiumAppBar(
          title: 'Insights',
          subtitle: 'Your personalized financial feed',
        ),
        body: const DashboardSkeleton(),
      );
    }

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Insights',
        subtitle: 'What matters most, right now',
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () => context.push(AppRoutes.search),
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: trendsAsync.when(
        loading: () => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: ShellBottomInset.scrollPadding(context),
          children: const [
            InsightsFeedSection(),
            SizedBox(height: AppSpacing.lg),
            DashboardSkeleton(),
          ],
        ),
        error: (e, _) => ErrorState(
          message: 'We couldn\'t load your insights.',
          onRetry: () {
            ref.invalidate(spendingTrendsProvider);
            ref.invalidate(insightsFeedProvider);
          },
        ),
        data: (report) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(spendingTrendsProvider);
              ref.invalidate(insightsFeedProvider);
              ref.invalidate(
                spendingByTagsProvider(ref.read(selectedCycleKeyProvider)),
              );
            },
            child: ResponsiveBody(
              padding: EdgeInsets.zero,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: ShellBottomInset.scrollPadding(context),
                children: [
                  const InsightsFeedSection(),
                  const SizedBox(height: AppSpacing.lg),
                  InsightsAnalyticsPanel(report: report),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
