// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('INR'));
  static const VerificationMeta _themeModeMeta =
      const VerificationMeta('themeMode');
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('system'));
  static const VerificationMeta _majorExpenseThresholdPaiseMeta =
      const VerificationMeta('majorExpenseThresholdPaise');
  @override
  late final GeneratedColumn<int> majorExpenseThresholdPaise =
      GeneratedColumn<int>('major_expense_threshold_paise', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(10000));
  static const VerificationMeta _largeExpenseThresholdPaiseMeta =
      const VerificationMeta('largeExpenseThresholdPaise');
  @override
  late final GeneratedColumn<int> largeExpenseThresholdPaise =
      GeneratedColumn<int>('large_expense_threshold_paise', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(50000));
  static const VerificationMeta _veryLargeExpenseThresholdPaiseMeta =
      const VerificationMeta('veryLargeExpenseThresholdPaise');
  @override
  late final GeneratedColumn<int> veryLargeExpenseThresholdPaise =
      GeneratedColumn<int>(
          'very_large_expense_threshold_paise', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(100000));
  static const VerificationMeta _majorPurchaseThresholdPaiseMeta =
      const VerificationMeta('majorPurchaseThresholdPaise');
  @override
  late final GeneratedColumn<int> majorPurchaseThresholdPaise =
      GeneratedColumn<int>('major_purchase_threshold_paise', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(500000));
  static const VerificationMeta _salaryDayMeta =
      const VerificationMeta('salaryDay');
  @override
  late final GeneratedColumn<int> salaryDay = GeneratedColumn<int>(
      'salary_day', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _pinEnabledMeta =
      const VerificationMeta('pinEnabled');
  @override
  late final GeneratedColumn<bool> pinEnabled = GeneratedColumn<bool>(
      'pin_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("pin_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        currencyCode,
        themeMode,
        majorExpenseThresholdPaise,
        largeExpenseThresholdPaise,
        veryLargeExpenseThresholdPaise,
        majorPurchaseThresholdPaise,
        salaryDay,
        pinEnabled,
        pinHash,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AppSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(_themeModeMeta,
          themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta));
    }
    if (data.containsKey('major_expense_threshold_paise')) {
      context.handle(
          _majorExpenseThresholdPaiseMeta,
          majorExpenseThresholdPaise.isAcceptableOrUnknown(
              data['major_expense_threshold_paise']!,
              _majorExpenseThresholdPaiseMeta));
    }
    if (data.containsKey('large_expense_threshold_paise')) {
      context.handle(
          _largeExpenseThresholdPaiseMeta,
          largeExpenseThresholdPaise.isAcceptableOrUnknown(
              data['large_expense_threshold_paise']!,
              _largeExpenseThresholdPaiseMeta));
    }
    if (data.containsKey('very_large_expense_threshold_paise')) {
      context.handle(
          _veryLargeExpenseThresholdPaiseMeta,
          veryLargeExpenseThresholdPaise.isAcceptableOrUnknown(
              data['very_large_expense_threshold_paise']!,
              _veryLargeExpenseThresholdPaiseMeta));
    }
    if (data.containsKey('major_purchase_threshold_paise')) {
      context.handle(
          _majorPurchaseThresholdPaiseMeta,
          majorPurchaseThresholdPaise.isAcceptableOrUnknown(
              data['major_purchase_threshold_paise']!,
              _majorPurchaseThresholdPaiseMeta));
    }
    if (data.containsKey('salary_day')) {
      context.handle(_salaryDayMeta,
          salaryDay.isAcceptableOrUnknown(data['salary_day']!, _salaryDayMeta));
    }
    if (data.containsKey('pin_enabled')) {
      context.handle(
          _pinEnabledMeta,
          pinEnabled.isAcceptableOrUnknown(
              data['pin_enabled']!, _pinEnabledMeta));
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      themeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_mode'])!,
      majorExpenseThresholdPaise: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}major_expense_threshold_paise'])!,
      largeExpenseThresholdPaise: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}large_expense_threshold_paise'])!,
      veryLargeExpenseThresholdPaise: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}very_large_expense_threshold_paise'])!,
      majorPurchaseThresholdPaise: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}major_purchase_threshold_paise'])!,
      salaryDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}salary_day'])!,
      pinEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pin_enabled'])!,
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final int id;
  final String currencyCode;
  final String themeMode;
  final int majorExpenseThresholdPaise;
  final int largeExpenseThresholdPaise;
  final int veryLargeExpenseThresholdPaise;
  final int majorPurchaseThresholdPaise;
  final int salaryDay;
  final bool pinEnabled;
  final String? pinHash;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AppSettingsTableData(
      {required this.id,
      required this.currencyCode,
      required this.themeMode,
      required this.majorExpenseThresholdPaise,
      required this.largeExpenseThresholdPaise,
      required this.veryLargeExpenseThresholdPaise,
      required this.majorPurchaseThresholdPaise,
      required this.salaryDay,
      required this.pinEnabled,
      this.pinHash,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['currency_code'] = Variable<String>(currencyCode);
    map['theme_mode'] = Variable<String>(themeMode);
    map['major_expense_threshold_paise'] =
        Variable<int>(majorExpenseThresholdPaise);
    map['large_expense_threshold_paise'] =
        Variable<int>(largeExpenseThresholdPaise);
    map['very_large_expense_threshold_paise'] =
        Variable<int>(veryLargeExpenseThresholdPaise);
    map['major_purchase_threshold_paise'] =
        Variable<int>(majorPurchaseThresholdPaise);
    map['salary_day'] = Variable<int>(salaryDay);
    map['pin_enabled'] = Variable<bool>(pinEnabled);
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      currencyCode: Value(currencyCode),
      themeMode: Value(themeMode),
      majorExpenseThresholdPaise: Value(majorExpenseThresholdPaise),
      largeExpenseThresholdPaise: Value(largeExpenseThresholdPaise),
      veryLargeExpenseThresholdPaise: Value(veryLargeExpenseThresholdPaise),
      majorPurchaseThresholdPaise: Value(majorPurchaseThresholdPaise),
      salaryDay: Value(salaryDay),
      pinEnabled: Value(pinEnabled),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      majorExpenseThresholdPaise:
          serializer.fromJson<int>(json['majorExpenseThresholdPaise']),
      largeExpenseThresholdPaise:
          serializer.fromJson<int>(json['largeExpenseThresholdPaise']),
      veryLargeExpenseThresholdPaise:
          serializer.fromJson<int>(json['veryLargeExpenseThresholdPaise']),
      majorPurchaseThresholdPaise:
          serializer.fromJson<int>(json['majorPurchaseThresholdPaise']),
      salaryDay: serializer.fromJson<int>(json['salaryDay']),
      pinEnabled: serializer.fromJson<bool>(json['pinEnabled']),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'themeMode': serializer.toJson<String>(themeMode),
      'majorExpenseThresholdPaise':
          serializer.toJson<int>(majorExpenseThresholdPaise),
      'largeExpenseThresholdPaise':
          serializer.toJson<int>(largeExpenseThresholdPaise),
      'veryLargeExpenseThresholdPaise':
          serializer.toJson<int>(veryLargeExpenseThresholdPaise),
      'majorPurchaseThresholdPaise':
          serializer.toJson<int>(majorPurchaseThresholdPaise),
      'salaryDay': serializer.toJson<int>(salaryDay),
      'pinEnabled': serializer.toJson<bool>(pinEnabled),
      'pinHash': serializer.toJson<String?>(pinHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSettingsTableData copyWith(
          {int? id,
          String? currencyCode,
          String? themeMode,
          int? majorExpenseThresholdPaise,
          int? largeExpenseThresholdPaise,
          int? veryLargeExpenseThresholdPaise,
          int? majorPurchaseThresholdPaise,
          int? salaryDay,
          bool? pinEnabled,
          Value<String?> pinHash = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      AppSettingsTableData(
        id: id ?? this.id,
        currencyCode: currencyCode ?? this.currencyCode,
        themeMode: themeMode ?? this.themeMode,
        majorExpenseThresholdPaise:
            majorExpenseThresholdPaise ?? this.majorExpenseThresholdPaise,
        largeExpenseThresholdPaise:
            largeExpenseThresholdPaise ?? this.largeExpenseThresholdPaise,
        veryLargeExpenseThresholdPaise: veryLargeExpenseThresholdPaise ??
            this.veryLargeExpenseThresholdPaise,
        majorPurchaseThresholdPaise:
            majorPurchaseThresholdPaise ?? this.majorPurchaseThresholdPaise,
        salaryDay: salaryDay ?? this.salaryDay,
        pinEnabled: pinEnabled ?? this.pinEnabled,
        pinHash: pinHash.present ? pinHash.value : this.pinHash,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      majorExpenseThresholdPaise: data.majorExpenseThresholdPaise.present
          ? data.majorExpenseThresholdPaise.value
          : this.majorExpenseThresholdPaise,
      largeExpenseThresholdPaise: data.largeExpenseThresholdPaise.present
          ? data.largeExpenseThresholdPaise.value
          : this.largeExpenseThresholdPaise,
      veryLargeExpenseThresholdPaise:
          data.veryLargeExpenseThresholdPaise.present
              ? data.veryLargeExpenseThresholdPaise.value
              : this.veryLargeExpenseThresholdPaise,
      majorPurchaseThresholdPaise: data.majorPurchaseThresholdPaise.present
          ? data.majorPurchaseThresholdPaise.value
          : this.majorPurchaseThresholdPaise,
      salaryDay: data.salaryDay.present ? data.salaryDay.value : this.salaryDay,
      pinEnabled:
          data.pinEnabled.present ? data.pinEnabled.value : this.pinEnabled,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('id: $id, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('themeMode: $themeMode, ')
          ..write('majorExpenseThresholdPaise: $majorExpenseThresholdPaise, ')
          ..write('largeExpenseThresholdPaise: $largeExpenseThresholdPaise, ')
          ..write(
              'veryLargeExpenseThresholdPaise: $veryLargeExpenseThresholdPaise, ')
          ..write('majorPurchaseThresholdPaise: $majorPurchaseThresholdPaise, ')
          ..write('salaryDay: $salaryDay, ')
          ..write('pinEnabled: $pinEnabled, ')
          ..write('pinHash: $pinHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      currencyCode,
      themeMode,
      majorExpenseThresholdPaise,
      largeExpenseThresholdPaise,
      veryLargeExpenseThresholdPaise,
      majorPurchaseThresholdPaise,
      salaryDay,
      pinEnabled,
      pinHash,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.id == this.id &&
          other.currencyCode == this.currencyCode &&
          other.themeMode == this.themeMode &&
          other.majorExpenseThresholdPaise == this.majorExpenseThresholdPaise &&
          other.largeExpenseThresholdPaise == this.largeExpenseThresholdPaise &&
          other.veryLargeExpenseThresholdPaise ==
              this.veryLargeExpenseThresholdPaise &&
          other.majorPurchaseThresholdPaise ==
              this.majorPurchaseThresholdPaise &&
          other.salaryDay == this.salaryDay &&
          other.pinEnabled == this.pinEnabled &&
          other.pinHash == this.pinHash &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<int> id;
  final Value<String> currencyCode;
  final Value<String> themeMode;
  final Value<int> majorExpenseThresholdPaise;
  final Value<int> largeExpenseThresholdPaise;
  final Value<int> veryLargeExpenseThresholdPaise;
  final Value<int> majorPurchaseThresholdPaise;
  final Value<int> salaryDay;
  final Value<bool> pinEnabled;
  final Value<String?> pinHash;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.majorExpenseThresholdPaise = const Value.absent(),
    this.largeExpenseThresholdPaise = const Value.absent(),
    this.veryLargeExpenseThresholdPaise = const Value.absent(),
    this.majorPurchaseThresholdPaise = const Value.absent(),
    this.salaryDay = const Value.absent(),
    this.pinEnabled = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.majorExpenseThresholdPaise = const Value.absent(),
    this.largeExpenseThresholdPaise = const Value.absent(),
    this.veryLargeExpenseThresholdPaise = const Value.absent(),
    this.majorPurchaseThresholdPaise = const Value.absent(),
    this.salaryDay = const Value.absent(),
    this.pinEnabled = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<AppSettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? currencyCode,
    Expression<String>? themeMode,
    Expression<int>? majorExpenseThresholdPaise,
    Expression<int>? largeExpenseThresholdPaise,
    Expression<int>? veryLargeExpenseThresholdPaise,
    Expression<int>? majorPurchaseThresholdPaise,
    Expression<int>? salaryDay,
    Expression<bool>? pinEnabled,
    Expression<String>? pinHash,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (themeMode != null) 'theme_mode': themeMode,
      if (majorExpenseThresholdPaise != null)
        'major_expense_threshold_paise': majorExpenseThresholdPaise,
      if (largeExpenseThresholdPaise != null)
        'large_expense_threshold_paise': largeExpenseThresholdPaise,
      if (veryLargeExpenseThresholdPaise != null)
        'very_large_expense_threshold_paise': veryLargeExpenseThresholdPaise,
      if (majorPurchaseThresholdPaise != null)
        'major_purchase_threshold_paise': majorPurchaseThresholdPaise,
      if (salaryDay != null) 'salary_day': salaryDay,
      if (pinEnabled != null) 'pin_enabled': pinEnabled,
      if (pinHash != null) 'pin_hash': pinHash,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppSettingsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? currencyCode,
      Value<String>? themeMode,
      Value<int>? majorExpenseThresholdPaise,
      Value<int>? largeExpenseThresholdPaise,
      Value<int>? veryLargeExpenseThresholdPaise,
      Value<int>? majorPurchaseThresholdPaise,
      Value<int>? salaryDay,
      Value<bool>? pinEnabled,
      Value<String?>? pinHash,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      currencyCode: currencyCode ?? this.currencyCode,
      themeMode: themeMode ?? this.themeMode,
      majorExpenseThresholdPaise:
          majorExpenseThresholdPaise ?? this.majorExpenseThresholdPaise,
      largeExpenseThresholdPaise:
          largeExpenseThresholdPaise ?? this.largeExpenseThresholdPaise,
      veryLargeExpenseThresholdPaise:
          veryLargeExpenseThresholdPaise ?? this.veryLargeExpenseThresholdPaise,
      majorPurchaseThresholdPaise:
          majorPurchaseThresholdPaise ?? this.majorPurchaseThresholdPaise,
      salaryDay: salaryDay ?? this.salaryDay,
      pinEnabled: pinEnabled ?? this.pinEnabled,
      pinHash: pinHash ?? this.pinHash,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (majorExpenseThresholdPaise.present) {
      map['major_expense_threshold_paise'] =
          Variable<int>(majorExpenseThresholdPaise.value);
    }
    if (largeExpenseThresholdPaise.present) {
      map['large_expense_threshold_paise'] =
          Variable<int>(largeExpenseThresholdPaise.value);
    }
    if (veryLargeExpenseThresholdPaise.present) {
      map['very_large_expense_threshold_paise'] =
          Variable<int>(veryLargeExpenseThresholdPaise.value);
    }
    if (majorPurchaseThresholdPaise.present) {
      map['major_purchase_threshold_paise'] =
          Variable<int>(majorPurchaseThresholdPaise.value);
    }
    if (salaryDay.present) {
      map['salary_day'] = Variable<int>(salaryDay.value);
    }
    if (pinEnabled.present) {
      map['pin_enabled'] = Variable<bool>(pinEnabled.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('themeMode: $themeMode, ')
          ..write('majorExpenseThresholdPaise: $majorExpenseThresholdPaise, ')
          ..write('largeExpenseThresholdPaise: $largeExpenseThresholdPaise, ')
          ..write(
              'veryLargeExpenseThresholdPaise: $veryLargeExpenseThresholdPaise, ')
          ..write('majorPurchaseThresholdPaise: $majorPurchaseThresholdPaise, ')
          ..write('salaryDay: $salaryDay, ')
          ..write('pinEnabled: $pinEnabled, ')
          ..write('pinHash: $pinHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MonthlySalaryTableTable extends MonthlySalaryTable
    with TableInfo<$MonthlySalaryTableTable, MonthlySalaryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlySalaryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _monthKeyMeta =
      const VerificationMeta('monthKey');
  @override
  late final GeneratedColumn<String> monthKey = GeneratedColumn<String>(
      'month_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _amountPaiseMeta =
      const VerificationMeta('amountPaise');
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
      'amount_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _receivedAtMeta =
      const VerificationMeta('receivedAt');
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
      'received_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, monthKey, amountPaise, receivedAt, notes, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_salary_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<MonthlySalaryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('month_key')) {
      context.handle(_monthKeyMeta,
          monthKey.isAcceptableOrUnknown(data['month_key']!, _monthKeyMeta));
    } else if (isInserting) {
      context.missing(_monthKeyMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
          _amountPaiseMeta,
          amountPaise.isAcceptableOrUnknown(
              data['amount_paise']!, _amountPaiseMeta));
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
          _receivedAtMeta,
          receivedAt.isAcceptableOrUnknown(
              data['received_at']!, _receivedAtMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonthlySalaryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlySalaryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      monthKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}month_key'])!,
      amountPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paise'])!,
      receivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}received_at']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MonthlySalaryTableTable createAlias(String alias) {
    return $MonthlySalaryTableTable(attachedDatabase, alias);
  }
}

class MonthlySalaryTableData extends DataClass
    implements Insertable<MonthlySalaryTableData> {
  final int id;
  final String monthKey;
  final int amountPaise;
  final DateTime? receivedAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MonthlySalaryTableData(
      {required this.id,
      required this.monthKey,
      required this.amountPaise,
      this.receivedAt,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['month_key'] = Variable<String>(monthKey);
    map['amount_paise'] = Variable<int>(amountPaise);
    if (!nullToAbsent || receivedAt != null) {
      map['received_at'] = Variable<DateTime>(receivedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MonthlySalaryTableCompanion toCompanion(bool nullToAbsent) {
    return MonthlySalaryTableCompanion(
      id: Value(id),
      monthKey: Value(monthKey),
      amountPaise: Value(amountPaise),
      receivedAt: receivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(receivedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MonthlySalaryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlySalaryTableData(
      id: serializer.fromJson<int>(json['id']),
      monthKey: serializer.fromJson<String>(json['monthKey']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      receivedAt: serializer.fromJson<DateTime?>(json['receivedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'monthKey': serializer.toJson<String>(monthKey),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'receivedAt': serializer.toJson<DateTime?>(receivedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MonthlySalaryTableData copyWith(
          {int? id,
          String? monthKey,
          int? amountPaise,
          Value<DateTime?> receivedAt = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MonthlySalaryTableData(
        id: id ?? this.id,
        monthKey: monthKey ?? this.monthKey,
        amountPaise: amountPaise ?? this.amountPaise,
        receivedAt: receivedAt.present ? receivedAt.value : this.receivedAt,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MonthlySalaryTableData copyWithCompanion(MonthlySalaryTableCompanion data) {
    return MonthlySalaryTableData(
      id: data.id.present ? data.id.value : this.id,
      monthKey: data.monthKey.present ? data.monthKey.value : this.monthKey,
      amountPaise:
          data.amountPaise.present ? data.amountPaise.value : this.amountPaise,
      receivedAt:
          data.receivedAt.present ? data.receivedAt.value : this.receivedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlySalaryTableData(')
          ..write('id: $id, ')
          ..write('monthKey: $monthKey, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, monthKey, amountPaise, receivedAt, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlySalaryTableData &&
          other.id == this.id &&
          other.monthKey == this.monthKey &&
          other.amountPaise == this.amountPaise &&
          other.receivedAt == this.receivedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MonthlySalaryTableCompanion
    extends UpdateCompanion<MonthlySalaryTableData> {
  final Value<int> id;
  final Value<String> monthKey;
  final Value<int> amountPaise;
  final Value<DateTime?> receivedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MonthlySalaryTableCompanion({
    this.id = const Value.absent(),
    this.monthKey = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MonthlySalaryTableCompanion.insert({
    this.id = const Value.absent(),
    required String monthKey,
    required int amountPaise,
    this.receivedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : monthKey = Value(monthKey),
        amountPaise = Value(amountPaise);
  static Insertable<MonthlySalaryTableData> custom({
    Expression<int>? id,
    Expression<String>? monthKey,
    Expression<int>? amountPaise,
    Expression<DateTime>? receivedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monthKey != null) 'month_key': monthKey,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (receivedAt != null) 'received_at': receivedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MonthlySalaryTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? monthKey,
      Value<int>? amountPaise,
      Value<DateTime?>? receivedAt,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MonthlySalaryTableCompanion(
      id: id ?? this.id,
      monthKey: monthKey ?? this.monthKey,
      amountPaise: amountPaise ?? this.amountPaise,
      receivedAt: receivedAt ?? this.receivedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (monthKey.present) {
      map['month_key'] = Variable<String>(monthKey.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlySalaryTableCompanion(')
          ..write('id: $id, ')
          ..write('monthKey: $monthKey, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('category'));
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFF9E9E9E));
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
      'is_system', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _countsTowardSpendingMeta =
      const VerificationMeta('countsTowardSpending');
  @override
  late final GeneratedColumn<bool> countsTowardSpending = GeneratedColumn<bool>(
      'counts_toward_spending', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("counts_toward_spending" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        slug,
        iconName,
        colorValue,
        isSystem,
        countsTowardSpending,
        sortOrder,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CategoriesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    if (data.containsKey('counts_toward_spending')) {
      context.handle(
          _countsTowardSpendingMeta,
          countsTowardSpending.isAcceptableOrUnknown(
              data['counts_toward_spending']!, _countsTowardSpendingMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
      countsTowardSpending: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}counts_toward_spending'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final int id;
  final String name;
  final String slug;
  final String iconName;
  final int colorValue;
  final bool isSystem;
  final bool countsTowardSpending;
  final int sortOrder;
  final bool isDeleted;
  const CategoriesTableData(
      {required this.id,
      required this.name,
      required this.slug,
      required this.iconName,
      required this.colorValue,
      required this.isSystem,
      required this.countsTowardSpending,
      required this.sortOrder,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    map['icon_name'] = Variable<String>(iconName);
    map['color_value'] = Variable<int>(colorValue);
    map['is_system'] = Variable<bool>(isSystem);
    map['counts_toward_spending'] = Variable<bool>(countsTowardSpending);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      slug: Value(slug),
      iconName: Value(iconName),
      colorValue: Value(colorValue),
      isSystem: Value(isSystem),
      countsTowardSpending: Value(countsTowardSpending),
      sortOrder: Value(sortOrder),
      isDeleted: Value(isDeleted),
    );
  }

  factory CategoriesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      iconName: serializer.fromJson<String>(json['iconName']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      countsTowardSpending:
          serializer.fromJson<bool>(json['countsTowardSpending']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'iconName': serializer.toJson<String>(iconName),
      'colorValue': serializer.toJson<int>(colorValue),
      'isSystem': serializer.toJson<bool>(isSystem),
      'countsTowardSpending': serializer.toJson<bool>(countsTowardSpending),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  CategoriesTableData copyWith(
          {int? id,
          String? name,
          String? slug,
          String? iconName,
          int? colorValue,
          bool? isSystem,
          bool? countsTowardSpending,
          int? sortOrder,
          bool? isDeleted}) =>
      CategoriesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        iconName: iconName ?? this.iconName,
        colorValue: colorValue ?? this.colorValue,
        isSystem: isSystem ?? this.isSystem,
        countsTowardSpending: countsTowardSpending ?? this.countsTowardSpending,
        sortOrder: sortOrder ?? this.sortOrder,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      countsTowardSpending: data.countsTowardSpending.present
          ? data.countsTowardSpending.value
          : this.countsTowardSpending,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('iconName: $iconName, ')
          ..write('colorValue: $colorValue, ')
          ..write('isSystem: $isSystem, ')
          ..write('countsTowardSpending: $countsTowardSpending, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, slug, iconName, colorValue,
      isSystem, countsTowardSpending, sortOrder, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.iconName == this.iconName &&
          other.colorValue == this.colorValue &&
          other.isSystem == this.isSystem &&
          other.countsTowardSpending == this.countsTowardSpending &&
          other.sortOrder == this.sortOrder &&
          other.isDeleted == this.isDeleted);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> slug;
  final Value<String> iconName;
  final Value<int> colorValue;
  final Value<bool> isSystem;
  final Value<bool> countsTowardSpending;
  final Value<int> sortOrder;
  final Value<bool> isDeleted;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.countsTowardSpending = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String slug,
    this.iconName = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.countsTowardSpending = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : name = Value(name),
        slug = Value(slug);
  static Insertable<CategoriesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? iconName,
    Expression<int>? colorValue,
    Expression<bool>? isSystem,
    Expression<bool>? countsTowardSpending,
    Expression<int>? sortOrder,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (iconName != null) 'icon_name': iconName,
      if (colorValue != null) 'color_value': colorValue,
      if (isSystem != null) 'is_system': isSystem,
      if (countsTowardSpending != null)
        'counts_toward_spending': countsTowardSpending,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  CategoriesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? slug,
      Value<String>? iconName,
      Value<int>? colorValue,
      Value<bool>? isSystem,
      Value<bool>? countsTowardSpending,
      Value<int>? sortOrder,
      Value<bool>? isDeleted}) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      isSystem: isSystem ?? this.isSystem,
      countsTowardSpending: countsTowardSpending ?? this.countsTowardSpending,
      sortOrder: sortOrder ?? this.sortOrder,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (countsTowardSpending.present) {
      map['counts_toward_spending'] =
          Variable<bool>(countsTowardSpending.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('iconName: $iconName, ')
          ..write('colorValue: $colorValue, ')
          ..write('isSystem: $isSystem, ')
          ..write('countsTowardSpending: $countsTowardSpending, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTableTable extends ExpensesTable
    with TableInfo<$ExpensesTableTable, ExpensesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _amountPaiseMeta =
      const VerificationMeta('amountPaise');
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
      'amount_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories_table (id)'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _monthKeyMeta =
      const VerificationMeta('monthKey');
  @override
  late final GeneratedColumn<String> monthKey = GeneratedColumn<String>(
      'month_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('UPI'));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subscriptionIdMeta =
      const VerificationMeta('subscriptionId');
  @override
  late final GeneratedColumn<int> subscriptionId = GeneratedColumn<int>(
      'subscription_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _loanPaymentIdMeta =
      const VerificationMeta('loanPaymentId');
  @override
  late final GeneratedColumn<int> loanPaymentId = GeneratedColumn<int>(
      'loan_payment_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _autoLabelsMeta =
      const VerificationMeta('autoLabels');
  @override
  late final GeneratedColumn<String> autoLabels = GeneratedColumn<String>(
      'auto_labels', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        amountPaise,
        categoryId,
        title,
        description,
        occurredAt,
        monthKey,
        paymentMethod,
        tags,
        notes,
        subscriptionId,
        loanPaymentId,
        autoLabels,
        isDeleted,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses_table';
  @override
  VerificationContext validateIntegrity(Insertable<ExpensesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
          _amountPaiseMeta,
          amountPaise.isAcceptableOrUnknown(
              data['amount_paise']!, _amountPaiseMeta));
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('month_key')) {
      context.handle(_monthKeyMeta,
          monthKey.isAcceptableOrUnknown(data['month_key']!, _monthKeyMeta));
    } else if (isInserting) {
      context.missing(_monthKeyMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('subscription_id')) {
      context.handle(
          _subscriptionIdMeta,
          subscriptionId.isAcceptableOrUnknown(
              data['subscription_id']!, _subscriptionIdMeta));
    }
    if (data.containsKey('loan_payment_id')) {
      context.handle(
          _loanPaymentIdMeta,
          loanPaymentId.isAcceptableOrUnknown(
              data['loan_payment_id']!, _loanPaymentIdMeta));
    }
    if (data.containsKey('auto_labels')) {
      context.handle(
          _autoLabelsMeta,
          autoLabels.isAcceptableOrUnknown(
              data['auto_labels']!, _autoLabelsMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpensesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpensesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      amountPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paise'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
      monthKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}month_key'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      subscriptionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subscription_id']),
      loanPaymentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}loan_payment_id']),
      autoLabels: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}auto_labels'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ExpensesTableTable createAlias(String alias) {
    return $ExpensesTableTable(attachedDatabase, alias);
  }
}

class ExpensesTableData extends DataClass
    implements Insertable<ExpensesTableData> {
  final int id;
  final int amountPaise;
  final int categoryId;
  final String title;
  final String? description;
  final DateTime occurredAt;
  final String monthKey;
  final String paymentMethod;
  final String tags;
  final String? notes;
  final int? subscriptionId;
  final int? loanPaymentId;
  final String autoLabels;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ExpensesTableData(
      {required this.id,
      required this.amountPaise,
      required this.categoryId,
      required this.title,
      this.description,
      required this.occurredAt,
      required this.monthKey,
      required this.paymentMethod,
      required this.tags,
      this.notes,
      this.subscriptionId,
      this.loanPaymentId,
      required this.autoLabels,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['category_id'] = Variable<int>(categoryId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['month_key'] = Variable<String>(monthKey);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || subscriptionId != null) {
      map['subscription_id'] = Variable<int>(subscriptionId);
    }
    if (!nullToAbsent || loanPaymentId != null) {
      map['loan_payment_id'] = Variable<int>(loanPaymentId);
    }
    map['auto_labels'] = Variable<String>(autoLabels);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExpensesTableCompanion toCompanion(bool nullToAbsent) {
    return ExpensesTableCompanion(
      id: Value(id),
      amountPaise: Value(amountPaise),
      categoryId: Value(categoryId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      occurredAt: Value(occurredAt),
      monthKey: Value(monthKey),
      paymentMethod: Value(paymentMethod),
      tags: Value(tags),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      subscriptionId: subscriptionId == null && nullToAbsent
          ? const Value.absent()
          : Value(subscriptionId),
      loanPaymentId: loanPaymentId == null && nullToAbsent
          ? const Value.absent()
          : Value(loanPaymentId),
      autoLabels: Value(autoLabels),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExpensesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpensesTableData(
      id: serializer.fromJson<int>(json['id']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      monthKey: serializer.fromJson<String>(json['monthKey']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      tags: serializer.fromJson<String>(json['tags']),
      notes: serializer.fromJson<String?>(json['notes']),
      subscriptionId: serializer.fromJson<int?>(json['subscriptionId']),
      loanPaymentId: serializer.fromJson<int?>(json['loanPaymentId']),
      autoLabels: serializer.fromJson<String>(json['autoLabels']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'categoryId': serializer.toJson<int>(categoryId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'monthKey': serializer.toJson<String>(monthKey),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'tags': serializer.toJson<String>(tags),
      'notes': serializer.toJson<String?>(notes),
      'subscriptionId': serializer.toJson<int?>(subscriptionId),
      'loanPaymentId': serializer.toJson<int?>(loanPaymentId),
      'autoLabels': serializer.toJson<String>(autoLabels),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ExpensesTableData copyWith(
          {int? id,
          int? amountPaise,
          int? categoryId,
          String? title,
          Value<String?> description = const Value.absent(),
          DateTime? occurredAt,
          String? monthKey,
          String? paymentMethod,
          String? tags,
          Value<String?> notes = const Value.absent(),
          Value<int?> subscriptionId = const Value.absent(),
          Value<int?> loanPaymentId = const Value.absent(),
          String? autoLabels,
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ExpensesTableData(
        id: id ?? this.id,
        amountPaise: amountPaise ?? this.amountPaise,
        categoryId: categoryId ?? this.categoryId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        occurredAt: occurredAt ?? this.occurredAt,
        monthKey: monthKey ?? this.monthKey,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        tags: tags ?? this.tags,
        notes: notes.present ? notes.value : this.notes,
        subscriptionId:
            subscriptionId.present ? subscriptionId.value : this.subscriptionId,
        loanPaymentId:
            loanPaymentId.present ? loanPaymentId.value : this.loanPaymentId,
        autoLabels: autoLabels ?? this.autoLabels,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ExpensesTableData copyWithCompanion(ExpensesTableCompanion data) {
    return ExpensesTableData(
      id: data.id.present ? data.id.value : this.id,
      amountPaise:
          data.amountPaise.present ? data.amountPaise.value : this.amountPaise,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      monthKey: data.monthKey.present ? data.monthKey.value : this.monthKey,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      tags: data.tags.present ? data.tags.value : this.tags,
      notes: data.notes.present ? data.notes.value : this.notes,
      subscriptionId: data.subscriptionId.present
          ? data.subscriptionId.value
          : this.subscriptionId,
      loanPaymentId: data.loanPaymentId.present
          ? data.loanPaymentId.value
          : this.loanPaymentId,
      autoLabels:
          data.autoLabels.present ? data.autoLabels.value : this.autoLabels,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesTableData(')
          ..write('id: $id, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('monthKey: $monthKey, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('tags: $tags, ')
          ..write('notes: $notes, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('loanPaymentId: $loanPaymentId, ')
          ..write('autoLabels: $autoLabels, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      amountPaise,
      categoryId,
      title,
      description,
      occurredAt,
      monthKey,
      paymentMethod,
      tags,
      notes,
      subscriptionId,
      loanPaymentId,
      autoLabels,
      isDeleted,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpensesTableData &&
          other.id == this.id &&
          other.amountPaise == this.amountPaise &&
          other.categoryId == this.categoryId &&
          other.title == this.title &&
          other.description == this.description &&
          other.occurredAt == this.occurredAt &&
          other.monthKey == this.monthKey &&
          other.paymentMethod == this.paymentMethod &&
          other.tags == this.tags &&
          other.notes == this.notes &&
          other.subscriptionId == this.subscriptionId &&
          other.loanPaymentId == this.loanPaymentId &&
          other.autoLabels == this.autoLabels &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpensesTableCompanion extends UpdateCompanion<ExpensesTableData> {
  final Value<int> id;
  final Value<int> amountPaise;
  final Value<int> categoryId;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> occurredAt;
  final Value<String> monthKey;
  final Value<String> paymentMethod;
  final Value<String> tags;
  final Value<String?> notes;
  final Value<int?> subscriptionId;
  final Value<int?> loanPaymentId;
  final Value<String> autoLabels;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ExpensesTableCompanion({
    this.id = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.monthKey = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.tags = const Value.absent(),
    this.notes = const Value.absent(),
    this.subscriptionId = const Value.absent(),
    this.loanPaymentId = const Value.absent(),
    this.autoLabels = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ExpensesTableCompanion.insert({
    this.id = const Value.absent(),
    required int amountPaise,
    required int categoryId,
    required String title,
    this.description = const Value.absent(),
    required DateTime occurredAt,
    required String monthKey,
    this.paymentMethod = const Value.absent(),
    this.tags = const Value.absent(),
    this.notes = const Value.absent(),
    this.subscriptionId = const Value.absent(),
    this.loanPaymentId = const Value.absent(),
    this.autoLabels = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : amountPaise = Value(amountPaise),
        categoryId = Value(categoryId),
        title = Value(title),
        occurredAt = Value(occurredAt),
        monthKey = Value(monthKey);
  static Insertable<ExpensesTableData> custom({
    Expression<int>? id,
    Expression<int>? amountPaise,
    Expression<int>? categoryId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? occurredAt,
    Expression<String>? monthKey,
    Expression<String>? paymentMethod,
    Expression<String>? tags,
    Expression<String>? notes,
    Expression<int>? subscriptionId,
    Expression<int>? loanPaymentId,
    Expression<String>? autoLabels,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (categoryId != null) 'category_id': categoryId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (monthKey != null) 'month_key': monthKey,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (tags != null) 'tags': tags,
      if (notes != null) 'notes': notes,
      if (subscriptionId != null) 'subscription_id': subscriptionId,
      if (loanPaymentId != null) 'loan_payment_id': loanPaymentId,
      if (autoLabels != null) 'auto_labels': autoLabels,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ExpensesTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? amountPaise,
      Value<int>? categoryId,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime>? occurredAt,
      Value<String>? monthKey,
      Value<String>? paymentMethod,
      Value<String>? tags,
      Value<String?>? notes,
      Value<int?>? subscriptionId,
      Value<int?>? loanPaymentId,
      Value<String>? autoLabels,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ExpensesTableCompanion(
      id: id ?? this.id,
      amountPaise: amountPaise ?? this.amountPaise,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      occurredAt: occurredAt ?? this.occurredAt,
      monthKey: monthKey ?? this.monthKey,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      loanPaymentId: loanPaymentId ?? this.loanPaymentId,
      autoLabels: autoLabels ?? this.autoLabels,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (monthKey.present) {
      map['month_key'] = Variable<String>(monthKey.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (subscriptionId.present) {
      map['subscription_id'] = Variable<int>(subscriptionId.value);
    }
    if (loanPaymentId.present) {
      map['loan_payment_id'] = Variable<int>(loanPaymentId.value);
    }
    if (autoLabels.present) {
      map['auto_labels'] = Variable<String>(autoLabels.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesTableCompanion(')
          ..write('id: $id, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('monthKey: $monthKey, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('tags: $tags, ')
          ..write('notes: $notes, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('loanPaymentId: $loanPaymentId, ')
          ..write('autoLabels: $autoLabels, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTableTable extends SubscriptionsTable
    with TableInfo<$SubscriptionsTableTable, SubscriptionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountPaiseMeta =
      const VerificationMeta('amountPaise');
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
      'amount_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories_table (id)'));
  static const VerificationMeta _billingCycleMeta =
      const VerificationMeta('billingCycle');
  @override
  late final GeneratedColumn<String> billingCycle = GeneratedColumn<String>(
      'billing_cycle', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('monthly'));
  static const VerificationMeta _billingIntervalDaysMeta =
      const VerificationMeta('billingIntervalDays');
  @override
  late final GeneratedColumn<int> billingIntervalDays = GeneratedColumn<int>(
      'billing_interval_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nextRenewalAtMeta =
      const VerificationMeta('nextRenewalAt');
  @override
  late final GeneratedColumn<DateTime> nextRenewalAt =
      GeneratedColumn<DateTime>('next_renewal_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Auto Debit'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        amountPaise,
        categoryId,
        billingCycle,
        billingIntervalDays,
        nextRenewalAt,
        paymentMethod,
        isActive,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SubscriptionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
          _amountPaiseMeta,
          amountPaise.isAcceptableOrUnknown(
              data['amount_paise']!, _amountPaiseMeta));
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('billing_cycle')) {
      context.handle(
          _billingCycleMeta,
          billingCycle.isAcceptableOrUnknown(
              data['billing_cycle']!, _billingCycleMeta));
    }
    if (data.containsKey('billing_interval_days')) {
      context.handle(
          _billingIntervalDaysMeta,
          billingIntervalDays.isAcceptableOrUnknown(
              data['billing_interval_days']!, _billingIntervalDaysMeta));
    }
    if (data.containsKey('next_renewal_at')) {
      context.handle(
          _nextRenewalAtMeta,
          nextRenewalAt.isAcceptableOrUnknown(
              data['next_renewal_at']!, _nextRenewalAtMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubscriptionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amountPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paise'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      billingCycle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}billing_cycle'])!,
      billingIntervalDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}billing_interval_days']),
      nextRenewalAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_renewal_at']),
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SubscriptionsTableTable createAlias(String alias) {
    return $SubscriptionsTableTable(attachedDatabase, alias);
  }
}

class SubscriptionsTableData extends DataClass
    implements Insertable<SubscriptionsTableData> {
  final int id;
  final String name;
  final int amountPaise;
  final int? categoryId;
  final String billingCycle;
  final int? billingIntervalDays;
  final DateTime? nextRenewalAt;
  final String paymentMethod;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SubscriptionsTableData(
      {required this.id,
      required this.name,
      required this.amountPaise,
      this.categoryId,
      required this.billingCycle,
      this.billingIntervalDays,
      this.nextRenewalAt,
      required this.paymentMethod,
      required this.isActive,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['amount_paise'] = Variable<int>(amountPaise);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['billing_cycle'] = Variable<String>(billingCycle);
    if (!nullToAbsent || billingIntervalDays != null) {
      map['billing_interval_days'] = Variable<int>(billingIntervalDays);
    }
    if (!nullToAbsent || nextRenewalAt != null) {
      map['next_renewal_at'] = Variable<DateTime>(nextRenewalAt);
    }
    map['payment_method'] = Variable<String>(paymentMethod);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SubscriptionsTableCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsTableCompanion(
      id: Value(id),
      name: Value(name),
      amountPaise: Value(amountPaise),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      billingCycle: Value(billingCycle),
      billingIntervalDays: billingIntervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(billingIntervalDays),
      nextRenewalAt: nextRenewalAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRenewalAt),
      paymentMethod: Value(paymentMethod),
      isActive: Value(isActive),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SubscriptionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      billingCycle: serializer.fromJson<String>(json['billingCycle']),
      billingIntervalDays:
          serializer.fromJson<int?>(json['billingIntervalDays']),
      nextRenewalAt: serializer.fromJson<DateTime?>(json['nextRenewalAt']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'categoryId': serializer.toJson<int?>(categoryId),
      'billingCycle': serializer.toJson<String>(billingCycle),
      'billingIntervalDays': serializer.toJson<int?>(billingIntervalDays),
      'nextRenewalAt': serializer.toJson<DateTime?>(nextRenewalAt),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'isActive': serializer.toJson<bool>(isActive),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SubscriptionsTableData copyWith(
          {int? id,
          String? name,
          int? amountPaise,
          Value<int?> categoryId = const Value.absent(),
          String? billingCycle,
          Value<int?> billingIntervalDays = const Value.absent(),
          Value<DateTime?> nextRenewalAt = const Value.absent(),
          String? paymentMethod,
          bool? isActive,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SubscriptionsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        amountPaise: amountPaise ?? this.amountPaise,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        billingCycle: billingCycle ?? this.billingCycle,
        billingIntervalDays: billingIntervalDays.present
            ? billingIntervalDays.value
            : this.billingIntervalDays,
        nextRenewalAt:
            nextRenewalAt.present ? nextRenewalAt.value : this.nextRenewalAt,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        isActive: isActive ?? this.isActive,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SubscriptionsTableData copyWithCompanion(SubscriptionsTableCompanion data) {
    return SubscriptionsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amountPaise:
          data.amountPaise.present ? data.amountPaise.value : this.amountPaise,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      billingCycle: data.billingCycle.present
          ? data.billingCycle.value
          : this.billingCycle,
      billingIntervalDays: data.billingIntervalDays.present
          ? data.billingIntervalDays.value
          : this.billingIntervalDays,
      nextRenewalAt: data.nextRenewalAt.present
          ? data.nextRenewalAt.value
          : this.nextRenewalAt,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('categoryId: $categoryId, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('billingIntervalDays: $billingIntervalDays, ')
          ..write('nextRenewalAt: $nextRenewalAt, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      amountPaise,
      categoryId,
      billingCycle,
      billingIntervalDays,
      nextRenewalAt,
      paymentMethod,
      isActive,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.amountPaise == this.amountPaise &&
          other.categoryId == this.categoryId &&
          other.billingCycle == this.billingCycle &&
          other.billingIntervalDays == this.billingIntervalDays &&
          other.nextRenewalAt == this.nextRenewalAt &&
          other.paymentMethod == this.paymentMethod &&
          other.isActive == this.isActive &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubscriptionsTableCompanion
    extends UpdateCompanion<SubscriptionsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> amountPaise;
  final Value<int?> categoryId;
  final Value<String> billingCycle;
  final Value<int?> billingIntervalDays;
  final Value<DateTime?> nextRenewalAt;
  final Value<String> paymentMethod;
  final Value<bool> isActive;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SubscriptionsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.billingCycle = const Value.absent(),
    this.billingIntervalDays = const Value.absent(),
    this.nextRenewalAt = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SubscriptionsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int amountPaise,
    this.categoryId = const Value.absent(),
    this.billingCycle = const Value.absent(),
    this.billingIntervalDays = const Value.absent(),
    this.nextRenewalAt = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        amountPaise = Value(amountPaise);
  static Insertable<SubscriptionsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? amountPaise,
    Expression<int>? categoryId,
    Expression<String>? billingCycle,
    Expression<int>? billingIntervalDays,
    Expression<DateTime>? nextRenewalAt,
    Expression<String>? paymentMethod,
    Expression<bool>? isActive,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (categoryId != null) 'category_id': categoryId,
      if (billingCycle != null) 'billing_cycle': billingCycle,
      if (billingIntervalDays != null)
        'billing_interval_days': billingIntervalDays,
      if (nextRenewalAt != null) 'next_renewal_at': nextRenewalAt,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (isActive != null) 'is_active': isActive,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SubscriptionsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? amountPaise,
      Value<int?>? categoryId,
      Value<String>? billingCycle,
      Value<int?>? billingIntervalDays,
      Value<DateTime?>? nextRenewalAt,
      Value<String>? paymentMethod,
      Value<bool>? isActive,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return SubscriptionsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amountPaise: amountPaise ?? this.amountPaise,
      categoryId: categoryId ?? this.categoryId,
      billingCycle: billingCycle ?? this.billingCycle,
      billingIntervalDays: billingIntervalDays ?? this.billingIntervalDays,
      nextRenewalAt: nextRenewalAt ?? this.nextRenewalAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (billingCycle.present) {
      map['billing_cycle'] = Variable<String>(billingCycle.value);
    }
    if (billingIntervalDays.present) {
      map['billing_interval_days'] = Variable<int>(billingIntervalDays.value);
    }
    if (nextRenewalAt.present) {
      map['next_renewal_at'] = Variable<DateTime>(nextRenewalAt.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('categoryId: $categoryId, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('billingIntervalDays: $billingIntervalDays, ')
          ..write('nextRenewalAt: $nextRenewalAt, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionPaymentsTableTable extends SubscriptionPaymentsTable
    with
        TableInfo<$SubscriptionPaymentsTableTable,
            SubscriptionPaymentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionPaymentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _subscriptionIdMeta =
      const VerificationMeta('subscriptionId');
  @override
  late final GeneratedColumn<int> subscriptionId = GeneratedColumn<int>(
      'subscription_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES subscriptions_table (id)'));
  static const VerificationMeta _amountPaiseMeta =
      const VerificationMeta('amountPaise');
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
      'amount_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _monthKeyMeta =
      const VerificationMeta('monthKey');
  @override
  late final GeneratedColumn<String> monthKey = GeneratedColumn<String>(
      'month_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expenseIdMeta =
      const VerificationMeta('expenseId');
  @override
  late final GeneratedColumn<int> expenseId = GeneratedColumn<int>(
      'expense_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('paid'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        subscriptionId,
        amountPaise,
        paidAt,
        monthKey,
        expenseId,
        status,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscription_payments_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SubscriptionPaymentsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subscription_id')) {
      context.handle(
          _subscriptionIdMeta,
          subscriptionId.isAcceptableOrUnknown(
              data['subscription_id']!, _subscriptionIdMeta));
    } else if (isInserting) {
      context.missing(_subscriptionIdMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
          _amountPaiseMeta,
          amountPaise.isAcceptableOrUnknown(
              data['amount_paise']!, _amountPaiseMeta));
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('month_key')) {
      context.handle(_monthKeyMeta,
          monthKey.isAcceptableOrUnknown(data['month_key']!, _monthKeyMeta));
    } else if (isInserting) {
      context.missing(_monthKeyMeta);
    }
    if (data.containsKey('expense_id')) {
      context.handle(_expenseIdMeta,
          expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubscriptionPaymentsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionPaymentsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      subscriptionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subscription_id'])!,
      amountPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paise'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at'])!,
      monthKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}month_key'])!,
      expenseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expense_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SubscriptionPaymentsTableTable createAlias(String alias) {
    return $SubscriptionPaymentsTableTable(attachedDatabase, alias);
  }
}

class SubscriptionPaymentsTableData extends DataClass
    implements Insertable<SubscriptionPaymentsTableData> {
  final int id;
  final int subscriptionId;
  final int amountPaise;
  final DateTime paidAt;
  final String monthKey;
  final int? expenseId;
  final String status;
  final DateTime createdAt;
  const SubscriptionPaymentsTableData(
      {required this.id,
      required this.subscriptionId,
      required this.amountPaise,
      required this.paidAt,
      required this.monthKey,
      this.expenseId,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subscription_id'] = Variable<int>(subscriptionId);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['paid_at'] = Variable<DateTime>(paidAt);
    map['month_key'] = Variable<String>(monthKey);
    if (!nullToAbsent || expenseId != null) {
      map['expense_id'] = Variable<int>(expenseId);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SubscriptionPaymentsTableCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionPaymentsTableCompanion(
      id: Value(id),
      subscriptionId: Value(subscriptionId),
      amountPaise: Value(amountPaise),
      paidAt: Value(paidAt),
      monthKey: Value(monthKey),
      expenseId: expenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseId),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory SubscriptionPaymentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionPaymentsTableData(
      id: serializer.fromJson<int>(json['id']),
      subscriptionId: serializer.fromJson<int>(json['subscriptionId']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      monthKey: serializer.fromJson<String>(json['monthKey']),
      expenseId: serializer.fromJson<int?>(json['expenseId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subscriptionId': serializer.toJson<int>(subscriptionId),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'monthKey': serializer.toJson<String>(monthKey),
      'expenseId': serializer.toJson<int?>(expenseId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SubscriptionPaymentsTableData copyWith(
          {int? id,
          int? subscriptionId,
          int? amountPaise,
          DateTime? paidAt,
          String? monthKey,
          Value<int?> expenseId = const Value.absent(),
          String? status,
          DateTime? createdAt}) =>
      SubscriptionPaymentsTableData(
        id: id ?? this.id,
        subscriptionId: subscriptionId ?? this.subscriptionId,
        amountPaise: amountPaise ?? this.amountPaise,
        paidAt: paidAt ?? this.paidAt,
        monthKey: monthKey ?? this.monthKey,
        expenseId: expenseId.present ? expenseId.value : this.expenseId,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  SubscriptionPaymentsTableData copyWithCompanion(
      SubscriptionPaymentsTableCompanion data) {
    return SubscriptionPaymentsTableData(
      id: data.id.present ? data.id.value : this.id,
      subscriptionId: data.subscriptionId.present
          ? data.subscriptionId.value
          : this.subscriptionId,
      amountPaise:
          data.amountPaise.present ? data.amountPaise.value : this.amountPaise,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      monthKey: data.monthKey.present ? data.monthKey.value : this.monthKey,
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionPaymentsTableData(')
          ..write('id: $id, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('paidAt: $paidAt, ')
          ..write('monthKey: $monthKey, ')
          ..write('expenseId: $expenseId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subscriptionId, amountPaise, paidAt,
      monthKey, expenseId, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionPaymentsTableData &&
          other.id == this.id &&
          other.subscriptionId == this.subscriptionId &&
          other.amountPaise == this.amountPaise &&
          other.paidAt == this.paidAt &&
          other.monthKey == this.monthKey &&
          other.expenseId == this.expenseId &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class SubscriptionPaymentsTableCompanion
    extends UpdateCompanion<SubscriptionPaymentsTableData> {
  final Value<int> id;
  final Value<int> subscriptionId;
  final Value<int> amountPaise;
  final Value<DateTime> paidAt;
  final Value<String> monthKey;
  final Value<int?> expenseId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const SubscriptionPaymentsTableCompanion({
    this.id = const Value.absent(),
    this.subscriptionId = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.monthKey = const Value.absent(),
    this.expenseId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SubscriptionPaymentsTableCompanion.insert({
    this.id = const Value.absent(),
    required int subscriptionId,
    required int amountPaise,
    required DateTime paidAt,
    required String monthKey,
    this.expenseId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : subscriptionId = Value(subscriptionId),
        amountPaise = Value(amountPaise),
        paidAt = Value(paidAt),
        monthKey = Value(monthKey);
  static Insertable<SubscriptionPaymentsTableData> custom({
    Expression<int>? id,
    Expression<int>? subscriptionId,
    Expression<int>? amountPaise,
    Expression<DateTime>? paidAt,
    Expression<String>? monthKey,
    Expression<int>? expenseId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subscriptionId != null) 'subscription_id': subscriptionId,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (paidAt != null) 'paid_at': paidAt,
      if (monthKey != null) 'month_key': monthKey,
      if (expenseId != null) 'expense_id': expenseId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SubscriptionPaymentsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? subscriptionId,
      Value<int>? amountPaise,
      Value<DateTime>? paidAt,
      Value<String>? monthKey,
      Value<int?>? expenseId,
      Value<String>? status,
      Value<DateTime>? createdAt}) {
    return SubscriptionPaymentsTableCompanion(
      id: id ?? this.id,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      amountPaise: amountPaise ?? this.amountPaise,
      paidAt: paidAt ?? this.paidAt,
      monthKey: monthKey ?? this.monthKey,
      expenseId: expenseId ?? this.expenseId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subscriptionId.present) {
      map['subscription_id'] = Variable<int>(subscriptionId.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (monthKey.present) {
      map['month_key'] = Variable<String>(monthKey.value);
    }
    if (expenseId.present) {
      map['expense_id'] = Variable<int>(expenseId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionPaymentsTableCompanion(')
          ..write('id: $id, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('paidAt: $paidAt, ')
          ..write('monthKey: $monthKey, ')
          ..write('expenseId: $expenseId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LoansTableTable extends LoansTable
    with TableInfo<$LoansTableTable, LoansTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _personNameMeta =
      const VerificationMeta('personName');
  @override
  late final GeneratedColumn<String> personName = GeneratedColumn<String>(
      'person_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _directionMeta =
      const VerificationMeta('direction');
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
      'direction', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('borrowed_by_me'));
  static const VerificationMeta _principalPaiseMeta =
      const VerificationMeta('principalPaise');
  @override
  late final GeneratedColumn<int> principalPaise = GeneratedColumn<int>(
      'principal_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _balancePaiseMeta =
      const VerificationMeta('balancePaise');
  @override
  late final GeneratedColumn<int> balancePaise = GeneratedColumn<int>(
      'balance_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _borrowedAtMeta =
      const VerificationMeta('borrowedAt');
  @override
  late final GeneratedColumn<DateTime> borrowedAt = GeneratedColumn<DateTime>(
      'borrowed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expectedReturnAtMeta =
      const VerificationMeta('expectedReturnAt');
  @override
  late final GeneratedColumn<DateTime> expectedReturnAt =
      GeneratedColumn<DateTime>('expected_return_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        personName,
        direction,
        principalPaise,
        balancePaise,
        reason,
        borrowedAt,
        expectedReturnAt,
        status,
        notes,
        isDeleted,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans_table';
  @override
  VerificationContext validateIntegrity(Insertable<LoansTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_name')) {
      context.handle(
          _personNameMeta,
          personName.isAcceptableOrUnknown(
              data['person_name']!, _personNameMeta));
    } else if (isInserting) {
      context.missing(_personNameMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(_directionMeta,
          direction.isAcceptableOrUnknown(data['direction']!, _directionMeta));
    }
    if (data.containsKey('principal_paise')) {
      context.handle(
          _principalPaiseMeta,
          principalPaise.isAcceptableOrUnknown(
              data['principal_paise']!, _principalPaiseMeta));
    } else if (isInserting) {
      context.missing(_principalPaiseMeta);
    }
    if (data.containsKey('balance_paise')) {
      context.handle(
          _balancePaiseMeta,
          balancePaise.isAcceptableOrUnknown(
              data['balance_paise']!, _balancePaiseMeta));
    } else if (isInserting) {
      context.missing(_balancePaiseMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('borrowed_at')) {
      context.handle(
          _borrowedAtMeta,
          borrowedAt.isAcceptableOrUnknown(
              data['borrowed_at']!, _borrowedAtMeta));
    } else if (isInserting) {
      context.missing(_borrowedAtMeta);
    }
    if (data.containsKey('expected_return_at')) {
      context.handle(
          _expectedReturnAtMeta,
          expectedReturnAt.isAcceptableOrUnknown(
              data['expected_return_at']!, _expectedReturnAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoansTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoansTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      personName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_name'])!,
      direction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direction'])!,
      principalPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}principal_paise'])!,
      balancePaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}balance_paise'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      borrowedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}borrowed_at'])!,
      expectedReturnAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}expected_return_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LoansTableTable createAlias(String alias) {
    return $LoansTableTable(attachedDatabase, alias);
  }
}

class LoansTableData extends DataClass implements Insertable<LoansTableData> {
  final int id;
  final String personName;
  final String direction;
  final int principalPaise;
  final int balancePaise;
  final String? reason;
  final DateTime borrowedAt;
  final DateTime? expectedReturnAt;
  final String status;
  final String? notes;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LoansTableData(
      {required this.id,
      required this.personName,
      required this.direction,
      required this.principalPaise,
      required this.balancePaise,
      this.reason,
      required this.borrowedAt,
      this.expectedReturnAt,
      required this.status,
      this.notes,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person_name'] = Variable<String>(personName);
    map['direction'] = Variable<String>(direction);
    map['principal_paise'] = Variable<int>(principalPaise);
    map['balance_paise'] = Variable<int>(balancePaise);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['borrowed_at'] = Variable<DateTime>(borrowedAt);
    if (!nullToAbsent || expectedReturnAt != null) {
      map['expected_return_at'] = Variable<DateTime>(expectedReturnAt);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LoansTableCompanion toCompanion(bool nullToAbsent) {
    return LoansTableCompanion(
      id: Value(id),
      personName: Value(personName),
      direction: Value(direction),
      principalPaise: Value(principalPaise),
      balancePaise: Value(balancePaise),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      borrowedAt: Value(borrowedAt),
      expectedReturnAt: expectedReturnAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedReturnAt),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LoansTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoansTableData(
      id: serializer.fromJson<int>(json['id']),
      personName: serializer.fromJson<String>(json['personName']),
      direction: serializer.fromJson<String>(json['direction']),
      principalPaise: serializer.fromJson<int>(json['principalPaise']),
      balancePaise: serializer.fromJson<int>(json['balancePaise']),
      reason: serializer.fromJson<String?>(json['reason']),
      borrowedAt: serializer.fromJson<DateTime>(json['borrowedAt']),
      expectedReturnAt:
          serializer.fromJson<DateTime?>(json['expectedReturnAt']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personName': serializer.toJson<String>(personName),
      'direction': serializer.toJson<String>(direction),
      'principalPaise': serializer.toJson<int>(principalPaise),
      'balancePaise': serializer.toJson<int>(balancePaise),
      'reason': serializer.toJson<String?>(reason),
      'borrowedAt': serializer.toJson<DateTime>(borrowedAt),
      'expectedReturnAt': serializer.toJson<DateTime?>(expectedReturnAt),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LoansTableData copyWith(
          {int? id,
          String? personName,
          String? direction,
          int? principalPaise,
          int? balancePaise,
          Value<String?> reason = const Value.absent(),
          DateTime? borrowedAt,
          Value<DateTime?> expectedReturnAt = const Value.absent(),
          String? status,
          Value<String?> notes = const Value.absent(),
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      LoansTableData(
        id: id ?? this.id,
        personName: personName ?? this.personName,
        direction: direction ?? this.direction,
        principalPaise: principalPaise ?? this.principalPaise,
        balancePaise: balancePaise ?? this.balancePaise,
        reason: reason.present ? reason.value : this.reason,
        borrowedAt: borrowedAt ?? this.borrowedAt,
        expectedReturnAt: expectedReturnAt.present
            ? expectedReturnAt.value
            : this.expectedReturnAt,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LoansTableData copyWithCompanion(LoansTableCompanion data) {
    return LoansTableData(
      id: data.id.present ? data.id.value : this.id,
      personName:
          data.personName.present ? data.personName.value : this.personName,
      direction: data.direction.present ? data.direction.value : this.direction,
      principalPaise: data.principalPaise.present
          ? data.principalPaise.value
          : this.principalPaise,
      balancePaise: data.balancePaise.present
          ? data.balancePaise.value
          : this.balancePaise,
      reason: data.reason.present ? data.reason.value : this.reason,
      borrowedAt:
          data.borrowedAt.present ? data.borrowedAt.value : this.borrowedAt,
      expectedReturnAt: data.expectedReturnAt.present
          ? data.expectedReturnAt.value
          : this.expectedReturnAt,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoansTableData(')
          ..write('id: $id, ')
          ..write('personName: $personName, ')
          ..write('direction: $direction, ')
          ..write('principalPaise: $principalPaise, ')
          ..write('balancePaise: $balancePaise, ')
          ..write('reason: $reason, ')
          ..write('borrowedAt: $borrowedAt, ')
          ..write('expectedReturnAt: $expectedReturnAt, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      personName,
      direction,
      principalPaise,
      balancePaise,
      reason,
      borrowedAt,
      expectedReturnAt,
      status,
      notes,
      isDeleted,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoansTableData &&
          other.id == this.id &&
          other.personName == this.personName &&
          other.direction == this.direction &&
          other.principalPaise == this.principalPaise &&
          other.balancePaise == this.balancePaise &&
          other.reason == this.reason &&
          other.borrowedAt == this.borrowedAt &&
          other.expectedReturnAt == this.expectedReturnAt &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LoansTableCompanion extends UpdateCompanion<LoansTableData> {
  final Value<int> id;
  final Value<String> personName;
  final Value<String> direction;
  final Value<int> principalPaise;
  final Value<int> balancePaise;
  final Value<String?> reason;
  final Value<DateTime> borrowedAt;
  final Value<DateTime?> expectedReturnAt;
  final Value<String> status;
  final Value<String?> notes;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const LoansTableCompanion({
    this.id = const Value.absent(),
    this.personName = const Value.absent(),
    this.direction = const Value.absent(),
    this.principalPaise = const Value.absent(),
    this.balancePaise = const Value.absent(),
    this.reason = const Value.absent(),
    this.borrowedAt = const Value.absent(),
    this.expectedReturnAt = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  LoansTableCompanion.insert({
    this.id = const Value.absent(),
    required String personName,
    this.direction = const Value.absent(),
    required int principalPaise,
    required int balancePaise,
    this.reason = const Value.absent(),
    required DateTime borrowedAt,
    this.expectedReturnAt = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : personName = Value(personName),
        principalPaise = Value(principalPaise),
        balancePaise = Value(balancePaise),
        borrowedAt = Value(borrowedAt);
  static Insertable<LoansTableData> custom({
    Expression<int>? id,
    Expression<String>? personName,
    Expression<String>? direction,
    Expression<int>? principalPaise,
    Expression<int>? balancePaise,
    Expression<String>? reason,
    Expression<DateTime>? borrowedAt,
    Expression<DateTime>? expectedReturnAt,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personName != null) 'person_name': personName,
      if (direction != null) 'direction': direction,
      if (principalPaise != null) 'principal_paise': principalPaise,
      if (balancePaise != null) 'balance_paise': balancePaise,
      if (reason != null) 'reason': reason,
      if (borrowedAt != null) 'borrowed_at': borrowedAt,
      if (expectedReturnAt != null) 'expected_return_at': expectedReturnAt,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  LoansTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? personName,
      Value<String>? direction,
      Value<int>? principalPaise,
      Value<int>? balancePaise,
      Value<String?>? reason,
      Value<DateTime>? borrowedAt,
      Value<DateTime?>? expectedReturnAt,
      Value<String>? status,
      Value<String?>? notes,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return LoansTableCompanion(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      direction: direction ?? this.direction,
      principalPaise: principalPaise ?? this.principalPaise,
      balancePaise: balancePaise ?? this.balancePaise,
      reason: reason ?? this.reason,
      borrowedAt: borrowedAt ?? this.borrowedAt,
      expectedReturnAt: expectedReturnAt ?? this.expectedReturnAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personName.present) {
      map['person_name'] = Variable<String>(personName.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (principalPaise.present) {
      map['principal_paise'] = Variable<int>(principalPaise.value);
    }
    if (balancePaise.present) {
      map['balance_paise'] = Variable<int>(balancePaise.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (borrowedAt.present) {
      map['borrowed_at'] = Variable<DateTime>(borrowedAt.value);
    }
    if (expectedReturnAt.present) {
      map['expected_return_at'] = Variable<DateTime>(expectedReturnAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansTableCompanion(')
          ..write('id: $id, ')
          ..write('personName: $personName, ')
          ..write('direction: $direction, ')
          ..write('principalPaise: $principalPaise, ')
          ..write('balancePaise: $balancePaise, ')
          ..write('reason: $reason, ')
          ..write('borrowedAt: $borrowedAt, ')
          ..write('expectedReturnAt: $expectedReturnAt, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $LoanPaymentsTableTable extends LoanPaymentsTable
    with TableInfo<$LoanPaymentsTableTable, LoanPaymentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoanPaymentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _loanIdMeta = const VerificationMeta('loanId');
  @override
  late final GeneratedColumn<int> loanId = GeneratedColumn<int>(
      'loan_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES loans_table (id)'));
  static const VerificationMeta _amountPaiseMeta =
      const VerificationMeta('amountPaise');
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
      'amount_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expenseIdMeta =
      const VerificationMeta('expenseId');
  @override
  late final GeneratedColumn<int> expenseId = GeneratedColumn<int>(
      'expense_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, loanId, amountPaise, paidAt, notes, expenseId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loan_payments_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<LoanPaymentsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('loan_id')) {
      context.handle(_loanIdMeta,
          loanId.isAcceptableOrUnknown(data['loan_id']!, _loanIdMeta));
    } else if (isInserting) {
      context.missing(_loanIdMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
          _amountPaiseMeta,
          amountPaise.isAcceptableOrUnknown(
              data['amount_paise']!, _amountPaiseMeta));
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('expense_id')) {
      context.handle(_expenseIdMeta,
          expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanPaymentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanPaymentsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      loanId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}loan_id'])!,
      amountPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paise'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      expenseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expense_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $LoanPaymentsTableTable createAlias(String alias) {
    return $LoanPaymentsTableTable(attachedDatabase, alias);
  }
}

class LoanPaymentsTableData extends DataClass
    implements Insertable<LoanPaymentsTableData> {
  final int id;
  final int loanId;
  final int amountPaise;
  final DateTime paidAt;
  final String? notes;
  final int? expenseId;
  final DateTime createdAt;
  const LoanPaymentsTableData(
      {required this.id,
      required this.loanId,
      required this.amountPaise,
      required this.paidAt,
      this.notes,
      this.expenseId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['loan_id'] = Variable<int>(loanId);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['paid_at'] = Variable<DateTime>(paidAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || expenseId != null) {
      map['expense_id'] = Variable<int>(expenseId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LoanPaymentsTableCompanion toCompanion(bool nullToAbsent) {
    return LoanPaymentsTableCompanion(
      id: Value(id),
      loanId: Value(loanId),
      amountPaise: Value(amountPaise),
      paidAt: Value(paidAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      expenseId: expenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseId),
      createdAt: Value(createdAt),
    );
  }

  factory LoanPaymentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanPaymentsTableData(
      id: serializer.fromJson<int>(json['id']),
      loanId: serializer.fromJson<int>(json['loanId']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      expenseId: serializer.fromJson<int?>(json['expenseId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loanId': serializer.toJson<int>(loanId),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'notes': serializer.toJson<String?>(notes),
      'expenseId': serializer.toJson<int?>(expenseId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LoanPaymentsTableData copyWith(
          {int? id,
          int? loanId,
          int? amountPaise,
          DateTime? paidAt,
          Value<String?> notes = const Value.absent(),
          Value<int?> expenseId = const Value.absent(),
          DateTime? createdAt}) =>
      LoanPaymentsTableData(
        id: id ?? this.id,
        loanId: loanId ?? this.loanId,
        amountPaise: amountPaise ?? this.amountPaise,
        paidAt: paidAt ?? this.paidAt,
        notes: notes.present ? notes.value : this.notes,
        expenseId: expenseId.present ? expenseId.value : this.expenseId,
        createdAt: createdAt ?? this.createdAt,
      );
  LoanPaymentsTableData copyWithCompanion(LoanPaymentsTableCompanion data) {
    return LoanPaymentsTableData(
      id: data.id.present ? data.id.value : this.id,
      loanId: data.loanId.present ? data.loanId.value : this.loanId,
      amountPaise:
          data.amountPaise.present ? data.amountPaise.value : this.amountPaise,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanPaymentsTableData(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('paidAt: $paidAt, ')
          ..write('notes: $notes, ')
          ..write('expenseId: $expenseId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, loanId, amountPaise, paidAt, notes, expenseId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanPaymentsTableData &&
          other.id == this.id &&
          other.loanId == this.loanId &&
          other.amountPaise == this.amountPaise &&
          other.paidAt == this.paidAt &&
          other.notes == this.notes &&
          other.expenseId == this.expenseId &&
          other.createdAt == this.createdAt);
}

class LoanPaymentsTableCompanion
    extends UpdateCompanion<LoanPaymentsTableData> {
  final Value<int> id;
  final Value<int> loanId;
  final Value<int> amountPaise;
  final Value<DateTime> paidAt;
  final Value<String?> notes;
  final Value<int?> expenseId;
  final Value<DateTime> createdAt;
  const LoanPaymentsTableCompanion({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.expenseId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LoanPaymentsTableCompanion.insert({
    this.id = const Value.absent(),
    required int loanId,
    required int amountPaise,
    required DateTime paidAt,
    this.notes = const Value.absent(),
    this.expenseId = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : loanId = Value(loanId),
        amountPaise = Value(amountPaise),
        paidAt = Value(paidAt);
  static Insertable<LoanPaymentsTableData> custom({
    Expression<int>? id,
    Expression<int>? loanId,
    Expression<int>? amountPaise,
    Expression<DateTime>? paidAt,
    Expression<String>? notes,
    Expression<int>? expenseId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loanId != null) 'loan_id': loanId,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (paidAt != null) 'paid_at': paidAt,
      if (notes != null) 'notes': notes,
      if (expenseId != null) 'expense_id': expenseId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LoanPaymentsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? loanId,
      Value<int>? amountPaise,
      Value<DateTime>? paidAt,
      Value<String?>? notes,
      Value<int?>? expenseId,
      Value<DateTime>? createdAt}) {
    return LoanPaymentsTableCompanion(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      amountPaise: amountPaise ?? this.amountPaise,
      paidAt: paidAt ?? this.paidAt,
      notes: notes ?? this.notes,
      expenseId: expenseId ?? this.expenseId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (loanId.present) {
      map['loan_id'] = Variable<int>(loanId.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (expenseId.present) {
      map['expense_id'] = Variable<int>(expenseId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoanPaymentsTableCompanion(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('paidAt: $paidAt, ')
          ..write('notes: $notes, ')
          ..write('expenseId: $expenseId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetPlansTableTable extends BudgetPlansTable
    with TableInfo<$BudgetPlansTableTable, BudgetPlansTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetPlansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _monthKeyMeta =
      const VerificationMeta('monthKey');
  @override
  late final GeneratedColumn<String> monthKey = GeneratedColumn<String>(
      'month_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _salaryPaiseMeta =
      const VerificationMeta('salaryPaise');
  @override
  late final GeneratedColumn<int> salaryPaise = GeneratedColumn<int>(
      'salary_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _allocationModeMeta =
      const VerificationMeta('allocationMode');
  @override
  late final GeneratedColumn<String> allocationMode = GeneratedColumn<String>(
      'allocation_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('percentage'));
  static const VerificationMeta _rolloverEnabledMeta =
      const VerificationMeta('rolloverEnabled');
  @override
  late final GeneratedColumn<bool> rolloverEnabled = GeneratedColumn<bool>(
      'rollover_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("rollover_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _aiNotesMeta =
      const VerificationMeta('aiNotes');
  @override
  late final GeneratedColumn<String> aiNotes = GeneratedColumn<String>(
      'ai_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        monthKey,
        salaryPaise,
        allocationMode,
        rolloverEnabled,
        aiNotes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_plans_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<BudgetPlansTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('month_key')) {
      context.handle(_monthKeyMeta,
          monthKey.isAcceptableOrUnknown(data['month_key']!, _monthKeyMeta));
    } else if (isInserting) {
      context.missing(_monthKeyMeta);
    }
    if (data.containsKey('salary_paise')) {
      context.handle(
          _salaryPaiseMeta,
          salaryPaise.isAcceptableOrUnknown(
              data['salary_paise']!, _salaryPaiseMeta));
    } else if (isInserting) {
      context.missing(_salaryPaiseMeta);
    }
    if (data.containsKey('allocation_mode')) {
      context.handle(
          _allocationModeMeta,
          allocationMode.isAcceptableOrUnknown(
              data['allocation_mode']!, _allocationModeMeta));
    }
    if (data.containsKey('rollover_enabled')) {
      context.handle(
          _rolloverEnabledMeta,
          rolloverEnabled.isAcceptableOrUnknown(
              data['rollover_enabled']!, _rolloverEnabledMeta));
    }
    if (data.containsKey('ai_notes')) {
      context.handle(_aiNotesMeta,
          aiNotes.isAcceptableOrUnknown(data['ai_notes']!, _aiNotesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetPlansTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetPlansTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      monthKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}month_key'])!,
      salaryPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}salary_paise'])!,
      allocationMode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}allocation_mode'])!,
      rolloverEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}rollover_enabled'])!,
      aiNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ai_notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BudgetPlansTableTable createAlias(String alias) {
    return $BudgetPlansTableTable(attachedDatabase, alias);
  }
}

class BudgetPlansTableData extends DataClass
    implements Insertable<BudgetPlansTableData> {
  final int id;
  final String monthKey;
  final int salaryPaise;
  final String allocationMode;
  final bool rolloverEnabled;
  final String? aiNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BudgetPlansTableData(
      {required this.id,
      required this.monthKey,
      required this.salaryPaise,
      required this.allocationMode,
      required this.rolloverEnabled,
      this.aiNotes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['month_key'] = Variable<String>(monthKey);
    map['salary_paise'] = Variable<int>(salaryPaise);
    map['allocation_mode'] = Variable<String>(allocationMode);
    map['rollover_enabled'] = Variable<bool>(rolloverEnabled);
    if (!nullToAbsent || aiNotes != null) {
      map['ai_notes'] = Variable<String>(aiNotes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetPlansTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetPlansTableCompanion(
      id: Value(id),
      monthKey: Value(monthKey),
      salaryPaise: Value(salaryPaise),
      allocationMode: Value(allocationMode),
      rolloverEnabled: Value(rolloverEnabled),
      aiNotes: aiNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(aiNotes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BudgetPlansTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetPlansTableData(
      id: serializer.fromJson<int>(json['id']),
      monthKey: serializer.fromJson<String>(json['monthKey']),
      salaryPaise: serializer.fromJson<int>(json['salaryPaise']),
      allocationMode: serializer.fromJson<String>(json['allocationMode']),
      rolloverEnabled: serializer.fromJson<bool>(json['rolloverEnabled']),
      aiNotes: serializer.fromJson<String?>(json['aiNotes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'monthKey': serializer.toJson<String>(monthKey),
      'salaryPaise': serializer.toJson<int>(salaryPaise),
      'allocationMode': serializer.toJson<String>(allocationMode),
      'rolloverEnabled': serializer.toJson<bool>(rolloverEnabled),
      'aiNotes': serializer.toJson<String?>(aiNotes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BudgetPlansTableData copyWith(
          {int? id,
          String? monthKey,
          int? salaryPaise,
          String? allocationMode,
          bool? rolloverEnabled,
          Value<String?> aiNotes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      BudgetPlansTableData(
        id: id ?? this.id,
        monthKey: monthKey ?? this.monthKey,
        salaryPaise: salaryPaise ?? this.salaryPaise,
        allocationMode: allocationMode ?? this.allocationMode,
        rolloverEnabled: rolloverEnabled ?? this.rolloverEnabled,
        aiNotes: aiNotes.present ? aiNotes.value : this.aiNotes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BudgetPlansTableData copyWithCompanion(BudgetPlansTableCompanion data) {
    return BudgetPlansTableData(
      id: data.id.present ? data.id.value : this.id,
      monthKey: data.monthKey.present ? data.monthKey.value : this.monthKey,
      salaryPaise:
          data.salaryPaise.present ? data.salaryPaise.value : this.salaryPaise,
      allocationMode: data.allocationMode.present
          ? data.allocationMode.value
          : this.allocationMode,
      rolloverEnabled: data.rolloverEnabled.present
          ? data.rolloverEnabled.value
          : this.rolloverEnabled,
      aiNotes: data.aiNotes.present ? data.aiNotes.value : this.aiNotes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetPlansTableData(')
          ..write('id: $id, ')
          ..write('monthKey: $monthKey, ')
          ..write('salaryPaise: $salaryPaise, ')
          ..write('allocationMode: $allocationMode, ')
          ..write('rolloverEnabled: $rolloverEnabled, ')
          ..write('aiNotes: $aiNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, monthKey, salaryPaise, allocationMode,
      rolloverEnabled, aiNotes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetPlansTableData &&
          other.id == this.id &&
          other.monthKey == this.monthKey &&
          other.salaryPaise == this.salaryPaise &&
          other.allocationMode == this.allocationMode &&
          other.rolloverEnabled == this.rolloverEnabled &&
          other.aiNotes == this.aiNotes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetPlansTableCompanion extends UpdateCompanion<BudgetPlansTableData> {
  final Value<int> id;
  final Value<String> monthKey;
  final Value<int> salaryPaise;
  final Value<String> allocationMode;
  final Value<bool> rolloverEnabled;
  final Value<String?> aiNotes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BudgetPlansTableCompanion({
    this.id = const Value.absent(),
    this.monthKey = const Value.absent(),
    this.salaryPaise = const Value.absent(),
    this.allocationMode = const Value.absent(),
    this.rolloverEnabled = const Value.absent(),
    this.aiNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BudgetPlansTableCompanion.insert({
    this.id = const Value.absent(),
    required String monthKey,
    required int salaryPaise,
    this.allocationMode = const Value.absent(),
    this.rolloverEnabled = const Value.absent(),
    this.aiNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : monthKey = Value(monthKey),
        salaryPaise = Value(salaryPaise);
  static Insertable<BudgetPlansTableData> custom({
    Expression<int>? id,
    Expression<String>? monthKey,
    Expression<int>? salaryPaise,
    Expression<String>? allocationMode,
    Expression<bool>? rolloverEnabled,
    Expression<String>? aiNotes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monthKey != null) 'month_key': monthKey,
      if (salaryPaise != null) 'salary_paise': salaryPaise,
      if (allocationMode != null) 'allocation_mode': allocationMode,
      if (rolloverEnabled != null) 'rollover_enabled': rolloverEnabled,
      if (aiNotes != null) 'ai_notes': aiNotes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BudgetPlansTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? monthKey,
      Value<int>? salaryPaise,
      Value<String>? allocationMode,
      Value<bool>? rolloverEnabled,
      Value<String?>? aiNotes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return BudgetPlansTableCompanion(
      id: id ?? this.id,
      monthKey: monthKey ?? this.monthKey,
      salaryPaise: salaryPaise ?? this.salaryPaise,
      allocationMode: allocationMode ?? this.allocationMode,
      rolloverEnabled: rolloverEnabled ?? this.rolloverEnabled,
      aiNotes: aiNotes ?? this.aiNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (monthKey.present) {
      map['month_key'] = Variable<String>(monthKey.value);
    }
    if (salaryPaise.present) {
      map['salary_paise'] = Variable<int>(salaryPaise.value);
    }
    if (allocationMode.present) {
      map['allocation_mode'] = Variable<String>(allocationMode.value);
    }
    if (rolloverEnabled.present) {
      map['rollover_enabled'] = Variable<bool>(rolloverEnabled.value);
    }
    if (aiNotes.present) {
      map['ai_notes'] = Variable<String>(aiNotes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetPlansTableCompanion(')
          ..write('id: $id, ')
          ..write('monthKey: $monthKey, ')
          ..write('salaryPaise: $salaryPaise, ')
          ..write('allocationMode: $allocationMode, ')
          ..write('rolloverEnabled: $rolloverEnabled, ')
          ..write('aiNotes: $aiNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetBucketsTableTable extends BudgetBucketsTable
    with TableInfo<$BudgetBucketsTableTable, BudgetBucketsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetBucketsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
      'plan_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES budget_plans_table (id)'));
  static const VerificationMeta _bucketKeyMeta =
      const VerificationMeta('bucketKey');
  @override
  late final GeneratedColumn<String> bucketKey = GeneratedColumn<String>(
      'bucket_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories_table (id)'));
  static const VerificationMeta _bucketTypeMeta =
      const VerificationMeta('bucketType');
  @override
  late final GeneratedColumn<String> bucketType = GeneratedColumn<String>(
      'bucket_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('spending'));
  static const VerificationMeta _allocatedPaiseMeta =
      const VerificationMeta('allocatedPaise');
  @override
  late final GeneratedColumn<int> allocatedPaise = GeneratedColumn<int>(
      'allocated_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _allocatedPercentMeta =
      const VerificationMeta('allocatedPercent');
  @override
  late final GeneratedColumn<double> allocatedPercent = GeneratedColumn<double>(
      'allocated_percent', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _rolloverPaiseMeta =
      const VerificationMeta('rolloverPaise');
  @override
  late final GeneratedColumn<int> rolloverPaise = GeneratedColumn<int>(
      'rollover_paise', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        planId,
        bucketKey,
        displayName,
        categoryId,
        bucketType,
        allocatedPaise,
        allocatedPercent,
        rolloverPaise,
        sortOrder
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_buckets_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<BudgetBucketsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('bucket_key')) {
      context.handle(_bucketKeyMeta,
          bucketKey.isAcceptableOrUnknown(data['bucket_key']!, _bucketKeyMeta));
    } else if (isInserting) {
      context.missing(_bucketKeyMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('bucket_type')) {
      context.handle(
          _bucketTypeMeta,
          bucketType.isAcceptableOrUnknown(
              data['bucket_type']!, _bucketTypeMeta));
    }
    if (data.containsKey('allocated_paise')) {
      context.handle(
          _allocatedPaiseMeta,
          allocatedPaise.isAcceptableOrUnknown(
              data['allocated_paise']!, _allocatedPaiseMeta));
    } else if (isInserting) {
      context.missing(_allocatedPaiseMeta);
    }
    if (data.containsKey('allocated_percent')) {
      context.handle(
          _allocatedPercentMeta,
          allocatedPercent.isAcceptableOrUnknown(
              data['allocated_percent']!, _allocatedPercentMeta));
    }
    if (data.containsKey('rollover_paise')) {
      context.handle(
          _rolloverPaiseMeta,
          rolloverPaise.isAcceptableOrUnknown(
              data['rollover_paise']!, _rolloverPaiseMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {planId, bucketKey},
      ];
  @override
  BudgetBucketsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetBucketsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      planId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plan_id'])!,
      bucketKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bucket_key'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      bucketType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bucket_type'])!,
      allocatedPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}allocated_paise'])!,
      allocatedPercent: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}allocated_percent']),
      rolloverPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rollover_paise'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $BudgetBucketsTableTable createAlias(String alias) {
    return $BudgetBucketsTableTable(attachedDatabase, alias);
  }
}

class BudgetBucketsTableData extends DataClass
    implements Insertable<BudgetBucketsTableData> {
  final int id;
  final int planId;
  final String bucketKey;
  final String displayName;
  final int? categoryId;
  final String bucketType;
  final int allocatedPaise;
  final double? allocatedPercent;
  final int rolloverPaise;
  final int sortOrder;
  const BudgetBucketsTableData(
      {required this.id,
      required this.planId,
      required this.bucketKey,
      required this.displayName,
      this.categoryId,
      required this.bucketType,
      required this.allocatedPaise,
      this.allocatedPercent,
      required this.rolloverPaise,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<int>(planId);
    map['bucket_key'] = Variable<String>(bucketKey);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['bucket_type'] = Variable<String>(bucketType);
    map['allocated_paise'] = Variable<int>(allocatedPaise);
    if (!nullToAbsent || allocatedPercent != null) {
      map['allocated_percent'] = Variable<double>(allocatedPercent);
    }
    map['rollover_paise'] = Variable<int>(rolloverPaise);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  BudgetBucketsTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetBucketsTableCompanion(
      id: Value(id),
      planId: Value(planId),
      bucketKey: Value(bucketKey),
      displayName: Value(displayName),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      bucketType: Value(bucketType),
      allocatedPaise: Value(allocatedPaise),
      allocatedPercent: allocatedPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(allocatedPercent),
      rolloverPaise: Value(rolloverPaise),
      sortOrder: Value(sortOrder),
    );
  }

  factory BudgetBucketsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetBucketsTableData(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int>(json['planId']),
      bucketKey: serializer.fromJson<String>(json['bucketKey']),
      displayName: serializer.fromJson<String>(json['displayName']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      bucketType: serializer.fromJson<String>(json['bucketType']),
      allocatedPaise: serializer.fromJson<int>(json['allocatedPaise']),
      allocatedPercent: serializer.fromJson<double?>(json['allocatedPercent']),
      rolloverPaise: serializer.fromJson<int>(json['rolloverPaise']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int>(planId),
      'bucketKey': serializer.toJson<String>(bucketKey),
      'displayName': serializer.toJson<String>(displayName),
      'categoryId': serializer.toJson<int?>(categoryId),
      'bucketType': serializer.toJson<String>(bucketType),
      'allocatedPaise': serializer.toJson<int>(allocatedPaise),
      'allocatedPercent': serializer.toJson<double?>(allocatedPercent),
      'rolloverPaise': serializer.toJson<int>(rolloverPaise),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  BudgetBucketsTableData copyWith(
          {int? id,
          int? planId,
          String? bucketKey,
          String? displayName,
          Value<int?> categoryId = const Value.absent(),
          String? bucketType,
          int? allocatedPaise,
          Value<double?> allocatedPercent = const Value.absent(),
          int? rolloverPaise,
          int? sortOrder}) =>
      BudgetBucketsTableData(
        id: id ?? this.id,
        planId: planId ?? this.planId,
        bucketKey: bucketKey ?? this.bucketKey,
        displayName: displayName ?? this.displayName,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        bucketType: bucketType ?? this.bucketType,
        allocatedPaise: allocatedPaise ?? this.allocatedPaise,
        allocatedPercent: allocatedPercent.present
            ? allocatedPercent.value
            : this.allocatedPercent,
        rolloverPaise: rolloverPaise ?? this.rolloverPaise,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  BudgetBucketsTableData copyWithCompanion(BudgetBucketsTableCompanion data) {
    return BudgetBucketsTableData(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      bucketKey: data.bucketKey.present ? data.bucketKey.value : this.bucketKey,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      bucketType:
          data.bucketType.present ? data.bucketType.value : this.bucketType,
      allocatedPaise: data.allocatedPaise.present
          ? data.allocatedPaise.value
          : this.allocatedPaise,
      allocatedPercent: data.allocatedPercent.present
          ? data.allocatedPercent.value
          : this.allocatedPercent,
      rolloverPaise: data.rolloverPaise.present
          ? data.rolloverPaise.value
          : this.rolloverPaise,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetBucketsTableData(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('bucketKey: $bucketKey, ')
          ..write('displayName: $displayName, ')
          ..write('categoryId: $categoryId, ')
          ..write('bucketType: $bucketType, ')
          ..write('allocatedPaise: $allocatedPaise, ')
          ..write('allocatedPercent: $allocatedPercent, ')
          ..write('rolloverPaise: $rolloverPaise, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      planId,
      bucketKey,
      displayName,
      categoryId,
      bucketType,
      allocatedPaise,
      allocatedPercent,
      rolloverPaise,
      sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetBucketsTableData &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.bucketKey == this.bucketKey &&
          other.displayName == this.displayName &&
          other.categoryId == this.categoryId &&
          other.bucketType == this.bucketType &&
          other.allocatedPaise == this.allocatedPaise &&
          other.allocatedPercent == this.allocatedPercent &&
          other.rolloverPaise == this.rolloverPaise &&
          other.sortOrder == this.sortOrder);
}

class BudgetBucketsTableCompanion
    extends UpdateCompanion<BudgetBucketsTableData> {
  final Value<int> id;
  final Value<int> planId;
  final Value<String> bucketKey;
  final Value<String> displayName;
  final Value<int?> categoryId;
  final Value<String> bucketType;
  final Value<int> allocatedPaise;
  final Value<double?> allocatedPercent;
  final Value<int> rolloverPaise;
  final Value<int> sortOrder;
  const BudgetBucketsTableCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.bucketKey = const Value.absent(),
    this.displayName = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.bucketType = const Value.absent(),
    this.allocatedPaise = const Value.absent(),
    this.allocatedPercent = const Value.absent(),
    this.rolloverPaise = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  BudgetBucketsTableCompanion.insert({
    this.id = const Value.absent(),
    required int planId,
    required String bucketKey,
    required String displayName,
    this.categoryId = const Value.absent(),
    this.bucketType = const Value.absent(),
    required int allocatedPaise,
    this.allocatedPercent = const Value.absent(),
    this.rolloverPaise = const Value.absent(),
    this.sortOrder = const Value.absent(),
  })  : planId = Value(planId),
        bucketKey = Value(bucketKey),
        displayName = Value(displayName),
        allocatedPaise = Value(allocatedPaise);
  static Insertable<BudgetBucketsTableData> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<String>? bucketKey,
    Expression<String>? displayName,
    Expression<int>? categoryId,
    Expression<String>? bucketType,
    Expression<int>? allocatedPaise,
    Expression<double>? allocatedPercent,
    Expression<int>? rolloverPaise,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (bucketKey != null) 'bucket_key': bucketKey,
      if (displayName != null) 'display_name': displayName,
      if (categoryId != null) 'category_id': categoryId,
      if (bucketType != null) 'bucket_type': bucketType,
      if (allocatedPaise != null) 'allocated_paise': allocatedPaise,
      if (allocatedPercent != null) 'allocated_percent': allocatedPercent,
      if (rolloverPaise != null) 'rollover_paise': rolloverPaise,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  BudgetBucketsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? planId,
      Value<String>? bucketKey,
      Value<String>? displayName,
      Value<int?>? categoryId,
      Value<String>? bucketType,
      Value<int>? allocatedPaise,
      Value<double?>? allocatedPercent,
      Value<int>? rolloverPaise,
      Value<int>? sortOrder}) {
    return BudgetBucketsTableCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      bucketKey: bucketKey ?? this.bucketKey,
      displayName: displayName ?? this.displayName,
      categoryId: categoryId ?? this.categoryId,
      bucketType: bucketType ?? this.bucketType,
      allocatedPaise: allocatedPaise ?? this.allocatedPaise,
      allocatedPercent: allocatedPercent ?? this.allocatedPercent,
      rolloverPaise: rolloverPaise ?? this.rolloverPaise,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (bucketKey.present) {
      map['bucket_key'] = Variable<String>(bucketKey.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (bucketType.present) {
      map['bucket_type'] = Variable<String>(bucketType.value);
    }
    if (allocatedPaise.present) {
      map['allocated_paise'] = Variable<int>(allocatedPaise.value);
    }
    if (allocatedPercent.present) {
      map['allocated_percent'] = Variable<double>(allocatedPercent.value);
    }
    if (rolloverPaise.present) {
      map['rollover_paise'] = Variable<int>(rolloverPaise.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetBucketsTableCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('bucketKey: $bucketKey, ')
          ..write('displayName: $displayName, ')
          ..write('categoryId: $categoryId, ')
          ..write('bucketType: $bucketType, ')
          ..write('allocatedPaise: $allocatedPaise, ')
          ..write('allocatedPercent: $allocatedPercent, ')
          ..write('rolloverPaise: $rolloverPaise, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $IncomeSourcesTableTable extends IncomeSourcesTable
    with TableInfo<$IncomeSourcesTableTable, IncomeSourcesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeSourcesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Primary salary'));
  static const VerificationMeta _cycleTypeMeta =
      const VerificationMeta('cycleType');
  @override
  late final GeneratedColumn<String> cycleType = GeneratedColumn<String>(
      'cycle_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('monthly_day'));
  static const VerificationMeta _dayOfMonthMeta =
      const VerificationMeta('dayOfMonth');
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
      'day_of_month', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _weekStartDayMeta =
      const VerificationMeta('weekStartDay');
  @override
  late final GeneratedColumn<int> weekStartDay = GeneratedColumn<int>(
      'week_start_day', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isPrimaryMeta =
      const VerificationMeta('isPrimary');
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
      'is_primary', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_primary" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        cycleType,
        dayOfMonth,
        weekStartDay,
        isPrimary,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_sources_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<IncomeSourcesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('cycle_type')) {
      context.handle(_cycleTypeMeta,
          cycleType.isAcceptableOrUnknown(data['cycle_type']!, _cycleTypeMeta));
    }
    if (data.containsKey('day_of_month')) {
      context.handle(
          _dayOfMonthMeta,
          dayOfMonth.isAcceptableOrUnknown(
              data['day_of_month']!, _dayOfMonthMeta));
    }
    if (data.containsKey('week_start_day')) {
      context.handle(
          _weekStartDayMeta,
          weekStartDay.isAcceptableOrUnknown(
              data['week_start_day']!, _weekStartDayMeta));
    }
    if (data.containsKey('is_primary')) {
      context.handle(_isPrimaryMeta,
          isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncomeSourcesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeSourcesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      cycleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cycle_type'])!,
      dayOfMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_of_month'])!,
      weekStartDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}week_start_day']),
      isPrimary: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_primary'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $IncomeSourcesTableTable createAlias(String alias) {
    return $IncomeSourcesTableTable(attachedDatabase, alias);
  }
}

class IncomeSourcesTableData extends DataClass
    implements Insertable<IncomeSourcesTableData> {
  final int id;
  final String name;
  final String cycleType;
  final int dayOfMonth;
  final int? weekStartDay;
  final bool isPrimary;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const IncomeSourcesTableData(
      {required this.id,
      required this.name,
      required this.cycleType,
      required this.dayOfMonth,
      this.weekStartDay,
      required this.isPrimary,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['cycle_type'] = Variable<String>(cycleType);
    map['day_of_month'] = Variable<int>(dayOfMonth);
    if (!nullToAbsent || weekStartDay != null) {
      map['week_start_day'] = Variable<int>(weekStartDay);
    }
    map['is_primary'] = Variable<bool>(isPrimary);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IncomeSourcesTableCompanion toCompanion(bool nullToAbsent) {
    return IncomeSourcesTableCompanion(
      id: Value(id),
      name: Value(name),
      cycleType: Value(cycleType),
      dayOfMonth: Value(dayOfMonth),
      weekStartDay: weekStartDay == null && nullToAbsent
          ? const Value.absent()
          : Value(weekStartDay),
      isPrimary: Value(isPrimary),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory IncomeSourcesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeSourcesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      cycleType: serializer.fromJson<String>(json['cycleType']),
      dayOfMonth: serializer.fromJson<int>(json['dayOfMonth']),
      weekStartDay: serializer.fromJson<int?>(json['weekStartDay']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'cycleType': serializer.toJson<String>(cycleType),
      'dayOfMonth': serializer.toJson<int>(dayOfMonth),
      'weekStartDay': serializer.toJson<int?>(weekStartDay),
      'isPrimary': serializer.toJson<bool>(isPrimary),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  IncomeSourcesTableData copyWith(
          {int? id,
          String? name,
          String? cycleType,
          int? dayOfMonth,
          Value<int?> weekStartDay = const Value.absent(),
          bool? isPrimary,
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      IncomeSourcesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        cycleType: cycleType ?? this.cycleType,
        dayOfMonth: dayOfMonth ?? this.dayOfMonth,
        weekStartDay:
            weekStartDay.present ? weekStartDay.value : this.weekStartDay,
        isPrimary: isPrimary ?? this.isPrimary,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  IncomeSourcesTableData copyWithCompanion(IncomeSourcesTableCompanion data) {
    return IncomeSourcesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      cycleType: data.cycleType.present ? data.cycleType.value : this.cycleType,
      dayOfMonth:
          data.dayOfMonth.present ? data.dayOfMonth.value : this.dayOfMonth,
      weekStartDay: data.weekStartDay.present
          ? data.weekStartDay.value
          : this.weekStartDay,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeSourcesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('cycleType: $cycleType, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('weekStartDay: $weekStartDay, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, cycleType, dayOfMonth, weekStartDay,
      isPrimary, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeSourcesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.cycleType == this.cycleType &&
          other.dayOfMonth == this.dayOfMonth &&
          other.weekStartDay == this.weekStartDay &&
          other.isPrimary == this.isPrimary &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class IncomeSourcesTableCompanion
    extends UpdateCompanion<IncomeSourcesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> cycleType;
  final Value<int> dayOfMonth;
  final Value<int?> weekStartDay;
  final Value<bool> isPrimary;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const IncomeSourcesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.cycleType = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.weekStartDay = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  IncomeSourcesTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.cycleType = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.weekStartDay = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<IncomeSourcesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? cycleType,
    Expression<int>? dayOfMonth,
    Expression<int>? weekStartDay,
    Expression<bool>? isPrimary,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (cycleType != null) 'cycle_type': cycleType,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (weekStartDay != null) 'week_start_day': weekStartDay,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  IncomeSourcesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? cycleType,
      Value<int>? dayOfMonth,
      Value<int?>? weekStartDay,
      Value<bool>? isPrimary,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return IncomeSourcesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      cycleType: cycleType ?? this.cycleType,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      weekStartDay: weekStartDay ?? this.weekStartDay,
      isPrimary: isPrimary ?? this.isPrimary,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (cycleType.present) {
      map['cycle_type'] = Variable<String>(cycleType.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (weekStartDay.present) {
      map['week_start_day'] = Variable<int>(weekStartDay.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeSourcesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('cycleType: $cycleType, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('weekStartDay: $weekStartDay, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TaggingRulesTableTable extends TaggingRulesTable
    with TableInfo<$TaggingRulesTableTable, TaggingRulesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaggingRulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _patternMeta =
      const VerificationMeta('pattern');
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
      'pattern', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _matchFieldMeta =
      const VerificationMeta('matchField');
  @override
  late final GeneratedColumn<String> matchField = GeneratedColumn<String>(
      'match_field', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('title'));
  static const VerificationMeta _categorySlugMeta =
      const VerificationMeta('categorySlug');
  @override
  late final GeneratedColumn<String> categorySlug = GeneratedColumn<String>(
      'category_slug', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.8));
  static const VerificationMeta _useCountMeta =
      const VerificationMeta('useCount');
  @override
  late final GeneratedColumn<int> useCount = GeneratedColumn<int>(
      'use_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pattern,
        matchField,
        categorySlug,
        tags,
        source,
        confidence,
        useCount,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tagging_rules_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TaggingRulesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pattern')) {
      context.handle(_patternMeta,
          pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta));
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('match_field')) {
      context.handle(
          _matchFieldMeta,
          matchField.isAcceptableOrUnknown(
              data['match_field']!, _matchFieldMeta));
    }
    if (data.containsKey('category_slug')) {
      context.handle(
          _categorySlugMeta,
          categorySlug.isAcceptableOrUnknown(
              data['category_slug']!, _categorySlugMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    }
    if (data.containsKey('use_count')) {
      context.handle(_useCountMeta,
          useCount.isAcceptableOrUnknown(data['use_count']!, _useCountMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {pattern, matchField},
      ];
  @override
  TaggingRulesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaggingRulesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pattern: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pattern'])!,
      matchField: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}match_field'])!,
      categorySlug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_slug']),
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      useCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}use_count'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TaggingRulesTableTable createAlias(String alias) {
    return $TaggingRulesTableTable(attachedDatabase, alias);
  }
}

class TaggingRulesTableData extends DataClass
    implements Insertable<TaggingRulesTableData> {
  final int id;
  final String pattern;
  final String matchField;
  final String? categorySlug;
  final String tags;
  final String source;
  final double confidence;
  final int useCount;
  final DateTime updatedAt;
  const TaggingRulesTableData(
      {required this.id,
      required this.pattern,
      required this.matchField,
      this.categorySlug,
      required this.tags,
      required this.source,
      required this.confidence,
      required this.useCount,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pattern'] = Variable<String>(pattern);
    map['match_field'] = Variable<String>(matchField);
    if (!nullToAbsent || categorySlug != null) {
      map['category_slug'] = Variable<String>(categorySlug);
    }
    map['tags'] = Variable<String>(tags);
    map['source'] = Variable<String>(source);
    map['confidence'] = Variable<double>(confidence);
    map['use_count'] = Variable<int>(useCount);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaggingRulesTableCompanion toCompanion(bool nullToAbsent) {
    return TaggingRulesTableCompanion(
      id: Value(id),
      pattern: Value(pattern),
      matchField: Value(matchField),
      categorySlug: categorySlug == null && nullToAbsent
          ? const Value.absent()
          : Value(categorySlug),
      tags: Value(tags),
      source: Value(source),
      confidence: Value(confidence),
      useCount: Value(useCount),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaggingRulesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaggingRulesTableData(
      id: serializer.fromJson<int>(json['id']),
      pattern: serializer.fromJson<String>(json['pattern']),
      matchField: serializer.fromJson<String>(json['matchField']),
      categorySlug: serializer.fromJson<String?>(json['categorySlug']),
      tags: serializer.fromJson<String>(json['tags']),
      source: serializer.fromJson<String>(json['source']),
      confidence: serializer.fromJson<double>(json['confidence']),
      useCount: serializer.fromJson<int>(json['useCount']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pattern': serializer.toJson<String>(pattern),
      'matchField': serializer.toJson<String>(matchField),
      'categorySlug': serializer.toJson<String?>(categorySlug),
      'tags': serializer.toJson<String>(tags),
      'source': serializer.toJson<String>(source),
      'confidence': serializer.toJson<double>(confidence),
      'useCount': serializer.toJson<int>(useCount),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaggingRulesTableData copyWith(
          {int? id,
          String? pattern,
          String? matchField,
          Value<String?> categorySlug = const Value.absent(),
          String? tags,
          String? source,
          double? confidence,
          int? useCount,
          DateTime? updatedAt}) =>
      TaggingRulesTableData(
        id: id ?? this.id,
        pattern: pattern ?? this.pattern,
        matchField: matchField ?? this.matchField,
        categorySlug:
            categorySlug.present ? categorySlug.value : this.categorySlug,
        tags: tags ?? this.tags,
        source: source ?? this.source,
        confidence: confidence ?? this.confidence,
        useCount: useCount ?? this.useCount,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TaggingRulesTableData copyWithCompanion(TaggingRulesTableCompanion data) {
    return TaggingRulesTableData(
      id: data.id.present ? data.id.value : this.id,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      matchField:
          data.matchField.present ? data.matchField.value : this.matchField,
      categorySlug: data.categorySlug.present
          ? data.categorySlug.value
          : this.categorySlug,
      tags: data.tags.present ? data.tags.value : this.tags,
      source: data.source.present ? data.source.value : this.source,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      useCount: data.useCount.present ? data.useCount.value : this.useCount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaggingRulesTableData(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('matchField: $matchField, ')
          ..write('categorySlug: $categorySlug, ')
          ..write('tags: $tags, ')
          ..write('source: $source, ')
          ..write('confidence: $confidence, ')
          ..write('useCount: $useCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pattern, matchField, categorySlug, tags,
      source, confidence, useCount, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaggingRulesTableData &&
          other.id == this.id &&
          other.pattern == this.pattern &&
          other.matchField == this.matchField &&
          other.categorySlug == this.categorySlug &&
          other.tags == this.tags &&
          other.source == this.source &&
          other.confidence == this.confidence &&
          other.useCount == this.useCount &&
          other.updatedAt == this.updatedAt);
}

class TaggingRulesTableCompanion
    extends UpdateCompanion<TaggingRulesTableData> {
  final Value<int> id;
  final Value<String> pattern;
  final Value<String> matchField;
  final Value<String?> categorySlug;
  final Value<String> tags;
  final Value<String> source;
  final Value<double> confidence;
  final Value<int> useCount;
  final Value<DateTime> updatedAt;
  const TaggingRulesTableCompanion({
    this.id = const Value.absent(),
    this.pattern = const Value.absent(),
    this.matchField = const Value.absent(),
    this.categorySlug = const Value.absent(),
    this.tags = const Value.absent(),
    this.source = const Value.absent(),
    this.confidence = const Value.absent(),
    this.useCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TaggingRulesTableCompanion.insert({
    this.id = const Value.absent(),
    required String pattern,
    this.matchField = const Value.absent(),
    this.categorySlug = const Value.absent(),
    this.tags = const Value.absent(),
    required String source,
    this.confidence = const Value.absent(),
    this.useCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : pattern = Value(pattern),
        source = Value(source);
  static Insertable<TaggingRulesTableData> custom({
    Expression<int>? id,
    Expression<String>? pattern,
    Expression<String>? matchField,
    Expression<String>? categorySlug,
    Expression<String>? tags,
    Expression<String>? source,
    Expression<double>? confidence,
    Expression<int>? useCount,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pattern != null) 'pattern': pattern,
      if (matchField != null) 'match_field': matchField,
      if (categorySlug != null) 'category_slug': categorySlug,
      if (tags != null) 'tags': tags,
      if (source != null) 'source': source,
      if (confidence != null) 'confidence': confidence,
      if (useCount != null) 'use_count': useCount,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TaggingRulesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? pattern,
      Value<String>? matchField,
      Value<String?>? categorySlug,
      Value<String>? tags,
      Value<String>? source,
      Value<double>? confidence,
      Value<int>? useCount,
      Value<DateTime>? updatedAt}) {
    return TaggingRulesTableCompanion(
      id: id ?? this.id,
      pattern: pattern ?? this.pattern,
      matchField: matchField ?? this.matchField,
      categorySlug: categorySlug ?? this.categorySlug,
      tags: tags ?? this.tags,
      source: source ?? this.source,
      confidence: confidence ?? this.confidence,
      useCount: useCount ?? this.useCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (matchField.present) {
      map['match_field'] = Variable<String>(matchField.value);
    }
    if (categorySlug.present) {
      map['category_slug'] = Variable<String>(categorySlug.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (useCount.present) {
      map['use_count'] = Variable<int>(useCount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaggingRulesTableCompanion(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('matchField: $matchField, ')
          ..write('categorySlug: $categorySlug, ')
          ..write('tags: $tags, ')
          ..write('source: $source, ')
          ..write('confidence: $confidence, ')
          ..write('useCount: $useCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTableTable appSettingsTable =
      $AppSettingsTableTable(this);
  late final $MonthlySalaryTableTable monthlySalaryTable =
      $MonthlySalaryTableTable(this);
  late final $CategoriesTableTable categoriesTable =
      $CategoriesTableTable(this);
  late final $ExpensesTableTable expensesTable = $ExpensesTableTable(this);
  late final $SubscriptionsTableTable subscriptionsTable =
      $SubscriptionsTableTable(this);
  late final $SubscriptionPaymentsTableTable subscriptionPaymentsTable =
      $SubscriptionPaymentsTableTable(this);
  late final $LoansTableTable loansTable = $LoansTableTable(this);
  late final $LoanPaymentsTableTable loanPaymentsTable =
      $LoanPaymentsTableTable(this);
  late final $BudgetPlansTableTable budgetPlansTable =
      $BudgetPlansTableTable(this);
  late final $BudgetBucketsTableTable budgetBucketsTable =
      $BudgetBucketsTableTable(this);
  late final $IncomeSourcesTableTable incomeSourcesTable =
      $IncomeSourcesTableTable(this);
  late final $TaggingRulesTableTable taggingRulesTable =
      $TaggingRulesTableTable(this);
  late final ExpensesDao expensesDao = ExpensesDao(this as AppDatabase);
  late final SalaryDao salaryDao = SalaryDao(this as AppDatabase);
  late final CategoriesDao categoriesDao = CategoriesDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final SubscriptionsDao subscriptionsDao =
      SubscriptionsDao(this as AppDatabase);
  late final LoansDao loansDao = LoansDao(this as AppDatabase);
  late final BudgetDao budgetDao = BudgetDao(this as AppDatabase);
  late final IncomeSourcesDao incomeSourcesDao =
      IncomeSourcesDao(this as AppDatabase);
  late final TaggingRulesDao taggingRulesDao =
      TaggingRulesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        appSettingsTable,
        monthlySalaryTable,
        categoriesTable,
        expensesTable,
        subscriptionsTable,
        subscriptionPaymentsTable,
        loansTable,
        loanPaymentsTable,
        budgetPlansTable,
        budgetBucketsTable,
        incomeSourcesTable,
        taggingRulesTable
      ];
}

typedef $$AppSettingsTableTableCreateCompanionBuilder
    = AppSettingsTableCompanion Function({
  Value<int> id,
  Value<String> currencyCode,
  Value<String> themeMode,
  Value<int> majorExpenseThresholdPaise,
  Value<int> largeExpenseThresholdPaise,
  Value<int> veryLargeExpenseThresholdPaise,
  Value<int> majorPurchaseThresholdPaise,
  Value<int> salaryDay,
  Value<bool> pinEnabled,
  Value<String?> pinHash,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$AppSettingsTableTableUpdateCompanionBuilder
    = AppSettingsTableCompanion Function({
  Value<int> id,
  Value<String> currencyCode,
  Value<String> themeMode,
  Value<int> majorExpenseThresholdPaise,
  Value<int> largeExpenseThresholdPaise,
  Value<int> veryLargeExpenseThresholdPaise,
  Value<int> majorPurchaseThresholdPaise,
  Value<int> salaryDay,
  Value<bool> pinEnabled,
  Value<String?> pinHash,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get majorExpenseThresholdPaise => $composableBuilder(
      column: $table.majorExpenseThresholdPaise,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get largeExpenseThresholdPaise => $composableBuilder(
      column: $table.largeExpenseThresholdPaise,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get veryLargeExpenseThresholdPaise => $composableBuilder(
      column: $table.veryLargeExpenseThresholdPaise,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get majorPurchaseThresholdPaise => $composableBuilder(
      column: $table.majorPurchaseThresholdPaise,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get salaryDay => $composableBuilder(
      column: $table.salaryDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pinEnabled => $composableBuilder(
      column: $table.pinEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get majorExpenseThresholdPaise => $composableBuilder(
      column: $table.majorExpenseThresholdPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get largeExpenseThresholdPaise => $composableBuilder(
      column: $table.largeExpenseThresholdPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get veryLargeExpenseThresholdPaise => $composableBuilder(
      column: $table.veryLargeExpenseThresholdPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get majorPurchaseThresholdPaise => $composableBuilder(
      column: $table.majorPurchaseThresholdPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get salaryDay => $composableBuilder(
      column: $table.salaryDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pinEnabled => $composableBuilder(
      column: $table.pinEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<int> get majorExpenseThresholdPaise => $composableBuilder(
      column: $table.majorExpenseThresholdPaise, builder: (column) => column);

  GeneratedColumn<int> get largeExpenseThresholdPaise => $composableBuilder(
      column: $table.largeExpenseThresholdPaise, builder: (column) => column);

  GeneratedColumn<int> get veryLargeExpenseThresholdPaise => $composableBuilder(
      column: $table.veryLargeExpenseThresholdPaise,
      builder: (column) => column);

  GeneratedColumn<int> get majorPurchaseThresholdPaise => $composableBuilder(
      column: $table.majorPurchaseThresholdPaise, builder: (column) => column);

  GeneratedColumn<int> get salaryDay =>
      $composableBuilder(column: $table.salaryDay, builder: (column) => column);

  GeneratedColumn<bool> get pinEnabled => $composableBuilder(
      column: $table.pinEnabled, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableTableManager(
      _$AppDatabase db, $AppSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<int> majorExpenseThresholdPaise = const Value.absent(),
            Value<int> largeExpenseThresholdPaise = const Value.absent(),
            Value<int> veryLargeExpenseThresholdPaise = const Value.absent(),
            Value<int> majorPurchaseThresholdPaise = const Value.absent(),
            Value<int> salaryDay = const Value.absent(),
            Value<bool> pinEnabled = const Value.absent(),
            Value<String?> pinHash = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AppSettingsTableCompanion(
            id: id,
            currencyCode: currencyCode,
            themeMode: themeMode,
            majorExpenseThresholdPaise: majorExpenseThresholdPaise,
            largeExpenseThresholdPaise: largeExpenseThresholdPaise,
            veryLargeExpenseThresholdPaise: veryLargeExpenseThresholdPaise,
            majorPurchaseThresholdPaise: majorPurchaseThresholdPaise,
            salaryDay: salaryDay,
            pinEnabled: pinEnabled,
            pinHash: pinHash,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<int> majorExpenseThresholdPaise = const Value.absent(),
            Value<int> largeExpenseThresholdPaise = const Value.absent(),
            Value<int> veryLargeExpenseThresholdPaise = const Value.absent(),
            Value<int> majorPurchaseThresholdPaise = const Value.absent(),
            Value<int> salaryDay = const Value.absent(),
            Value<bool> pinEnabled = const Value.absent(),
            Value<String?> pinHash = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AppSettingsTableCompanion.insert(
            id: id,
            currencyCode: currencyCode,
            themeMode: themeMode,
            majorExpenseThresholdPaise: majorExpenseThresholdPaise,
            largeExpenseThresholdPaise: largeExpenseThresholdPaise,
            veryLargeExpenseThresholdPaise: veryLargeExpenseThresholdPaise,
            majorPurchaseThresholdPaise: majorPurchaseThresholdPaise,
            salaryDay: salaryDay,
            pinEnabled: pinEnabled,
            pinHash: pinHash,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()>;
typedef $$MonthlySalaryTableTableCreateCompanionBuilder
    = MonthlySalaryTableCompanion Function({
  Value<int> id,
  required String monthKey,
  required int amountPaise,
  Value<DateTime?> receivedAt,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$MonthlySalaryTableTableUpdateCompanionBuilder
    = MonthlySalaryTableCompanion Function({
  Value<int> id,
  Value<String> monthKey,
  Value<int> amountPaise,
  Value<DateTime?> receivedAt,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$MonthlySalaryTableTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlySalaryTableTable> {
  $$MonthlySalaryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get monthKey => $composableBuilder(
      column: $table.monthKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MonthlySalaryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlySalaryTableTable> {
  $$MonthlySalaryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get monthKey => $composableBuilder(
      column: $table.monthKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MonthlySalaryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlySalaryTableTable> {
  $$MonthlySalaryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get monthKey =>
      $composableBuilder(column: $table.monthKey, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MonthlySalaryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MonthlySalaryTableTable,
    MonthlySalaryTableData,
    $$MonthlySalaryTableTableFilterComposer,
    $$MonthlySalaryTableTableOrderingComposer,
    $$MonthlySalaryTableTableAnnotationComposer,
    $$MonthlySalaryTableTableCreateCompanionBuilder,
    $$MonthlySalaryTableTableUpdateCompanionBuilder,
    (
      MonthlySalaryTableData,
      BaseReferences<_$AppDatabase, $MonthlySalaryTableTable,
          MonthlySalaryTableData>
    ),
    MonthlySalaryTableData,
    PrefetchHooks Function()> {
  $$MonthlySalaryTableTableTableManager(
      _$AppDatabase db, $MonthlySalaryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlySalaryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlySalaryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlySalaryTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> monthKey = const Value.absent(),
            Value<int> amountPaise = const Value.absent(),
            Value<DateTime?> receivedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MonthlySalaryTableCompanion(
            id: id,
            monthKey: monthKey,
            amountPaise: amountPaise,
            receivedAt: receivedAt,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String monthKey,
            required int amountPaise,
            Value<DateTime?> receivedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MonthlySalaryTableCompanion.insert(
            id: id,
            monthKey: monthKey,
            amountPaise: amountPaise,
            receivedAt: receivedAt,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MonthlySalaryTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MonthlySalaryTableTable,
    MonthlySalaryTableData,
    $$MonthlySalaryTableTableFilterComposer,
    $$MonthlySalaryTableTableOrderingComposer,
    $$MonthlySalaryTableTableAnnotationComposer,
    $$MonthlySalaryTableTableCreateCompanionBuilder,
    $$MonthlySalaryTableTableUpdateCompanionBuilder,
    (
      MonthlySalaryTableData,
      BaseReferences<_$AppDatabase, $MonthlySalaryTableTable,
          MonthlySalaryTableData>
    ),
    MonthlySalaryTableData,
    PrefetchHooks Function()>;
typedef $$CategoriesTableTableCreateCompanionBuilder = CategoriesTableCompanion
    Function({
  Value<int> id,
  required String name,
  required String slug,
  Value<String> iconName,
  Value<int> colorValue,
  Value<bool> isSystem,
  Value<bool> countsTowardSpending,
  Value<int> sortOrder,
  Value<bool> isDeleted,
});
typedef $$CategoriesTableTableUpdateCompanionBuilder = CategoriesTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> slug,
  Value<String> iconName,
  Value<int> colorValue,
  Value<bool> isSystem,
  Value<bool> countsTowardSpending,
  Value<int> sortOrder,
  Value<bool> isDeleted,
});

final class $$CategoriesTableTableReferences extends BaseReferences<
    _$AppDatabase, $CategoriesTableTable, CategoriesTableData> {
  $$CategoriesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpensesTableTable, List<ExpensesTableData>>
      _expensesTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.expensesTable,
              aliasName: $_aliasNameGenerator(
                  db.categoriesTable.id, db.expensesTable.categoryId));

  $$ExpensesTableTableProcessedTableManager get expensesTableRefs {
    final manager = $$ExpensesTableTableTableManager($_db, $_db.expensesTable)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SubscriptionsTableTable,
      List<SubscriptionsTableData>> _subscriptionsTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.subscriptionsTable,
          aliasName: $_aliasNameGenerator(
              db.categoriesTable.id, db.subscriptionsTable.categoryId));

  $$SubscriptionsTableTableProcessedTableManager get subscriptionsTableRefs {
    final manager =
        $$SubscriptionsTableTableTableManager($_db, $_db.subscriptionsTable)
            .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_subscriptionsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BudgetBucketsTableTable,
      List<BudgetBucketsTableData>> _budgetBucketsTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.budgetBucketsTable,
          aliasName: $_aliasNameGenerator(
              db.categoriesTable.id, db.budgetBucketsTable.categoryId));

  $$BudgetBucketsTableTableProcessedTableManager get budgetBucketsTableRefs {
    final manager =
        $$BudgetBucketsTableTableTableManager($_db, $_db.budgetBucketsTable)
            .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_budgetBucketsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get countsTowardSpending => $composableBuilder(
      column: $table.countsTowardSpending,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  Expression<bool> expensesTableRefs(
      Expression<bool> Function($$ExpensesTableTableFilterComposer f) f) {
    final $$ExpensesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expensesTable,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableTableFilterComposer(
              $db: $db,
              $table: $db.expensesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> subscriptionsTableRefs(
      Expression<bool> Function($$SubscriptionsTableTableFilterComposer f) f) {
    final $$SubscriptionsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.subscriptionsTable,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubscriptionsTableTableFilterComposer(
              $db: $db,
              $table: $db.subscriptionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> budgetBucketsTableRefs(
      Expression<bool> Function($$BudgetBucketsTableTableFilterComposer f) f) {
    final $$BudgetBucketsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.budgetBucketsTable,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetBucketsTableTableFilterComposer(
              $db: $db,
              $table: $db.budgetBucketsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get countsTowardSpending => $composableBuilder(
      column: $table.countsTowardSpending,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<bool> get countsTowardSpending => $composableBuilder(
      column: $table.countsTowardSpending, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> expensesTableRefs<T extends Object>(
      Expression<T> Function($$ExpensesTableTableAnnotationComposer a) f) {
    final $$ExpensesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expensesTable,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.expensesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> subscriptionsTableRefs<T extends Object>(
      Expression<T> Function($$SubscriptionsTableTableAnnotationComposer a) f) {
    final $$SubscriptionsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.subscriptionsTable,
            getReferencedColumn: (t) => t.categoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SubscriptionsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.subscriptionsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> budgetBucketsTableRefs<T extends Object>(
      Expression<T> Function($$BudgetBucketsTableTableAnnotationComposer a) f) {
    final $$BudgetBucketsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.budgetBucketsTable,
            getReferencedColumn: (t) => t.categoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$BudgetBucketsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.budgetBucketsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CategoriesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (CategoriesTableData, $$CategoriesTableTableReferences),
    CategoriesTableData,
    PrefetchHooks Function(
        {bool expensesTableRefs,
        bool subscriptionsTableRefs,
        bool budgetBucketsTableRefs})> {
  $$CategoriesTableTableTableManager(
      _$AppDatabase db, $CategoriesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String> iconName = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<bool> countsTowardSpending = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              CategoriesTableCompanion(
            id: id,
            name: name,
            slug: slug,
            iconName: iconName,
            colorValue: colorValue,
            isSystem: isSystem,
            countsTowardSpending: countsTowardSpending,
            sortOrder: sortOrder,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String slug,
            Value<String> iconName = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<bool> countsTowardSpending = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              CategoriesTableCompanion.insert(
            id: id,
            name: name,
            slug: slug,
            iconName: iconName,
            colorValue: colorValue,
            isSystem: isSystem,
            countsTowardSpending: countsTowardSpending,
            sortOrder: sortOrder,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {expensesTableRefs = false,
              subscriptionsTableRefs = false,
              budgetBucketsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (expensesTableRefs) db.expensesTable,
                if (subscriptionsTableRefs) db.subscriptionsTable,
                if (budgetBucketsTableRefs) db.budgetBucketsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesTableRefs)
                    await $_getPrefetchedData<CategoriesTableData,
                            $CategoriesTableTable, ExpensesTableData>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableTableReferences
                            ._expensesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableTableReferences(db, table, p0)
                                .expensesTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (subscriptionsTableRefs)
                    await $_getPrefetchedData<CategoriesTableData,
                            $CategoriesTableTable, SubscriptionsTableData>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableTableReferences
                            ._subscriptionsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableTableReferences(db, table, p0)
                                .subscriptionsTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (budgetBucketsTableRefs)
                    await $_getPrefetchedData<CategoriesTableData,
                            $CategoriesTableTable, BudgetBucketsTableData>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableTableReferences
                            ._budgetBucketsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableTableReferences(db, table, p0)
                                .budgetBucketsTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (CategoriesTableData, $$CategoriesTableTableReferences),
    CategoriesTableData,
    PrefetchHooks Function(
        {bool expensesTableRefs,
        bool subscriptionsTableRefs,
        bool budgetBucketsTableRefs})>;
typedef $$ExpensesTableTableCreateCompanionBuilder = ExpensesTableCompanion
    Function({
  Value<int> id,
  required int amountPaise,
  required int categoryId,
  required String title,
  Value<String?> description,
  required DateTime occurredAt,
  required String monthKey,
  Value<String> paymentMethod,
  Value<String> tags,
  Value<String?> notes,
  Value<int?> subscriptionId,
  Value<int?> loanPaymentId,
  Value<String> autoLabels,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ExpensesTableTableUpdateCompanionBuilder = ExpensesTableCompanion
    Function({
  Value<int> id,
  Value<int> amountPaise,
  Value<int> categoryId,
  Value<String> title,
  Value<String?> description,
  Value<DateTime> occurredAt,
  Value<String> monthKey,
  Value<String> paymentMethod,
  Value<String> tags,
  Value<String?> notes,
  Value<int?> subscriptionId,
  Value<int?> loanPaymentId,
  Value<String> autoLabels,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ExpensesTableTableReferences extends BaseReferences<_$AppDatabase,
    $ExpensesTableTable, ExpensesTableData> {
  $$ExpensesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) =>
      db.categoriesTable.createAlias($_aliasNameGenerator(
          db.expensesTable.categoryId, db.categoriesTable.id));

  $$CategoriesTableTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager =
        $$CategoriesTableTableTableManager($_db, $_db.categoriesTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExpensesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get monthKey => $composableBuilder(
      column: $table.monthKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get subscriptionId => $composableBuilder(
      column: $table.subscriptionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get loanPaymentId => $composableBuilder(
      column: $table.loanPaymentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get autoLabels => $composableBuilder(
      column: $table.autoLabels, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoriesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableTableFilterComposer(
              $db: $db,
              $table: $db.categoriesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get monthKey => $composableBuilder(
      column: $table.monthKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get subscriptionId => $composableBuilder(
      column: $table.subscriptionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get loanPaymentId => $composableBuilder(
      column: $table.loanPaymentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get autoLabels => $composableBuilder(
      column: $table.autoLabels, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoriesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableTableOrderingComposer(
              $db: $db,
              $table: $db.categoriesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);

  GeneratedColumn<String> get monthKey =>
      $composableBuilder(column: $table.monthKey, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get subscriptionId => $composableBuilder(
      column: $table.subscriptionId, builder: (column) => column);

  GeneratedColumn<int> get loanPaymentId => $composableBuilder(
      column: $table.loanPaymentId, builder: (column) => column);

  GeneratedColumn<String> get autoLabels => $composableBuilder(
      column: $table.autoLabels, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoriesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.categoriesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTableTable,
    ExpensesTableData,
    $$ExpensesTableTableFilterComposer,
    $$ExpensesTableTableOrderingComposer,
    $$ExpensesTableTableAnnotationComposer,
    $$ExpensesTableTableCreateCompanionBuilder,
    $$ExpensesTableTableUpdateCompanionBuilder,
    (ExpensesTableData, $$ExpensesTableTableReferences),
    ExpensesTableData,
    PrefetchHooks Function({bool categoryId})> {
  $$ExpensesTableTableTableManager(_$AppDatabase db, $ExpensesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> amountPaise = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
            Value<String> monthKey = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> subscriptionId = const Value.absent(),
            Value<int?> loanPaymentId = const Value.absent(),
            Value<String> autoLabels = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ExpensesTableCompanion(
            id: id,
            amountPaise: amountPaise,
            categoryId: categoryId,
            title: title,
            description: description,
            occurredAt: occurredAt,
            monthKey: monthKey,
            paymentMethod: paymentMethod,
            tags: tags,
            notes: notes,
            subscriptionId: subscriptionId,
            loanPaymentId: loanPaymentId,
            autoLabels: autoLabels,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int amountPaise,
            required int categoryId,
            required String title,
            Value<String?> description = const Value.absent(),
            required DateTime occurredAt,
            required String monthKey,
            Value<String> paymentMethod = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> subscriptionId = const Value.absent(),
            Value<int?> loanPaymentId = const Value.absent(),
            Value<String> autoLabels = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ExpensesTableCompanion.insert(
            id: id,
            amountPaise: amountPaise,
            categoryId: categoryId,
            title: title,
            description: description,
            occurredAt: occurredAt,
            monthKey: monthKey,
            paymentMethod: paymentMethod,
            tags: tags,
            notes: notes,
            subscriptionId: subscriptionId,
            loanPaymentId: loanPaymentId,
            autoLabels: autoLabels,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExpensesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$ExpensesTableTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$ExpensesTableTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExpensesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTableTable,
    ExpensesTableData,
    $$ExpensesTableTableFilterComposer,
    $$ExpensesTableTableOrderingComposer,
    $$ExpensesTableTableAnnotationComposer,
    $$ExpensesTableTableCreateCompanionBuilder,
    $$ExpensesTableTableUpdateCompanionBuilder,
    (ExpensesTableData, $$ExpensesTableTableReferences),
    ExpensesTableData,
    PrefetchHooks Function({bool categoryId})>;
typedef $$SubscriptionsTableTableCreateCompanionBuilder
    = SubscriptionsTableCompanion Function({
  Value<int> id,
  required String name,
  required int amountPaise,
  Value<int?> categoryId,
  Value<String> billingCycle,
  Value<int?> billingIntervalDays,
  Value<DateTime?> nextRenewalAt,
  Value<String> paymentMethod,
  Value<bool> isActive,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$SubscriptionsTableTableUpdateCompanionBuilder
    = SubscriptionsTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> amountPaise,
  Value<int?> categoryId,
  Value<String> billingCycle,
  Value<int?> billingIntervalDays,
  Value<DateTime?> nextRenewalAt,
  Value<String> paymentMethod,
  Value<bool> isActive,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$SubscriptionsTableTableReferences extends BaseReferences<
    _$AppDatabase, $SubscriptionsTableTable, SubscriptionsTableData> {
  $$SubscriptionsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) =>
      db.categoriesTable.createAlias($_aliasNameGenerator(
          db.subscriptionsTable.categoryId, db.categoriesTable.id));

  $$CategoriesTableTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager =
        $$CategoriesTableTableTableManager($_db, $_db.categoriesTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SubscriptionPaymentsTableTable,
      List<SubscriptionPaymentsTableData>> _subscriptionPaymentsTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.subscriptionPaymentsTable,
          aliasName: $_aliasNameGenerator(db.subscriptionsTable.id,
              db.subscriptionPaymentsTable.subscriptionId));

  $$SubscriptionPaymentsTableTableProcessedTableManager
      get subscriptionPaymentsTableRefs {
    final manager = $$SubscriptionPaymentsTableTableTableManager(
            $_db, $_db.subscriptionPaymentsTable)
        .filter((f) => f.subscriptionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult
        .readTableOrNull(_subscriptionPaymentsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SubscriptionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingCycle => $composableBuilder(
      column: $table.billingCycle, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get billingIntervalDays => $composableBuilder(
      column: $table.billingIntervalDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextRenewalAt => $composableBuilder(
      column: $table.nextRenewalAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoriesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableTableFilterComposer(
              $db: $db,
              $table: $db.categoriesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> subscriptionPaymentsTableRefs(
      Expression<bool> Function(
              $$SubscriptionPaymentsTableTableFilterComposer f)
          f) {
    final $$SubscriptionPaymentsTableTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.subscriptionPaymentsTable,
            getReferencedColumn: (t) => t.subscriptionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SubscriptionPaymentsTableTableFilterComposer(
                  $db: $db,
                  $table: $db.subscriptionPaymentsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$SubscriptionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingCycle => $composableBuilder(
      column: $table.billingCycle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get billingIntervalDays => $composableBuilder(
      column: $table.billingIntervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextRenewalAt => $composableBuilder(
      column: $table.nextRenewalAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoriesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableTableOrderingComposer(
              $db: $db,
              $table: $db.categoriesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubscriptionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => column);

  GeneratedColumn<String> get billingCycle => $composableBuilder(
      column: $table.billingCycle, builder: (column) => column);

  GeneratedColumn<int> get billingIntervalDays => $composableBuilder(
      column: $table.billingIntervalDays, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRenewalAt => $composableBuilder(
      column: $table.nextRenewalAt, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoriesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.categoriesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> subscriptionPaymentsTableRefs<T extends Object>(
      Expression<T> Function(
              $$SubscriptionPaymentsTableTableAnnotationComposer a)
          f) {
    final $$SubscriptionPaymentsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.subscriptionPaymentsTable,
            getReferencedColumn: (t) => t.subscriptionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SubscriptionPaymentsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.subscriptionPaymentsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$SubscriptionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubscriptionsTableTable,
    SubscriptionsTableData,
    $$SubscriptionsTableTableFilterComposer,
    $$SubscriptionsTableTableOrderingComposer,
    $$SubscriptionsTableTableAnnotationComposer,
    $$SubscriptionsTableTableCreateCompanionBuilder,
    $$SubscriptionsTableTableUpdateCompanionBuilder,
    (SubscriptionsTableData, $$SubscriptionsTableTableReferences),
    SubscriptionsTableData,
    PrefetchHooks Function(
        {bool categoryId, bool subscriptionPaymentsTableRefs})> {
  $$SubscriptionsTableTableTableManager(
      _$AppDatabase db, $SubscriptionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> amountPaise = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<String> billingCycle = const Value.absent(),
            Value<int?> billingIntervalDays = const Value.absent(),
            Value<DateTime?> nextRenewalAt = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SubscriptionsTableCompanion(
            id: id,
            name: name,
            amountPaise: amountPaise,
            categoryId: categoryId,
            billingCycle: billingCycle,
            billingIntervalDays: billingIntervalDays,
            nextRenewalAt: nextRenewalAt,
            paymentMethod: paymentMethod,
            isActive: isActive,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int amountPaise,
            Value<int?> categoryId = const Value.absent(),
            Value<String> billingCycle = const Value.absent(),
            Value<int?> billingIntervalDays = const Value.absent(),
            Value<DateTime?> nextRenewalAt = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SubscriptionsTableCompanion.insert(
            id: id,
            name: name,
            amountPaise: amountPaise,
            categoryId: categoryId,
            billingCycle: billingCycle,
            billingIntervalDays: billingIntervalDays,
            nextRenewalAt: nextRenewalAt,
            paymentMethod: paymentMethod,
            isActive: isActive,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SubscriptionsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false, subscriptionPaymentsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (subscriptionPaymentsTableRefs) db.subscriptionPaymentsTable
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable: $$SubscriptionsTableTableReferences
                        ._categoryIdTable(db),
                    referencedColumn: $$SubscriptionsTableTableReferences
                        ._categoryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (subscriptionPaymentsTableRefs)
                    await $_getPrefetchedData<
                            SubscriptionsTableData,
                            $SubscriptionsTableTable,
                            SubscriptionPaymentsTableData>(
                        currentTable: table,
                        referencedTable: $$SubscriptionsTableTableReferences
                            ._subscriptionPaymentsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SubscriptionsTableTableReferences(db, table, p0)
                                .subscriptionPaymentsTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.subscriptionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SubscriptionsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubscriptionsTableTable,
    SubscriptionsTableData,
    $$SubscriptionsTableTableFilterComposer,
    $$SubscriptionsTableTableOrderingComposer,
    $$SubscriptionsTableTableAnnotationComposer,
    $$SubscriptionsTableTableCreateCompanionBuilder,
    $$SubscriptionsTableTableUpdateCompanionBuilder,
    (SubscriptionsTableData, $$SubscriptionsTableTableReferences),
    SubscriptionsTableData,
    PrefetchHooks Function(
        {bool categoryId, bool subscriptionPaymentsTableRefs})>;
typedef $$SubscriptionPaymentsTableTableCreateCompanionBuilder
    = SubscriptionPaymentsTableCompanion Function({
  Value<int> id,
  required int subscriptionId,
  required int amountPaise,
  required DateTime paidAt,
  required String monthKey,
  Value<int?> expenseId,
  Value<String> status,
  Value<DateTime> createdAt,
});
typedef $$SubscriptionPaymentsTableTableUpdateCompanionBuilder
    = SubscriptionPaymentsTableCompanion Function({
  Value<int> id,
  Value<int> subscriptionId,
  Value<int> amountPaise,
  Value<DateTime> paidAt,
  Value<String> monthKey,
  Value<int?> expenseId,
  Value<String> status,
  Value<DateTime> createdAt,
});

final class $$SubscriptionPaymentsTableTableReferences extends BaseReferences<
    _$AppDatabase,
    $SubscriptionPaymentsTableTable,
    SubscriptionPaymentsTableData> {
  $$SubscriptionPaymentsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SubscriptionsTableTable _subscriptionIdTable(_$AppDatabase db) =>
      db.subscriptionsTable.createAlias($_aliasNameGenerator(
          db.subscriptionPaymentsTable.subscriptionId,
          db.subscriptionsTable.id));

  $$SubscriptionsTableTableProcessedTableManager get subscriptionId {
    final $_column = $_itemColumn<int>('subscription_id')!;

    final manager =
        $$SubscriptionsTableTableTableManager($_db, $_db.subscriptionsTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subscriptionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SubscriptionPaymentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionPaymentsTableTable> {
  $$SubscriptionPaymentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get monthKey => $composableBuilder(
      column: $table.monthKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expenseId => $composableBuilder(
      column: $table.expenseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$SubscriptionsTableTableFilterComposer get subscriptionId {
    final $$SubscriptionsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subscriptionId,
        referencedTable: $db.subscriptionsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubscriptionsTableTableFilterComposer(
              $db: $db,
              $table: $db.subscriptionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubscriptionPaymentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionPaymentsTableTable> {
  $$SubscriptionPaymentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get monthKey => $composableBuilder(
      column: $table.monthKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expenseId => $composableBuilder(
      column: $table.expenseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$SubscriptionsTableTableOrderingComposer get subscriptionId {
    final $$SubscriptionsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subscriptionId,
        referencedTable: $db.subscriptionsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubscriptionsTableTableOrderingComposer(
              $db: $db,
              $table: $db.subscriptionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubscriptionPaymentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionPaymentsTableTable> {
  $$SubscriptionPaymentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<String> get monthKey =>
      $composableBuilder(column: $table.monthKey, builder: (column) => column);

  GeneratedColumn<int> get expenseId =>
      $composableBuilder(column: $table.expenseId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SubscriptionsTableTableAnnotationComposer get subscriptionId {
    final $$SubscriptionsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.subscriptionId,
            referencedTable: $db.subscriptionsTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SubscriptionsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.subscriptionsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$SubscriptionPaymentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubscriptionPaymentsTableTable,
    SubscriptionPaymentsTableData,
    $$SubscriptionPaymentsTableTableFilterComposer,
    $$SubscriptionPaymentsTableTableOrderingComposer,
    $$SubscriptionPaymentsTableTableAnnotationComposer,
    $$SubscriptionPaymentsTableTableCreateCompanionBuilder,
    $$SubscriptionPaymentsTableTableUpdateCompanionBuilder,
    (SubscriptionPaymentsTableData, $$SubscriptionPaymentsTableTableReferences),
    SubscriptionPaymentsTableData,
    PrefetchHooks Function({bool subscriptionId})> {
  $$SubscriptionPaymentsTableTableTableManager(
      _$AppDatabase db, $SubscriptionPaymentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionPaymentsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionPaymentsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionPaymentsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> subscriptionId = const Value.absent(),
            Value<int> amountPaise = const Value.absent(),
            Value<DateTime> paidAt = const Value.absent(),
            Value<String> monthKey = const Value.absent(),
            Value<int?> expenseId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SubscriptionPaymentsTableCompanion(
            id: id,
            subscriptionId: subscriptionId,
            amountPaise: amountPaise,
            paidAt: paidAt,
            monthKey: monthKey,
            expenseId: expenseId,
            status: status,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int subscriptionId,
            required int amountPaise,
            required DateTime paidAt,
            required String monthKey,
            Value<int?> expenseId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SubscriptionPaymentsTableCompanion.insert(
            id: id,
            subscriptionId: subscriptionId,
            amountPaise: amountPaise,
            paidAt: paidAt,
            monthKey: monthKey,
            expenseId: expenseId,
            status: status,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SubscriptionPaymentsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({subscriptionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (subscriptionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.subscriptionId,
                    referencedTable: $$SubscriptionPaymentsTableTableReferences
                        ._subscriptionIdTable(db),
                    referencedColumn: $$SubscriptionPaymentsTableTableReferences
                        ._subscriptionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SubscriptionPaymentsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $SubscriptionPaymentsTableTable,
        SubscriptionPaymentsTableData,
        $$SubscriptionPaymentsTableTableFilterComposer,
        $$SubscriptionPaymentsTableTableOrderingComposer,
        $$SubscriptionPaymentsTableTableAnnotationComposer,
        $$SubscriptionPaymentsTableTableCreateCompanionBuilder,
        $$SubscriptionPaymentsTableTableUpdateCompanionBuilder,
        (
          SubscriptionPaymentsTableData,
          $$SubscriptionPaymentsTableTableReferences
        ),
        SubscriptionPaymentsTableData,
        PrefetchHooks Function({bool subscriptionId})>;
typedef $$LoansTableTableCreateCompanionBuilder = LoansTableCompanion Function({
  Value<int> id,
  required String personName,
  Value<String> direction,
  required int principalPaise,
  required int balancePaise,
  Value<String?> reason,
  required DateTime borrowedAt,
  Value<DateTime?> expectedReturnAt,
  Value<String> status,
  Value<String?> notes,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$LoansTableTableUpdateCompanionBuilder = LoansTableCompanion Function({
  Value<int> id,
  Value<String> personName,
  Value<String> direction,
  Value<int> principalPaise,
  Value<int> balancePaise,
  Value<String?> reason,
  Value<DateTime> borrowedAt,
  Value<DateTime?> expectedReturnAt,
  Value<String> status,
  Value<String?> notes,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$LoansTableTableReferences
    extends BaseReferences<_$AppDatabase, $LoansTableTable, LoansTableData> {
  $$LoansTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LoanPaymentsTableTable,
      List<LoanPaymentsTableData>> _loanPaymentsTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.loanPaymentsTable,
          aliasName: $_aliasNameGenerator(
              db.loansTable.id, db.loanPaymentsTable.loanId));

  $$LoanPaymentsTableTableProcessedTableManager get loanPaymentsTableRefs {
    final manager =
        $$LoanPaymentsTableTableTableManager($_db, $_db.loanPaymentsTable)
            .filter((f) => f.loanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_loanPaymentsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LoansTableTableFilterComposer
    extends Composer<_$AppDatabase, $LoansTableTable> {
  $$LoansTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personName => $composableBuilder(
      column: $table.personName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get principalPaise => $composableBuilder(
      column: $table.principalPaise,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get balancePaise => $composableBuilder(
      column: $table.balancePaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get borrowedAt => $composableBuilder(
      column: $table.borrowedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expectedReturnAt => $composableBuilder(
      column: $table.expectedReturnAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> loanPaymentsTableRefs(
      Expression<bool> Function($$LoanPaymentsTableTableFilterComposer f) f) {
    final $$LoanPaymentsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.loanPaymentsTable,
        getReferencedColumn: (t) => t.loanId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoanPaymentsTableTableFilterComposer(
              $db: $db,
              $table: $db.loanPaymentsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LoansTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LoansTableTable> {
  $$LoansTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personName => $composableBuilder(
      column: $table.personName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get principalPaise => $composableBuilder(
      column: $table.principalPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get balancePaise => $composableBuilder(
      column: $table.balancePaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get borrowedAt => $composableBuilder(
      column: $table.borrowedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expectedReturnAt => $composableBuilder(
      column: $table.expectedReturnAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LoansTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoansTableTable> {
  $$LoansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get personName => $composableBuilder(
      column: $table.personName, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<int> get principalPaise => $composableBuilder(
      column: $table.principalPaise, builder: (column) => column);

  GeneratedColumn<int> get balancePaise => $composableBuilder(
      column: $table.balancePaise, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get borrowedAt => $composableBuilder(
      column: $table.borrowedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expectedReturnAt => $composableBuilder(
      column: $table.expectedReturnAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> loanPaymentsTableRefs<T extends Object>(
      Expression<T> Function($$LoanPaymentsTableTableAnnotationComposer a) f) {
    final $$LoanPaymentsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.loanPaymentsTable,
            getReferencedColumn: (t) => t.loanId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$LoanPaymentsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.loanPaymentsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$LoansTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LoansTableTable,
    LoansTableData,
    $$LoansTableTableFilterComposer,
    $$LoansTableTableOrderingComposer,
    $$LoansTableTableAnnotationComposer,
    $$LoansTableTableCreateCompanionBuilder,
    $$LoansTableTableUpdateCompanionBuilder,
    (LoansTableData, $$LoansTableTableReferences),
    LoansTableData,
    PrefetchHooks Function({bool loanPaymentsTableRefs})> {
  $$LoansTableTableTableManager(_$AppDatabase db, $LoansTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoansTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoansTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoansTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> personName = const Value.absent(),
            Value<String> direction = const Value.absent(),
            Value<int> principalPaise = const Value.absent(),
            Value<int> balancePaise = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<DateTime> borrowedAt = const Value.absent(),
            Value<DateTime?> expectedReturnAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              LoansTableCompanion(
            id: id,
            personName: personName,
            direction: direction,
            principalPaise: principalPaise,
            balancePaise: balancePaise,
            reason: reason,
            borrowedAt: borrowedAt,
            expectedReturnAt: expectedReturnAt,
            status: status,
            notes: notes,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String personName,
            Value<String> direction = const Value.absent(),
            required int principalPaise,
            required int balancePaise,
            Value<String?> reason = const Value.absent(),
            required DateTime borrowedAt,
            Value<DateTime?> expectedReturnAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              LoansTableCompanion.insert(
            id: id,
            personName: personName,
            direction: direction,
            principalPaise: principalPaise,
            balancePaise: balancePaise,
            reason: reason,
            borrowedAt: borrowedAt,
            expectedReturnAt: expectedReturnAt,
            status: status,
            notes: notes,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LoansTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({loanPaymentsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (loanPaymentsTableRefs) db.loanPaymentsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (loanPaymentsTableRefs)
                    await $_getPrefetchedData<LoansTableData, $LoansTableTable,
                            LoanPaymentsTableData>(
                        currentTable: table,
                        referencedTable: $$LoansTableTableReferences
                            ._loanPaymentsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LoansTableTableReferences(db, table, p0)
                                .loanPaymentsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.loanId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LoansTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LoansTableTable,
    LoansTableData,
    $$LoansTableTableFilterComposer,
    $$LoansTableTableOrderingComposer,
    $$LoansTableTableAnnotationComposer,
    $$LoansTableTableCreateCompanionBuilder,
    $$LoansTableTableUpdateCompanionBuilder,
    (LoansTableData, $$LoansTableTableReferences),
    LoansTableData,
    PrefetchHooks Function({bool loanPaymentsTableRefs})>;
typedef $$LoanPaymentsTableTableCreateCompanionBuilder
    = LoanPaymentsTableCompanion Function({
  Value<int> id,
  required int loanId,
  required int amountPaise,
  required DateTime paidAt,
  Value<String?> notes,
  Value<int?> expenseId,
  Value<DateTime> createdAt,
});
typedef $$LoanPaymentsTableTableUpdateCompanionBuilder
    = LoanPaymentsTableCompanion Function({
  Value<int> id,
  Value<int> loanId,
  Value<int> amountPaise,
  Value<DateTime> paidAt,
  Value<String?> notes,
  Value<int?> expenseId,
  Value<DateTime> createdAt,
});

final class $$LoanPaymentsTableTableReferences extends BaseReferences<
    _$AppDatabase, $LoanPaymentsTableTable, LoanPaymentsTableData> {
  $$LoanPaymentsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $LoansTableTable _loanIdTable(_$AppDatabase db) =>
      db.loansTable.createAlias(
          $_aliasNameGenerator(db.loanPaymentsTable.loanId, db.loansTable.id));

  $$LoansTableTableProcessedTableManager get loanId {
    final $_column = $_itemColumn<int>('loan_id')!;

    final manager = $$LoansTableTableTableManager($_db, $_db.loansTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_loanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LoanPaymentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTableTable> {
  $$LoanPaymentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expenseId => $composableBuilder(
      column: $table.expenseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$LoansTableTableFilterComposer get loanId {
    final $$LoansTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.loanId,
        referencedTable: $db.loansTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoansTableTableFilterComposer(
              $db: $db,
              $table: $db.loansTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LoanPaymentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTableTable> {
  $$LoanPaymentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expenseId => $composableBuilder(
      column: $table.expenseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$LoansTableTableOrderingComposer get loanId {
    final $$LoansTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.loanId,
        referencedTable: $db.loansTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoansTableTableOrderingComposer(
              $db: $db,
              $table: $db.loansTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LoanPaymentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTableTable> {
  $$LoanPaymentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get expenseId =>
      $composableBuilder(column: $table.expenseId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$LoansTableTableAnnotationComposer get loanId {
    final $$LoansTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.loanId,
        referencedTable: $db.loansTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoansTableTableAnnotationComposer(
              $db: $db,
              $table: $db.loansTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LoanPaymentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LoanPaymentsTableTable,
    LoanPaymentsTableData,
    $$LoanPaymentsTableTableFilterComposer,
    $$LoanPaymentsTableTableOrderingComposer,
    $$LoanPaymentsTableTableAnnotationComposer,
    $$LoanPaymentsTableTableCreateCompanionBuilder,
    $$LoanPaymentsTableTableUpdateCompanionBuilder,
    (LoanPaymentsTableData, $$LoanPaymentsTableTableReferences),
    LoanPaymentsTableData,
    PrefetchHooks Function({bool loanId})> {
  $$LoanPaymentsTableTableTableManager(
      _$AppDatabase db, $LoanPaymentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoanPaymentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoanPaymentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoanPaymentsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> loanId = const Value.absent(),
            Value<int> amountPaise = const Value.absent(),
            Value<DateTime> paidAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> expenseId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              LoanPaymentsTableCompanion(
            id: id,
            loanId: loanId,
            amountPaise: amountPaise,
            paidAt: paidAt,
            notes: notes,
            expenseId: expenseId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int loanId,
            required int amountPaise,
            required DateTime paidAt,
            Value<String?> notes = const Value.absent(),
            Value<int?> expenseId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              LoanPaymentsTableCompanion.insert(
            id: id,
            loanId: loanId,
            amountPaise: amountPaise,
            paidAt: paidAt,
            notes: notes,
            expenseId: expenseId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LoanPaymentsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({loanId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (loanId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.loanId,
                    referencedTable:
                        $$LoanPaymentsTableTableReferences._loanIdTable(db),
                    referencedColumn:
                        $$LoanPaymentsTableTableReferences._loanIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LoanPaymentsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LoanPaymentsTableTable,
    LoanPaymentsTableData,
    $$LoanPaymentsTableTableFilterComposer,
    $$LoanPaymentsTableTableOrderingComposer,
    $$LoanPaymentsTableTableAnnotationComposer,
    $$LoanPaymentsTableTableCreateCompanionBuilder,
    $$LoanPaymentsTableTableUpdateCompanionBuilder,
    (LoanPaymentsTableData, $$LoanPaymentsTableTableReferences),
    LoanPaymentsTableData,
    PrefetchHooks Function({bool loanId})>;
typedef $$BudgetPlansTableTableCreateCompanionBuilder
    = BudgetPlansTableCompanion Function({
  Value<int> id,
  required String monthKey,
  required int salaryPaise,
  Value<String> allocationMode,
  Value<bool> rolloverEnabled,
  Value<String?> aiNotes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$BudgetPlansTableTableUpdateCompanionBuilder
    = BudgetPlansTableCompanion Function({
  Value<int> id,
  Value<String> monthKey,
  Value<int> salaryPaise,
  Value<String> allocationMode,
  Value<bool> rolloverEnabled,
  Value<String?> aiNotes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$BudgetPlansTableTableReferences extends BaseReferences<
    _$AppDatabase, $BudgetPlansTableTable, BudgetPlansTableData> {
  $$BudgetPlansTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BudgetBucketsTableTable,
      List<BudgetBucketsTableData>> _budgetBucketsTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.budgetBucketsTable,
          aliasName: $_aliasNameGenerator(
              db.budgetPlansTable.id, db.budgetBucketsTable.planId));

  $$BudgetBucketsTableTableProcessedTableManager get budgetBucketsTableRefs {
    final manager =
        $$BudgetBucketsTableTableTableManager($_db, $_db.budgetBucketsTable)
            .filter((f) => f.planId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_budgetBucketsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BudgetPlansTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetPlansTableTable> {
  $$BudgetPlansTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get monthKey => $composableBuilder(
      column: $table.monthKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get salaryPaise => $composableBuilder(
      column: $table.salaryPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get allocationMode => $composableBuilder(
      column: $table.allocationMode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get rolloverEnabled => $composableBuilder(
      column: $table.rolloverEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aiNotes => $composableBuilder(
      column: $table.aiNotes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> budgetBucketsTableRefs(
      Expression<bool> Function($$BudgetBucketsTableTableFilterComposer f) f) {
    final $$BudgetBucketsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.budgetBucketsTable,
        getReferencedColumn: (t) => t.planId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetBucketsTableTableFilterComposer(
              $db: $db,
              $table: $db.budgetBucketsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BudgetPlansTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetPlansTableTable> {
  $$BudgetPlansTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get monthKey => $composableBuilder(
      column: $table.monthKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get salaryPaise => $composableBuilder(
      column: $table.salaryPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get allocationMode => $composableBuilder(
      column: $table.allocationMode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get rolloverEnabled => $composableBuilder(
      column: $table.rolloverEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aiNotes => $composableBuilder(
      column: $table.aiNotes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BudgetPlansTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetPlansTableTable> {
  $$BudgetPlansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get monthKey =>
      $composableBuilder(column: $table.monthKey, builder: (column) => column);

  GeneratedColumn<int> get salaryPaise => $composableBuilder(
      column: $table.salaryPaise, builder: (column) => column);

  GeneratedColumn<String> get allocationMode => $composableBuilder(
      column: $table.allocationMode, builder: (column) => column);

  GeneratedColumn<bool> get rolloverEnabled => $composableBuilder(
      column: $table.rolloverEnabled, builder: (column) => column);

  GeneratedColumn<String> get aiNotes =>
      $composableBuilder(column: $table.aiNotes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> budgetBucketsTableRefs<T extends Object>(
      Expression<T> Function($$BudgetBucketsTableTableAnnotationComposer a) f) {
    final $$BudgetBucketsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.budgetBucketsTable,
            getReferencedColumn: (t) => t.planId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$BudgetBucketsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.budgetBucketsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$BudgetPlansTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetPlansTableTable,
    BudgetPlansTableData,
    $$BudgetPlansTableTableFilterComposer,
    $$BudgetPlansTableTableOrderingComposer,
    $$BudgetPlansTableTableAnnotationComposer,
    $$BudgetPlansTableTableCreateCompanionBuilder,
    $$BudgetPlansTableTableUpdateCompanionBuilder,
    (BudgetPlansTableData, $$BudgetPlansTableTableReferences),
    BudgetPlansTableData,
    PrefetchHooks Function({bool budgetBucketsTableRefs})> {
  $$BudgetPlansTableTableTableManager(
      _$AppDatabase db, $BudgetPlansTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetPlansTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetPlansTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetPlansTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> monthKey = const Value.absent(),
            Value<int> salaryPaise = const Value.absent(),
            Value<String> allocationMode = const Value.absent(),
            Value<bool> rolloverEnabled = const Value.absent(),
            Value<String?> aiNotes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              BudgetPlansTableCompanion(
            id: id,
            monthKey: monthKey,
            salaryPaise: salaryPaise,
            allocationMode: allocationMode,
            rolloverEnabled: rolloverEnabled,
            aiNotes: aiNotes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String monthKey,
            required int salaryPaise,
            Value<String> allocationMode = const Value.absent(),
            Value<bool> rolloverEnabled = const Value.absent(),
            Value<String?> aiNotes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              BudgetPlansTableCompanion.insert(
            id: id,
            monthKey: monthKey,
            salaryPaise: salaryPaise,
            allocationMode: allocationMode,
            rolloverEnabled: rolloverEnabled,
            aiNotes: aiNotes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BudgetPlansTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({budgetBucketsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (budgetBucketsTableRefs) db.budgetBucketsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (budgetBucketsTableRefs)
                    await $_getPrefetchedData<BudgetPlansTableData,
                            $BudgetPlansTableTable, BudgetBucketsTableData>(
                        currentTable: table,
                        referencedTable: $$BudgetPlansTableTableReferences
                            ._budgetBucketsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BudgetPlansTableTableReferences(db, table, p0)
                                .budgetBucketsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.planId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BudgetPlansTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetPlansTableTable,
    BudgetPlansTableData,
    $$BudgetPlansTableTableFilterComposer,
    $$BudgetPlansTableTableOrderingComposer,
    $$BudgetPlansTableTableAnnotationComposer,
    $$BudgetPlansTableTableCreateCompanionBuilder,
    $$BudgetPlansTableTableUpdateCompanionBuilder,
    (BudgetPlansTableData, $$BudgetPlansTableTableReferences),
    BudgetPlansTableData,
    PrefetchHooks Function({bool budgetBucketsTableRefs})>;
typedef $$BudgetBucketsTableTableCreateCompanionBuilder
    = BudgetBucketsTableCompanion Function({
  Value<int> id,
  required int planId,
  required String bucketKey,
  required String displayName,
  Value<int?> categoryId,
  Value<String> bucketType,
  required int allocatedPaise,
  Value<double?> allocatedPercent,
  Value<int> rolloverPaise,
  Value<int> sortOrder,
});
typedef $$BudgetBucketsTableTableUpdateCompanionBuilder
    = BudgetBucketsTableCompanion Function({
  Value<int> id,
  Value<int> planId,
  Value<String> bucketKey,
  Value<String> displayName,
  Value<int?> categoryId,
  Value<String> bucketType,
  Value<int> allocatedPaise,
  Value<double?> allocatedPercent,
  Value<int> rolloverPaise,
  Value<int> sortOrder,
});

final class $$BudgetBucketsTableTableReferences extends BaseReferences<
    _$AppDatabase, $BudgetBucketsTableTable, BudgetBucketsTableData> {
  $$BudgetBucketsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $BudgetPlansTableTable _planIdTable(_$AppDatabase db) =>
      db.budgetPlansTable.createAlias($_aliasNameGenerator(
          db.budgetBucketsTable.planId, db.budgetPlansTable.id));

  $$BudgetPlansTableTableProcessedTableManager get planId {
    final $_column = $_itemColumn<int>('plan_id')!;

    final manager =
        $$BudgetPlansTableTableTableManager($_db, $_db.budgetPlansTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) =>
      db.categoriesTable.createAlias($_aliasNameGenerator(
          db.budgetBucketsTable.categoryId, db.categoriesTable.id));

  $$CategoriesTableTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager =
        $$CategoriesTableTableTableManager($_db, $_db.categoriesTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BudgetBucketsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetBucketsTableTable> {
  $$BudgetBucketsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bucketKey => $composableBuilder(
      column: $table.bucketKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bucketType => $composableBuilder(
      column: $table.bucketType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get allocatedPaise => $composableBuilder(
      column: $table.allocatedPaise,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get allocatedPercent => $composableBuilder(
      column: $table.allocatedPercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rolloverPaise => $composableBuilder(
      column: $table.rolloverPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  $$BudgetPlansTableTableFilterComposer get planId {
    final $$BudgetPlansTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.budgetPlansTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetPlansTableTableFilterComposer(
              $db: $db,
              $table: $db.budgetPlansTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoriesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableTableFilterComposer(
              $db: $db,
              $table: $db.categoriesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetBucketsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetBucketsTableTable> {
  $$BudgetBucketsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bucketKey => $composableBuilder(
      column: $table.bucketKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bucketType => $composableBuilder(
      column: $table.bucketType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get allocatedPaise => $composableBuilder(
      column: $table.allocatedPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get allocatedPercent => $composableBuilder(
      column: $table.allocatedPercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rolloverPaise => $composableBuilder(
      column: $table.rolloverPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  $$BudgetPlansTableTableOrderingComposer get planId {
    final $$BudgetPlansTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.budgetPlansTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetPlansTableTableOrderingComposer(
              $db: $db,
              $table: $db.budgetPlansTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoriesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableTableOrderingComposer(
              $db: $db,
              $table: $db.categoriesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetBucketsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetBucketsTableTable> {
  $$BudgetBucketsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bucketKey =>
      $composableBuilder(column: $table.bucketKey, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get bucketType => $composableBuilder(
      column: $table.bucketType, builder: (column) => column);

  GeneratedColumn<int> get allocatedPaise => $composableBuilder(
      column: $table.allocatedPaise, builder: (column) => column);

  GeneratedColumn<double> get allocatedPercent => $composableBuilder(
      column: $table.allocatedPercent, builder: (column) => column);

  GeneratedColumn<int> get rolloverPaise => $composableBuilder(
      column: $table.rolloverPaise, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$BudgetPlansTableTableAnnotationComposer get planId {
    final $$BudgetPlansTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.budgetPlansTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetPlansTableTableAnnotationComposer(
              $db: $db,
              $table: $db.budgetPlansTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoriesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.categoriesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetBucketsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetBucketsTableTable,
    BudgetBucketsTableData,
    $$BudgetBucketsTableTableFilterComposer,
    $$BudgetBucketsTableTableOrderingComposer,
    $$BudgetBucketsTableTableAnnotationComposer,
    $$BudgetBucketsTableTableCreateCompanionBuilder,
    $$BudgetBucketsTableTableUpdateCompanionBuilder,
    (BudgetBucketsTableData, $$BudgetBucketsTableTableReferences),
    BudgetBucketsTableData,
    PrefetchHooks Function({bool planId, bool categoryId})> {
  $$BudgetBucketsTableTableTableManager(
      _$AppDatabase db, $BudgetBucketsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetBucketsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetBucketsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetBucketsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> planId = const Value.absent(),
            Value<String> bucketKey = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<String> bucketType = const Value.absent(),
            Value<int> allocatedPaise = const Value.absent(),
            Value<double?> allocatedPercent = const Value.absent(),
            Value<int> rolloverPaise = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              BudgetBucketsTableCompanion(
            id: id,
            planId: planId,
            bucketKey: bucketKey,
            displayName: displayName,
            categoryId: categoryId,
            bucketType: bucketType,
            allocatedPaise: allocatedPaise,
            allocatedPercent: allocatedPercent,
            rolloverPaise: rolloverPaise,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int planId,
            required String bucketKey,
            required String displayName,
            Value<int?> categoryId = const Value.absent(),
            Value<String> bucketType = const Value.absent(),
            required int allocatedPaise,
            Value<double?> allocatedPercent = const Value.absent(),
            Value<int> rolloverPaise = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              BudgetBucketsTableCompanion.insert(
            id: id,
            planId: planId,
            bucketKey: bucketKey,
            displayName: displayName,
            categoryId: categoryId,
            bucketType: bucketType,
            allocatedPaise: allocatedPaise,
            allocatedPercent: allocatedPercent,
            rolloverPaise: rolloverPaise,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BudgetBucketsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({planId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (planId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.planId,
                    referencedTable:
                        $$BudgetBucketsTableTableReferences._planIdTable(db),
                    referencedColumn:
                        $$BudgetBucketsTableTableReferences._planIdTable(db).id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable: $$BudgetBucketsTableTableReferences
                        ._categoryIdTable(db),
                    referencedColumn: $$BudgetBucketsTableTableReferences
                        ._categoryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BudgetBucketsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetBucketsTableTable,
    BudgetBucketsTableData,
    $$BudgetBucketsTableTableFilterComposer,
    $$BudgetBucketsTableTableOrderingComposer,
    $$BudgetBucketsTableTableAnnotationComposer,
    $$BudgetBucketsTableTableCreateCompanionBuilder,
    $$BudgetBucketsTableTableUpdateCompanionBuilder,
    (BudgetBucketsTableData, $$BudgetBucketsTableTableReferences),
    BudgetBucketsTableData,
    PrefetchHooks Function({bool planId, bool categoryId})>;
typedef $$IncomeSourcesTableTableCreateCompanionBuilder
    = IncomeSourcesTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> cycleType,
  Value<int> dayOfMonth,
  Value<int?> weekStartDay,
  Value<bool> isPrimary,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$IncomeSourcesTableTableUpdateCompanionBuilder
    = IncomeSourcesTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> cycleType,
  Value<int> dayOfMonth,
  Value<int?> weekStartDay,
  Value<bool> isPrimary,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$IncomeSourcesTableTableFilterComposer
    extends Composer<_$AppDatabase, $IncomeSourcesTableTable> {
  $$IncomeSourcesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cycleType => $composableBuilder(
      column: $table.cycleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekStartDay => $composableBuilder(
      column: $table.weekStartDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPrimary => $composableBuilder(
      column: $table.isPrimary, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$IncomeSourcesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomeSourcesTableTable> {
  $$IncomeSourcesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cycleType => $composableBuilder(
      column: $table.cycleType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekStartDay => $composableBuilder(
      column: $table.weekStartDay,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
      column: $table.isPrimary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$IncomeSourcesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomeSourcesTableTable> {
  $$IncomeSourcesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get cycleType =>
      $composableBuilder(column: $table.cycleType, builder: (column) => column);

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => column);

  GeneratedColumn<int> get weekStartDay => $composableBuilder(
      column: $table.weekStartDay, builder: (column) => column);

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$IncomeSourcesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IncomeSourcesTableTable,
    IncomeSourcesTableData,
    $$IncomeSourcesTableTableFilterComposer,
    $$IncomeSourcesTableTableOrderingComposer,
    $$IncomeSourcesTableTableAnnotationComposer,
    $$IncomeSourcesTableTableCreateCompanionBuilder,
    $$IncomeSourcesTableTableUpdateCompanionBuilder,
    (
      IncomeSourcesTableData,
      BaseReferences<_$AppDatabase, $IncomeSourcesTableTable,
          IncomeSourcesTableData>
    ),
    IncomeSourcesTableData,
    PrefetchHooks Function()> {
  $$IncomeSourcesTableTableTableManager(
      _$AppDatabase db, $IncomeSourcesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeSourcesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeSourcesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeSourcesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> cycleType = const Value.absent(),
            Value<int> dayOfMonth = const Value.absent(),
            Value<int?> weekStartDay = const Value.absent(),
            Value<bool> isPrimary = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              IncomeSourcesTableCompanion(
            id: id,
            name: name,
            cycleType: cycleType,
            dayOfMonth: dayOfMonth,
            weekStartDay: weekStartDay,
            isPrimary: isPrimary,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> cycleType = const Value.absent(),
            Value<int> dayOfMonth = const Value.absent(),
            Value<int?> weekStartDay = const Value.absent(),
            Value<bool> isPrimary = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              IncomeSourcesTableCompanion.insert(
            id: id,
            name: name,
            cycleType: cycleType,
            dayOfMonth: dayOfMonth,
            weekStartDay: weekStartDay,
            isPrimary: isPrimary,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$IncomeSourcesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IncomeSourcesTableTable,
    IncomeSourcesTableData,
    $$IncomeSourcesTableTableFilterComposer,
    $$IncomeSourcesTableTableOrderingComposer,
    $$IncomeSourcesTableTableAnnotationComposer,
    $$IncomeSourcesTableTableCreateCompanionBuilder,
    $$IncomeSourcesTableTableUpdateCompanionBuilder,
    (
      IncomeSourcesTableData,
      BaseReferences<_$AppDatabase, $IncomeSourcesTableTable,
          IncomeSourcesTableData>
    ),
    IncomeSourcesTableData,
    PrefetchHooks Function()>;
typedef $$TaggingRulesTableTableCreateCompanionBuilder
    = TaggingRulesTableCompanion Function({
  Value<int> id,
  required String pattern,
  Value<String> matchField,
  Value<String?> categorySlug,
  Value<String> tags,
  required String source,
  Value<double> confidence,
  Value<int> useCount,
  Value<DateTime> updatedAt,
});
typedef $$TaggingRulesTableTableUpdateCompanionBuilder
    = TaggingRulesTableCompanion Function({
  Value<int> id,
  Value<String> pattern,
  Value<String> matchField,
  Value<String?> categorySlug,
  Value<String> tags,
  Value<String> source,
  Value<double> confidence,
  Value<int> useCount,
  Value<DateTime> updatedAt,
});

class $$TaggingRulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $TaggingRulesTableTable> {
  $$TaggingRulesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pattern => $composableBuilder(
      column: $table.pattern, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get matchField => $composableBuilder(
      column: $table.matchField, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categorySlug => $composableBuilder(
      column: $table.categorySlug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get useCount => $composableBuilder(
      column: $table.useCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TaggingRulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TaggingRulesTableTable> {
  $$TaggingRulesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pattern => $composableBuilder(
      column: $table.pattern, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get matchField => $composableBuilder(
      column: $table.matchField, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categorySlug => $composableBuilder(
      column: $table.categorySlug,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get useCount => $composableBuilder(
      column: $table.useCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TaggingRulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaggingRulesTableTable> {
  $$TaggingRulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<String> get matchField => $composableBuilder(
      column: $table.matchField, builder: (column) => column);

  GeneratedColumn<String> get categorySlug => $composableBuilder(
      column: $table.categorySlug, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<int> get useCount =>
      $composableBuilder(column: $table.useCount, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TaggingRulesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaggingRulesTableTable,
    TaggingRulesTableData,
    $$TaggingRulesTableTableFilterComposer,
    $$TaggingRulesTableTableOrderingComposer,
    $$TaggingRulesTableTableAnnotationComposer,
    $$TaggingRulesTableTableCreateCompanionBuilder,
    $$TaggingRulesTableTableUpdateCompanionBuilder,
    (
      TaggingRulesTableData,
      BaseReferences<_$AppDatabase, $TaggingRulesTableTable,
          TaggingRulesTableData>
    ),
    TaggingRulesTableData,
    PrefetchHooks Function()> {
  $$TaggingRulesTableTableTableManager(
      _$AppDatabase db, $TaggingRulesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaggingRulesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaggingRulesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaggingRulesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> pattern = const Value.absent(),
            Value<String> matchField = const Value.absent(),
            Value<String?> categorySlug = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<int> useCount = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TaggingRulesTableCompanion(
            id: id,
            pattern: pattern,
            matchField: matchField,
            categorySlug: categorySlug,
            tags: tags,
            source: source,
            confidence: confidence,
            useCount: useCount,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String pattern,
            Value<String> matchField = const Value.absent(),
            Value<String?> categorySlug = const Value.absent(),
            Value<String> tags = const Value.absent(),
            required String source,
            Value<double> confidence = const Value.absent(),
            Value<int> useCount = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TaggingRulesTableCompanion.insert(
            id: id,
            pattern: pattern,
            matchField: matchField,
            categorySlug: categorySlug,
            tags: tags,
            source: source,
            confidence: confidence,
            useCount: useCount,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaggingRulesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaggingRulesTableTable,
    TaggingRulesTableData,
    $$TaggingRulesTableTableFilterComposer,
    $$TaggingRulesTableTableOrderingComposer,
    $$TaggingRulesTableTableAnnotationComposer,
    $$TaggingRulesTableTableCreateCompanionBuilder,
    $$TaggingRulesTableTableUpdateCompanionBuilder,
    (
      TaggingRulesTableData,
      BaseReferences<_$AppDatabase, $TaggingRulesTableTable,
          TaggingRulesTableData>
    ),
    TaggingRulesTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$MonthlySalaryTableTableTableManager get monthlySalaryTable =>
      $$MonthlySalaryTableTableTableManager(_db, _db.monthlySalaryTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$ExpensesTableTableTableManager get expensesTable =>
      $$ExpensesTableTableTableManager(_db, _db.expensesTable);
  $$SubscriptionsTableTableTableManager get subscriptionsTable =>
      $$SubscriptionsTableTableTableManager(_db, _db.subscriptionsTable);
  $$SubscriptionPaymentsTableTableTableManager get subscriptionPaymentsTable =>
      $$SubscriptionPaymentsTableTableTableManager(
          _db, _db.subscriptionPaymentsTable);
  $$LoansTableTableTableManager get loansTable =>
      $$LoansTableTableTableManager(_db, _db.loansTable);
  $$LoanPaymentsTableTableTableManager get loanPaymentsTable =>
      $$LoanPaymentsTableTableTableManager(_db, _db.loanPaymentsTable);
  $$BudgetPlansTableTableTableManager get budgetPlansTable =>
      $$BudgetPlansTableTableTableManager(_db, _db.budgetPlansTable);
  $$BudgetBucketsTableTableTableManager get budgetBucketsTable =>
      $$BudgetBucketsTableTableTableManager(_db, _db.budgetBucketsTable);
  $$IncomeSourcesTableTableTableManager get incomeSourcesTable =>
      $$IncomeSourcesTableTableTableManager(_db, _db.incomeSourcesTable);
  $$TaggingRulesTableTableTableManager get taggingRulesTable =>
      $$TaggingRulesTableTableTableManager(_db, _db.taggingRulesTable);
}
