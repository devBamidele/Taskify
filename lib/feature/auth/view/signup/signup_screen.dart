import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/common/components/index.dart';

import '../../../../common/styles/text_styles.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../../../../core/providers/providers.dart';
import '../widgets/index.dart';

class SignupScreen extends HookConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validationStates = useState<List<bool>>(List.filled(4, false));

    final emailFocusNode = useFocusNode();
    final pwdFocusNode = useFocusNode();
    final cfmPwdFocusNode = useFocusNode();

    final email = useTextEditingController();
    final password = useTextEditingController();
    final cfmPassword = useTextEditingController();

    final emailFormKey = useState(GlobalKey<FormState>());
    final pwdFormKey = useState(GlobalKey<FormState>());
    final cfmPwdFormKey = useState(GlobalKey<FormState>());

    final emailShakeState = useState(GlobalKey<ShakeState>());
    final cfmPwdShakeState = useState(GlobalKey<ShakeState>());

    final pwdVisible = useState(true);
    final cfmPwdVisible = useState(true);

    final pwdColor = useState(AppColors.hintTextColor);
    final cfmPwdColor = useState(AppColors.hintTextColor);

    const requirements = AppStrings.requirements;

    useEffect(() {
      void updatePasswordColor() {
        pwdColor.value = pwdFocusNode.hasFocus
            ? AppColors.black
            : password.text.isEmpty
                ? AppColors.hintTextColor
                : AppColors.black;
      }

      pwdFocusNode.addListener(updatePasswordColor);

      return () => pwdFocusNode.removeListener(updatePasswordColor);
    }, [pwdFocusNode]);

    useEffect(() {
      void updatePasswordColor() {
        cfmPwdColor.value = cfmPwdFocusNode.hasFocus
            ? AppColors.black
            : cfmPassword.text.isEmpty
                ? AppColors.hintTextColor
                : AppColors.black;
      }

      cfmPwdFocusNode.addListener(updatePasswordColor);

      return () => cfmPwdFocusNode.removeListener(updatePasswordColor);
    }, [cfmPwdFocusNode]);

    useEffect(() {
      void validatePassword() {
        final pwd = password.text;

        validationStates.value = [
          pwd.length >= 8,
          RegExp(r'[a-z]').hasMatch(pwd) && RegExp(r'[A-Z]').hasMatch(pwd),
          RegExp(r'\d').hasMatch(pwd),
          RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(pwd),
        ];
      }

      password.addListener(validatePassword);

      return () => password.removeListener(validatePassword);
    }, [password]);

    bool authLoading() {
      return ref.watch(authNotifierProvider).maybeWhen(
            orElse: () => false,
            loading: () => true,
          );
    }

    void signUp() {
      ref.read(authNotifierProvider.notifier).signup(
            email: email.text.trim(),
            password: password.text,
          );
    }

    void validateSignUp() {
      bool emailValid = emailFormKey.value.currentState?.validate() ?? false;
      bool pwdValid = password.text.validatePassword();
      bool cfmPwdValid = cfmPwdFormKey.value.currentState?.validate() ?? false;

      if (emailValid && pwdValid && cfmPwdValid) {
        signUp();
        return;
      }

      if (!emailValid) emailShakeState.value.currentState?.shake();
      if (!cfmPwdValid) cfmPwdShakeState.value.currentState?.shake();
    }

    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        authenticated: (user) => context.replace(AppRoutes.home),
        unauthenticated: (msg) => showSnackbar(context, msg),
      );
    });

    return AppScaffold(
      canNavigateBack: true,
      children: [
        const Header(
          topSpacing: 20,
          title: AppStrings.signUpTitle,
          subtitle: AppStrings.signUpSubtitle,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text(
            AppStrings.emailLabel,
            style: TextStyles.body(fontWeight: FontWeight.w500),
          ),
        ),
        Form(
          key: emailFormKey.value,
          child: Shake(
            key: emailShakeState.value,
            child: AppTextField(
              enabled: !authLoading(),
              focusNode: emailFocusNode,
              textController: email,
              hintText: AppStrings.emailHint,
              validation: (email) => email?.trim().validateEmail(),
            ),
          ),
        ),
        addHeight(12),
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text(
            AppStrings.passwordLabel,
            style: TextStyles.body(fontWeight: FontWeight.w500),
          ),
        ),
        Form(
          key: pwdFormKey.value,
          child: AppTextField(
            enabled: !authLoading(),
            focusNode: pwdFocusNode,
            textController: password,
            action: TextInputAction.done,
            hintText: AppStrings.passwordHint,
            obscureText: pwdVisible.value,
            onFieldSubmitted: (password) => validateSignUp(),
            validation: (pass) => pass?.validateString('Password'),
            suffixIcon: IconButton(
              icon: VisibilityIcon(
                isVisible: pwdVisible.value,
                iconColor: pwdColor.value,
              ),
              onPressed: () => pwdVisible.value = !pwdVisible.value,
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.all(12.h),
            margin: EdgeInsets.only(top: 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.black.withOpacity(0.6),
                width: 1, // Border thickness
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(requirements.length * 2 - 1, (index) {
                if (index.isEven) {
                  int requirementIndex = index ~/ 2;
                  return passwordRequirementRow(
                    requirements[requirementIndex],
                    checked: validationStates.value[requirementIndex],
                  );
                }
                return addHeight(6);
              }),
            )),
        addHeight(20),
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text(
            AppStrings.cfmPasswordLabel,
            style: TextStyles.body(fontWeight: FontWeight.w500),
          ),
        ),
        Form(
          key: cfmPwdFormKey.value,
          child: Shake(
            key: cfmPwdShakeState.value,
            child: AppTextField(
              enabled: !authLoading(),
              focusNode: cfmPwdFocusNode,
              textController: cfmPassword,
              action: TextInputAction.done,
              hintText: AppStrings.passwordHint,
              obscureText: cfmPwdVisible.value,
              validation: (value) => value.validateConfirmPwd(password),
              onFieldSubmitted: (password) => validateSignUp(),
              suffixIcon: IconButton(
                icon: VisibilityIcon(
                  isVisible: cfmPwdVisible.value,
                  iconColor: cfmPwdColor.value,
                ),
                onPressed: () => cfmPwdVisible.value = !cfmPwdVisible.value,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: AppButton(
            onPress: validateSignUp,
            text: AppStrings.signUpButton,
            loading: authLoading(),
          ),
        ),
      ],
    );
  }
}

Row passwordRequirementRow(String text, {required bool checked}) {
  return Row(
    children: [
      Icon(
        Icons.check,
        color: checked ? Colors.green.shade300 : AppColors.hintTextColor,
        size: 17,
      ),
      addWidth(8),
      Expanded(
        child: Text(
          text,
          style: TextStyles.body(
            color: checked ? Colors.green.shade300 : AppColors.hintTextColor,
            fontSize: 15.5,
          ),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ),
    ],
  );
}
