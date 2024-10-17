import 'package:medihabit/signin_page/domain_layer/user_entity.dart';

abstract interface class IUserRepository {
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signInWithKakao();
  Future<UserEntity?> fetchUser(String userId);
}
