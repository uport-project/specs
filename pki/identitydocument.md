# Identity Document

Note this format will be deprecated soon and replaced by a standard [DID Document](./diddocument.md).

The Identity document is stored on IPFS and tied to the address using the uport registry as specified in the [PKI document](../index).

The Identity document is a JSON document (strictly speaking a [JSON-LD](https://json-ld.org/)).

## Contents

The Identity document must contain the public key for the identity, everything else is optional. Anything in this document is public, so please be wary of publishing any Private information to it.

This is an example of a minimal identity document:

```js
{
  "@context":"http://schema.org",
  "@type":"Person",
  "publicKey":"0x04613bb3a4874d27032618f020614c21cbe4c4e4781687525f6674089f9bd3d6c7f6eb13569053d31715a3ba32e0b791b97922af6387f087d6b5548c06944ab062",
  "publicEncKey":"QCFPBLm5pwmuTOu+haxv0+Vpmr6Rrz/DEEvbcjktQnQ="
}
```

This is a example of a identity document for an app with extra public profile information:

```js
{
  "@context":"http://schema.org",
  "@type":"Organization",
  "name":"uPort @ Devcon 3",
  "description":"Uport Attestations","publicKey":"0x04613bb3a4874d27032618f020614c21cbe4c4e4781687525f6674089f9bd3d6c7f6eb13569053d31715a3ba32e0b791b97922af6387f087d6b5548c06944ab062",
  "image":{"@type":"ImageObject","name":"avatar","contentUrl":"/ipfs/QmSCnmXC91Arz2gj934Ce4DeR7d9fULWRepjzGMX6SSazB"}
}
```

### Parameters

Name | Description | Required
---- | ----------- | --------
`@context` | `http://schema.org`| yes
`@type` | `Person`, `App`, `Organization`| yes
`publicKey` | `0x` prefixed hex encoded [secp256k1 ECDSA curve](https://en.bitcoin.it/wiki/Secp256k1) public key | yes
`publicEncKey` | Base64 encoded [`curve25519xsalsa20poly1305`](http://nacl.cr.yp.to/box.html) public key | no
`name` | Name of identity | no
`description` | Description of identity | no
`image` | Avatar or logo of identity (Uses [ImageObject](http://schema.org/ImageObject) with `contentUrl`) | no




