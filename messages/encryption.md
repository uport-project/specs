---
title: "Message Encryption"
category: "reference"
type: "content"
---

# Message Encryption

Some [message transports](/transprots/index.md) are not directly secure and require encryption of the message. We currently use the [box public key auhtenticated encryption algorithm](http://nacl.cr.yp.to/box.html) and thus both parties need a Curve25519 public key to be able to create a secure session.

## Encryption Public Key resolution

A public key can either be published as part of the [DID document](/pki/diddocument.md). In this case it looks for a `publicKey` of type `Curve25519EncryptionPublicKey` in the DID document. eg.

```js
{
  '@context': 'https://w3id.org/did/v1',
  'id': 'did:uport:2nQtiQG6Cgm1GYTBaaKAgr76uY7iSexUkqX',
  'publicKey': [
    ...,
    {
    'id': 'did:uport:2nQtiQG6Cgm1GYTBaaKAgr76uY7iSexUkqX#keys-2',
    'type': 'Curve25519EncryptionPublicKey',
    'owner': 'did:uport:2nQtiQG6Cgm1GYTBaaKAgr76uY7iSexUkqX',
    'publicKeyBase64': 'QCFPBLm5pwmuTOu+haxv0+Vpmr6Rrz/DEEvbcjktQnQ='
  }],
  ...
}
```

Currently the public key must be base64 encoded in the `publicKeyBase64` attribute.

## Request/Response resolution

If your DID method does not include an encryption key it can also be included as part of the initiation of a session setup between requesting and disclosing parties as part of the [Selective Disclosure Flow](/flows/selectivedisclosure.md).

If the requesting party does not include the encryption public key in the DID document they can include a `boxPub` attribute as part of the [Selective Disclosure Request](/messages/sharereq.md).

If the disclosing party does not include the encryption public key in the DID document they can also include a `boxPub` attribute as part of the [Selective Disclosure Response](/messages/shareresp.md).

### JOSE JWK Standards

We currently do not support the JOSE JWT standards including the [JOSE CFRG ECDH RFC](https://tools.ietf.org/html/draft-ietf-jose-cfrg-curves-06). This is primarily for reasons of compactness. Our responses have to be limited in size to be able to comfortably fit in a QR code.

We plan to support these in the future.

## Encrypting the request

We use the [Sealed Box](https://download.libsodium.org/doc/public-key_cryptography/sealed_boxes.html) method which is part of [libsodium](https://download.libsodium.org). This allows the recipient to decrypt a message without having to resolve the public key of the sender.

A Javascript implementation can be found in [tweetnacl-sealed-box](https://github.com/whs/tweetnacl-sealed-box).

Create the signed [JWT payload like normal](/messages/index.md) and encrypt the resulting JWT using the `crypto_box_seal()` function from [libsodium](https://download.libsodium.org/doc/public-key_cryptography/sealed_boxes.html) or the `tweetnacl.sealedbox.open()` function from [tweetnact-sealedbox](https://github.com/whs/tweetnacl-sealed-box). The resulting data should be base64url encoded.

## Decrypting the request

If a message matches a single base64url section, the message is encrypted. Regular JWT's match 3 `.` separated base64url sections and can be verified directly.

Decode the base64url message and pass the resulting raw payload into either `crypto_box_seal_open()` from [libsodium](https://download.libsodium.org/doc/public-key_cryptography/sealed_boxes.html) or `tweetnacl.sealedbox.open()` function from [tweetnact-sealedbox](https://github.com/whs/tweetnacl-sealed-box).

## Legacy Encryption of the request

This method is used in early versions of uPort and is only documented here for historical reasons.

To encrypt the request [NACL Box Public Key Encryption](http://nacl.cr.yp.to/box.html) is used. An ephemeral key is generated in order to encrypt the data to the public key of the user.

The `encryptionPublicKey` is encoded as a Base64 string. The decoded public key `upk` should be 32 bytes.
The ephemeral key pair is generated using the NACL library. Both secret key `eSK` and the public key `epk` has to be 32 bytes.
The nonce `n` should be randomly generated and of length 24.

Using the data above a NACL Box can be used to encrypt the message: `c = crypto_box(m, n, upk, eSK)`

### Encoding the encrypted data

In order for the mobile app to be able to decrypt the ciphertext it also needs `epk` and `n`. This needs to be formatted in a specific way. Most importantly the parameters need to be encoded as Base64 strings.

Simply create a JSON object and encode it as a string: `{"from":"<epk encoded as Base64>","nonce":"<n encoded as Base64>","ciphertext":"<c encoded as Base64>"}`. This string is now our `encrypted message`.

