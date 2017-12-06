# Attestation Response

The Attestation Response is created by a users mobile app as a response to a [Attestation Request](attreq.md) during the [Attestation Flow](../flows/attestation.md).

The response is always signed and returned to the callback url included in the request.

#### Attributes

The JWT shares these attributes with the [Share Response](shareresp.md): `iss`, `iat`, `exp`, `aud`.

The following attributes of the JWT are supported:

Name | Description | Required
---- | ----------- | --------
`type` | MUST have the value `attResp` | yes
`req`| The original JWT encoded Selective Disclosure Request | yes for responses to signed requests
`signedClaims` | List of the signed JWTs | yes
