import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/features/monthly_report/data/monthly_report_repository.dart';

/// Auto-generates closing reports when salary cycles end.
class MonthlyReportListener extends ConsumerStatefulWidget {
  const MonthlyReportListener({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<MonthlyReportListener> createState() =>
      _MonthlyReportListenerState();
}

class _MonthlyReportListenerState extends ConsumerState<MonthlyReportListener> {
  bool _ran = false;
  String? _notifiedCycleKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoGenerate());
  }

  Future<void> _autoGenerate() async {
    if (_ran) return;
    _ran = true;

    final salaryDay = ref.read(salaryDayProvider);
    await ref
        .read(monthlyReportRepositoryProvider)
        .ensureAutoReports(salaryDay: salaryDay);

    if (!mounted) return;
    ref.invalidate(previousCycleClosingReportProvider);

    final previous = previousCycleKey(
      ref.read(selectedCycleKeyProvider),
      salaryDay: salaryDay,
    );
    final report =
        await ref.read(monthlyReportStoreProvider).loadReport(previous);

    if (report != null &&
        _notifiedCycleKey != previous &&
        mounted) {
      _notifiedCycleKey = previous;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 6),
          content: Text('${report.cycleLabel} closing report is ready'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () => context.push(
              AppRoutes.monthlyReport,
              extra: report.cycleKey,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
