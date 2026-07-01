import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/features/salary/domain/salary_deduction_type.dart';

class SalaryBreakdown {
  const SalaryBreakdown({
    required this.cycleKey,
    required this.grossPaise,
    required this.deductions,
    required this.extraIncome,
  });

  final String cycleKey;
  final int grossPaise;
  final List<SalaryDeductionRow> deductions;
  final List<ExtraIncomeRow> extraIncome;

  int get deductionsPaise =>
      deductions.fold<int>(0, (sum, row) => sum + row.amountPaise);

  int get extraIncomePaise =>
      extraIncome.fold<int>(0, (sum, row) => sum + row.amountPaise);

  /// Salary in-hand after deductions.
  int get netPaise => (grossPaise - deductionsPaise).clamp(0, 1 << 30);

  /// Salary + gifts/family/other cash for this cycle.
  int get totalInflowPaise => netPaise + extraIncomePaise;

  bool get hasSalary => grossPaise > 0;
}

class SalaryDeductionRow {
  const SalaryDeductionRow({
    required this.id,
    required this.type,
    required this.amountPaise,
    this.customLabel,
  });

  final int id;
  final SalaryDeductionType type;
  final int amountPaise;
  final String? customLabel;

  String get displayLabel {
    if (type == SalaryDeductionType.other &&
        customLabel != null &&
        customLabel!.trim().isNotEmpty) {
      return customLabel!.trim();
    }
    return type.label;
  }

  factory SalaryDeductionRow.fromTable(SalaryDeductionsTableData data) {
    return SalaryDeductionRow(
      id: data.id,
      type: SalaryDeductionType.fromStorage(data.type) ??
          SalaryDeductionType.other,
      amountPaise: data.amountPaise,
      customLabel: data.label,
    );
  }
}

class ExtraIncomeRow {
  const ExtraIncomeRow({
    required this.id,
    required this.label,
    required this.amountPaise,
    this.receivedAt,
  });

  final int id;
  final String label;
  final int amountPaise;
  final DateTime? receivedAt;

  factory ExtraIncomeRow.fromTable(CycleExtraIncomeTableData data) {
    return ExtraIncomeRow(
      id: data.id,
      label: data.label,
      amountPaise: data.amountPaise,
      receivedAt: data.receivedAt,
    );
  }
}
