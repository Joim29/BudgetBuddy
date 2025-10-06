import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_grouped_card.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_summary_card.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_tab_bar.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_providers.dart';
import 'package:pockaw/features/transaction/presentation/screens/transaction_filter_form_dialog.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTransactionsAsyncValue = ref.watch(transactionListProvider);
    final isFilterActive = ref.watch(transactionFilterProvider);

    return CustomScaffold(
      context: context,
      showBackButton: false,
      showBalance: true,
      title: 'My Transactions',
      actions: [
        CustomIconButton(
          context,
          onPressed: () {
            final currentFilter = ref.read(transactionFilterProvider);
            context.openBottomSheet(
              child: TransactionFilterFormDialog(initialFilter: currentFilter),
            );
          },
          icon: HugeIcons.strokeRoundedFilter,
          showBadge: isFilterActive != null,
          themeMode: context.themeMode,
        ),
      ],
      body: allTransactionsAsyncValue.when(
        data: (allTransactions) {
          if (allTransactions.isEmpty) {
            return const Center(child: Text('No transactions recorded yet.'));
          }

          // 1. Extract unique months from transactions
          final uniqueMonthYears = allTransactions
              .map((t) => DateTime(t.date.year, t.date.month, 1))
              .toSet()
              .toList();

          // 2. Sort months in descending order (most recent first)
          uniqueMonthYears.sort((a, b) => a.compareTo(b));

          if (uniqueMonthYears.isEmpty) {
            // This case should ideally be covered by allTransactions.isEmpty,
            // but as a fallback.
            return const Center(
              child: Text('No transactions with valid dates found.'),
            );
          }

          // Determine initial index - try to set to current month if available, else most recent
          final now = DateTime.now();
          final currentMonthDate = DateTime(now.year, now.month, 1);
          int initialTabIndex = uniqueMonthYears.indexOf(currentMonthDate);
          if (initialTabIndex == -1) {
            initialTabIndex =
                0; // Default to the most recent month if current is not in the list
          }

          return DefaultTabController(
            length: uniqueMonthYears.length,
            initialIndex: initialTabIndex,
            child: Column(
              children: [
                const Gap(AppSpacing.spacing20),
                TransactionTabBar(
                  // TabController is now implicitly handled by DefaultTabController
                  monthsForTabs: uniqueMonthYears,
                ),
                const Gap(AppSpacing.spacing20),
                Expanded(
                  child: TabBarView(
                    children: uniqueMonthYears.map((tabMonthDate) {
                      // Filter transactions for the current tab's month
                      final transactionsForMonth = allTransactions.where((t) {
                        return t.date.year == tabMonthDate.year &&
                            t.date.month == tabMonthDate.month;
                      }).toList();

                      if (transactionsForMonth.isEmpty) {
                        // This should ideally not happen if tabs are generated from existing transaction months,
                        // but good for robustness.
                        return Center(
                          child: Text(
                            'No transactions for ${tabMonthDate.month}/${tabMonthDate.year}.',
                          ),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.only(bottom: 120),
                        children: [
                          TransactionSummaryCard(
                            transactions: transactionsForMonth,
                          ),
                          const Gap(AppSpacing.spacing20),
                          TransactionGroupedCard(
                            transactions: transactionsForMonth,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
