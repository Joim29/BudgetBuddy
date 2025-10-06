part of '../screens/login_screen.dart';

class Form extends HookConsumerWidget {
  final TextEditingController nameField;
  const Form({super.key, required this.nameField});

  @override
  Widget build(BuildContext context, ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const LoginImagePicker(),
          const Gap(AppSpacing.spacing20),
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Get Started',
                style: AppTextStyles.heading5,
                textAlign: TextAlign.center,
              ),
              Gap(AppSpacing.spacing4),
              GetStartedDescription(),
            ],
          ),
          const Gap(AppSpacing.spacing20),
          Column(
            spacing: AppSpacing.spacing16,
            children: [
              CustomTextField(
                controller: nameField,
                label: 'Name',
                hint: 'John Doe',
                prefixIcon: HugeIcons.strokeRoundedTextSmallcaps,
              ),
              const CreateFirstWalletField(),
            ],
          ),
          const Gap(AppSpacing.spacing20),
          const LoginInfo(),
          const Gap(AppSpacing.spacing56),
        ],
      ),
    );
  }
}
