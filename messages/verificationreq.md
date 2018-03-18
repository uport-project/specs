# Verified Claim Request

The Verified Claim Request is created by a client app and sent to a user's mobile app during the [Verified Claim Request Flow](../flows/verificationreq.md).


#### Attributes

The JWT shares these attributes with the [Share Request](sharereq.md): `iss`, `iat`, `exp`. The claim in the `unsignedClaim` object should follow the [claims best practices](./verification.md#claims-best-practices).

The following additional attributes of the JWT are supported:

Name | Description | Required
---- | ----------- | --------
`type` | MUST have the value `verReq` | yes
`sub` | The DID of the identity you want the user to sign the claims ABOUT | yes
`unsignedClaim` | An unsigned claim that the user is requested to sign, this should exactly match the `claim` of the finished signed [Verified Claim](./verification.md). | yes
`aud` | The DID of the identity you want to sign the Verified Claim | no
`callback` | Callback URL for returning the response to a request (may be deprecated in future) | no
`rexp` | Requested expiry time in seconds | no


Example Verified Claim request:

```js
{
  "type":"verReq",
  "iss":"did:uport:REQUESTING_APP_OR_USER",
  "aud":"did:uport:VERIFYING_APP_OR_USER",
  "sub":"did:uport:SUBJECT_OF_VERIFIED_CLAIM",
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
