import 'package:sellerproof/core/utils/result.dart';
import 'package:sellerproof/data/models/api_models.dart';
import 'package:sellerproof/domain/repositories/auth_repository.dart';

class GetCachedUserUseCase {
  final AuthRepository _repository;

  GetCachedUserUseCase(this._repository);

  Future<Result<UserInfo?, String>> call() => _repository.getCachedUser();
}
