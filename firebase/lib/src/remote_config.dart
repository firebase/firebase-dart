import 'interop/js_interop.dart' as js_interop;
import 'interop/remote_config_interop.dart';
import 'js.dart';
import 'utils.dart';

/// Provides access to Remote Config service.
class RemoteConfig extends JsObjectWrapper<RemoteConfigJsImpl> {
  static final _expando = Expando<RemoteConfig>();

  static RemoteConfig getInstance(RemoteConfigJsImpl jsObject) =>
      _expando[jsObject] ??= RemoteConfig._fromJsObject(jsObject);

  RemoteConfig._fromJsObject(RemoteConfigJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Defines configuration for the Remote Config SDK.
  RemoteConfigSettings get settings =>
      RemoteConfigSettings._fromJsObject(jsObject.settings);

  /// Contains default values for configs. To set default config, compose a map and then assign it to `defaultConfig`.
  /// Any modifications to the map after the assignment will not take effect.
  ///
  /// Example:
  /// ```dart
  ///
  /// final remoteConfig = firebase.remoteConfig();
  /// Map<String, dynamic> defaultsMap = {'title': 'Hello', counter: 1};
  /// remoteConfig.defaultConfig = defaultsMap;   // Correct.
  /// defaultsMap['x'] = 1;                       // remoteConfig.defaultConfig will not be updated.
  /// remoteConfig.defaultConfig['x'] = 1;        // Runtime error: attempt to modify an unmodifiable map.
  /// ```
  Map<String, dynamic> get defaultConfig =>
      Map.unmodifiable(dartifyMap(jsObject.defaultConfig));

  set defaultConfig(Map<String, dynamic> value) {
    jsObject.defaultConfig = jsify(value);
  }

  /// Returns the timestamp of the last *successful* fetch, or `null` if the instance either hasn't fetched
  /// or initialization is incomplete.
  DateTime? get fetchTime {
    if (jsObject.fetchTimeMillis < 0) {
      return null;
    } else {
      return DateTime.fromMillisecondsSinceEpoch(jsObject.fetchTimeMillis);
    }
  }

  /// The status of the last fetch attempt.
  RemoteConfigFetchStatus get lastFetchStatus {
    switch (jsObject.lastFetchStatus) {
      case 'no-fetch-yet':
        return RemoteConfigFetchStatus.notFetchedYet;
      case 'success':
        return RemoteConfigFetchStatus.success;
      case 'failure':
        return RemoteConfigFetchStatus.failure;
      case 'throttle':
        return RemoteConfigFetchStatus.throttle;
      default:
        throw UnimplementedError(jsObject.lastFetchStatus);
    }
  }

  ///  Makes the last fetched config available to the getters.
  ///  Returns a future which resolves to `true` if the current call activated the fetched configs.
  ///  If the fetched configs were already activated, the promise will resolve to `false`.
  Future<bool> activate() async => handleThenable(jsObject.activate());

  ///  Ensures the last activated config are available to the getters.
  Future<void> ensureInitialized() async =>
      handleThenable(jsObject.ensureInitialized());

  /// Fetches and caches configuration from the Remote Config service.
  Future<void> fetch() async => handleThenable(jsObject.fetch());

  /// Performs fetch and activate operations, as a convenience.
  /// Returns a promise which resolves to true if the current call activated the fetched configs.
  /// If the fetched configs were already activated, the promise will resolve to false.
  Future<bool> fetchAndActivate() async =>
      handleThenable(jsObject.fetchAndActivate());

  /// Returns all config values.
  Map<String, RemoteConfigValue> getAll() {
    final keys = js_interop.objectKeys(jsObject.getAll());
    final entries = keys.map<MapEntry<String, RemoteConfigValue>>(
        (dynamic k) => MapEntry<String, RemoteConfigValue>(k, getValue(k)));
    return Map<String, RemoteConfigValue>.fromEntries(entries);
  }

  ///  Gets the value for the given key as a boolean.
  ///  Convenience method for calling `remoteConfig.getValue(key).asString()`.
  bool getBoolean(String key) => jsObject.getBoolean(key);

  ///  Gets the value for the given key as a number.
  ///  Convenience method for calling `remoteConfig.getValue(key).asNumber()`.
  num getNumber(String key) => jsObject.getNumber(key);

  ///  Gets the value for the given key as a string.
  ///  Convenience method for calling `remoteConfig.getValue(key).asString()`.
  String getString(String key) => jsObject.getString(key);

  ///  Gets the value for the given key.
  RemoteConfigValue getValue(String key) =>
      RemoteConfigValue._fromJsObject(jsObject.getValue(key));

  void setLogLevel(RemoteConfigLogLevel value) {
    jsObject.setLogLevel(const {
      RemoteConfigLogLevel.debug: 'debug',
      RemoteConfigLogLevel.error: 'error',
      RemoteConfigLogLevel.silent: 'silent',
    }[value]!);
  }
}

/// Wraps a value with metadata and type-safe getters.
class RemoteConfigValue extends JsObjectWrapper<ValueJsImpl> {
  RemoteConfigValue._fromJsObject(ValueJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Gets the value as a boolean.
  /// The following values (case insensitive) are interpreted as true:
  /// `"1"`, `"true"`, `"t"`, `"yes"`, `"y"`, `"on"`. Other values are interpreted as false.
  bool asBoolean() => jsObject.asBoolean();

  ///  Gets the value as a number. Returns `0` if the value is not a number.
  num asNumber() => jsObject.asNumber();

  /// Gets the value as a string.
  String asString() => jsObject.asString();

  /// Returns the source of the value.
  RemoteConfigValueSource getSource() {
    switch (jsObject.getSource()) {
      case 'static':
        return RemoteConfigValueSource.static;
      case 'default':
        return RemoteConfigValueSource.defaults;
      case 'remote':
        return RemoteConfigValueSource.remote;
      default:
        throw UnimplementedError(jsObject.getSource());
    }
  }
}

/// Indicates the source of a value.
enum RemoteConfigValueSource {
  /// The value has not been defined. It was initialized by a static constant.
  static,

  /// The value was defined by default config.
  defaults,

  /// The value was defined by fetched config.
  remote,
}

/// Defines configuration options for the Remote Config SDK.
class RemoteConfigSettings extends JsObjectWrapper<SettingsJsImpl> {
  RemoteConfigSettings._fromJsObject(SettingsJsImpl jsObject)
      : super.fromJsObject(jsObject);

  ///  Defines the maximum age in milliseconds of an entry in the config cache before
  ///  it is considered stale. Defaults to twelve hours.
  Duration get minimumFetchInterval =>
      Duration(milliseconds: jsObject.minimumFetchIntervalMillis);

  set minimumFetchInterval(Duration value) {
    jsObject.minimumFetchIntervalMillis = value.inMilliseconds;
  }

  /// Defines the maximum amount of time to wait for a response when fetching
  /// configuration from the Remote Config server. Defaults to one minute.
  Duration get fetchTimeoutMillis =>
      Duration(milliseconds: jsObject.fetchTimeoutMillis);

  set fetchTimeoutMillis(Duration value) {
    jsObject.fetchTimeoutMillis = value.inMilliseconds;
  }
}

/// Summarizes the outcome of the last attempt to fetch config from the Firebase Remote Config server.
enum RemoteConfigFetchStatus {
  /// Indicates the config has not been fetched yet or that SDK initialization is incomplete.
  notFetchedYet,

  /// Indicates the last attempt succeeded.
  success,

  /// Indicates the last attempt failed.
  failure,

  /// Indicates the last attempt was rate-limited.
  throttle,
}

/// Defines levels of Remote Config logging.
enum RemoteConfigLogLevel {
  debug,
  error,
  silent,
}
