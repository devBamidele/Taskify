import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/common/styles/text_styles.dart';

import '../../../../common/components/index.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../../../../core/providers/providers.dart';
import '../widgets/index.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailFocusNode = useFocusNode();
    final pwdFocusNode = useFocusNode();

    final email = useTextEditingController();
    final password = useTextEditingController();

    final emailFormKey = useState(GlobalKey<FormState>());
    final pwdFormKey = useState(GlobalKey<FormState>());

    final emailShakeState = useState(GlobalKey<ShakeState>());
    final pwdShakeState = useState(GlobalKey<ShakeState>());

    final pwdVisible = useState(true);
    final pwdColor = useState(AppColors.hintTextColor);

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

    bool authLoading() {
      return ref.watch(authNotifierProvider).maybeWhen(
            orElse: () => false,
            loading: () => true,
          );
    }

    void login() {
      ref.read(authNotifierProvider.notifier).login(
            email: email.text.trim(),
            password: password.text,
          );
    }

    void validateLogin() {
      bool emailValid = emailFormKey.value.currentState?.validate() ?? false;
      bool pwdValid = pwdFormKey.value.currentState?.validate() ?? false;

      if (emailValid && pwdValid) {
        login();
        return;
      }

      if (!emailValid) emailShakeState.value.currentState?.shake();
      if (!pwdValid) pwdShakeState.value.currentState?.shake();
    }

    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        authenticated: (user) => context.replace(AppRoutes.home),
        unauthenticated: (msg) => showSnackbar(context, msg),
      );
    });

    return AppScaffold(
      children: [
        addHeight(20),
        const Header(
          title: AppStrings.loginTitle,
          subtitle: AppStrings.loginSubtitle,
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
          child: Shake(
            key: pwdShakeState.value,
            child: AppTextField(
              enabled: !authLoading(),
              focusNode: pwdFocusNode,
              textController: password,
              action: TextInputAction.done,
              hintText: AppStrings.passwordHint,
              obscureText: pwdVisible.value,
              onFieldSubmitted: (password) => validateLogin(),
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
        ),
        Padding(
          padding: EdgeInsets.only(top: 40.h),
          child: AppButton(
            onPress: validateLogin,
            text: AppStrings.loginButton,
            loading: authLoading(),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.unRegistered,
                style: TextStyles.body(color: AppColors.hintTextColor),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.signup),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(0, 7, 11, 7),
                ),
                child: Text(
                  AppStrings.cAccount,
                  style: TextStyles.body(fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
