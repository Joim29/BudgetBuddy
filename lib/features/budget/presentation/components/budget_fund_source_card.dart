import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/budget/data/model/budget_model.dart';

class BudgetFundSourceCard extends StatelessWidget {
  final BudgetModel budget;
  const BudgetFundSourceCard({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing8),
      decoration: BoxDecoration(
        color: context.incomeBackground,
        border: Border.all(color: context.incomeLine),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Row(
        children: [
          CustomIconButton(
            context,
            onPressed: () {},
            icon: HugeIcons.strokeRoundedWallet01,
            backgroundColor: context.incomeBackground,
            borderColor: context.incomeLine,
            color: context.incomeText,
          ),
          const Gap(AppSpacing.spacing4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Funds Source',
                style: AppTextStyles.body3.copyWith(color: context.incomeText),
              ),
              Text(
                budget.wallet.name, // Display wallet name
                style: AppTextStyles.body5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
