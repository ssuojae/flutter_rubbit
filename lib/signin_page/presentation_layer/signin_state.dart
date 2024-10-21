import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medihabit/signin_page/domain_layer/entities/user_entity.dart';

part 'signin_state.freezed.dart';


@freezed
class SigninState with _$SigninState {
  const factory SigninState({
    required bool isLoading,
    bool? isAuthenticated,
    UserEntity? user,
    String? error,
  }) = _SigninState;

  factory SigninState.initial() => const SigninState(
    isLoading: false,
    isAuthenticated: false,
    user: null,
    error: null,
  );
}
