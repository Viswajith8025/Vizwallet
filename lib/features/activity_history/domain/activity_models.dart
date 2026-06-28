import 'package:flutter/material.dart';

enum ActivityAction {
  created,
  updated,
  deleted,
  restored,
  cancelled,
  completed,
  imported,
  exported,
  backupCreated,
  restorePerformed,
  settingsChanged,
}

enum ActivityModule {
  expense,
  income,
  goal,
  wishlist,
  budget,
  subscription,
  loan,
  wallet,
  category,
  settings,
  backup,
  importExport,
}

enum ActivitySeverity {
  info,
  warning,
  critical,
}

class ActivityEntry {
  const ActivityEntry({
    required this.id,
    required this.action,
    required this.module,
    required this.entityLabel,
    required this.occurredAt,
    this.entityId,
    this.oldValueJson,
    this.newValueJson,
    this.reason,
    this.severity = ActivitySeverity.info,
    this.performedBy = 'You',
    this.isUndoable = false,
    this.isUndone = false,
  });

  final int id;
  final ActivityAction action;
  final ActivityModule module;
  final int? entityId;
  final String entityLabel;
  final String? oldValueJson;
  final String? newValueJson;
  final String? reason;
  final ActivitySeverity severity;
  final String performedBy;
  final bool isUndoable;
  final bool isUndone;
  final DateTime occurredAt;

  bool get canUndo => isUndoable && !isUndone;

  String get actionLabel => activityActionLabel(action);
  String get moduleLabel => activityModuleLabel(module);
}

class ActivityTimelineGroup {
  const ActivityTimelineGroup({
    required this.dateLabel,
    required this.entries,
  });

  final String dateLabel;
  final List<ActivityEntry> entries;
}

class ActivityFilters {
  const ActivityFilters({
    this.query = '',
    this.module,
    this.action,
    this.severity,
    this.daysBack = 30,
  });

  final String query;
  final ActivityModule? module;
  final ActivityAction? action;
  final ActivitySeverity? severity;
  final int daysBack;

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      module != null ||
      action != null ||
      severity != null ||
      daysBack != 30;

  ActivityFilters copyWith({
    String? query,
    ActivityModule? module,
    ActivityAction? action,
    ActivitySeverity? severity,
    int? daysBack,
    bool clearModule = false,
    bool clearAction = false,
    bool clearSeverity = false,
  }) {
    return ActivityFilters(
      query: query ?? this.query,
      module: clearModule ? null : (module ?? this.module),
      action: clearAction ? null : (action ?? this.action),
      severity: clearSeverity ? null : (severity ?? this.severity),
      daysBack: daysBack ?? this.daysBack,
    );
  }
}

class RecycleBinItem {
  const RecycleBinItem({
    required this.id,
    required this.module,
    required this.title,
    required this.subtitle,
    required this.deletedAt,
    this.amountPaise,
    this.icon = Icons.delete_outline,
    this.colorValue,
  });

  final String id;
  final ActivityModule module;
  final String title;
  final String subtitle;
  final DateTime? deletedAt;
  final int? amountPaise;
  final IconData icon;
  final int? colorValue;
}

String activityActionLabel(ActivityAction action) => switch (action) {
      ActivityAction.created => 'Created',
      ActivityAction.updated => 'Updated',
      ActivityAction.deleted => 'Deleted',
      ActivityAction.restored => 'Restored',
      ActivityAction.cancelled => 'Cancelled',
      ActivityAction.completed => 'Completed',
      ActivityAction.imported => 'Imported',
      ActivityAction.exported => 'Exported',
      ActivityAction.backupCreated => 'Backup created',
      ActivityAction.restorePerformed => 'Restore performed',
      ActivityAction.settingsChanged => 'Settings changed',
    };

String activityModuleLabel(ActivityModule module) => switch (module) {
      ActivityModule.expense => 'Expense',
      ActivityModule.income => 'Income',
      ActivityModule.goal => 'Goal',
      ActivityModule.wishlist => 'Wishlist',
      ActivityModule.budget => 'Budget',
      ActivityModule.subscription => 'Subscription',
      ActivityModule.loan => 'Loan',
      ActivityModule.wallet => 'Wallet',
      ActivityModule.category => 'Category',
      ActivityModule.settings => 'Settings',
      ActivityModule.backup => 'Backup',
      ActivityModule.importExport => 'Import / Export',
    };

String activityActionKey(ActivityAction action) => action.name;

String activityModuleKey(ActivityModule module) => module.name;

String activitySeverityKey(ActivitySeverity severity) => severity.name;

ActivityAction? activityActionFromKey(String? key) {
  if (key == null) return null;
  for (final action in ActivityAction.values) {
    if (action.name == key) return action;
  }
  return null;
}

ActivityModule? activityModuleFromKey(String? key) {
  if (key == null) return null;
  for (final module in ActivityModule.values) {
    if (module.name == key) return module;
  }
  return null;
}

ActivitySeverity? activitySeverityFromKey(String? key) {
  if (key == null) return null;
  for (final severity in ActivitySeverity.values) {
    if (severity.name == key) return severity;
  }
  return null;
}

IconData activityModuleIcon(ActivityModule module) => switch (module) {
      ActivityModule.expense => Icons.receipt_long_outlined,
      ActivityModule.income => Icons.payments_outlined,
      ActivityModule.goal => Icons.flag_outlined,
      ActivityModule.wishlist => Icons.favorite_border,
      ActivityModule.budget => Icons.pie_chart_outline,
      ActivityModule.subscription => Icons.subscriptions_outlined,
      ActivityModule.loan => Icons.handshake_outlined,
      ActivityModule.wallet => Icons.account_balance_wallet_outlined,
      ActivityModule.category => Icons.category_outlined,
      ActivityModule.settings => Icons.settings_outlined,
      ActivityModule.backup => Icons.backup_outlined,
      ActivityModule.importExport => Icons.import_export_outlined,
    };

Color activitySeverityColor(ActivitySeverity severity, ColorScheme scheme) =>
    switch (severity) {
      ActivitySeverity.info => scheme.primary,
      ActivitySeverity.warning => const Color(0xFFFF9800),
      ActivitySeverity.critical => scheme.error,
    };
