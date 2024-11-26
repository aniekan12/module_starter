import 'dart:async';

import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:obodo_module_starter/common/events/data_bus.dart';
import 'package:obodo_module_starter/common/events/events.dart';
import 'package:obodo_module_starter/common/io/interceptors/loggin_interceptor.dart';
import 'package:obodo_module_starter/domain/providers/shared_preference_provider.dart';

import 'notification_dispatcher.dart';
import 'notification_factory.dart';

class FirebaseService extends NotificationService {
  FirebaseService({
    SharedPreferenceProvider? sharedPreferenceProvider,
  }) : sharedPreferenceProvider =
            sharedPreferenceProvider ?? GetIt.I<SharedPreferenceProvider>();

  final SharedPreferenceProvider sharedPreferenceProvider;

  late final NotificationServiceConfig config;

  final Map<String, NotificationHandler> _handlers = {};
  late final NotificationDispatcher dispatcher;
  RemoteMessageParser _parser = defaultMessageParser;

  Future<void> configure(NotificationServiceConfig config,
      NotificationDispatcher dispatcher) async {
    this.config = config;
    this.dispatcher = dispatcher;
    unawaited(Firebase.initializeApp(
      options: config.firebaseOptions,
    ).then((value) async {
      FirebaseMessaging.onMessage.listen(_onMessageReceived);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
      FirebaseMessaging.instance.getInitialMessage();
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }).catchError((Object e) {
      log.e(
        'Unable to initialize app: $e',
      );
    }));
  }

  void _onMessageReceived(RemoteMessage message) {
    log.i("$message message received");
    final event = _parser.call(message, NotificationType.foreground);
    try {
      (_handlers[event.messageType] ?? DefaultNotificationHandler(dispatcher))
          .notify(event);
    } catch (e) {
      log.e('Error Notifying Notification: $e');
    }
  }

  void _getInitialMessage(RemoteMessage message) {}

  void _onMessageOpenedApp(RemoteMessage message) {
    log.i(
      "$message opened app",
    );

    final event = _parser.call(message, NotificationType.foreground);

    // final path = event.path;
    //
    // if (path != null) {
    //   final redirectPath = path.startsWith('/') ? path : '/$path';
    //   DeeplinkUseCase.setRedirectPath(redirectPath);
    // }

    DataBus.getInstance().publish(event, strategy: PublishStrategy.last);
  }

  static Future<String?> getFirebaseApnsToken() {
    return FirebaseMessaging.instance.getAPNSToken();
  }

  static Future<String?> getFirebaseToken() {
    return FirebaseMessaging.instance.getToken();
  }

  @override
  void registerForegroundNotificationHandler(
      String messageType, NotificationHandler handler) {
    _handlers.putIfAbsent(messageType, () => handler);
  }

  @override
  void registerBackgroundNotificationHandler(
      Future<void> Function(RemoteMessage) handler) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }

  @override
  void setRemoteMessageParser(RemoteMessageParser parser) {
    _parser = parser;
    dispatcher.parser = parser;
  }

  @override
  RemoteMessageParser getMessageParser() => _parser;
}
