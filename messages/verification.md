---
title: "Verified Claims"
category: "messages"
type: "reference"
source: "https://github.com/uport-project/specs/blob/develop/messages/verification.md"
---


# Verified Claims

A Verified Claim is a statement issued by a third party verifying claims about an identity [Verified Claim Flow](../flows/verification.md).

Verified Claims are always signed.

## Attributes

The following attributes of the JWT are supported:

Name | Description | Required
---- | ----------- | --------
[`iss`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids) of the signing identity| yes
[`sub`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids) of the subject identity| yes
`type`| The type of attestation | no
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of Verification | no
`claim` | An object containing one or more claims about `sub` eg: `{"name":"Carol Crypteau"}` | yes
`vc` | Array of Verified Claims JWTs or IPFS hash of JSON encoded equivalent about the `iss` of this message | no
`dev` | `true` or `false`. Is this Verification for development purpose only? Use it to distinguish between verifications created during development and/or testing. | no (defaults to `false`)

## Claims Best Practices

### Use atomic claims

In most cases we recommend having a single claim per Verified Claim. This allows your users to share only the specific claims they want.

```json
{"name":"Carol Crypteau"}
```

### Bundling multiple claims as one

Some times multiple claims are actually a single claim. A good example is an address which can consist of multiple fields. In that case we recommend nesting them under a single claim like this:

```json
{"address": {
  "streetAddress":"12345 Buterin Lane",
  "postalCode":"123133",
  "addressLocality":"Toronto",
  "addressRegion":"ON",
  "addressCountry":"CA"}
}
```

### Claim Taxonomy

uPort is agnostic to different claim types. This allows you to plug in your own taxonomy of claims or use an existing taxonomy that works in your industry.

If you don't need to follow a specific taxonomy of claims, we recommend that you find suitable claim types within [Schema.org](http://schema.org).
