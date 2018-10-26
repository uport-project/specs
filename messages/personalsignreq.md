---
title: "Personal Sign Request"
category: "messages"
"type": "reference"
source: "https://github.com/uport-project/specs/blob/develop/messages/personalsignreq.md"
---

# Personal Sign Request

The Personal Sign Request is a message created by a client app and sent to a user's mobile app, which contains a string of arbitrary, unstructured data to be signed.  This is an adaptation of the `personal_sign` RPC call to a uPort-based workflow.

#### Attributes

The JWT shares these attributes with the [Share Request](sharereq.md) and [Verification Request](verificationreq.md): `iat`, `exp`, `callback`, and `vc`; it also shares the `riss` field with [Verification Request](verificationreq.md). The data in the `data` field should be a string containing the hex characters that make up the UTF-8 representation of the data to be signed, prefixed with `0x`.

The following additional attributes of the JWT are supported:

Name | Description | Required
---- | ----------- | --------
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of JWT | no
`type` | MUST have the value `personalSignReq` | yes
`data` | A string containing the hex encoding of the data to be signed | yes
`callback` | Callback URL for returning the response to a request (may be deprecated in future) | no
`riss` | The DID of the identity you want to sign the Verified Claim | no
`vc` | Array of Verified Claims JWTs or IPFS hash of JSON encoded equivalent about the `iss` of this message. See [Issuer Claims](/messages/claims.md) and [Verified Claims](/messages/verification.md) | no


Example Personal Sign request:

```json
{
  "riss":"did:ethr:IDENTITY_THAT_WILL_SIGN_THE_CLAIM",
  "data": "0xdeaddeadbeefbeef",
  "callback": "https://example.com",
  "exp": 123456789
}
```