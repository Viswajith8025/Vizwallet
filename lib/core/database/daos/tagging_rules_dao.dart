import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/tables.dart';

part 'tagging_rules_dao.g.dart';

@DriftAccessor(tables: [TaggingRulesTable])
class TaggingRulesDao extends DatabaseAccessor<AppDatabase>
    with _$TaggingRulesDaoMixin {
  TaggingRulesDao(super.db);

  Future<List<TaggingRulesTableData>> getAllRules() {
    return select(taggingRulesTable).get();
  }

  Future<List<TaggingRulesTableData>> rulesBySource(String source) {
    return (select(taggingRulesTable)..where((t) => t.source.equals(source)))
        .get();
  }

  Future<TaggingRulesTableData?> findTitleRule(String normalizedPattern) {
    return (select(taggingRulesTable)
          ..where((t) => t.pattern.equals(normalizedPattern))
          ..where((t) => t.matchField.equals('title')))
        .getSingleOrNull();
  }

  Future<void> upsertRule({
    required String pattern,
    required String matchField,
    String? categorySlug,
    required List<String> tags,
    required String source,
    required double confidence,
  }) async {
    final existing = await (select(taggingRulesTable)
          ..where((t) => t.pattern.equals(pattern))
          ..where((t) => t.matchField.equals(matchField)))
        .getSingleOrNull();

    if (existing == null) {
      await into(taggingRulesTable).insert(
        TaggingRulesTableCompanion.insert(
          pattern: pattern,
          matchField: Value(matchField),
          categorySlug: Value(categorySlug),
          tags: Value(jsonEncode(tags)),
          source: source,
          confidence: Value(confidence),
        ),
      );
      return;
    }

    if (source == 'user') {
      await (update(taggingRulesTable)..where((t) => t.id.equals(existing.id)))
          .write(
        TaggingRulesTableCompanion(
          categorySlug: Value(categorySlug),
          tags: Value(jsonEncode(tags)),
          source: Value(source),
          confidence: Value(confidence),
          useCount: Value(existing.useCount + 1),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      return;
    }

    await (update(taggingRulesTable)..where((t) => t.id.equals(existing.id)))
        .write(
      TaggingRulesTableCompanion(
        useCount: Value(existing.useCount + 1),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> incrementUseCount(int id) async {
    final row = await (select(taggingRulesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;
    await (update(taggingRulesTable)..where((t) => t.id.equals(id))).write(
      TaggingRulesTableCompanion(
        useCount: Value(row.useCount + 1),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}
