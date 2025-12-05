import 'package:sellerproof/core/utils/result.dart';
import 'package:sellerproof/data/models/api_models.dart';
import 'package:sellerproof/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Result<void, String>> call(RegisterRequest request) {
    return _repository.register(request);
  }
}
