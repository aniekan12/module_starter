enum ObodoResponseType {
  // 100xx

  ok('00'),
  inactiveAccount('02'),
  processing('202'),
  success('200'),

  // 400xx
  badRequest('400'),

  badGateway('502'),

  denied('99'),

  // UNKNOWN
  unknown('-1');

  const ObodoResponseType(this.code);

  final String code;

  static ObodoResponseType fromCode(String code) {
    return ObodoResponseType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => ObodoResponseType.badRequest,
    );
  }
}
