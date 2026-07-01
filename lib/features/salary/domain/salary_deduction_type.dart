/// Payroll deduction kinds for a salary cycle.
enum SalaryDeductionType {
  pf('pf', 'PF'),
  esi('esi', 'ESI'),
  tax('tax', 'Tax / TDS'),
  other('other', 'Other');

  const SalaryDeductionType(this.storageKey, this.label);

  final String storageKey;
  final String label;

  static SalaryDeductionType? fromStorage(String? value) {
    if (value == null) return null;
    for (final type in SalaryDeductionType.values) {
      if (type.storageKey == value) return type;
    }
    return null;
  }
}
