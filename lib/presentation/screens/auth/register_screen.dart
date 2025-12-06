import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:sellerproof/l10n/gen/app_localizations.dart';
import 'package:sellerproof/data/models/api_models.dart';

import 'package:sellerproof/presentation/providers/auth_provider.dart';
import 'package:sellerproof/presentation/screens/auth/verify_email_screen.dart';
import 'package:sellerproof/presentation/theme/app_colors.dart';
import 'package:sellerproof/presentation/widgets/auth_shared.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isJoinOrganization = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  final _orgNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return AuthLayout(
      title: AppLocalizations.of(context)!.registerTitle,
      subtitle: AppLocalizations.of(context)!.registerSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AuthInput(
              label: AppLocalizations.of(context)!.fullNameLabel,
              placeholder: AppLocalizations.of(context)!.fullNamePlaceholder,
              icon: LucideIcons.user,
              controller: _fullNameController,
              validator: (v) => v == null || v.isEmpty
                  ? AppLocalizations.of(context)!.fullNameValidator
                  : null,
            ),
            const SizedBox(height: 16),
            AuthToggle(
              isFirstOption: _isJoinOrganization,
              firstOption: AppLocalizations.of(context)!.joinOrganization,
              secondOption: AppLocalizations.of(context)!.createOrganization,
              onToggle: () {
                setState(() {
                  _isJoinOrganization = !_isJoinOrganization;
                });
              },
            ),
            const SizedBox(height: 16),
            if (_isJoinOrganization)
              AuthInput(
                label: AppLocalizations.of(context)!.inviteCodeLabel,
                placeholder: AppLocalizations.of(
                  context,
                )!.inviteCodePlaceholder,
                icon: LucideIcons.key,
                controller: _inviteCodeController,
                validator: (v) => v == null || v.isEmpty
                    ? AppLocalizations.of(context)!.inviteCodeValidator
                    : null,
              )
            else
              AuthInput(
                label: AppLocalizations.of(context)!.orgNameLabel,
                placeholder: AppLocalizations.of(context)!.orgNamePlaceholder,
                icon: LucideIcons.building,
                controller: _orgNameController,
                validator: (v) => v == null || v.isEmpty
                    ? AppLocalizations.of(context)!.orgNameValidator
                    : null,
              ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
            AuthButton(
              text: AppLocalizations.of(context)!.createAccountButton,
              onPressed: _register,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.alreadyHaveAccountText,
                  style: const TextStyle(color: AppColors.slate600),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.loginLink,
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

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final request = RegisterRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        inviteCode: _isJoinOrganization
            ? _inviteCodeController.text.trim()
            : null,
        organizationName: !_isJoinOrganization
            ? _orgNameController.text.trim()
            : null,
      );

      final success = await context.read<AuthProvider>().register(request);
      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyEmailScreen(email: request.email),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _inviteCodeController.dispose();
    _orgNameController.dispose();
    super.dispose();
  }
}
