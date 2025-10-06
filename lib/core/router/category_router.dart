import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/category/presentation/screens/category_icon_asset_picker.dart';
import 'package:pockaw/features/category/presentation/screens/category_icon_emoji_picker.dart';
import 'package:pockaw/features/category_picker/presentation/screens/category_picker_screen.dart';

class CategoryRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.categoryList,
      builder: (context, state) => const CategoryPickerScreen(),
    ),
    GoRoute(
      path: Routes.manageCategories,
      builder: (context, state) =>
          const CategoryPickerScreen(isManageCategories: true),
    ),
    GoRoute(
      path: Routes.categoryListPickingParent,
      builder: (context, state) =>
          const CategoryPickerScreen(isPickingParent: true),
    ),
    GoRoute(
      path: Routes.categoryIconAssetPicker,
      builder: (context, state) => const CategoryIconAssetPicker(),
    ),
    GoRoute(
      path: Routes.categoryIconEmojiPicker,
      builder: (context, state) => const CategoryIconEmojiPicker(),
    ),
    // GoRoute(
    //   path: Routes.categoryIconInitialPicker,
    //   builder: (context, state) => const CategoryIconAssetPicker(),
    // ),
  ];
}
