import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import 'events.dart';

/// @author Anyanwu Nzubechi

/// An enumeration defining strategies for notifying subscribers of events.
///
/// The strategies include:
/// - `all`: Notifies all registered subscribers of a particular event type.
/// - `first`: Notifies only the first subscriber that was registered for the event type.
/// - `last`: Notifies only the most recently added subscriber for the event type.
enum PublishStrategy { all, first, last }

class DataBus {
  DataBus();

  factory DataBus.getInstance() {
    return GetIt.I.get<DataBus>(instanceName: dataBusKey);
  }

  static void inject() {
    if (!GetIt.I.isRegistered<DataBus>(instanceName: dataBusKey)) {
      GetIt.I.registerLazySingleton<DataBus>(() {
        return DataBus();
      }, instanceName: dataBusKey);
    }
  }

  static const dataBusKey = '@@__app_obodo_data_bus__';
  final _mediator = StreamController<DataEvent>.broadcast();
  final _subscriptions = <StreamSubscription<DataEvent>>[];
  final _subscribers = <Type, List<Function>>{};

  void on<T extends DataEvent>(void Function(T event) subscriber) {
    _subscribers[T] = (_subscribers[T] ?? <Function>[])..add(subscriber);
  }

  void exclusive<T extends DataEvent>(void Function(T event) subscriber) {
    if (_subscribers[T]?.isNotEmpty ?? false) {
      return;
    }
    on<T>(subscriber);
  }

  /// Subscribe to a specific event to receive only a [count] of event
  void onCount<T extends DataEvent>(
      void Function(T event) subscriber, int count) {
    var eventCount = 0;
    void Function(T event)? handler;
    handler = (T e) {
      eventCount++;
      if (eventCount >= count) {
        unsubscribe<T>(handler!);
      }
      if (eventCount <= count) {
        subscriber(e);
      }
    };
    on<T>(handler);
  }

  /// Subscribes to a specific event just once
  void once<T extends DataEvent>(void Function(T event) subscriber) {
    onCount(subscriber, 1);
  }

  void subscribe(void Function(DataEvent event) subscriber) {
    unsubscribe(subscriber);
    _subscriptions.add(_mediator.stream.listen(subscriber));
  }

  void unsubscribe<T extends DataEvent>(void Function(T event) subscriber) {
    _subscribers[T]?.remove(subscriber);
    final subscription =
        _subscriptions.firstWhereOrNull((sub) => sub.onData == subscriber);
    if (subscription != null) {
      subscription.cancel();
      _subscriptions.remove(subscription);
    }
  }

  /// Publishes an event to subscribers according to the specified [strategy].
  ///
  /// Depending on the [strategy], this method can notify all subscribers, only the
  /// first subscriber, or only the last subscriber of the event's type.
  void publish(DataEvent event,
      {PublishStrategy strategy = PublishStrategy.all}) {
    _mediator.add(event);
    final queue = _subscribers[event.runtimeType] ?? [];

    final subscribers = switch (strategy) {
      PublishStrategy.first when queue.isNotEmpty => [queue.first],
      PublishStrategy.last when queue.isNotEmpty => [queue.last],
      _ => queue,
    };

    for (final subscriber in subscribers) {
      Future.microtask(() {
        // ignore: avoid_dynamic_calls
        subscriber(event);
      });
    }
  }

  /// Publishes an event with a delay, according to the specified [strategy].
  void publishDelayed(DataEvent event, Duration duration,
      {PublishStrategy strategy = PublishStrategy.all}) {
    Future<void>.delayed(duration, () => publish(event, strategy: strategy));
  }

  @visibleForTesting
  int get subscribersCount => _subscribers.length;

  void dispose() {
    for (final element in _subscriptions) {
      element.cancel();
    }
    _subscribers.clear();
    _mediator.close();
  }
}
