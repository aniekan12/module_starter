import 'dart:io';

import 'package:flutter/material.dart';
import 'package:obodo_module_starter/domain/providers/device_info_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum StorageMediaType {
  audio,
  videos,
  photos,
  documents,
}

class PermissionHandler {
  const PermissionHandler._();

  static DeviceInfoProvider get provider => DeviceInfoProvider.getInstance();

  static Future<bool> launchSettingApp() async {
    return openAppSettings();
  }

  static Future<bool> requestReadStoragePermission({
    StorageMediaType storageType = StorageMediaType.photos,
    VoidCallback? onPermissionDenied,
  }) async {
    if (Platform.isAndroid == false && Platform.isIOS == false) {
      return false;
    }

    if (Platform.isIOS == true) {
      if (StorageMediaType.photos != storageType &&
          StorageMediaType.videos != storageType) {
        return true;
      }

      return requestIOSPhotoPermission(
        onPermissionDenied: onPermissionDenied,
      );
    }

    final requiresExternalStoragePermission = provider.androidSdkInt <= 32;

    if (requiresExternalStoragePermission == false) {
      if (storageType == StorageMediaType.documents) {
        return true;
      }
      return requestAndroidMediaPermission(
        storageType: storageType,
        onPermissionDenied: onPermissionDenied,
      );
    }

    final isPermissionGranted =
        await Permission.storage.isGranted.catchError((_) => false);

    if (isPermissionGranted == false) {
      final permissionStatus = await Permission.storage
          .request()
          .catchError((_) => PermissionStatus.denied);

      if (permissionStatus.isGranted == false) {
        if (permissionStatus.isPermanentlyDenied == true) {
          onPermissionDenied?.call();
        }

        return false;
      }
    }

    return true;
  }

  static Future<bool> requestIOSPhotoPermission({
    VoidCallback? onPermissionDenied,
  }) async {
    if (Platform.isIOS == false) {
      return false;
    }

    final iOSVersion = await _getIOSVersion(provider.deviceVersion ?? '');

    final requiresPhotosPermission = iOSVersion >= 14;

    if (requiresPhotosPermission == false) {
      return true;
    }

    final isPermissionGranted =
        await Permission.photos.isGranted.catchError((_) => false);

    if (isPermissionGranted == false) {
      final permissionStatus = await Permission.photos
          .request()
          .catchError((_) => PermissionStatus.denied);

      if (!permissionStatus.isGranted) {
        if (permissionStatus.isPermanentlyDenied) {
          onPermissionDenied?.call();
        }

        return false;
      }
    }

    return true;
  }

  static Future<bool> requestAndroidMediaPermission({
    required StorageMediaType storageType,
    VoidCallback? onPermissionDenied,
  }) async {
    if (Platform.isAndroid == false) {
      return false;
    }

    final requiresMediaPermission = provider.androidSdkInt > 32;

    if (requiresMediaPermission == false) {
      return false;
    }

    final isPermissionGranted =
        await _hasMediaPermission(storageType).catchError((_) => false);

    if (isPermissionGranted == false) {
      final permissionStatus = await _requestMediaPermission(storageType)
          .catchError((_) => PermissionStatus.denied);

      if (!permissionStatus.isGranted) {
        if (permissionStatus.isPermanentlyDenied) {
          onPermissionDenied?.call();
        }

        return false;
      }
    }

    return true;
  }

  static Future<bool> requestCameraPermission({
    VoidCallback? onPermissionDenied,
  }) async {
    if (Platform.isAndroid == false && Platform.isIOS == false) {
      return false;
    }

    var requiresCameraPermission = true;

    if (Platform.isAndroid == true) {
      requiresCameraPermission = provider.androidSdkInt >= 23;
    }

    if (requiresCameraPermission == false) {
      return true;
    }

    final isPermissionGranted = await Permission.camera.isGranted;

    if (isPermissionGranted == false) {
      final permissionStatus = await Permission.camera.request();

      if (!permissionStatus.isGranted) {
        if (permissionStatus.isPermanentlyDenied) {
          onPermissionDenied?.call();
        }

        return false;
      }
    }

    return true;
  }

  static Future<bool> _hasMediaPermission(StorageMediaType storageType) async {
    return switch (storageType) {
      StorageMediaType.photos => Permission.photos.isGranted,
      StorageMediaType.videos => Permission.videos.isGranted,
      StorageMediaType.audio => Permission.audio.isGranted,
      _ => Future.value(false),
    };
  }

  static Future<PermissionStatus> _requestMediaPermission(
      StorageMediaType storageType) async {
    return switch (storageType) {
      StorageMediaType.photos => Permission.photos.request(),
      StorageMediaType.videos => Permission.videos.request(),
      StorageMediaType.audio => Permission.audio.request(),
      _ => Future.value(PermissionStatus.denied),
    };
  }

  static Future<int> _getIOSVersion(String systemVersion) async {
    final mayorRelease = systemVersion.split('.').first;
    return int.tryParse(mayorRelease) ?? 0;
  }
}
