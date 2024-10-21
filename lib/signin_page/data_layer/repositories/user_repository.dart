import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:medihabit/signin_page/domain_layer/entities/user_entity.dart';
import '../../../util/result.dart';
import '../../domain_layer/repositories/user_repository_interface.dart';

final class UserRepository implements IUserRepository {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  UserRepository(this._firestore, this._firebaseAuth);

  @override
  Future<Result<UserEntity>> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return const Result.failure('Google sign-in canceled.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      final userEntity = _convertToDomainUser(id: userCredential.user!.uid);
      await _storeUserInFirestore(userEntity);

      return Result.success(userEntity);
    } catch (error) {
      return Result.failure('Google Sign-in Error: $error');
    }
  }

  @override
  Future<Result<UserEntity>> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      final credential = firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      final userEntity = _convertToDomainUser(
        id: userCredential.user!.uid,
        name: userCredential.additionalUserInfo?.profile?['givenName'] ?? 'N/A',
        email: userCredential.user?.email ?? 'N/A',
      );
      await _storeUserInFirestore(userEntity);

      return Result.success(userEntity);
    } catch (error) {
      return Result.failure('Apple Sign-in Error: $error');
    }
  }

  @override
  Future<Result<UserEntity>> signInWithKakao() async {
    kakao.User? kakaoUser;
    try {
      final token = await _fetchKakaoToken();
      kakaoUser = await kakao.UserApi.instance.me();
      await _requestKakaoPermissions(token, kakaoUser);

      final credential = firebase_auth.OAuthProvider('oidc.medihabit').credential(
        accessToken: token.accessToken,
        idToken: token.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      final userEntity = _convertToDomainUser(
        id: userCredential.user!.uid,
        name: kakaoUser.kakaoAccount?.profile?.nickname ?? 'N/A',
        email: kakaoUser.kakaoAccount?.email ?? 'N/A',
      );
      await _storeUserInFirestore(userEntity);

      return Result.success(userEntity);
    } catch (error) {
      return Result.failure('Kakao Sign-in Error: $error');
    }
  }

  @override
  Future<Result<UserEntity>> fetchUser(String userId) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(userId).get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        final user = UserEntity.fromJson(docSnapshot.data()!);
        return Result.success(user);
      }
      return const Result.failure('User not found');
    } catch (error) {
      return Result.failure('Fetch User Error: $error');
    }
  }

  UserEntity _convertToDomainUser({
    required String id,
    String name = 'N/A',
    String email = 'N/A',
  }) {
    return UserEntity(
      id: id,
      name: name,
      email: email,
    );
  }

  Future<void> _storeUserInFirestore(UserEntity user) async {
    await _firestore.collection('users').doc(user.id).set(user.toJson(), SetOptions(merge: true));
  }

  Future<kakao.OAuthToken> _fetchKakaoToken() async {
    try {
      return await (await kakao.isKakaoTalkInstalled()
          ? kakao.UserApi.instance.loginWithKakaoTalk()
          : kakao.UserApi.instance.loginWithKakaoAccount());
    } catch (error) {
      return Future<kakao.OAuthToken>.error('Kakao Sign-in Error: $error');
    }
  }

  Future<kakao.OAuthToken> _requestKakaoPermissions(kakao.OAuthToken token, kakao.User kakaoUser) async {
    final requiredScopes = [
      if (kakaoUser.kakaoAccount?.emailNeedsAgreement == true) 'account_email',
      if (kakaoUser.kakaoAccount?.profileNeedsAgreement == true) 'profile',
    ];
    if (requiredScopes.isEmpty) token;
    try {
      return await kakao.UserApi.instance.loginWithNewScopes(requiredScopes);
    } catch (error) {
      return token;
    }
  }
}
