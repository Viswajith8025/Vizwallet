import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/supabase/supabase_bootstrap.dart';
import 'package:rupee_track/features/budget_alerts/data/budget_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences sharedPreferences;

Future<void> bootstrap() async {
  sharedPreferences = await SharedPreferences.getInstance();
  await initializeSupabase();
  await BudgetNotificationService.instance.initialize();
}

Future<AppDatabase> openDatabase(ProviderContainer container) {
  return container.read(databaseProvider.future);
}
