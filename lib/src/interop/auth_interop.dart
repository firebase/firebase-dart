@JS('firebase.auth')
library firebase.auth_interop;

import 'package:func/func.dart';
import 'package:js/js.dart';

import 'app_interop.dart';
import 'firebase_interop.dart';

@JS('Auth')
abstract class AuthJsImpl {
  external AppJsImpl get app;
  external PromiseJsImpl applyActionCode(String code);
  external PromiseJsImpl<ActionCodeInfo> checkActionCode(String code);
  external PromiseJsImpl confirmPasswordReset(String code, String newPassword);
  external PromiseJsImpl<UserJsImpl> createUserWithEmailAndPassword(
      String email, String password);
  external UserJsImpl get currentUser;
  external PromiseJsImpl<List<String>> fetchProvidersForEmail(String email);
  external PromiseJsImpl<UserCredentialJsImpl> getRedirectResult();
  external String get languageCode;
  external void set languageCode(String s);
  external Func0 onAuthStateChanged(nextOrObserver,
      [Func1 opt_error, Func0 opt_completed]);
  external Func0 onIdTokenChanged(nextOrObserver,
      [Func1 opt_error, Func0 opt_completed]);
  external PromiseJsImpl sendPasswordResetEmail(String email,
      [ActionCodeSettings actionCodeSettings]);
  external PromiseJsImpl setPersistence(String persistence);
  external PromiseJsImpl<UserCredentialJsImpl>
      signInAndRetrieveDataWithCredential(AuthCredential credential);
  external PromiseJsImpl<UserJsImpl> signInAnonymously();
  external PromiseJsImpl<UserJsImpl> signInWithCredential(
      AuthCredential credential);
  external PromiseJsImpl<UserJsImpl> signInWithCustomToken(String token);
  external PromiseJsImpl<UserJsImpl> signInWithEmailAndPassword(
      String email, String password);
  external PromiseJsImpl<ConfirmationResultJsImpl> signInWithPhoneNumber(
      String phoneNumber, ApplicationVerifierJsImpl applicationVerifier);
  external PromiseJsImpl<UserCredentialJsImpl> signInWithPopup(
      AuthProviderJsImpl provider);
  external PromiseJsImpl signInWithRedirect(AuthProviderJsImpl provider);
  external PromiseJsImpl signOut();
  external void useDeviceLanguage();
  external PromiseJsImpl<String> verifyPasswordResetCode(String code);
}

/// An enumeration of the possible persistence mechanism types.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.Auth#.Persistence>
@JS('Auth.Persistence')
class Persistence {
  /// Indicates that the state will be persisted even when the browser window
  /// is closed.
  external static String get LOCAL;
  /// Indicates that the state will only be stored in memory and will be cleared
  /// when the window.
  external static String get NONE;
  /// Indicates that the state will only persist in current session/tab,
  /// relevant to web only, and will be cleared when the tab is closed.
  external static String get SESSION;
}

/// Represents the credentials returned by an auth provider.
/// Implementations specify the details about each auth provider's credential
/// requirements.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.AuthCredential>.
@JS()
abstract class AuthCredential {
  /// The authentication provider ID for the credential.
  external String get providerId;
}

@JS('AuthProvider')
abstract class AuthProviderJsImpl {
  external String get providerId;
}

@JS('EmailAuthProvider')
class EmailAuthProviderJsImpl extends AuthProviderJsImpl {
  external factory EmailAuthProviderJsImpl();
  external static String get PROVIDER_ID;
  external static AuthCredential credential(String email, String password);
}

@JS('FacebookAuthProvider')
class FacebookAuthProviderJsImpl extends AuthProviderJsImpl {
  external factory FacebookAuthProviderJsImpl();
  external static String get PROVIDER_ID;
  external FacebookAuthProviderJsImpl addScope(String scope);
  external FacebookAuthProviderJsImpl setCustomParameters(
      customOAuthParameters);
  external static AuthCredential credential(String token);
}

@JS('GithubAuthProvider')
class GithubAuthProviderJsImpl extends AuthProviderJsImpl {
  external factory GithubAuthProviderJsImpl();
  external static String get PROVIDER_ID;
  external GithubAuthProviderJsImpl addScope(String scope);
  external GithubAuthProviderJsImpl setCustomParameters(customOAuthParameters);
  external static AuthCredential credential(String token);
}

@JS('GoogleAuthProvider')
class GoogleAuthProviderJsImpl extends AuthProviderJsImpl {
  external factory GoogleAuthProviderJsImpl();
  external static String get PROVIDER_ID;
  external GoogleAuthProviderJsImpl addScope(String scope);
  external GoogleAuthProviderJsImpl setCustomParameters(customOAuthParameters);
  external static AuthCredential credential(
      [String idToken, String accessToken]);
}

@JS('TwitterAuthProvider')
class TwitterAuthProviderJsImpl extends AuthProviderJsImpl {
  external factory TwitterAuthProviderJsImpl();
  external static String get PROVIDER_ID;
  external TwitterAuthProviderJsImpl setCustomParameters(customOAuthParameters);
  external static AuthCredential credential(String token, String secret);
}

@JS('PhoneAuthProvider')
class PhoneAuthProviderJsImpl extends AuthProviderJsImpl {
  external factory PhoneAuthProviderJsImpl([AuthJsImpl auth]);
  external static String get PROVIDER_ID;
  external PromiseJsImpl<String> verifyPhoneNumber(
      String phoneNumber, ApplicationVerifierJsImpl applicationVerifier);
  // TODO official documentation says PromiseJsImpl<AuthCredential> return type
  external static AuthCredential credential(
      String verificationId, String verificationCode);
}

@JS('ApplicationVerifier')
abstract class ApplicationVerifierJsImpl {
  external String get type;
  external PromiseJsImpl<String> verify();
}

@JS('RecaptchaVerifier')
class RecaptchaVerifierJsImpl extends ApplicationVerifierJsImpl {
  external factory RecaptchaVerifierJsImpl(container,
      [Object parameters, AppJsImpl app]);
  external clear();
  external PromiseJsImpl<num> render();
}

@JS('ConfirmationResult')
abstract class ConfirmationResultJsImpl {
  external String get verificationId;
  external PromiseJsImpl<UserCredentialJsImpl> confirm(String verificationCode);
}

/// A response from [Auth.checkActionCode].
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.ActionCodeInfo>.
@JS()
abstract class ActionCodeInfo {
  external ActionCodeEmail get data;
}

/// An authentication error.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.Error>.
@JS('Error')
abstract class AuthError {
  external String get code;
  external void set code(String s);
  external String get message;
  external void set message(String s);
}

@JS()
@anonymous
class ActionCodeEmail {
  external String get email;
}

/// This is the interface that defines the required continue/state URL with
/// optional Android and iOS bundle identifiers.
///
/// The fields are:
///
/// [url] Sets the link continue/state URL, which has different meanings
/// in different contexts:
/// * When the link is handled in the web action widgets, this is the deep link
/// in the continueUrl query parameter.
/// * When the link is handled in the app directly, this is the continueUrl
/// query parameter in the deep link of the Dynamic Link.
///
/// [iOS] Sets the iOS bundle ID. This will try to open the link in an iOS app
/// if it is installed.
///
/// [android] Sets the Android package name. This will try to open the link
/// in an android app if it is installed.
/// If installApp is passed, it specifies whether to install the Android app
/// if the device supports it and the app is not already installed.
/// If this field is provided without a packageName, an error is thrown
/// explaining that the packageName must be provided in conjunction with
/// this field.
/// If minimumVersion is specified, and an older version of the app
/// is installed, the user is taken to the Play Store to upgrade the app.
///
/// [handleCodeInApp] The default is [:false:]. When set to [:true:],
/// the action code link will be be sent as a Universal Link or Android App Link
/// and will be opened by the app if installed. In the [:false:] case,
/// the code will be sent to the web widget first and then on continue will
/// redirect to the app if installed.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth#.ActionCodeSettings>
@JS()
@anonymous
class ActionCodeSettings {
  external String get url;
  external void set url(String s);
  external IosSettings get iOS;
  external void set iOS(IosSettings i);
  external AndroidSettings get android;
  external void set android(AndroidSettings a);
  external bool get handleCodeInApp;
  external void set handleCodeInApp(bool b);
  external factory ActionCodeSettings(
      {String url,
      IosSettings iOS,
      AndroidSettings android,
      bool handleCodeInApp});
}

/// The iOS settings.
///
/// Sets the iOS [bundleId].
/// This will try to open the link in an iOS app if it is installed.
@JS()
@anonymous
class IosSettings {
  external String get bundleId;
  external void set bundleId(String s);
  external factory IosSettings({String bundleId});
}

/// The Android settings.
///
/// Sets the Android [packageName]. This will try to open the link
/// in an android app if it is installed.
///
/// If [installApp] is passed, it specifies whether to install the Android app
/// if the device supports it and the app is not already installed.
/// If this field is provided without a [packageName], an error is thrown
/// explaining that the [packageName] must be provided in conjunction with
/// this field.
///
/// If [minimumVersion] is specified, and an older version of the app
/// is installed, the user is taken to the Play Store to upgrade the app.
@JS()
@anonymous
class AndroidSettings {
  external String get packageName;
  external void set packageName(String s);
  external String get minimumVersion;
  external void set minimumVersion(String s);
  external bool get installApp;
  external void set installApp(bool b);
  external factory AndroidSettings(
      {String packageName, String minimumVersion, bool installApp});
}

/// https://firebase.google.com/docs/reference/js/firebase.auth#.UserCredential
@JS()
@anonymous
class UserCredentialJsImpl {
  external UserJsImpl get user;
  external AuthCredential get credential;
  external String get operationType;
  external AdditionalUserInfoJsImpl get additionalUserInfo;
}

/// https://firebase.google.com/docs/reference/js/firebase.auth#.AdditionalUserInfo
@JS()
@anonymous
class AdditionalUserInfoJsImpl {
  external String get providerId;
  external Object get profile;
  external String get username;
}
