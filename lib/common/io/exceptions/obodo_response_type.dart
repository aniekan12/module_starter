enum ObodoResponseType {
  // General
  created('201'),
  processing('202'),
  success('200'),
  badRequest('400'),
  badGateway('502'),
  denied('99'),
  unknown('-1');

  const ObodoResponseType(this.code);

  final String code;

  static ObodoResponseType fromCode(String code) {
    return ObodoResponseType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => ObodoResponseType.unknown,
    );
  }
}
