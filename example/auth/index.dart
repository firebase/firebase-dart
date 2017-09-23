import 'dart:convert';
import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/src/assets/assets.dart';

main() async {
  //Use for firebase package development only
  await config();

  try {
    fb.initializeApp(
        apiKey: apiKey,
        authDomain: authDomain,
        databaseURL: databaseUrl,
        storageBucket: storageBucket);

    new AuthApp();
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}

class AuthApp {
  final fb.Auth auth;
  final FormElement registerForm;
  final InputElement email, password;
  final AnchorElement logout;
  final TableElement authInfo;
  final ParagraphElement error;
  final SelectElement persistenceState;
  final ButtonElement verifyEmail;

  AuthApp()
      : this.auth = fb.auth(),
        this.email = querySelector("#email"),
        this.password = querySelector("#password"),
        this.authInfo = querySelector("#auth_info"),
        this.error = querySelector("#register_form p"),
        this.logout = querySelector("#logout_btn"),
        this.registerForm = querySelector("#register_form"),
        this.persistenceState = querySelector("#persistent_state"),
        this.verifyEmail = querySelector('#verify_email') {
    logout.onClick.listen((e) {
      e.preventDefault();
      auth.signOut();
    });

    this.registerForm.onSubmit.listen((e) {
      e.preventDefault();
      var emailValue = email.value.trim();
      var passwordvalue = password.value.trim();
      _registerUser(emailValue, passwordvalue);
    });

    // After opening
    if (auth.currentUser != null) {
      _setLayout(auth.currentUser);
    }

    // When auth state changes
    auth.onAuthStateChanged.listen((e) => _setLayout(e));

    verifyEmail.onClick.listen((e) async {
      verifyEmail.disabled = true;
      verifyEmail.text = 'Sending verification email...';
      try {
        // you will get the verification email in czech language
        auth.languageCode = 'cs';
        // url should be any authorized domain in your console - we use here,
        // for this example, authDomain because it is whitelisted by default
        // More info: https://firebase.google.com/docs/auth/web/passing-state-in-email-actions
        await auth.currentUser.sendEmailVerification(
            new fb.ActionCodeSettings(url: "https://$authDomain"));
        verifyEmail.text = 'Verification email sent!';
      } catch (e) {
        verifyEmail
          ..text = e.toString()
          ..style.color = 'red';
      }
    });
  }

  _registerUser(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      var trySignin = false;
      try {
        // Modifies persistence state. More info: https://firebase.google.com/docs/auth/web/auth-state-persistence
        var selectedPersistence =
            persistenceState.options[persistenceState.selectedIndex].value;
        await auth.setPersistence(selectedPersistence);
        await auth.createUserWithEmailAndPassword(email, password);
      } on fb.FirebaseError catch (e) {
        if (e.code == "auth/email-already-in-use") {
          trySignin = true;
        }
      } catch (e) {
        error.text = e.toString();
      }

      if (trySignin) {
        try {
          await auth.signInWithEmailAndPassword(email, password);
        } catch (e) {
          error.text = e.toString();
        }
      }
    } else {
      error.text = "Please fill correct e-mail and password.";
    }
  }

  void _setLayout(fb.User user) {
    if (user != null) {
      registerForm.style.display = "none";
      logout.style.display = "block";
      email.value = "";
      password.value = "";
      error.text = "";
      authInfo.style.display = "block";

      var data = <String, dynamic>{
        'email': user.email,
        'emailVerified': user.emailVerified,
        'isAnonymous': user.isAnonymous
      };

      data.forEach((k, v) {
        if (v != null) {
          var row = authInfo.addRow();

          row.addCell()
            ..text = k
            ..classes.add('header');
          row.addCell()..text = "$v";
        }
      });

      print('User.toJson:');
      print(const JsonEncoder.withIndent(' ').convert(user));

      verifyEmail.style.display = user.emailVerified ? 'none' : 'block';
    } else {
      registerForm.style.display = "block";
      authInfo.style.display = "none";
      logout.style.display = "none";
      verifyEmail.style.display = "none";
      authInfo.children.clear();
    }
  }
}
