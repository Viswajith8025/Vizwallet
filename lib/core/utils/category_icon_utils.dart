import 'package:flutter/material.dart';

IconData categoryIconFromName(String iconName) {
  return switch (iconName) {
    'restaurant' => Icons.restaurant,
    'smartphone' => Icons.smartphone,
    'subscriptions' => Icons.subscriptions,
    'directions_bus' => Icons.directions_bus,
    'shopping_bag' => Icons.shopping_bag,
    'movie' => Icons.movie,
    'receipt_long' => Icons.receipt_long,
    'favorite' => Icons.favorite,
    'home' => Icons.home,
    'school' => Icons.school,
    'trending_up' => Icons.trending_up,
    'family_restroom' => Icons.family_restroom,
    'account_balance' => Icons.account_balance,
    'payments' => Icons.payments,
    _ => Icons.category,
  };
}
