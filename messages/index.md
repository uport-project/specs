---
title: "Off-chain Messages"
category: "reference"
type: "content"
source: "https://github.com/uport-project/specs/blob/develop/messages/index.md"
---

# Off-chain Messages

Most request and responses are performed privately off-chain between the different parties to a flow.

## JSON Web Token

Most off-chain messages consist of signed JWTs (JSON Web Tokens) as defined in [RFC 7519](https://tools.ietf.org/html/rfc7519).

### Requirements

We currently only support signatures using the [secp256k1 ECDSA curve](https://en.bitcoin.it/wiki/Secp256k1), which is also used by both Bitcoin and Ethereum.

#### JOSE Header

The [JOSE header](https://tools.ietf.org/html/rfc7519#section-5) indicates the signing algorithm used in the JWT. This MUST contain the following:

```json
{"typ": "JWT", "alg": "ES256K"}
```

#### Attributes

The JWT spec calls these claims, but we use the term "claims" for identity-specific data. So in this document we will call these standard JWT "claims" "attributes" instead.

Name | Description | Required
---- | ----------- | --------
[`iss`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The [MNID](https://github.com/uport-project/mnid) of the signing identity| yes
[`sub`](https://tools.ietf.org/html/rfc7519#section-4.1.2) | The [MNID](https://github.com/uport-project/mnid) of the subject of the JWT| no
[`aud`](https://tools.ietf.org/html/rfc7519#section-4.1.3) | The [MNID](https://github.com/uport-project/mnid) or URL of the audience of the JWT. Our libraries or app will not accept any JWT that has someone else as the audience| no
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of JWT | no

Non Standard attributes:

Name | Description | Required
---- | ----------- | --------
`callback` | Callback URL for returning the response to a request | no
`type` | Type of Message | no
`own` | The self signed claims for the `iss` of this message. Either as an Object of claim types for self signed claims eg: `{"name":"Some Corp Inc", "url":"https://somecorp.example","image":{"/":"/ipfs/QmSCnmXC91Arz2gj934Ce4DeR7d9fULWRepjzGMX6SSazB"}}` or the IPFS Hash of a JSON encoded equivalent. See [Issuer Claims](/messages/claims.md) | no
`verified` | Array of Verified Claims JWTs or IPFS hash of JSON encoded equivalent about the `iss` of this message. See [Verified Claims](/messages/verification.md) | no
`boxPub` | 32 byte base64 encoded [`Curve25519`](http://nacl.cr.yp.to/box.html) public key | no

The following attributes can also be appended to the signed request as URL encoded query parameters outside of the signed payload.

Name | Description | Required
---- | ----------- | --------
`redirect_url` | The URL that control is returned to once a request is complete (mobile). Base url/domain must match callback in JWT. | no
`callback_type` | Valid values `post` or `redirect`. Determines if callback should be sent as a HTTP POST or open the link (`redirect`). If unspecified, the mobile app will attempt to pick the correct one| no

These options allow you to tell the client how you want to receive the response. If a redirect_url is provided, the client will post the response to the callback in the JWT and then call the given redirect_url to return control to the original callee. You can also add any contextual data in the redirect_url query params or as a url fragment (i.e. you may want to map requests to responses). If a redirect_url is provided and a callback_type redirect is provided the response will be passed as url fragment with the redirect_url. If no redirect_url is provided, it will use the callback in JWT and will use the callback_type if provided or the client will attempt to choose the correct type.

### Signature Verification

Each uPort compatible JWT must be signed using an secp256k1 curve. The public key is resolved for the `iss` using the [uPort PKI](/pki/index.md).

### Message Encryption

Some [message transports](/transports/index.md) are not secure and require messages to be encrypted. See [/messages/encryption.md] for more.

## Unsigned Requests (Deprecated)

Many apps that run 100% in the browser do not have a secure way of signing a request. Therefore we provide unsigned versions of certain requests.

### Standard Unsigned Parameters

There are certain standardized parameters that are provided using HTTP query params in the request. Some of these are based on parameters in the [OAuth 2.0 RFC 6749 Spec](https://tools.ietf.org/html/rfc6749):

Name | Description | Required
---- | ----------- | --------
`client_id` | The [MNID](https://github.com/uport-project/mnid) of the requesting identity | no
`callback_url` | The URL that receives the response | no
`callback_type` | Valid values `post` or `redirect`. Determines if callback should be sent as a HTTP POST or open the link (`redirect`). If unspecified the mobile app will attempt to pick the correct one| no
`label` | Plain text name of client to be displayed to user | no

## Message types

There are several standard message types that the uPort mobile app knows how to handle or create:

- **[Selective Disclosure Request](sharereq.md)** for asking private data from a user
- **[Selective Disclosure Response](shareresp.md)** signed by the app as a response to a Selective Disclosure Request
- **[Verified Claim](verification.md)** - signed claim by one party about another party
- **[Verified Claim Request](verificationreq.md)** - Request a signed claim by one party about another party
- **[Ethereum Transaction Request](tx.md)** for requesting a user to sign a transaction
- **[Private Chain Provisioning Message](privatechain.md)** for provisioning an identity on a private Ethereum chain
