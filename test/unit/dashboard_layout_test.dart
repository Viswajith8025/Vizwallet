import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/custom_dashboard/domain/dashboard_layout_models.dart';
import 'package:rupee_track/features/custom_dashboard/domain/dashboard_templates.dart';

void main() {
  test('dashboard layout json roundtrip', () {
    final config = DashboardTemplates.defaults();
    final restored = DashboardLayoutConfig.fromJson(config.toJson());
    expect(restored.widgets.length, config.widgets.length);
    expect(restored.layoutMode, config.layoutMode);
    expect(restored.widgets.first.type, config.widgets.first.type);
  });

  test('widget instance copyWith clears accent', () {
    const w = DashboardWidgetInstance(
      id: 'a',
      type: DashboardWidgetType.currentBalance,
      accentArgb: 0xFF0000FF,
    );
    final cleared = w.copyWith(clearAccent: true);
    expect(cleared.accentArgb, isNull);
  });
}
