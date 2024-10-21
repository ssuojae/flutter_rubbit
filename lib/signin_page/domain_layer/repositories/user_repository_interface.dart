import 'package:medihabit/signin_page/domain_layer/entities/user_entity.dart';

import '../../../util/result.dart';

abstract interface class IUserRepository {
  Future<Result<UserEntity>> signInWithGoogle();
  Future<Result<UserEntity>> signInWithApple();
  Future<Result<UserEntity>> signInWithKakao();
  Future<Result<UserEntity>> fetchUser(String userId);
}
