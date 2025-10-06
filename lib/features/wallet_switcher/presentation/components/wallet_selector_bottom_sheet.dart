import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/bottom_sheets/alert_bottom_sheet.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';

class WalletSelectorBottomSheet extends ConsumerWidget {
  const WalletSelectorBottomSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allWalletsAsync = ref.watch(allWalletsStreamProvider);
    final activeWalletAsync = ref.watch(activeWalletProvider);

    return CustomBottomSheet(
      title: 'Select Wallet',
      child: allWalletsAsync.when(
        data: (wallets) {
          if (wallets.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.spacing16),
                child: Text('No wallets available.'),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: wallets.length,
            itemBuilder: (context, index) {
              final wallet = wallets[index];
              final bool isSelected =
                  activeWalletAsync.valueOrNull?.id == wallet.id;

              return ListTile(
                title: Text(wallet.name, style: AppTextStyles.body1),
                dense: true,
                // You can add icons or other details here
                // leading: wallet.iconName != null ? Icon(...) : null,
                subtitle: Text(
                  '${wallet.currencyByIsoCode(ref).symbol} ${wallet.balance.toPriceFormat()}',
                  style: AppTextStyles.body3,
                ),
                trailing: Icon(
                  isSelected
                      ? HugeIcons.strokeRoundedCheckmarkCircle01
                      : HugeIcons.strokeRoundedCircle,
                  color: isSelected ? Colors.green : Colors.grey,
                ),
                onTap: () {
                  if (isSelected) return;
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    builder: (context) {
                      return AlertBottomSheet(
                        title: 'Switch Wallet',
                        content: Text(
                          'Are you sure you want to switch to ${wallet.name}?',
                          style: AppTextStyles.body2,
                        ),
                        onConfirm: () {
                          ref
                              .read(activeWalletProvider.notifier)
                              .setActiveWallet(wallet);
                          context.pop(); // Close the dialog
                          context.pop(); // Close the bottom sheet
                        },
                      );
                    },
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 1),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
