import 'package:sellerproof/core/utils/result.dart';
import 'package:sellerproof/data/models/api_models.dart';
import 'package:sellerproof/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Result<UserInfo, String>> call(String email, String password) {
    return _repository.login(email, password);
  }
}
