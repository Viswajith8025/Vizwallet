import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rupee_track/bootstrap.dart';
import 'package:rupee_track/features/monthly_report/domain/monthly_closing_report.dart';

class MonthlyReportStore {
  static const _generatedKey = 'monthly_reports_generated_cycles';

  Future<Directory> _reportsDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'monthly_reports'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Set<String> get generatedCycleKeys {
    final raw = sharedPreferences.getStringList(_generatedKey);
    return raw?.toSet() ?? {};
  }

  Future<void> markGenerated(String cycleKey) async {
    final keys = generatedCycleKeys..add(cycleKey);
    await sharedPreferences.setStringList(
      _generatedKey,
      keys.toList()..sort(),
    );
  }

  Future<bool> hasReport(String cycleKey) async {
    final file = File(await _reportPath(cycleKey));
    return file.exists();
  }

  Future<String> _reportPath(String cycleKey) async {
    final dir = await _reportsDir();
    return p.join(dir.path, '$cycleKey.json');
  }

  Future<void> saveReport(MonthlyClosingReport report) async {
    final file = File(await _reportPath(report.cycleKey));
    await file.writeAsString(jsonEncode(report.toJson()));
    await markGenerated(report.cycleKey);
  }

  Future<MonthlyClosingReport?> loadReport(String cycleKey) async {
    final file = File(await _reportPath(cycleKey));
    if (!await file.exists()) return null;
    final decoded =
        jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return MonthlyClosingReport.fromJson(decoded);
  }

  Future<List<String>> listStoredCycleKeys() async {
    final dir = await _reportsDir();
    if (!await dir.exists()) return [];
    final files = await dir
        .list()
        .where((e) => e is File && e.path.endsWith('.json'))
        .cast<File>()
        .toList();
    return files.map((f) => p.basenameWithoutExtension(f.path)).toList()
      ..sort((a, b) => b.compareTo(a));
  }
}
