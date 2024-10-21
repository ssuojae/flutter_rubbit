import 'package:freezed_annotation/freezed_annotation.dart';

part 'signin_event.freezed.dart';

@freezed
class SigninEvent with _$SigninEvent {
  const factory SigninEvent.googleSigninRequested() = GoogleSigninRequested;
  const factory SigninEvent.appleSigninRequested() = AppleSigninRequested;
  const factory SigninEvent.kakaoSigninRequested() = KakaoSigninRequested;
}
