import 'package:sellerproof/core/utils/result.dart';
import 'package:sellerproof/domain/repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository _repository;

  VerifyEmailUseCase(this._repository);

  Future<Result<void, String>> call(String email, String code) {
    return _repository.verifyEmail(email, code);
  }
}
