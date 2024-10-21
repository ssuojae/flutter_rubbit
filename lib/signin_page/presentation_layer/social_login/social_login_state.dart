import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medihabit/signin_page/domain_layer/entities/user_entity.dart';

part 'social_login_state.freezed.dart';


@freezed
class SocialLoginState with _$SigninState {
  const factory SocialLoginState({
    required bool isLoading,
    bool? isAuthenticated,
    UserEntity? user,
    String? error,
  }) = _SigninState;

  factory SocialLoginState.initial() => const SocialLoginState(
    isLoading: false,
    isAuthenticated: false,
    user: null,
    error: null,
  );
}
