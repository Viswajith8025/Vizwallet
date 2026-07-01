import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/features/salary/domain/salary_breakdown.dart';

final salaryBreakdownProvider =
    StreamProvider.family<SalaryBreakdown, String>((ref, cycleKey) async* {
  final dao = await ref.watch(salaryDaoProvider.future);
  yield* dao.watchBreakdownForMonth(cycleKey);
});
