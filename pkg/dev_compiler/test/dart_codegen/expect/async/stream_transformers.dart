part of dart.async;
 class _EventSinkWrapper<T> implements EventSink<T> {_EventSink _sink;
 _EventSinkWrapper(this._sink);
 void add(T data) {
  _sink._add(data);
  }
 void addError(error, [StackTrace stackTrace]) {
  _sink._addError(error, stackTrace);
  }
 void close() {
  _sink._close();
  }
}
 class _SinkTransformerStreamSubscription<S, T> extends _BufferingStreamSubscription<T> {EventSink _transformerSink;
 StreamSubscription<S> _subscription;
 _SinkTransformerStreamSubscription(Stream<S> source, _SinkMapper<S, T> mapper, void onData(T data), Function onError, void onDone(), bool cancelOnError) : super(onData, onError, onDone, cancelOnError) {
_EventSinkWrapper<T> eventSink = new _EventSinkWrapper<T>(this);
 _transformerSink = mapper(eventSink);
 _subscription = source.listen(_handleData, onError: _handleError, onDone: _handleDone);
}
 bool get _isSubscribed => _subscription != null;
 void _add(T data) {
if (_isClosed) {
  throw new StateError("Stream is already closed");
  }
 super._add(data);
}
 void _addError(Object error, StackTrace stackTrace) {
if (_isClosed) {
  throw new StateError("Stream is already closed");
  }
 super._addError(error, stackTrace);
}
 void _close() {
if (_isClosed) {
  throw new StateError("Stream is already closed");
  }
 super._close();
}
 void _onPause() {
if (_isSubscribed) _subscription.pause();
}
 void _onResume() {
if (_isSubscribed) _subscription.resume();
}
 Future _onCancel() {
if (_isSubscribed) {
  StreamSubscription subscription = _subscription;
   _subscription = null;
   subscription.cancel();
  }
 return null;
}
 void _handleData(S data) {
try {
  _transformerSink.add(data);
  }
 catch (e, s) {
  _addError(e, s);
  }
}
 void _handleError(error, [stackTrace]) {
try {
  _transformerSink.addError(error, DEVC$RT.cast(stackTrace, dynamic, StackTrace, "DynamicCast", """line 127, column 40 of dart:async/stream_transformers.dart: """, stackTrace is StackTrace, true));
  }
 catch (e, s) {
  if (identical(e, error)) {
    _addError(error, DEVC$RT.cast(stackTrace, dynamic, StackTrace, "DynamicCast", """line 130, column 26 of dart:async/stream_transformers.dart: """, stackTrace is StackTrace, true));
    }
   else {
    _addError(e, s);
    }
  }
}
 void _handleDone() {
try {
  _subscription = null;
   _transformerSink.close();
  }
 catch (e, s) {
  _addError(e, s);
  }
}
}
 typedef EventSink<S> _SinkMapper<S, T>(EventSink<T> output);
 class _StreamSinkTransformer<S, T> implements StreamTransformer<S, T> {final _SinkMapper<S, T> _sinkMapper;
 const _StreamSinkTransformer(this._sinkMapper);
 Stream<T> bind(Stream<S> stream) => new _BoundSinkStream<S, T>(stream, _sinkMapper);
}
 class _BoundSinkStream<S, T> extends Stream<T> {final _SinkMapper<S, T> _sinkMapper;
 final Stream<S> _stream;
 bool get isBroadcast => _stream.isBroadcast;
 _BoundSinkStream(this._stream, this._sinkMapper);
 StreamSubscription<T> listen(void onData(T event), {
Function onError, void onDone(), bool cancelOnError}
) {
cancelOnError = identical(true, cancelOnError);
 StreamSubscription<T> subscription = new _SinkTransformerStreamSubscription<dynamic, T>(_stream, DEVC$RT.cast(_sinkMapper, DEVC$RT.type((_SinkMapper<S, T> _) {
}
), DEVC$RT.type((_SinkMapper<dynamic, dynamic> _) {
}
), "CompositeCast", """line 187, column 18 of dart:async/stream_transformers.dart: """, _sinkMapper is _SinkMapper<dynamic, dynamic>, false), onData, onError, onDone, cancelOnError);
 return subscription;
}
}
 typedef void _TransformDataHandler<S, T>(S data, EventSink<T> sink);
 typedef void _TransformErrorHandler<T>(Object error, StackTrace stackTrace, EventSink<T> sink);
 typedef void _TransformDoneHandler<T>(EventSink<T> sink);
 class _HandlerEventSink<S, T> implements EventSink<S> {final _TransformDataHandler<S, T> _handleData;
 final _TransformErrorHandler<T> _handleError;
 final _TransformDoneHandler<T> _handleDone;
 final EventSink<T> _sink;
 _HandlerEventSink(this._handleData, this._handleError, this._handleDone, this._sink);
 void add(S data) => _handleData(data, _sink);
 void addError(Object error, [StackTrace stackTrace]) => _handleError(error, stackTrace, _sink);
 void close() => _handleDone(_sink);
}
 class _StreamHandlerTransformer<S, T> extends _StreamSinkTransformer<S, T> {_StreamHandlerTransformer({
void handleData(S data, EventSink<T> sink), void handleError(Object error, StackTrace stackTrace, EventSink<T> sink), void handleDone(EventSink<T> sink)}
) : super(((__x61) => DEVC$RT.cast(__x61, DEVC$RT.type((__CastType59<T> _) {
}
), DEVC$RT.type((_SinkMapper<S, T> _) {
}
), "InferableClosure", """line 233, column 15 of dart:async/stream_transformers.dart: """, __x61 is _SinkMapper<S, T>, false))((EventSink<T> outputSink) {
if (handleData == null) handleData = DEVC$RT.cast(_defaultHandleData, __CastType65, DEVC$RT.type((__CastType62<S, T> _) {
}
), "CompositeCast", """line 234, column 48 of dart:async/stream_transformers.dart: """, _defaultHandleData is __CastType62<S, T>, false);
 if (handleError == null) handleError = DEVC$RT.cast(_defaultHandleError, __CastType72, DEVC$RT.type((__CastType68<T> _) {
}
), "CompositeCast", """line 235, column 50 of dart:async/stream_transformers.dart: """, _defaultHandleError is __CastType68<T>, false);
 if (handleDone == null) handleDone = _defaultHandleDone;
 return new _HandlerEventSink<S, T>(handleData, handleError, handleDone, outputSink);
}
));
 Stream<T> bind(Stream<S> stream) {
return super.bind(stream);
}
 static void _defaultHandleData(var data, EventSink sink) {
sink.add(data);
}
 static void _defaultHandleError(error, StackTrace stackTrace, EventSink sink) {
sink.addError(error);
}
 static void _defaultHandleDone(EventSink sink) {
sink.close();
}
}
 typedef StreamSubscription<T> _SubscriptionTransformer<S, T>(Stream<S> stream, bool cancelOnError);
 class _StreamSubscriptionTransformer<S, T> implements StreamTransformer<S, T> {final _SubscriptionTransformer<S, T> _transformer;
 const _StreamSubscriptionTransformer(this._transformer);
 Stream<T> bind(Stream<S> stream) => new _BoundSubscriptionStream<S, T>(stream, _transformer);
}
 class _BoundSubscriptionStream<S, T> extends Stream<T> {final _SubscriptionTransformer<S, T> _transformer;
 final Stream<S> _stream;
 _BoundSubscriptionStream(this._stream, this._transformer);
 StreamSubscription<T> listen(void onData(T event), {
Function onError, void onDone(), bool cancelOnError}
) {
cancelOnError = identical(true, cancelOnError);
 StreamSubscription<T> result = _transformer(_stream, cancelOnError);
 result.onData(onData);
 result.onError(onError);
 result.onDone(onDone);
 return result;
}
}
 typedef dynamic __CastType59<T>(EventSink<T> __u60);
 typedef void __CastType62<S, T>(S __u63, EventSink<T> __u64);
 typedef void __CastType65(dynamic __u66, EventSink<dynamic> __u67);
 typedef void __CastType68<T>(Object __u69, StackTrace __u70, EventSink<T> __u71);
 typedef void __CastType72(dynamic __u73, StackTrace __u74, EventSink<dynamic> __u75);
