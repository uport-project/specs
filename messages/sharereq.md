---
title: "Selective Disclosure Request"
category: "messages"
type: "reference"
source: "https://github.com/uport-project/specs/blob/develop/messages/sharereq.md"
---

# Selective Disclosure Request

The Selective Disclosure Request is created by a client app and sent to a user's mobile app during the [Selective Disclosure Flow](/flows/selectivedisclosure.md).

The request can be either signed or unsigned.

#### Attributes

The following attributes of the JWT are supported:

Name | Description | Required
---- | ----------- | --------
`type` | MUST have the value `shareReq` | yes
[`iss`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids) of the signing identity| yes
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of JWT | no
`callback` | Callback URL for returning the response to a request | no
`net` | network id of Ethereum chain of identity eg. `0x4` for `rinkeby` | no
`act` | Ethereum account type: `general` users choice (default), `segregated` a unique smart contract based account will be created for requesting app, `keypair` a unique keypair based account will be created for requesting app, `devicekey` request a new device key for a [Private Chain Account](./privatechain.md), `none` no account is returned | no
`requested` | DEPRECATED The self signed claims requested from a user. Array of claim types for self signed claims. Currently supported: `["name", "email", "image", "country", "phone"]` | no
`verified` | DEPRECATED The verified claims requested from a user. Array of claim types for self signed claims eg: `["name", "email"]`, see [Verified Claims](/messages/verification.md) | no
`claims` | Requirements for claims requested from a user. See [Claims Specs](#claims-spec) and [Verified Claims](/messages/verification.md) | no
`permissions` | An array of permissions requested. Currently only supported is `notifications` | no
`boxPub` | 32 byte base64 encoded [`Curve25519`](http://nacl.cr.yp.to/box.html) public key of requesting identity. Use to encrypt messages sent to callback URL| no
`issc` | The self signed claims for the `iss` of this message. Either as an Object of claim types for self signed claims eg: `{"name":"Some Corp Inc", "url":"https://somecorp.example","image":{"/":"/ipfs/QmSCnmXC91Arz2gj934Ce4DeR7d9fULWRepjzGMX6SSazB"}}` or the IPFS Hash of a JSON encoded equivalent. See [Issuer Claims](/messages/claims.md) | no
`vc` | Array of Verified Claims JWTs or IPFS hash of JSON encoded equivalent about the `iss` of this message. See [Issuer Claims](/messages/claims.md) and [Verified Claims](/messages/verification.md) | no
`rpc` | URL for the JSON RPC endpoint, ie: `https://mainnet.infura.io/`. Useful for [Private Networks](/flows/privatechain.md). The `net_version` method shoud return the same networkId as the filed `net`. The JSON RPC endpoint must provide the following methods: `eth_getTransactionCount`, `eth_getBalance`, `eth_estimateGas`, `eth_gasPrice`, `eth_sendRawTransaction`, `eth_getTransactionReceipt` | no

The attributes `redirect_url` and `callback_type` can also be appended to the signed request as URL encoded query parameters outside of the signed payload. They are used to specify how you want the response and control returned. For more details see [Messages](./index.md#json-web-token).

### Claims Spec

A Claims Spec allows you to request claims with very specific properties. This is based on the `claims` spec in [OpenID-Connect](https://openid.net/specs/openid-connect-core-1_0.html#ClaimsParameter) but adapted to support Verifiable Claims.

This replaces the `requested` and `verified` parameters of this request. You may still include `requested` and `verified` to provide support for older clients. But they will be ignored if by newer clients if the `claims` field is present.

```js
{
  iss: 'did:web:somesite.com',
  type: 'shareReq',
  claims: {
    verifiable: {
      email: {
        iss: [
          {
            did: 'did:web:uport.claims',
            url: 'https://uport.claims/email'
          },
          {
            did: 'did:web:sobol.io',
            url: 'https://sobol.io/verify'
          }
        ],
        reason: 'Whe need to be able to email you'
      },
      nationalIdentity: {
        essential: true,
        iss: [
          {
            did: 'did:web:idverifier.claims',
            url: 'https://idverifier.example'
          }
        ],
        reason: 'To legally be able to open your account'
      }
    },
    user_info: {
      name: { essential: true, reason: "Show your name to other users"},
      country: null
    }
  }
}
```

#### Verifiable Claims Spec

This is an json object that lives at the `verifiable` key within the `claims` object. It is not required, but provides you flexibility in clearly specifying the kind of claims you need.

Name | Description | Required
---- | ----------- | --------
type | The key in the `verifiable` object is the claims type requested | yes
essential | This claim is essential. A response should not be returned if user does not have this claim | no
iss | Array of `{did, url}` objects where `did` is DID of allowed issuer of claims and `url` is URL for obtaining claim, `did` is required but `url` is not | no
reason | Short string explaining why you need this | no

Examples:

```js
{
  email: {
    essential: true,
    iss: [
      {
        did: 'did:web:uport.claims',
        url: 'https://uport.claims/email'
      },
      {
        did: 'did:web:sobol.io',
        url: 'https://sobol.io/verify'
      }
    ],
    reason: 'Whe need to be able to email you' 
  }
}
```

#### User Info Spec

This is an json object that lives at the `user_info` key within the `claims` object. It is not required, but provides you flexibility in clearly specifying the kind of self presented user claims you need.

NOTE: These are claims specifically made by the user themselves and are not verifiable by an external party.

Name | Description | Required
---- | ----------- | --------
type | The key in the `verifiable` object is the claims type requested | yes
essential | This claim is essential. A response should not be returned if user does not have this claim | no
reason | Short string explaining why you need this | no

Per the OpenId spec if the value of the claim type in the object is `null` then it is a non essential value.

Examples:

```js
{
  email: {
    essential: true,
    reason: 'Whe need to be able to email you' 
  },
  name: null,
  phone: {
    reason: 'So we can notify you by text'
  }
}
```

## Unsigned Requests (Deprecated)

To perform an unsigned selective disclosure request append the request parameters as URL encoded query parameters to one of the above endpoints and open it. Eg.:

`me.uport:me?callback_url=https://mysite.com/callback&label=My%20Site`

The following

Name | Description | Required
---- | ----------- | --------
`callback_url` | The URL that receives the response | yes
`callback_type` | Valid values `post` or `redirect`. Determines if callback should be sent as a HTTP POST or open the link (`redirect`). If unspecified, the mobile app will attempt to pick the correct one| no
`client_id` | The [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids) of the requesting identity | no
`label` | Plain text name of client to be displayed to user | no
`network_id` | Network ID of Ethereum chain of identity eg. `0x4` for `rinkeby` | no
