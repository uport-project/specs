# Off-chain Messages

Most request and responses are performed Off-chain in a private manner between the different parties to a flow.

## JSON Web Token

Most Off-chain messages consist of signed JWTs (JSON Web Tokens) as defined in [RFC 7519](https://tools.ietf.org/html/rfc7519).

### Requirements

We currently only support signatures using the [secp256k1 ECDSA curve](https://en.bitcoin.it/wiki/Secp256k1), which is the same as used by both Bitcoin and Ethereum.

#### JOSE Header

The [JOSE header](https://tools.ietf.org/html/rfc7519#section-5) indicates the signing algorithm used in the JWT. This MUST contain the following:

```json
{"typ": "JWT", "alg": "ES256K"}
```

#### Attributes

The JWT spec calls these claims, but we use the term claims for identity specific claims. So in this document we will call these standard JWT "claims" "attributes"

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

### Signature Verification

Each Uport compatible must be signed using an secp256k1 curve. The public key is resolved for the `iss` using the [Uport PKI](../pki/index.md).

## Unsigned Requests

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

There are several standard message types that the Uport mobile app knows how to handle or create:

- **[Selective Disclosure Request](sharereq.md)** for asking private data from a user
- **[Selective Disclosure Response](shareresp.md)** signed by the app as a response to a Selective Disclosure Request
- **Verification** - signed claim by one party about another party
