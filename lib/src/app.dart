import 'dart:async';

import 'auth.dart';
import 'database.dart';
import 'interop/app_interop.dart';
import 'interop/firebase_interop.dart';
import 'js.dart';
import 'storage.dart';
import 'utils.dart';

export 'interop/firebase_interop.dart' show FirebaseError, FirebaseOptions;

/// A Firebase App holds the initialization information for a collection
/// of services.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.app>.
class App extends JsObjectWrapper<AppJsImpl> {
  static final _expando = new Expando<App>();

  /// Name of the app.
  String get name => jsObject.name;

  /// Options used during [firebase.initializeApp()].
  FirebaseOptions get options => jsObject.options;

  /// Creates a new App from a [jsObject].
  static App get(AppJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= new App._fromJsObject(jsObject);
  }

  App._fromJsObject(AppJsImpl jsObject) : super.fromJsObject(jsObject);

  /// Returns [Auth] service.
  Auth auth() => Auth.get(jsObject.auth());

  /// Returns [Database] service.
  Database database() => Database.get(jsObject.database());

  /// Deletes the app and frees resources of all App's services.
  Future delete() => handleThenable(jsObject.delete());

  /// Returns [Storage] service optionally initialized with a custom storage bucket.
  Storage storage([String url]) {
    var jsObjectStorage =
        (url != null) ? jsObject.storage(url) : jsObject.storage();
    return Storage.get(jsObjectStorage);
  }
}
