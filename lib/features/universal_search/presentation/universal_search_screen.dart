import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/universal_search/data/universal_search_repository.dart';
import 'package:rupee_track/features/universal_search/domain/universal_search_models.dart';
import 'package:rupee_track/features/universal_search/presentation/widgets/search_result_tile.dart';

class UniversalSearchScreen extends ConsumerStatefulWidget {
  const UniversalSearchScreen({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  ConsumerState<UniversalSearchScreen> createState() =>
      _UniversalSearchScreenState();
}

class _UniversalSearchScreenState extends ConsumerState<UniversalSearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;
  String _debouncedQuery = '';

  @override
  void initState() {
    super.initState();
    final seed = widget.initialQuery?.trim();
    if (seed != null && seed.isNotEmpty) {
      _controller.text = seed;
      _debouncedQuery = seed;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      if (seed != null && seed.isNotEmpty) {
        _controller.selection = TextSelection.collapsed(offset: seed.length);
      }
    });
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      setState(() => _debouncedQuery = _controller.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filters = ref.watch(searchFiltersProvider);
    final reportAsync = _debouncedQuery.isEmpty
        ? const AsyncValue<UniversalSearchReport>.data(
            UniversalSearchReport(
              query: '',
              parsed: ParsedSearchQuery(
                rawQuery: '',
                tokens: const [],
                expandedTerms: const [],
              ),
              groups: [],
              suggestions: popularSearchQueries,
              totalCount: 0,
              hasMore: false,
            ),
          )
        : ref.watch(universalSearchReportProvider(_debouncedQuery));

    final history = ref.watch(searchHistoryStoreProvider);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.sm,
                  bottom: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    Expanded(
                      child: SearchBar(
                        controller: _controller,
                        focusNode: _focusNode,
                        hintText: 'Search anything in Viswallet…',
                        leading: const Icon(Icons.search_rounded),
                        trailing: [
                          if (filters.hasActiveFilters)
                            Badge(
                              child: IconButton(
                                onPressed: () =>
                                    showSearchFiltersSheet(context, ref),
                                icon: const Icon(Icons.tune_rounded),
                              ),
                            )
                          else
                            IconButton(
                              onPressed: () =>
                                  showSearchFiltersSheet(context, ref),
                              icon: const Icon(Icons.tune_outlined),
                            ),
                          if (_controller.text.isNotEmpty)
                            IconButton(
                              onPressed: () {
                                _controller.clear();
                                setState(() => _debouncedQuery = '');
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                        ],
                        onSubmitted: (q) => _submitSearch(q),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: reportAsync.when(
                  loading: () => ListView.builder(
                    itemCount: 6,
                    itemBuilder: (_, __) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      child: SkeletonCard(height: 56),
                    ),
                  ),
                  error: (e, _) => ErrorState(
                    message: 'We couldn\'t run that search.',
                    onRetry: () => ref.invalidate(
                      universalSearchReportProvider(_debouncedQuery),
                    ),
                  ),
                  data: (report) {
                    if (report.query.isEmpty) {
                      return _EmptySearchState(
                        recent: history.recent,
                        saved: history.saved,
                        suggestions: report.suggestions,
                        onPick: (q) {
                          _controller.text = q;
                          _submitSearch(q);
                        },
                        onSaveToggle: (q) async {
                          await ref
                              .read(searchHistoryStoreProvider)
                              .toggleSaved(q);
                          if (mounted) setState(() {});
                        },
                      );
                    }

                    if (report.groups.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'No results for "${report.query}"',
                                style: theme.textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Try another keyword or clear filters.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                      children: [
                        for (final group in report.groups) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              AppSpacing.md,
                              AppSpacing.lg,
                              AppSpacing.xs,
                            ),
                            child: Text(
                              group.label,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ...group.items.map(
                            (item) => SearchResultTile(
                              item: item,
                              onTap: () => _openResult(item),
                            ),
                          ),
                        ],
                        if (report.hasMore)
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Text(
                              'Showing first results — refine your query for more.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Text(
                  'Tip: use filters to narrow by date, category, or amount.',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitSearch(String query) {
    final q = query.trim();
    setState(() => _debouncedQuery = q);
    if (q.isNotEmpty) {
      ref.read(searchHistoryStoreProvider).addRecent(q);
    }
  }

  void _openResult(SearchResultItem item) {
    ref.read(searchHistoryStoreProvider).addRecent(_debouncedQuery);
    navigateToSearchResult(context, item);
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({
    required this.recent,
    required this.saved,
    required this.suggestions,
    required this.onPick,
    required this.onSaveToggle,
  });

  final List<String> recent;
  final List<String> saved;
  final List<String> suggestions;
  final ValueChanged<String> onPick;
  final ValueChanged<String> onSaveToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        if (recent.isNotEmpty) ...[
          Text('Recent', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: recent
                .map(
                  (q) => GestureDetector(
                    onLongPress: () => onSaveToggle(q),
                    child: ActionChip(
                      label: Text(q),
                      onPressed: () => onPick(q),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (saved.isNotEmpty) ...[
          Text('Saved', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: saved
                .map((q) => ActionChip(
                      avatar: const Icon(Icons.bookmark, size: 16),
                      label: Text(q),
                      onPressed: () => onPick(q),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        Text('Popular', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: suggestions
              .map((q) => ActionChip(
                    label: Text(q),
                    onPressed: () => onPick(q),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
