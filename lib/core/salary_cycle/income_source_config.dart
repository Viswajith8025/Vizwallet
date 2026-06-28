import 'package:rupee_track/core/salary_cycle/salary_cycle_type.dart';

/// Configuration for a single income stream's pay cycle.
///
/// Multiple sources can coexist in the future; the primary source drives the
/// global financial month shown in the UI.
class IncomeSourceConfig {
  const IncomeSourceConfig({
    required this.id,
    required this.name,
    this.cycleType = SalaryCycleType.monthlyDay,
    this.dayOfMonth = 1,
    this.weekStartDay,
    this.isPrimary = false,
    this.isActive = true,
  });

  final int id;
  final String name;
  final SalaryCycleType cycleType;
  final int dayOfMonth;
  final int? weekStartDay;
  final bool isPrimary;
  final bool isActive;

  int get effectiveSalaryDay => dayOfMonth.clamp(1, 31);
}
