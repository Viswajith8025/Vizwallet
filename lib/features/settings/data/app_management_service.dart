import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:share_plus/share_plus.dart';

final appManagementServiceProvider = Provider<AppManagementService>((ref) {
  return AppManagementService(ref);
});

class AppManagementService {
  AppManagementService(this._ref);

  final Ref _ref;

  Future<AppDatabase> _db() => _ref.read(databaseProvider.future);

  void _refresh() {
    _ref.invalidate(databaseProvider);
  }

  Future<Map<String, dynamic>> exportBackup() async {
    final db = await _db();
    final expenses = await db.select(db.expensesTable).get();
    final goals = await db.select(db.savingsGoalsTable).get();
    final subs = await db.select(db.subscriptionsTable).get();
    final loans = await db.select(db.loansTable).get();
    final settings = await db.settingsDao.getSettings();

    return {
      'version': 1,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'app': 'Vizwallet',
      'expenses': expenses.map((e) => e.toJson()).toList(),
      'goals': goals.map((g) => g.toJson()).toList(),
      'subscriptions': subs.map((s) => s.toJson()).toList(),
      'loans': loans.map((l) => l.toJson()).toList(),
      'settings': settings.toJson(),
    };
  }

  Future<void> shareExport() async {
    final backup = await exportBackup();
    final json = const JsonEncoder.withIndent('  ').convert(backup);
    final dir = await getTemporaryDirectory();
    final file = File(
      p.join(
        dir.path,
        'vizwallet_backup_${DateTime.now().millisecondsSinceEpoch}.json',
      ),
    );
    await file.writeAsString(json);
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Vizwallet backup',
      text: 'Your Vizwallet data export',
    );
  }

  Future<void> clearExpenses() async {
    final db = await _db();
    await db.customStatement('DELETE FROM expenses_table');
    _refresh();
  }

  Future<void> resetBudgets() async {
    final db = await _db();
    await db.customStatement('DELETE FROM budget_buckets_table');
    await db.customStatement('DELETE FROM budget_plans_table');
    _refresh();
  }

  Future<void> resetGoals() async {
    final db = await _db();
    await db.customStatement(
      'DELETE FROM savings_goals_table WHERE is_wishlist = 0',
    );
    _refresh();
  }

  Future<void> resetWishlist() async {
    final db = await _db();
    await db.customStatement(
      'DELETE FROM savings_goals_table WHERE is_wishlist = 1',
    );
    _refresh();
  }

  Future<void> clearSubscriptions() async {
    final db = await _db();
    await db.customStatement('DELETE FROM subscription_payments_table');
    await db.customStatement('DELETE FROM subscriptions_table');
    _refresh();
  }

  Future<void> clearLoans() async {
    final db = await _db();
    await db.customStatement('DELETE FROM loan_payments_table');
    await db.customStatement('DELETE FROM loans_table');
    _refresh();
  }

  Future<void> clearActivityLog() async {
    final db = await _db();
    await db.customStatement('DELETE FROM activity_log_table');
    _refresh();
  }

  Future<void> factoryReset() async {
    final db = await _db();
    await db.close();
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'vis_wallet.sqlite'));
    if (await file.exists()) {
      await file.delete();
    }
    _refresh();
  }
}
