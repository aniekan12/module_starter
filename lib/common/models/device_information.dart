class DeviceInformation {
  const DeviceInformation(
      {required this.deviceId,
      required this.deviceName,
      required this.deviceVersion,
      required this.deviceBrandName,
      required this.deviceOS});
  final String deviceId;
  final String deviceName;
  final String deviceVersion;
  final String deviceBrandName;
  final String deviceOS;

  @override
  String toString() {
    return 'DeviceId($deviceId), DeviceName($deviceName), '
        'DeviceVersion($deviceVersion), DeviceBrandName($deviceBrandName), '
        'DeviceOS($deviceOS)';
  }
}
