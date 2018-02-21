# Decentralized Identity Document (DID Document)

This is the subset of the [DID Document](https://w3c-ccg.github.io/did-spec) spec that we implement as part of the uPort platform.

The Identity document is stored on IPFS and tied to the address using the uport registry as specified in the [PKI document](../index).

## Contents

The Identity document must contain the public key for the identity, everything else is optional. Anything in this document is public, so please be wary of publishing any Private information to it.

This is an example of a minimal identity document:

```js
{
  "@context": "https://w3id.org/did/v1",
  "id": "did:uport:2nQtiQG6Cgm1GYTBaaKAgr76uY7iSexUkqX",
  "publicKey": [{
    "id": "did:uport:2nQtiQG6Cgm1GYTBaaKAgr76uY7iSexUkqX#keys-1",
    "type": "EcdsaPublicKeySecp256k1",
    "owner": "did:uport:2nQtiQG6Cgm1GYTBaaKAgr76uY7iSexUkqX",
    "publicKeyHex": "04613bb3a4874d27032618f020614c21cbe4c4e4781687525f6674089f9bd3d6c7f6eb13569053d31715a3ba32e0b791b97922af6387f087d6b5548c06944ab062"
  }, {
    "id": "did:uport:2nQtiQG6Cgm1GYTBaaKAgr76uY7iSexUkqX#keys-2",
    "type": "Ed25519EncryptionPublicKey",
    "owner": "did:uport:2nQtiQG6Cgm1GYTBaaKAgr76uY7iSexUkqX",
    "publicKeyBase64": "QCFPBLm5pwmuTOu+haxv0+Vpmr6Rrz/DEEvbcjktQnQ="
  }]
}
```

This is a example of a identity document for an app with extra public profile information:

```js
{
  "@context": "https://w3id.org/did/v1",
  "id": "did:uport:2nQtiQG6Cgm1GYTBaaKAgr76uY7iSexUkqX",
  "publicKey": [{
    "id": "did:uport:2nQtiQG6Cgm1GYTBaaKAgr76uY7iSexUkqX#keys-1",
    "type": "EcdsaPublicKeySecp256k1",
    "owner": "did:uport:2nQtiQG6Cgm1GYTBaaKAgr76uY7iSexUkqX",
    "publicKeyHex": "04613bb3a4874d27032618f020614c21cbe4c4e4781687525f6674089f9bd3d6c7f6eb13569053d31715a3ba32e0b791b97922af6387f087d6b5548c06944ab062"
  }],
  "uportProfile": {
    "@context":"http://schema.org",
    "@type":"Organization",
    "name":"uPort @ Devcon 3",
    "description":"Uport Attestations",
    "image":{"@type":"ImageObject","name":"avatar","contentUrl":"/ipfs/QmSCnmXC91Arz2gj934Ce4DeR7d9fULWRepjzGMX6SSazB"}
  }
}

```

### Parameters

Name | Description | Required
---- | ----------- | --------
`@context` | `https://w3id.org/did/v1`| yes
`publicKey` | array of allowed hex encoded [secp256k1 ECDSA curve](https://en.bitcoin.it/wiki/Secp256k1) public keys and/or Ed25519| yes
`owner` | Public profile information compatible with [schema.org](https://schema.org) | no
