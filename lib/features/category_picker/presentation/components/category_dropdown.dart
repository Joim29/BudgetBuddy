import 'package:expandable/expandable.dart'
    show ExpandableController, ExpandablePanel, ExpandableThemeData;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useMemoized, useState;

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/database/tables/category_table.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/category/presentation/riverpod/category_providers.dart';
import 'package:pockaw/features/category/presentation/screens/category_form_screen.dart';

import 'category_tile.dart';

class CategoryDropdown extends HookConsumerWidget {
  final bool isManageCategory;
  final CategoryModel category;
  const CategoryDropdown({
    super.key,
    this.isManageCategory = false,
    required this.category,
  });

  @override
  Widget build(BuildContext context, ref) {
    final expandableController = useMemoized(() => ExpandableController(), []);
    final expanded = useState(false);

    final List<CategoryModel> subCategories = category.subCategories ?? [];

    return ExpandablePanel(
      controller: expandableController,
      header: CategoryTile(
        category: category,
        suffixIcon: expanded.value
            ? HugeIcons.strokeRoundedArrowDown01
            : HugeIcons.strokeRoundedArrowRight01,
        onSelectCategory: (selectedCategory) async {
          Log.d(selectedCategory.toJson(), label: 'category');
          // if picking category, then return to previous screen with selected category
          if (!isManageCategory) {
            context.pop(selectedCategory);
          } else {
            // reset parent selection
            ref.read(selectedParentCategoryProvider.notifier).state = null;

            context.openBottomSheet(
              child: CategoryFormScreen(
                categoryId: selectedCategory.id,
                isEditingParent: true,
              ),
            );
          }
        },
        onSuffixIconPressed: () {
          expandableController.toggle();
          expanded.value = !expanded.value;
        },
      ),
      collapsed: Container(),
      expanded: ListView.separated(
        itemCount: subCategories.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          top: AppSpacing.spacing8,
          left: AppSpacing.spacing24,
        ),
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const Gap(AppSpacing.spacing8),
        itemBuilder: (context, index) {
          final subCategory = subCategories[index];
          return CategoryTile(
            category: subCategory,
            onSelectCategory: (selectedCategory) async {
              Log.d(selectedCategory.toJson(), label: 'category');
              // if picking category, then return to previous screen with selected category
              if (!isManageCategory) {
                context.pop(selectedCategory);
              } else {
                // reset parent selection
                ref.read(selectedParentCategoryProvider.notifier).state = null;

                // select parent if possible
                if (selectedCategory.parentId != null) {
                  final parentCategory = await ref
                      .read(databaseProvider)
                      .categoryDao
                      .getCategoryById(selectedCategory.parentId!);
                  Log.d(parentCategory?.toJson(), label: 'parent category');
                  if (parentCategory != null) {
                    ref.read(selectedParentCategoryProvider.notifier).state =
                        parentCategory.toModel();
                  }
                }

                if (!context.mounted) return;

                context.openBottomSheet(
                  child: CategoryFormScreen(categoryId: selectedCategory.id),
                );
              }
            },
          );
        },
      ),
      theme: const ExpandableThemeData(
        hasIcon: false,
        useInkWell: false,
        tapHeaderToExpand: false,
      ),
    );
  }
}
