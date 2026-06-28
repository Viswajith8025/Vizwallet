import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/features/monthly_report/data/monthly_report_repository.dart';

/// Auto-generates closing reports when salary cycles end.
///
/// Report availability is surfaced on the dashboard via [MonthlyReportSummaryCard]
/// — no snackbar here (floating snackbars overlapped the FAB and could stick).
class MonthlyReportListener extends ConsumerStatefulWidget {
  const MonthlyReportListener({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<MonthlyReportListener> createState() =>
      _MonthlyReportListenerState();
}

class _MonthlyReportListenerState extends ConsumerState<MonthlyReportListener> {
  bool _ran = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Clear any stuck snackbar from a previous session / hot reload.
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _autoGenerate();
    });
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
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
