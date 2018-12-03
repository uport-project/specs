---
title: "Sign Typed Data Response"
category: "messages"
"type": "reference"
source: "https://github.com/uport-project/specs/blob/develop/messages/signtypeddataresp.md"
---

# Signed Typed Data Response

A signed typed data response is a message created by a client app which includes a structured object that conforms to the EIP712 specification.  In particular, the signed typed data response contains within it the typed data signature *request*, so that the signature may be verified by anyone who receives the response jwt.  See also: [Sign Typed Data Request](signtypeddatareq.md)

# Attributes

The JWT contains three required fields, `iat`, `iss`, `request`, and `signature`.  The `request` is an EIP712 signature request, as definied in the [EIP712 specification for typed data](https://eips.ethereum.org/EIPS/eip-712). `iss` and `iat` are defined as the issuer of the JWT, and the time at which it was issued, as usual. The `signature` field is a string, prefixed with `0x`, containing the hex representation of a 129-byte signature. Bytes `0...64` contain the `r` parameter, bytes `64...128` the `s` parameter and the last byte the `v` parameter, which together make up the signature over the typed data specified in the `request` field.  The JWT may optionally also contain the `exp`, `vc` fields.

Name | Description | Required
---- | ----------- | --------
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
`type` | MUST have the value `eip712Resp` | yes
`iss` | The DID of the issuer of the JWT, not necessarily the same as the signer in `signature` | yes
`request` | A JSON object that conforms to the [ERC712 specification for typed data](https://eips.ethereum.org/EIPS/eip-712). It must contain the keys `types`, `primaryType`, `domain`, and `message`. | yes
`signature` | An object containing `r`, `s`, and `v`, the components of the signature | yes
`vc` | Array of Verified Claims JWTs or IPFS hash of JSON encoded equivalent about the `iss` of this message. See [Issuer Claims](/messages/claims.md) and [Verified Claims](/messages/verification.md) | no
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of JWT | no



An example typed data signature response:
```json
{
  "iat": 123456789,
  "iss": "did:ethr:0x...",
  "request": {
    "types": {
        "EIP712Domain": [
          {"name": "name", "type": "string"},
          {"name": "version", "type": "string"},
          {"name": "chainId", "type": "uint256"},
          {"name": "verifyingContract", "type": "address"},
          {"name": "salt", "type": "bytes32"}
        ],
        "Greeting": [
          {"name": "text", "type": "string"},
          {"name": "subject", "type": "string"},
        ]
      },
      "domain": {
        "name": "My dapp", 
        "version": "1.0", 
        "chainId": 1, 
        "verifyingContract": "0xdeadbeef",
        "salt": "0x999999999910101010101010"
      },
      "primaryType": "Greeting",
      "message": {
        "text": "Hello",
        "subject": "World"
      }
    }
  },
  "signature": "0xa90bed9301293da38...",
  exp: 123456789,
}
```
