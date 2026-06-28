import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/universal_search/data/universal_search_repository.dart';
import 'package:rupee_track/features/universal_search/domain/universal_search_models.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText({
    required this.text,
    required this.highlights,
    this.style,
    super.key,
  });

  final String text;
  final List<String> highlights;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (highlights.isEmpty) {
      return Text(text, style: style);
    }

    final lower = text.toLowerCase();
    final spans = <TextSpan>[];
    var index = 0;

    while (index < text.length) {
      String? match;
      for (final h in highlights) {
        if (h.isEmpty) continue;
        if (lower.startsWith(h, index)) {
          match = text.substring(index, index + h.length);
          break;
        }
      }
      if (match != null) {
        spans.add(
          TextSpan(
            text: match,
            style: style?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
        index += match.length;
      } else {
        final next = index + 1;
        spans.add(TextSpan(text: text[index]));
        index = next;
      }
    }

    return RichText(text: TextSpan(style: style, children: spans));
  }
}

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    required this.item,
    required this.onTap,
    super.key,
  });

  final SearchResultItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: item.colorValue != null
            ? Color(item.colorValue!).withValues(alpha: 0.15)
            : theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          item.icon ?? Icons.search,
          size: 20,
          color: item.colorValue != null
              ? Color(item.colorValue!)
              : theme.colorScheme.primary,
        ),
      ),
      title: HighlightedText(
        text: item.title,
        highlights: item.highlights,
        style: theme.textTheme.titleSmall,
      ),
      subtitle: Text(
        item.subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: item.amountPaise != null
          ? Text(
              formatPaise(item.amountPaise!),
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            )
          : const Icon(Icons.chevron_right_rounded),
    );
  }
}

Future<void> showSearchFiltersSheet(BuildContext context, WidgetRef ref) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.62,
    child: const _SearchFiltersSheet(),
  );
}

class _SearchFiltersSheet extends ConsumerWidget {
  const _SearchFiltersSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('Search filters', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        Text('Sort by', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: SearchSort.values.map((sort) {
            return FilterChip(
              label: Text(_sortLabel(sort)),
              selected: filters.sort == sort,
              onSelected: (_) {
                ref.read(searchFiltersProvider.notifier).state =
                    filters.copyWith(sort: sort);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Transaction type', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<SearchTransactionType>(
          segments: const [
            ButtonSegment(
              value: SearchTransactionType.all,
              label: Text('All'),
            ),
            ButtonSegment(
              value: SearchTransactionType.expense,
              label: Text('Expense'),
            ),
            ButtonSegment(
              value: SearchTransactionType.income,
              label: Text('Income'),
            ),
          ],
          selected: {filters.transactionType},
          onSelectionChanged: (selection) {
            ref.read(searchFiltersProvider.notifier).state =
                filters.copyWith(transactionType: selection.first);
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: () {
            ref.read(searchFiltersProvider.notifier).state =
                const SearchFilters();
            context.pop();
          },
          child: const Text('Clear filters'),
        ),
      ],
    );
  }

  static String _sortLabel(SearchSort sort) => switch (sort) {
        SearchSort.relevance => 'Relevance',
        SearchSort.newest => 'Newest',
        SearchSort.oldest => 'Oldest',
        SearchSort.highestAmount => 'Highest',
        SearchSort.lowestAmount => 'Lowest',
        SearchSort.alphabetical => 'A–Z',
      };
}

void navigateToSearchResult(BuildContext context, SearchResultItem item) {
  final params = item.routeQueryParams;
  if (params.isEmpty) {
    context.push(item.route);
  } else {
    context.push(Uri(path: item.route, queryParameters: params).toString());
  }
}
