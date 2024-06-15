import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import 'exceptions/obodo_exception.dart';
import 'logger/logger_factory.dart';

mixin NetworkBoundResource {
  @protected
  Resource<K> networkBoundResource<K>({
    // The source to fetch locally or from cache
    required Stream<K?> Function() fromLocal,
    // The source to fetch from the remote server
    required Future<K?> Function() fromRemote,
    // Determines if we should fetch fromLocal
    // or if fromLocal should be called
    bool shouldFetchLocal = false,
    // Determines if we should fetch from remote source
    // Passes the local data to the client to determine if we
    // should fetch from remote still.
    bool Function(K?)? shouldFetchFromRemote,
    // Callback once data has been received from the remote source
    Future<K?> Function(K? response)? onRemoteDataReceived,
  }) {
    final controller = _NetworkBoundResourceImpl<K>();

    controller.onListen = () {
      if (false == shouldFetchLocal) {
        controller.emitSafely(Resource.loading(null));
      }

      K? localData;

      if (shouldFetchLocal) {
        StreamSubscription<Resource<K?>>? localSubscription;

        localSubscription =
            _fetchLocalOnce(fromLocal, shouldFetchFromRemote).listen((event) {
          localData = event.valueOrNull;
          controller.emitSafely(event);

          localSubscription?.cancel();

          _attemptRemoteFetch(
              fromLocal: fromLocal,
              fromRemote: fromRemote,
              controller: controller,
              localData: localData,
              onRemoteDataReceived: onRemoteDataReceived,
              shouldFetchLocal: shouldFetchLocal,
              shouldFetchFromRemote: shouldFetchFromRemote);
        });
      } else {
        _attemptRemoteFetch(
            fromLocal: fromLocal,
            fromRemote: fromRemote,
            controller: controller,
            localData: localData,
            onRemoteDataReceived: onRemoteDataReceived,
            shouldFetchLocal: shouldFetchLocal,
            shouldFetchFromRemote: shouldFetchFromRemote);
      }
    };
    return controller;
  }

  void _attemptRemoteFetch<K>({
    required Stream<K?> Function() fromLocal,
    required Future<K?> Function() fromRemote,
    required _NetworkBoundResourceImpl<K?> controller,
    K? localData,
    Future<K?> Function(K? response)? onRemoteDataReceived,
    bool Function(K?)? shouldFetchFromRemote,
    bool shouldFetchLocal = false,
  }) {
    var doRemoteFetch = true;

    doRemoteFetch = shouldFetchFromRemote?.call(localData) ?? doRemoteFetch;

    if (!doRemoteFetch) {
      controller.closeSafely();
    } else {
      fromRemote().then((value) {
        if (null == value) {
          controller.emitSafely(Resource.success(null));
          return value;
        }
        return value;
      }).then((value) async {
        if (value == null) {
          controller.closeSafely();
          return;
        }
        final K result = await onRemoteDataReceived?.call(value) ?? value;
        if (shouldFetchLocal) {
          StreamSubscription<dynamic>? subs;
          subs = fromLocal().listen((event) {
            controller.emitSafely(Resource.success(event));
            subs?.cancel();
            controller.closeSafely();
          })
            ..onError((a) => controller.closeSafely());
        } else {
          controller
            ..emitSafely(Resource.success(result))
            ..closeSafely();
        }
      }).catchError((Object err) {
        if (err is DioException) {
          controller
              .emitSafely(Resource.failure(ObodoException.fromHttpError(err)));
          LoggerFactory.getLogger().error('DioException Error Exception', err);
        } else if (err is TypeError) {
          LoggerFactory.getLogger().error('TypeError Exception', err);
          controller
              .emitSafely(Resource.failure(ObodoException.fromTypeError(err)));
        }
        log(err.toString());
        controller.closeSafely();
      });
    }
  }

  /// Fetches data from the local stream just once and
  /// yields value if it passes certain conditions.
  /// Yields at-least once.
  Stream<Resource<K?>> _fetchLocalOnce<K>(
    Stream<K?> Function() fromLocal,
    bool Function(K?)? shouldFetchFromRemote,
  ) async* {
    const emitted = false;
    await for (final value in fromLocal()) {
      final doRemoteFetch = shouldFetchFromRemote?.call(value) ?? true;

      final isAList = value is List;

      if (doRemoteFetch && isAList && value.isNotEmpty) {
        yield Resource.loading(value);
      } else if (doRemoteFetch && !isAList && null != value) {
        yield Resource.loading(value);
      } else if (false == doRemoteFetch) {
        yield Resource.success(value);
      }
      break;
    }
    if (!emitted) yield Resource.loading(null);
    return;
  }
}

/// A wrapper that encapsulates either a value or a throwable
sealed class Resource<S> {
  const Resource();

  /// Returns an instance that encapsulates a value as a success.
  factory Resource.success(S value) = Success<S>;

  /// Returns an instance that encapsulates a throwable as a failure.
  factory Resource.failure(ObodoException throwable, {S? value}) = Failure<S>;

  /// Returns an instance that encapsulates a throwable as a loading.
  factory Resource.loading(S value) = Loading<S>;

  //===========================================================================
  // Shorthand for try/catch
  //===========================================================================

  /// Runs [function] and returns a resource that encapsulates a value
  /// of type [V]
  ///
  /// If an error occurs while running [function], it returns a resource
  /// that encapsulates a throwable of type [T].
  ///
  /// [onFailure] can be used to map/process
  /// the error and stacktrace to any throwable of type [T] before
  /// the failure instance is returned
  static Resource<V> guardSync<V, T extends ObodoException>({
    required V Function() function,
    T Function(Object throwable, StackTrace stackTrace)? onFailure,
  }) {
    try {
      return Resource.success(function.call());
    } catch (err, stacktrace) {
      if (onFailure != null) {
        final throwable = onFailure.call(err, stacktrace);
        return Resource.failure(throwable);
      }
      return Resource.failure(err as T);
    }
  }

  /// Runs the async [function] and returns a Future that encapsulates
  /// a resource with a value of type [V]
  ///
  /// If an error occurs while running [function], it returns
  /// a Future that encapsulates a resource with a throwable
  /// of type [T].
  ///
  /// [onFailure] can be used to map/process
  /// the error and stacktrace to any throwable of type [T] before
  /// the failure instance is returned
  static Future<Resource<V>> guardAsync<V, T extends ObodoException>({
    required Future<V> Function() function,
    T Function(Object throwable, StackTrace stackTrace)? onFailure,
  }) async {
    try {
      return Resource.success(await function.call());
    } catch (err, stacktrace) {
      if (onFailure != null) {
        final throwable = onFailure.call(err, stacktrace);
        return Resource.failure(throwable);
      }
      return Resource.failure(err as T);
    }
  }

  /// Runs the [function] and emits a Stream that encapsulates
  /// a resource with a value of type [V]
  ///
  /// If an error occurs while running [function], it emits
  /// a Stream that encapsulates a resource that encapsulates a throwable
  /// of type [T].
  ///
  /// [onFailure] can be used to map/process
  /// the error and stacktrace to any throwable of type [T] before
  /// the failure instance is returned
  static Stream<Resource<V>> guardEmit<V, T extends ObodoException>({
    required Stream<V> Function() function,
    T Function(Object throwable, StackTrace stackTrace)? onFailure,
  }) async* {
    try {
      await for (final event in function.call()) {
        yield Resource.success(event);
      }
    } catch (err, stacktrace) {
      if (onFailure != null) {
        final throwable = onFailure.call(err, stacktrace);
        yield Resource.failure(throwable);
      }
      yield Resource.failure(err as T);
    }
  }

  //===========================================================================
  // Discovering the status
  //===========================================================================

  /// Whether this instance represents a successful outcome.
  ///
  /// In this case [isFailure] returns false.
  bool get isSuccess => this is Success<S>;

  /// Whether this instance represents a failed outcome.
  ///
  ///In this case [isSuccess] returns false.
  bool get isFailure => this is Failure<S>;

  //===========================================================================
  // Getting values and exceptions
  //===========================================================================

  /// The encapsulated value if this instance represents a success.
  ///
  /// If this instance represents a failure, it returns null
  S? get valueOrNull;

  /// The encapsulated throwable if this instance represents a failure.
  ///
  /// If this instance represents a success, it returns null
  ObodoException? get throwableOrNull;

  /// Returns the encapsulated value if this instance represents a success.
  ///
  /// If this instance represents a failure, it returns the [defaultValue]
  S valueOrDefault({required S defaultValue});

  /// Returns the encapsulated value if this instance represents a success.
  ///
  /// If this instance represents a failure, it returns the result of
  /// [ orElse]
  S valueOrElse({required S Function(ObodoException throwable) orElse});

  /// Returns the encapsulated value if this instance represents a success.
  ///
  /// If this instance represents a failure, it throws the
  /// encapsulated throwable
  S valueOrThrow();

  //===========================================================================
  // Handling event
  //===========================================================================

  /// Returns the result of [onSuccess] for the encapsulated value if this
  /// instance represents a success.
  ///
  /// If this instance represents a failure, it returns
  /// the result of [onFailure]
  void when<T>({
    required T Function(S value) onSuccess,
    required T Function(ObodoException throwable) onFailure,
    required T Function(S? value) onLoading,
  });

  void whenResource(void Function(Resource<S> value) event);

  /// Runs [onSuccess] on the encapsulated value if
  /// this instance represents a success and returns the original instance
  ///  unchanged.
  void whenSuccess(void Function(S value) onSuccess);

  /// Runs [onFailure] on the encapsulated throwable if
  /// this instance represents failure and returns the original instance
  /// unchanged.
  void maybeWhen({
    void Function(ObodoException throwable)? onFailure,
    void Function(S? value)? onLoading,
    void Function(S value)? onSuccess,
  });

  /// Runs [onFailure] on the encapsulated throwable if
  /// this instance represents failure and returns the original instance
  /// unchanged.
  void whenFailure(void Function(ObodoException throwable) onFailure);

  //==========================================================================
  // Transforming values and exceptions
  //==========================================================================

  /// Returns the encapsulated result of the given [transformer] applied
  /// to the encapsulated value if this instance represents success or
  /// the original encapsulated throwable if it is failure.
  // Resource<> map<T>(
  //     T Function(S value) transformer,
  //     );

  /// Returns the result of the given [transformer] applied
  /// to the encapsulated value if this instance represents a success or
  /// the original encapsulated throwable if it is failure.
  ///
  /// If an error occurs while running the given [transformer],
  /// it returns a failure.
  Resource<T> guardMap<T>(
    T Function(S value) transformer,
  );

  /// Returns the encapsulated result of the given [transformer] applied
  /// to the encapsulated throwable if this instance represents a failure or
  /// the original encapsulated value if it is a success.
  Resource<S> mapFailure<T extends ObodoException>(
    T Function(ObodoException throwable) transformer,
  );

  /// Returns the encapsulated result of the given [transformer] applied
  /// to the encapsulated throwable if this instance represents a failure or
  /// the original encapsulated value if it is a success.
  ///
  /// If an error occurs while running the given [transformer],
  /// it returns a failure.
  Resource<S> guardMapFailure<T extends ObodoException>(
    T Function(ObodoException throwable) transformer,
  );

  /// Returns a success after applying the given [transformer]
  /// to the encapsulated throwable if this instance represents a failure or
  /// the original encapsulated value if it is a success.
  Resource<S> recover(
    S Function(ObodoException throwable) transformer,
  );

  /// Returns a success after applying the given [transformer]
  /// to the encapsulated throwable if this instance represents a failure or
  /// the original encapsulated value if it is a success.
  ///
  /// If an error occurs while running the given [transformer],
  /// it returns a failure.
  Resource<S> guardRecover(
    S Function(ObodoException throwable) transformer,
  );

  /// Returns the encapsulated result of the given [transformer] applied
  /// to the encapsulated value if this instance represents success or
  /// the original encapsulated throwable if it is failure.
  Resource<T> map<T>(
    T Function(S? value) transformer,
  );

  Resource<T> flatMap<T>(Resource<T> Function(Resource<S?> value) transformer) {
    return transformer(Resource.loading(null));
  }

  Resource<S> skipIf(bool Function(Resource<S?> value) predicate) {
    return this;
  }

  Resource<S> retryWhen(
      Future<bool> Function(Failure<S?> value, int attempts) retry) {
    return this;
  }
}

/// A wrapper that encapsulates a value
@immutable
class Success<S> extends Resource<S> {
  const Success(this.value);

  /// The encapsulated value
  final S value;

  @override
  S get valueOrNull => value;

  @override
  ObodoException? get throwableOrNull => null;

  @override
  S valueOrDefault({required S defaultValue}) => value;

  @override
  S valueOrElse({required S Function(ObodoException throwable) orElse}) =>
      value;

  @override
  S valueOrThrow() => value;

  @override
  T when<T>({
    required T Function(S value) onSuccess,
    required T Function(ObodoException failure) onFailure,
    required T Function(S? value) onLoading,
  }) {
    return onSuccess(value);
  }

  @override
  Resource<S> whenSuccess(
    void Function(S value) onSuccess,
  ) {
    onSuccess(value);
    return this;
  }

  @override
  Resource<S> whenFailure(void Function(ObodoException throwable) onFailure) {
    return this;
  }

  @override
  Resource<T> map<T>(T Function(S value) transformer) {
    final transformedValue = transformer(value);
    return Resource.success(transformedValue);
  }

  @override
  Resource<T> guardMap<T>(T Function(S value) transformer) {
    return Resource.guardSync(
      function: () {
        final transformedValue = transformer(value);
        return transformedValue;
      },
    );
  }

  @override
  Resource<S> mapFailure<T extends ObodoException>(
    T Function(ObodoException throwable) transformer,
  ) {
    return Resource.success(value);
  }

  @override
  Resource<S> guardMapFailure<T extends ObodoException>(
    T Function(ObodoException throwable) transformer,
  ) {
    return Resource.success(value);
  }

  @override
  Resource<S> recover(
    S Function(ObodoException throwable) transformer,
  ) {
    return Success(value);
  }

  @override
  Resource<S> guardRecover(
    S Function(ObodoException throwable) transformer,
  ) {
    return Success(value);
  }

  @override
  bool operator ==(Object other) => (other is Success) && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';

  @override
  Resource<S> maybeWhen(
      {void Function(ObodoException throwable)? onFailure,
      void Function(S? value)? onLoading,
      void Function(S value)? onSuccess}) {
    onSuccess?.call(value);
    return this;
  }

  @override
  void whenResource(void Function(Resource<S> value) event) {
    return event.call(this);
  }

  @override
  Resource<T> flatMap<T>(Resource<T> Function(Resource<S?> value) transformer) {
    return transformer(this);
  }
}

/// A wrapper that encapsulates a throwable
@immutable
class Failure<S> extends Resource<S> {
  const Failure(this.throwable, {this.value});

  /// The encapsulated throwable
  final ObodoException throwable;
  final S? value;

  @override
  S? get valueOrNull => value;

  @override
  ObodoException? get throwableOrNull => throwable;

  @override
  S valueOrDefault({required S defaultValue}) => defaultValue;

  @override
  S valueOrElse({required S Function(ObodoException failure) orElse}) =>
      orElse(throwable);

  @override
  S valueOrThrow() {
    if (throwable is Error) {
      throw throwable as Error;
    }
    throw throwable;
  }

  @override
  T when<T>({
    required T Function(S value) onSuccess,
    required T Function(ObodoException failure) onFailure,
    required T Function(S value) onLoading,
  }) {
    return onFailure(throwable);
  }

  @override
  Resource<S> whenSuccess(
    void Function(S value) onSuccess,
  ) {
    return this;
  }

  @override
  Resource<S> whenFailure(void Function(ObodoException throwable) onFailure) {
    onFailure(throwable);
    return this;
  }

  @override
  Resource<T> map<T>(T Function(S value) transformer) =>
      Resource.failure(throwable);

  @override
  Resource<T> guardMap<T>(T Function(S value) transformer) =>
      Resource.failure(throwable, value: null);

  @override
  Resource<S> mapFailure<T extends ObodoException>(
    T Function(ObodoException throwable) transformer,
  ) {
    final transformedThrowable = transformer(throwable);
    return Resource.failure(transformedThrowable);
  }

  @override
  Resource<S> guardMapFailure<T extends ObodoException>(
    T Function(ObodoException throwable) transformer,
  ) {
    return Resource.guardSync(
      function: () {
        final transformedThrowable = transformer(throwable);
        if (transformedThrowable.cause is Error) {
          throw transformedThrowable;
        }
        throw transformedThrowable;
      },
    );
  }

  @override
  Resource<S> recover(
    S Function(ObodoException throwable) transformer,
  ) {
    final transformedValue = transformer(throwable);
    return Success(transformedValue);
  }

  @override
  Resource<S> guardRecover(
    S Function(ObodoException throwable) transformer,
  ) {
    return Resource.guardSync(
      function: () {
        final transformedValue = transformer(throwable);
        return transformedValue;
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      (other is Failure) && other.throwable == throwable;

  @override
  int get hashCode => throwable.hashCode;

  @override
  String toString() => 'Failure($throwable)';

  @override
  Resource<S> maybeWhen(
      {void Function(ObodoException throwable)? onFailure,
      void Function(S? value)? onLoading,
      void Function(S value)? onSuccess}) {
    onFailure?.call(throwable);
    return this;
  }

  @override
  void whenResource(void Function(Resource<S> value)? event) {
    event?.call(this);
  }
}

/// A wrapper that encapsulates a throwable
@immutable
class Loading<S> extends Resource<S> {
  const Loading(this.value);

  /// The encapsulated value
  final S value;

  @override
  S? get valueOrNull => value;

  @override
  ObodoException? get throwableOrNull => null;

  @override
  S valueOrDefault({required S defaultValue}) => value;

  @override
  S valueOrElse({required S Function(ObodoException throwable) orElse}) =>
      value;

  @override
  S valueOrThrow() => value;

  @override
  T when<T>({
    required T Function(S value) onSuccess,
    required T Function(ObodoException failure) onFailure,
    required T Function(S? value) onLoading,
  }) {
    return onLoading(value);
  }

  @override
  Resource<S> whenSuccess(void Function(S value) onSuccess) {
    return this;
  }

  @override
  Resource<S> whenFailure(
    void Function(ObodoException throwable) onFailure,
  ) {
    return this;
  }

  @override
  Resource<T> map<T>(T Function(S value) transformer) {
    final transformedValue = transformer(value);
    return Resource.loading(transformedValue);
  }

  @override
  Resource<T> guardMap<T>(T Function(S value) transformer) {
    return Resource.guardSync(
      function: () {
        final transformedValue = transformer(value);
        return transformedValue;
      },
    );
  }

  @override
  Resource<S> mapFailure<T extends ObodoException>(
    T Function(ObodoException throwable) transformer,
  ) {
    return Resource.loading(value);
  }

  @override
  Resource<S> guardMapFailure<T extends ObodoException>(
    T Function(ObodoException throwable) transformer,
  ) {
    return Resource.loading(value);
  }

  @override
  Resource<S> recover(
    S Function(ObodoException throwable) transformer,
  ) {
    return Loading(value);
  }

  @override
  Resource<S> guardRecover(
    S Function(ObodoException throwable) transformer,
  ) {
    return Loading(value);
  }

  @override
  bool operator ==(Object other) => (other is Loading) && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Loading($value)';

  @override
  Resource<S> maybeWhen(
      {void Function(ObodoException throwable)? onFailure,
      void Function(S? value)? onLoading,
      void Function(S value)? onSuccess}) {
    onLoading?.call(value);
    return this;
  }

  @override
  void whenResource(void Function(Resource<S> value) event) {
    event.call(this);
  }
}

///===========================NetworkBoundResourceImpl========================
class _NetworkBoundResourceImpl<S> extends Resource<S> {
  _NetworkBoundResourceImpl({this.onListen})
      : _controller = StreamController<Resource<S?>>.broadcast() {
    _createStream();
  }

  final StreamController<Resource<S?>> _controller;

  Stream<Resource<S?>> get stream => _controller.stream;
  final _ResourceCallback<S> _callback = _ResourceCallback<S>();

  void Function()? onListen;

  S? _value;
  ObodoException? _throwable;

  void _createStream() {
    _controller.onListen = () {
      onListen?.call();
    };
  }

  void emitSafely(Resource<S?> value) {
    try {
      if (!_controller.isClosed) {
        _controller.sink.add(value);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void closeSafely() {
    try {
      if (!_controller.isClosed) {
        _controller.close();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Resource<T> guardMap<T>(T Function(S value) transformer) {
    throw UnimplementedError();
  }

  @override
  Resource<S> guardMapFailure<T extends ObodoException>(
      T Function(ObodoException throwable) transformer) {
    // TODO(paul): implement guardMapFailure
    throw UnimplementedError();
  }

  @override
  Resource<S> guardRecover(S Function(ObodoException throwable) transformer) {
    // TODO(paul): implement guardRecover
    throw UnimplementedError();
  }

  @override
  Resource<S> mapFailure<T extends ObodoException>(
      T Function(ObodoException throwable) transformer) {
    return Resource.failure(transformer(_throwable!));
  }

  @override
  void maybeWhen(
      {void Function(ObodoException throwable)? onFailure,
      void Function(S? value)? onLoading,
      void Function(S value)? onSuccess}) {
    _callback
      ..onLoading = onLoading
      ..onSuccess = onSuccess
      ..onFailure = onFailure;
    _listen();
  }

  @override
  Resource<S> recover(S Function(ObodoException throwable) transformer) {
    throw UnimplementedError();
  }

  @override
  ObodoException? get throwableOrNull => _throwable;

  @override
  S valueOrDefault({required S defaultValue}) {
    return _value ?? defaultValue;
  }

  @override
  S valueOrElse({required S Function(ObodoException throwable) orElse}) {
    return _value ?? orElse(_throwable!);
  }

  @override
  S? get valueOrNull => _value;

  @override
  S valueOrThrow() {
    if (null != _throwable && _throwable is Error) {
      throw _throwable!;
    }
    if (_throwable is ObodoException) {
      throw _throwable!;
    }
    return _value!;
  }

  @override
  void when<T>(
      {required T Function(S value) onSuccess,
      required T Function(ObodoException throwable) onFailure,
      required T Function(S? value) onLoading}) {
    _callback
      ..onLoading = onLoading
      ..onSuccess = onSuccess
      ..onFailure = onFailure;
    _listen();
  }

  @override
  void whenFailure(void Function(ObodoException throwable) onFailure) {
    _callback.onFailure = onFailure;
    _listen();
  }

  @override
  void whenSuccess(void Function(S value) onSuccess) {
    _callback.onSuccess = onSuccess;
    _listen();
  }

  @override
  void whenResource(void Function(Resource<S> value) event) {
    _callback.onResource = event;
    _listen();
  }

  void _listen() {
    final StreamSubscription<dynamic> subs = stream.listen(_callback.invoke);
    subs
      ..onError((Object e) {
        if (e is ObodoException) {
          _callback.onFailure?.call(e);
          _callback.onResource?.call(Failure(e));
        } else {
          final exception = ObodoException.fromMessage(e.toString());
          _callback.onFailure?.call(exception);
          _callback.onResource?.call(Failure(exception));
        }
        subs.cancel();
      })
      ..onDone(subs.cancel);
  }

  @override
  Resource<T> map<T>(T Function(S? value) transformer) {
    final mappedStream = stream.map((resource) {
      if (resource is Success<S?>) {
        return Success(transformer(resource.value));
      } else if (resource is Failure<S?>) {
        return Failure(resource.throwable, value: transformer(resource.value));
      } else if (resource is Loading<S?>) {
        return Loading(transformer(resource.value));
      }
      return transformer(resource.valueOrNull) as Resource<T>;
    });
    return _NetworkBoundResourceImpl<T>().._controller.addStream(mappedStream);
  }

  @override
  Resource<T> flatMap<T>(Resource<T> Function(Resource<S?> value) transformer) {
    final transformedStream = stream.asyncExpand((resource) async* {
      final transformedResource = transformer(resource);
      if (transformedResource is _NetworkBoundResourceImpl<T>) {
        yield* transformedResource.stream;
      }
      yield transformedResource;
    });
    return _NetworkBoundResourceImpl<T>()
      .._controller.addStream(transformedStream);
  }

  @override
  Resource<S> skipIf(bool Function(Resource<S?> value) predicate) {
    final skippedStream = stream.where((event) => !predicate(event));
    return _NetworkBoundResourceImpl<S>().._controller.addStream(skippedStream);
  }

  // TODO(paul): complete this function
  @override
  Resource<S> retryWhen(
      Future<bool> Function(Failure<S?> value, int attempts) retry) {
    var attempts = 0;
    final retryStream = stream.asyncExpand((event) async* {
      if (event is Failure<S?>) {
        if (await retry(event, attempts)) {
          attempts++;
          onListen?.call();
          yield* this.stream;
        }
      } else {
        yield event;
      }
    });
    return _NetworkBoundResourceImpl<S>().._controller.addStream(retryStream);
  }
}

class _ResourceCallback<S> {
  void Function(S? loading)? onLoading;
  void Function(ObodoException throwable)? onFailure;
  void Function(S success)? onSuccess;
  void Function(Resource<S> resourceValue)? onResource;

  void invoke<T>(Resource<T> resource) {
    // Don't expose the NetworkBoundResourceImpl
    if (resource is _NetworkBoundResourceImpl) {
      return;
    }
    onResource?.call(resource as Resource<S>);
    if (resource is Loading<S>) {
      onLoading?.call(resource.valueOrNull as S?);
    } else if (resource is Failure<S?>) {
      onFailure?.call(resource.throwableOrNull!);
    } else if (resource is Success<S?>) {
      onSuccess?.call(resource.valueOrNull as S);
    }
  }
}
