---
title: "Message Encryption"
category: "reference"
type: "content"
source: "https://github.com/uport-project/specs/blob/develop/messages/encryption.md"
---

# Message Encryption

Some [message transports](/transports/index.md) are not directly secure and require encryption of the message. We currently use the [box public key auhtenticated encryption algorithm](http://nacl.cr.yp.to/box.html) and thus both parties need a Curve25519 public key to be able to create a secure session.

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

We use the [ERC 1098](https://github.com/ethereum/EIPs/pull/1098) encryption method which uses an ephemeral sending key and the [box](https://github.com/dchest/tweetnacl-js/blob/master/README.md#public-key-authenticated-encryption-box) method from [tweet-nacl](https://tweetnacl.js.org/). This allows the recipient to decrypt a message without having to resolve the public key of the sender.

The following method is used:

1. Create the signed [JWT payload like normal](/messages/index.md)
2. JWT is padded with `\0`s to the nearest multiple of 64 bytes (see "padding" below)
3. Create an ephemeral keypair using [`nacl.box.keyPair()`](https://github.com/dchest/tweetnacl-js/blob/master/README.md#naclboxkeypair)
4. Create a random 24 bytes `nonce` using [`nacl.randomBytes(nacl.box.nonceLength)`](https://github.com/dchest/tweetnacl-js/blob/master/README.md#naclrandombyteslength)
5. encrypt the resulting JWT using the [`nacl.box(message, nonce, recipient publicKey, ephemeralKeyPair.secretKey)`](https://github.com/dchest/tweetnacl-js/blob/master/README.md#naclboxmessage-nonce-theirpublickey-mysecretkey)
6. Combine the base64 encoded versions of the above `nonce`, `ephemPublicKey` and `ciphertext` values together with the `version` of `x25519-xsalsa20-poly1305` in a JSON payload.

```js
{ version: 'x25519-xsalsa20-poly1305',
  nonce: '1dvWO7uOnBnO7iNDJ9kO9pTasLuKNlej',
  ephemPublicKey: 'FBH1/pAEHOOW14Lu3FWkgV3qOEcuL78Zy+qW1RwzMXQ=',
  ciphertext: 'f8kBcl/NCyf3sybfbwAKk/np2Bzt9lRVkZejr6uh5FgnNlH/ic62DZzy' }
```

## Decrypting the request

You need to know the recipients secretKey.

1. Check that the `version` field is `x25519-xsalsa20-poly1305`
2. Decode the base64 encoded `nonce`, `ephemPublicKey` and `ciphertext` attributes
3. Decrypt it message using [`nacl.box.open(ciphertext, nonce, ephemPublicKey, recieverEncryptionPrivateKey)`](https://github.com/dchest/tweetnacl-js/blob/master/README.md#naclboxopenbox-nonce-theirpublickey-mysecretkey)
4. Strip any trailing `\0` from the payload
5. Decode JWT as normal


## Padding

To avoid leaking information about the specific size of the payload, we need to pad the payload to the nearest multiple of 64 bytes. The padding should be done with `\0` bytes.

After decrypting any trailing `\0`s  are removed before passing the result to the JWT verifier.

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
