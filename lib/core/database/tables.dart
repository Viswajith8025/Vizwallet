import 'package:drift/drift.dart';

class AppSettingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get currencyCode => text().withDefault(const Constant('INR'))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  IntColumn get majorExpenseThresholdPaise =>
      integer().withDefault(const Constant(50000))();
  IntColumn get largeExpenseThresholdPaise =>
      integer().withDefault(const Constant(200000))();
  IntColumn get veryLargeExpenseThresholdPaise =>
      integer().withDefault(const Constant(1000000))();
  IntColumn get majorPurchaseThresholdPaise =>
      integer().withDefault(const Constant(500000))();
  IntColumn get salaryDay => integer().withDefault(const Constant(1))();
  IntColumn get recycleBinRetentionDays =>
      integer().withDefault(const Constant(30))();
  BoolColumn get pinEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get pinHash => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class MonthlySalaryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get monthKey => text().unique()();
  IntColumn get amountPaise => integer()();
  DateTimeColumn get receivedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class CategoriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get slug => text().unique()();
  TextColumn get iconName => text().withDefault(const Constant('category'))();
  IntColumn get colorValue => integer().withDefault(const Constant(0xFF9E9E9E))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(true))();
  BoolColumn get countsTowardSpending =>
      boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class ExpensesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amountPaise => integer()();
  IntColumn get categoryId => integer().references(CategoriesTable, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get monthKey => text()();
  TextColumn get paymentMethod => text().withDefault(const Constant('UPI'))();
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  TextColumn get notes => text().nullable()();
  IntColumn get subscriptionId => integer().nullable()();
  IntColumn get loanPaymentId => integer().nullable()();
  TextColumn get autoLabels => text().withDefault(const Constant('[]'))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class SubscriptionsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get amountPaise => integer()();
  IntColumn get categoryId => integer().nullable().references(CategoriesTable, #id)();
  TextColumn get billingCycle =>
      text().withDefault(const Constant('monthly'))();
  IntColumn get billingIntervalDays => integer().nullable()();
  DateTimeColumn get nextRenewalAt => dateTime().nullable()();
  TextColumn get paymentMethod => text().withDefault(const Constant('Auto Debit'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get usageFrequency => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class SubscriptionPaymentsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get subscriptionId =>
      integer().references(SubscriptionsTable, #id)();
  IntColumn get amountPaise => integer()();
  DateTimeColumn get paidAt => dateTime()();
  TextColumn get monthKey => text()();
  IntColumn get expenseId => integer().nullable()();
  TextColumn get status => text().withDefault(const Constant('paid'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class LoansTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get personName => text()();
  TextColumn get direction =>
      text().withDefault(const Constant('borrowed_by_me'))();
  IntColumn get principalPaise => integer()();
  IntColumn get balancePaise => integer()();
  TextColumn get reason => text().nullable()();
  DateTimeColumn get borrowedAt => dateTime()();
  DateTimeColumn get expectedReturnAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get notes => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class LoanPaymentsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get loanId => integer().references(LoansTable, #id)();
  IntColumn get amountPaise => integer()();
  DateTimeColumn get paidAt => dateTime()();
  TextColumn get notes => text().nullable()();
  IntColumn get expenseId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class BudgetPlansTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get monthKey => text().unique()();
  IntColumn get salaryPaise => integer()();
  TextColumn get allocationMode =>
      text().withDefault(const Constant('percentage'))();
  BoolColumn get rolloverEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get aiNotes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class BudgetBucketsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer().references(BudgetPlansTable, #id)();
  TextColumn get bucketKey => text()();
  TextColumn get displayName => text()();
  IntColumn get categoryId => integer().nullable().references(CategoriesTable, #id)();
  TextColumn get bucketType =>
      text().withDefault(const Constant('spending'))();
  IntColumn get allocatedPaise => integer()();
  RealColumn get allocatedPercent => real().nullable()();
  IntColumn get rolloverPaise => integer().withDefault(const Constant(0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {planId, bucketKey},
      ];
}

/// Income streams — v1 seeds one primary monthly salary; future multi-income.
class IncomeSourcesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant('Primary salary'))();
  TextColumn get cycleType =>
      text().withDefault(const Constant('monthly_day'))();
  IntColumn get dayOfMonth => integer().withDefault(const Constant(1))();
  IntColumn get weekStartDay => integer().nullable()();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Learned and built-in merchant/keyword → category + tag rules.
class SavingsGoalsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get targetPaise => integer()();
  IntColumn get savedPaise => integer().withDefault(const Constant(0))();
  IntColumn get monthlyContributionPaise =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isWishlist => boolean().withDefault(const Constant(false))();
  DateTimeColumn get targetDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Learned and built-in merchant/keyword → category + tag rules.
class TaggingRulesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pattern => text()();
  TextColumn get matchField =>
      text().withDefault(const Constant('title'))();
  TextColumn get categorySlug => text().nullable()();
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  TextColumn get source => text()();
  RealColumn get confidence => real().withDefault(const Constant(0.8))();
  IntColumn get useCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {pattern, matchField},
      ];
}

/// Immutable audit trail — append-only; never updated except isUndone flag.
class ActivityLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get action => text()();
  TextColumn get module => text()();
  IntColumn get entityId => integer().nullable()();
  TextColumn get entityLabel => text().withDefault(const Constant(''))();
  TextColumn get oldValueJson => text().nullable()();
  TextColumn get newValueJson => text().nullable()();
  TextColumn get reason => text().nullable()();
  TextColumn get severity => text().withDefault(const Constant('info'))();
  TextColumn get performedBy => text().withDefault(const Constant('user'))();
  BoolColumn get isUndoable => boolean().withDefault(const Constant(false))();
  BoolColumn get isUndone => boolean().withDefault(const Constant(false))();
  DateTimeColumn get occurredAt => dateTime().withDefault(currentDateAndTime)();
}
