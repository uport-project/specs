# Verification

A Verification is a statement issued by a third party verifying claims about an identity [Verification Flow](../flows/verification.md).

Verifications are always signed.

## Attributes

The following attributes of the JWT are supported:

Name | Description | Required
---- | ----------- | --------
[`iss`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The [MNID](https://github.com/uport-project/mnid) of the signing identity| yes
[`sub`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The [MNID](https://github.com/uport-project/mnid) of the signing identity| yes
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of Verification | no
`claim` | An object containing one or more claims about `sub` eg: `{"name":"Carol Crypteau"}` | yes

## Claims Best Practices

### Use atomic claims

In most cases we recommend having a single claim per verification. This allows your users to share only the specific claims they want.

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
