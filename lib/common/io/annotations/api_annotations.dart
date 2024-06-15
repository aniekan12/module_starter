import 'package:retrofit/retrofit.dart';

const requiresAuthorizationKey = 'requires-authentication';

/// Specifies if an Endpoint should add the Authorization Token
class Authorized extends Extra {
  const Authorized() : super(const {requiresAuthorizationKey: true});
}
