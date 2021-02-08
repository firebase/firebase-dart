import 'interop/performance_interop.dart' as performance_interop;
import 'js.dart';
import 'utils.dart';

class Performance
    extends JsObjectWrapper<performance_interop.PerformanceJsImpl> {
  static final _expando = Expando<Performance>();

  static Performance getInstance(
          performance_interop.PerformanceJsImpl jsObject) =>
      _expando[jsObject] ??= Performance._fromJsObject(jsObject);

  Performance._fromJsObject(performance_interop.PerformanceJsImpl jsObject)
      : super.fromJsObject(jsObject);

  Trace trace(String traceName) =>
      Trace.fromJsObject(jsObject.trace(traceName));
}

class Trace extends JsObjectWrapper<performance_interop.TraceJsImpl> {
  Trace.fromJsObject(performance_interop.TraceJsImpl jsObject)
      : super.fromJsObject(jsObject);

  String getAttribute(String attr) => jsObject.getAttribute(attr);

  Map<String, dynamic> getAttributes() => dartify(jsObject.getAttributes());

  int getMetric(String metricName) => jsObject.getMetric(metricName);

  void incrementMetric(String metricName, [int? num]) {
    if (num != null) {
      jsObject.incrementMetric(metricName, num);
    } else {
      jsObject.incrementMetric(metricName);
    }
  }

  void putAttribute(String attr, String value) {
    jsObject.putAttribute(attr, value);
  }

  void removeAttribute(String attr) {
    jsObject.removeAttribute(attr);
  }

  void start() {
    jsObject.start();
  }

  void stop() {
    jsObject.stop();
  }
}
