import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:sellerproof/l10n/gen/app_localizations.dart';

import 'package:sellerproof/presentation/providers/auth_provider.dart';
import 'package:sellerproof/presentation/screens/auth/login_screen.dart';
import 'package:sellerproof/presentation/widgets/app_input.dart';
import 'package:sellerproof/presentation/widgets/auth_shared.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final l = AppLocalizations.of(context)!;
    return AuthLayout(
      title: l.verifyEmailTitle,
      subtitle: l.verifyEmailSubtitle(widget.email),
      child: Column(
        children: [
          AppInput(
            label: l.verificationCodeLabel,
            placeholder: l.verificationCodePlaceholder,
            icon: LucideIcons.shieldCheck,
            controller: _codeController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          AuthButton(
            text: l.verifyButton,
            onPressed: _verify,
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
        ],
      ),
    );
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    final success = await context.read<AuthProvider>().verifyEmail(
      widget.email,
      code,
    );
    if (success && mounted) {
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.emailVerifiedSnackbar)));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}
