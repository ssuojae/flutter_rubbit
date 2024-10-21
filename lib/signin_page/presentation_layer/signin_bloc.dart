import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medihabit/signin_page/presentation_layer/signin_event.dart';
import 'package:medihabit/signin_page/presentation_layer/signin_state.dart';

import '../../util/result.dart';
import '../domain_layer/entities/user_entity.dart';
import '../domain_layer/repositories/user_repository_interface.dart';

final class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final IUserRepository userRepository;

  SigninBloc({required this.userRepository}) : super(SigninState.initial()) {
    on<SigninEvent>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(SigninEvent event, Emitter<SigninState> emit) async {
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

  void _handleLoginSuccess(Emitter<SigninState> emit, UserEntity user) {
    emit(state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      user: user,
      error: null,
    ));
  }

  void _handleLoginError(Emitter<SigninState> emit, String error) {
    emit(state.copyWith(
      isLoading: false,
      isAuthenticated: false,
      error: error,
    ));
  }
}
