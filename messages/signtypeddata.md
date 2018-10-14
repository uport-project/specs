---
title: "Sign Typed Data (EIP712) Request"
category: "messages"
"type": "reference"
source: "https://github.com/uport-project/specs/blob/develop/messages/signtypeddata.md"
---

# Sign Typed Data (EIP712) Request

The Sign Typed Data Request is a message created by a client app and sent to a user's mobile app, which contains a potential complex claim to be signed. 


#### Attributes

The JWT shares these attributes with the [Share Request](sharereq.md) and [Verification Request](verificationreq.md): `iss`, `iat`, `exp`. The claim in the `typedData` object should follow the [EIP712 Typed Data specification](https://eips.ethereum.org/EIPS/eip-712).

The following additional attributes of the JWT are supported:

Name | Description | Required
---- | ----------- | --------
[`iss`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The DID of the signing identity| yes
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of JWT | no
`type` | MUST have the value `eip712Req` | yes
`typedData` | A JSON object that conforms to the [EIP712 specification for typed data](https://eips.ethereum.org/EIPS/eip-712). It must contain the keys `types`, `primaryType`, `domain`, and `message`. | yes
`callback` | Callback URL for returning the response to a request (may be deprecated in future) | no
`riss` | The DID of the identity you want to sign the Verified Claim | no
`rexp` | Requested expiry time in seconds | no
`vc` | Array of Verified Claims JWTs or IPFS hash of JSON encoded equivalent about the `iss` of this message. See [Issuer Claims](/messages/claims.md) and [Verified Claims](/messages/verification.md) | no


Example EIP712 signature request:

```json
{
  "type":"eip712Req",
  "iss":"did:uport:REQUESTING_APP_OR_USER",
  "riss":"did:uport:IDENTITY_THAT_WILL_SIGN_THE_CLAIM",
  "typedData": {
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
  "callback":"https://example.com",
  "rexp": 123456789
}
```

The signing user views the data structure in the UX and signs it (or rejects the signature). The following is an example of a signed response:

```json
{
  "iss":"did:uport:IDENTITY_OF_SIGNER",
  "typedData": {
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
  "signature": "98jdafzf4f9j...",
  "exp": 123456789
}
```
