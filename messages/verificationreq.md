---
title: "Verification Claim Request"
category: "messages"
type: "reference"
source: "https://github.com/uport-project/specs/blob/develop/messages/verificationreq.md"
---

# Verified Claim Request

The Verified Claim Request is created by a client app and sent to a user's mobile app during the [Verified Claim Request Flow](/flows/verification.md).


#### Attributes

The JWT shares these attributes with the [Share Request](sharereq.md): `iss`, `iat`, `exp`. The claim in the `unsignedClaim` object should follow the [claims best practices](./verification.md#claims-best-practices).

The following additional attributes of the JWT are supported:

Name | Description | Required
---- | ----------- | --------
[`iss`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The DID of the signing identity| yes
[`sub`](https://tools.ietf.org/html/rfc7519#section-4.1.2) | The DID of the identity you want the user to sign the claims ABOUT | no
[`aud`](https://tools.ietf.org/html/rfc7519#section-4.1.3) | The DID or URL of the audience of the JWT. Our libraries or app will not accept any JWT that has someone else as the audience| no
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of JWT | no
`type` | MUST have the value `verReq` | yes
`unsignedClaim` | An unsigned claim that the user is requested to sign, this should exactly match the `claim` of the finished signed [Verified Claim](./verification.md). | yes
`callback` | Callback URL for returning the response to a request (may be deprecated in future) | no
`riss` | The DID of the identity you want to sign the Verified Claim | no
`rexp` | Requested expiry time in seconds | no
QmSCnmXC91Arz2gj934Ce4DeR7d9fULWRepjzGMX6SSazB"}}` or the IPFS Hash of a JSON encoded equivalent. See [Issuer Claims](/messages/claims.md) | no
`vc` | Array of Verified Claims JWTs or IPFS hash of JSON encoded equivalent about the `iss` of this message. See [Issuer Claims](/messages/claims.md) and [Verified Claims](/messages/verification.md) | no


Example Verified Claim request:

```js
{
  "type":"verReq",
  "iss":"did:uport:REQUESTING_APP_OR_USER",
  "aud":"did:uport:VERIFYING_APP_OR_USER",
  "sub":"did:uport:SUBJECT_OF_VERIFIED_CLAIM",
  "riss":"did:uport:IDENTITY_THAT_WILL_SIGN_THE_CLAIM",
  "unsignedClaim": {
    "name":"Bob Smith"
  },
  "callback":"https://example.com",
  "rexp": 123456789
}
```

The verifying user views the requested data in the UX and signs the corresponding [Verified Claim](./verification.md). The following is an example of the response:

```js
{
  "iss":"did:uport:VERIFYING_APP_OR_USER",
  "sub":"did:uport:SUBJECT_OF_VERIFIED_CLAIM",
  "claim": {
    "name":"Bob Smith"
  },
  "exp": 123456789
}
```
