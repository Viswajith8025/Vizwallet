import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/constants/app_constants.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/features/monthly_report/data/monthly_report_exporter.dart';
import 'package:rupee_track/features/monthly_report/data/monthly_report_repository.dart';
import 'package:rupee_track/features/monthly_report/domain/monthly_closing_report.dart';
import 'package:rupee_track/features/monthly_report/presentation/widgets/monthly_report_widgets.dart';

class MonthlyReportScreen extends ConsumerStatefulWidget {
  const MonthlyReportScreen({this.initialCycleKey, super.key});

  final String? initialCycleKey;

  @override
  ConsumerState<MonthlyReportScreen> createState() =>
      _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends ConsumerState<MonthlyReportScreen> {
  String? _selectedCycleKey;
  bool _exporting = false;

  Future<void> _export(
    MonthlyClosingReport report,
    Future<void> Function(MonthlyClosingReport) action,
    String label,
  ) async {
    setState(() => _exporting = true);
    try {
      await action(report);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label exported')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final salaryDay = ref.watch(salaryDayProvider);
    final current = ref.watch(selectedCycleKeyProvider);
    final defaultKey = widget.initialCycleKey ??
        previousCycleKey(current, salaryDay: salaryDay);
    final cycleKey = _selectedCycleKey ?? defaultKey;

    final reportAsync = ref.watch(monthlyClosingReportProvider(cycleKey));
    final cycles = recentCycleKeys(salaryDay: salaryDay, count: 12)
        .where((k) => k != current)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Closing Report'),
        actions: [
          PopupMenuButton<String>(
            enabled: !_exporting,
            onSelected: (value) async {
              final report = reportAsync.valueOrNull;
              if (report == null) return;
              final exporter = ref.read(monthlyReportExporterProvider);
              switch (value) {
                case 'pdf':
                  await _export(
                    report,
                    (r) async {
                      final file = await exporter.exportPdf(r);
                      await exporter.shareFile(
                        file,
                        subject: '${AppConstants.appName} Closing Report',
                      );
                    },
                    'PDF',
                  );
                case 'csv':
                  await _export(
                    report,
                    (r) async {
                      final file = await exporter.exportCsv(r);
                      await exporter.shareFile(
                        file,
                        subject: '${AppConstants.appName} Closing Report CSV',
                      );
                    },
                    'CSV',
                  );
                case 'json':
                  await _export(
                    report,
                    (r) async {
                      final file = await exporter.exportJson(r);
                      await exporter.shareFile(
                        file,
                        subject: '${AppConstants.appName} Closing Report JSON',
                      );
                    },
                    'JSON',
                  );
                case 'print':
                  await _export(report, exporter.printPdf, 'Print');
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'pdf', child: Text('Export PDF')),
              PopupMenuItem(value: 'csv', child: Text('Export CSV')),
              PopupMenuItem(value: 'json', child: Text('Export JSON')),
              PopupMenuItem(value: 'print', child: Text('Print')),
            ],
            icon: _exporting
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (report) {
          if (report == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Closing report will be available after this salary cycle ends.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          return Column(
            children: [
              if (cycles.length > 1)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: DropdownButtonFormField<String>(
                    value: cycleKey,
                    decoration: const InputDecoration(
                      labelText: 'Statement period',
                      isDense: true,
                    ),
                    items: cycles.map((k) {
                      return DropdownMenuItem(
                        value: k,
                        child: Text(formatCycleLabel(k, salaryDay: salaryDay)),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedCycleKey = v);
                    },
                  ),
                ),
              Expanded(child: MonthlyReportDetailView(report: report)),
            ],
          );
        },
      ),
    );
  }
}
