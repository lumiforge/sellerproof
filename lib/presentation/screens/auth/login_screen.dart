import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:sellerproof/l10n/gen/app_localizations.dart';

import 'package:sellerproof/presentation/providers/auth_provider.dart';
import 'package:sellerproof/presentation/screens/auth/register_screen.dart';
import 'package:sellerproof/presentation/screens/scan_screen/scan_screen.dart';
import 'package:sellerproof/presentation/theme/app_colors.dart';
import 'package:sellerproof/presentation/widgets/auth_shared.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return AuthLayout(
      title: AppLocalizations.of(context)!.loginTitle,
      subtitle: AppLocalizations.of(context)!.loginSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AuthInput(
              label: AppLocalizations.of(context)!.emailLabel,
              placeholder: AppLocalizations.of(context)!.emailPlaceholder,
              icon: LucideIcons.mail,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v == null || v.isEmpty
                  ? AppLocalizations.of(context)!.emailValidator
                  : null,
            ),
            const SizedBox(height: 16),
            AuthInput(
              label: AppLocalizations.of(context)!.passwordLabel,
              placeholder: AppLocalizations.of(context)!.passwordPlaceholder,
              icon: LucideIcons.lock,
              controller: _passwordController,
              obscureText: true,
              validator: (v) => v == null || v.isEmpty
                  ? AppLocalizations.of(context)!.passwordValidator
                  : null,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Stub for forgot password
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppLocalizations.of(context)!.forgotPassword,
                  style: const TextStyle(
                    color: AppColors.sky600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            AuthButton(
              text: AppLocalizations.of(context)!.signInButton,
              onPressed: _login,
              isLoading: authProvider.isLoading,
            ),
            if (authProvider.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  authProvider.error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              runSpacing: 4,
              children: [
                Text(
                  AppLocalizations.of(context)!.noAccountText,
                  style: const TextStyle(color: AppColors.slate600),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.signUpLink,
                    style: const TextStyle(
                      color: AppColors.sky600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final success = await context.read<AuthProvider>().login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ScanScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
