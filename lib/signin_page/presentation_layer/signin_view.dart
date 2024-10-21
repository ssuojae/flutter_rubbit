import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medihabit/signin_page/presentation_layer/signin_event.dart';
import 'signin_bloc.dart';

final class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E3DC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Rubbit',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // KakaoTalk Login Button
              ElevatedButton.icon(
                onPressed: () {
                  _onSigninButtonPressed(context, const SigninEvent.kakaoSigninRequested());
                },
                icon: Image.asset(
                  'assets/icon/kakao_icon.png',
                  width: 24,
                  height: 24,
                ),
                label: const Text(
                  '카카오톡으로 시작하기',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE812),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _onSigninButtonPressed(context, const SigninEvent.appleSigninRequested());
                },
                icon: const Icon(
                  Icons.apple,
                  color: Colors.black,
                  size: 24,
                ),
                label: const Text(
                  'Apple로 시작하기',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSigninButtonPressed(BuildContext context, SigninEvent event) {
    context.read<SigninBloc>().add(event);
  }
}
