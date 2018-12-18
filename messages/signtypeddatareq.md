---
title: "Sign Typed Data Request"
category: "messages"
"type": "reference"
source: "https://github.com/uport-project/specs/blob/develop/messages/signtypeddatareq.md"
---

# Sign Typed Data Request

The Sign Typed Data Request is a message created by a client app and sent to a user's mobile app, which contains a potential complex claim to be signed.  These claims can be signed and verified on-chain as well as off, and include in the object to be signed a definition of the structure of the object itself.  For more information, see the [ERC712 specification for typed data](https://eips.ethereum.org/EIPS/eip-712).


#### Attributes

The JWT shares these attributes with the [Share Request](sharereq.md) and [Verification Request](verificationreq.md): `iat`, `exp`, `callback`, and `vc`; it also shares the `riss` field with [Verification Request](verificationreq.md). The claim in the `typedData` object should follow the [ERC712 Typed Data specification](https://eips.ethereum.org/EIPS/eip-712).

The following additional attributes of the JWT are supported:

Name | Description | Required
---- | ----------- | --------
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of JWT | no
`type` | MUST have the value `eip712Req` | yes
`typedData` | A JSON object that conforms to the [ERC712 specification for typed data](https://eips.ethereum.org/EIPS/eip-712). It must contain the keys `types`, `primaryType`, `domain`, and `message`. | yes
`callback` | Callback URL for returning the response to a request (may be deprecated in future) | no
`riss` | The DID of the identity you want to sign the Verified Claim | no
`from` | Hex encoded address requested to sign the transaction. If not specified the user will select an account. | no
`net` | network id of Ethereum chain of identity eg. `0x4` for `rinkeby`. It defaults to `0x1` for `mainnet`. | no
`vc` | Array of Verified Claims JWTs or IPFS hash of JSON encoded equivalent about the `iss` of this message. See [Issuer Claims](/messages/claims.md) and [Verified Claims](/messages/verification.md) | no


Example Typed Data Claim request:

```json
{
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
  },
  "callback": "https://example.com",
  "exp": 123456789
}
```