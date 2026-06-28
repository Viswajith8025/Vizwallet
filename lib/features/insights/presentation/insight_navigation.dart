import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/features/insights/domain/insights_feed_models.dart';

const _shellTabRoutes = {
  AppRoutes.home,
  AppRoutes.expenses,
  AppRoutes.insights,
  AppRoutes.jithu,
  AppRoutes.more,
};

void navigateToInsightAction(BuildContext context, InsightFeedItem item) {
  final route = item.actionRoute;
  if (route == null) return;

  if (_shellTabRoutes.contains(route)) {
    context.go(route);
    return;
  }

  final query = item.actionQuery;
  if (route == AppRoutes.search && query != null && query.isNotEmpty) {
    context.push('${AppRoutes.search}?q=${Uri.encodeComponent(query)}');
    return;
  }

  context.push(route);
}
