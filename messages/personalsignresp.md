---
title: "Sign Typed Data Response"
category: "messages"
"type": "reference"
source: "https://github.com/uport-project/specs/blob/develop/messages/signtypeddataresp.md"
---

# Personal Sign Response

A personal sign response is a JWT containing within it a hex string of data, and an object representing the signature of the hash of that data.  See also: [Personal Sign Request](personalsignreq.md)

# Attributes

The JWT contains three required fields, `iat`, `iss`, `request`, and `signature`.  The `request` is an EIP712 signature request, as definied in the [EIP712 specification for typed data](https://eips.ethereum.org/EIPS/eip-712). `iss` and `iat` are defined as the issuer of the JWT, and the time at which it was issued, as usual. The `signature` field is an object containing the components `r`, `s`, and `v` which make up the signature over the typed data specified in the `request` field.  The JWT may optionally also contain the `exp`, `vc` fields.

Name | Description | Required
---- | ----------- | --------
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
`type` | MUST have the value `personalSignResp` | yes
`iss` | The DID of the issuer of the JWT, not necessarily the same as the signer in `signature` | yes
`data` | A hex string representing the data that was signed. | yes
`signature` | An object containing `r`, `s`, and `v`, the components of the signature | yes
`vc` | Array of Verified Claims JWTs or IPFS hash of JSON encoded equivalent about the `iss` of this message. See [Issuer Claims](/messages/claims.md) and [Verified Claims](/messages/verification.md) | no
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of JWT | no



An example personal signature response:
```json
{
  "iat": 123456789,
  "type": "personalSignResp",
  "iss": "did:ethr:0x...",
  "data": "0xdeaddeadbeefbeef",
  "signature": {
    "r": "0x...",
    "s": "0x...",
    "v": "0x..."
  },
  "exp": 123456789,
}
```
