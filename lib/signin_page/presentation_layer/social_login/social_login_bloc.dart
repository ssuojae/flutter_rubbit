import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medihabit/signin_page/presentation_layer/social_login/social_login_event.dart';
import 'package:medihabit/signin_page/presentation_layer/social_login/social_login_state.dart';

import '../../../util/result.dart';
import '../../domain_layer/entities/user_entity.dart';
import '../../domain_layer/repositories/user_repository_interface.dart';

final class SocialLoginBloc extends Bloc<SocialLoginEvent, SocialLoginState> {
  final IUserRepository userRepository;

  SocialLoginBloc({required this.userRepository}) : super(SocialLoginState.initial()) {
    on<SocialLoginEvent>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(SocialLoginEvent event, Emitter<SocialLoginState> emit) async {
    emit(state.copyWith(isLoading: true));

    final Result<UserEntity> result = await event.when(
      googleSigninRequested: () => _signinWithGoogle(),
      appleSigninRequested: () => _signinWithApple(),
      kakaoSigninRequested: () => _signinWithKakao(),
    );

    result.when(
      success: (user) => _handleLoginSuccess(emit, user),
      failure: (error) => _handleLoginError(emit, error),
    );
  }

  Future<Result<UserEntity>> _signinWithGoogle() async => await userRepository.signInWithGoogle();

  Future<Result<UserEntity>> _signinWithApple() async => await userRepository.signInWithApple();

  Future<Result<UserEntity>> _signinWithKakao() async => await userRepository.signInWithKakao();

  void _handleLoginSuccess(Emitter<SocialLoginState> emit, UserEntity user) {
    emit(state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      user: user,
      error: null,
    ));
  }

  void _handleLoginError(Emitter<SocialLoginState> emit, String error) {
    emit(state.copyWith(
      isLoading: false,
      isAuthenticated: false,
      error: error,
    ));
  }
}
