import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellerproof/data/models/api_models.dart';

import 'package:sellerproof/presentation/providers/auth_provider.dart';
import 'package:sellerproof/presentation/screens/auth/verify_email_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  final _orgNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Вступить в организацию'),
                  Tab(text: 'Создать организацию'),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'ФИО'),
                validator: (v) => v == null || v.isEmpty ? 'Введите ФИО' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Введите email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Введите пароль' : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 80,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Join
                    TextFormField(
                      controller: _inviteCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Код приглашения',
                      ),
                      validator: (v) {
                        if (_tabController.index == 0 &&
                            (v == null || v.isEmpty)) {
                          return 'Введите код';
                        }
                        return null;
                      },
                    ),
                    // Create
                    TextFormField(
                      controller: _orgNameController,
                      decoration: const InputDecoration(
                        labelText: 'Название организации',
                      ),
                      validator: (v) {
                        if (_tabController.index == 1 &&
                            (v == null || v.isEmpty)) {
                          return 'Введите название';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (authProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Зарегистрироваться'),
                ),
              if (authProvider.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    authProvider.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final isJoin = _tabController.index == 0;
      final request = RegisterRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        inviteCode: isJoin ? _inviteCodeController.text.trim() : null,
        organizationName: !isJoin ? _orgNameController.text.trim() : null,
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
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _inviteCodeController.dispose();
    _orgNameController.dispose();
    super.dispose();
  }
}
