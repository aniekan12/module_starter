import 'package:retrofit/retrofit.dart';

const requiresAuthorizationKey = 'requires-authentication';
const requiresIndentityTokenKey = 'requires-identity-token';

/// Specifies if an Endpoint should add the Authorization Token
class Authorized extends Extra {
  const Authorized() : super(const {requiresAuthorizationKey: true});
}

/// Specifies if an Endpoint should add the Identity Token
class IdentityToken extends Extra {
  const IdentityToken() : super(const {requiresIndentityTokenKey: true});
}
