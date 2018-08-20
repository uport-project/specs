---
title: "Off-chain Messages"
category: "reference"
type: "content"
source: "https://github.com/uport-project/specs/blob/develop/messages/shareresp.md"
---

# Selective Disclosure Response

The Selective Disclosure Response is created by a users mobile app as a response to a [Selective Disclosure Request](sharereq.md) during the [Selective Disclosure Flow](/flows/selectivedisclosure.md).

The response is always signed and returned to the callback url included in the request.

#### Attributes

The following attributes of the JWT are supported:

Name | Description | Required
---- | ----------- | --------
`type` | MUST have the value `shareResp` | yes
[`iss`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The [MNID](https://github.com/uport-project/mnid) of the signing identity| yes
[`aud`](https://tools.ietf.org/html/rfc7519#section-4.1.3) | The [MNID](https://github.com/uport-project/mnid) of the requester or the callback url if this was created as a response to an unsigned request | yes
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of JWT | yes
`req`| The original JWT encoded Selective Disclosure Request | yes for responses to signed requests
`nad`| The [MNID](https://github.com/uport-project/mnid) of the Ethereum account requested using `act` in the [Selective Disclosure Request](sharereq.md) | no
`dad`| The `devicekey` as a regular hex encoded ethereum address as requested using `act='devicekey'` in the [Selective Disclosure Request](sharereq.md) | no
`own|issc` | The self signed claims requested from a user. Either as an Object of claim types for self signed claims eg: `{"name":"Carol Crypteau", "email":"carol@sample.com","image":{"/":"/ipfs/QmSCnmXC91Arz2gj934Ce4DeR7d9fULWRepjzGMX6SSazB"}}` or the IPFS Hash of a JSON encoded equivalent. See [claims](/messages/claims.md) | no
`verified|vc` | Array of Verified Claims JWTs or IPFS hash of JSON encoded equivalent. See [Verified Claims](/messages/verification.md) | no
`capabilities` | An array of JWT tokens giving client app the permissions requested. Currently a token allowing them to send push notifications | no
`boxPub` | 32 byte base64 encoded [`Curve25519`](http://nacl.cr.yp.to/box.html) public key used for sending encrypted messages to user | no
