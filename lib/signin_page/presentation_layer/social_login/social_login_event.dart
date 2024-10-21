import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_login_event.freezed.dart';

@freezed
class SocialLoginEvent with _$SigninEvent {
  const factory SocialLoginEvent.googleSigninRequested() = GoogleSigninRequested;
  const factory SocialLoginEvent.appleSigninRequested() = AppleSigninRequested;
  const factory SocialLoginEvent.kakaoSigninRequested() = KakaoSigninRequested;
}
