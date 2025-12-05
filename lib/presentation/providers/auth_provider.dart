import 'package:flutter/material.dart';
import 'package:sellerproof/core/utils/result.dart';
import 'package:sellerproof/data/models/api_models.dart';
import 'package:sellerproof/domain/usecases/auth/get_cached_user_usecase.dart';
import 'package:sellerproof/domain/usecases/auth/login_usecase.dart';
import 'package:sellerproof/domain/usecases/auth/logout_usecase.dart';
import 'package:sellerproof/domain/usecases/auth/register_usecase.dart';
import 'package:sellerproof/domain/usecases/auth/verify_email_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;
  final LogoutUseCase logoutUseCase;

  UserInfo? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyEmailUseCase,
    required this.getCachedUserUseCase,
    required this.logoutUseCase,
  });

  UserInfo? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> checkAuthStatus() async {
    final result = await getCachedUserUseCase();
    if (result is Success<UserInfo?, String>) {
      _user = result.data;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await loginUseCase(email, password);
    _isLoading = false;

    if (result is Success<UserInfo, String>) {
      _user = result.data;
      notifyListeners();
      return true;
    } else if (result is Failure<UserInfo, String>) {
      _error = result.error;
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<bool> register(RegisterRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await registerUseCase(request);
    _isLoading = false;

    if (result is Success) {
      return true;
    } else if (result is Failure<void, String>) {
      _error = result.error;
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<bool> verifyEmail(String email, String code) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await verifyEmailUseCase(email, code);
    _isLoading = false;

    if (result is Success) {
      return true;
    } else if (result is Failure<void, String>) {
      _error = result.error;
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<void> logout() async {
    await logoutUseCase();
    _user = null;
    notifyListeners();
  }
}
