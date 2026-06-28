import 'package:drift/drift.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/tables.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [AppSettingsTable])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Stream<AppSettingsTableData> watchSettings() {
    return select(appSettingsTable).watchSingle();
  }

  Future<AppSettingsTableData> getSettings() {
    return select(appSettingsTable).getSingle();
  }

  Future<void> updateThemeMode(String themeMode) async {
    await (update(appSettingsTable)..where((t) => t.id.equals(1))).write(
      AppSettingsTableCompanion(
        themeMode: Value(themeMode),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> updateThresholds({
    int? majorExpenseThresholdPaise,
    int? largeExpenseThresholdPaise,
    int? veryLargeExpenseThresholdPaise,
    int? majorPurchaseThresholdPaise,
    int? salaryDay,
  }) async {
    await (update(appSettingsTable)..where((t) => t.id.equals(1))).write(
      AppSettingsTableCompanion(
        majorExpenseThresholdPaise: majorExpenseThresholdPaise == null
            ? const Value.absent()
            : Value(majorExpenseThresholdPaise),
        largeExpenseThresholdPaise: largeExpenseThresholdPaise == null
            ? const Value.absent()
            : Value(largeExpenseThresholdPaise),
        veryLargeExpenseThresholdPaise: veryLargeExpenseThresholdPaise == null
            ? const Value.absent()
            : Value(veryLargeExpenseThresholdPaise),
        majorPurchaseThresholdPaise: majorPurchaseThresholdPaise == null
            ? const Value.absent()
            : Value(majorPurchaseThresholdPaise),
        salaryDay:
            salaryDay == null ? const Value.absent() : Value(salaryDay),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> updatePin({
    required bool enabled,
    required String pinHash,
  }) async {
    await (update(appSettingsTable)..where((t) => t.id.equals(1))).write(
      AppSettingsTableCompanion(
        pinEnabled: Value(enabled),
        pinHash: Value(pinHash),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> clearPin() async {
    await (update(appSettingsTable)..where((t) => t.id.equals(1))).write(
      AppSettingsTableCompanion(
        pinEnabled: const Value(false),
        pinHash: const Value(null),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}
