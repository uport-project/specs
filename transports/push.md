---
title: "Push Notification Transport"
category: "reference"
index: 0
prefix: "/transports"
type: "content"
tags:
    - programming
    - stuff
    - other
---

# Push Notification Transport
Push notifications is a transport for sending requests to users. To make sure that the push notification service does not learn any information about what is in the request itself, all requests have to be encrypted. This means that sending a request as a push notification has two steps; encryption and a REST call.

## Encrypting the request
In order to properly encrypt the message you first need to [resolve the public encryption key](../pki/index.md#resolving-the-public-encryption-key-for-iss) for your user. From now on we call that `userPublicKey` in this section. If you want code to look at, check out the implementation in [uport-js](https://github.com/uport-project/uport-js/blob/develop/src/Credentials.js#L175)

### Proper encoding of the request

First, simply wrap the request url in a JSON object and encode it as a string, like so: `{"url":"<request-url>"}`.
We recommend padding the message so that it is less vulnerable to analysis attacks. This is done by appending spaces to the message until it is of length `N * I`, where `N` is any integer and `I` is some consistent number. We recommend `I = 50`.

Lastly by decoding this UTF-8 string to bytes we get message `m`.

### Encryption of the request

To encrypt the request [NACL Box Public Key Encryption](http://nacl.cr.yp.to/box.html) is used. An ephemeral key is generated in order to encrypt the data to the public key of the user.

The `userPublicKey` is encoded as a Base64 string. The decoded public key `upk` should be 32 bytes.
The ephemeral key pair is generated using the NACL library. Both secret key `eSK` and the public key `epk` has to be 32 bytes.
The nonce `n` should be randomly generated and of length 24.

Using the data above a NACL Box can be used to encrypt the message: `c = crypto_box(m, n, upk, eSK)`

### Encoding the encrypted data

In order for the mobile app to be able to decrypt the ciphertext it also needs `epk` and `n`. This needs to be formatted in a specific way. Most importantly the parameters need to be encoded as Base64 strings.

Simply create a JSON object and encode it as a string: `{"from":"<epk encoded as Base64>","nonce":"<n encoded as Base64>","ciphertext":"<c encoded as Base64>"}`. This string is now our `encrypted message`.

## Sending the request
To send the now encrypted message the server described below is used.

### Push notification server

The uPort push notification service is operating from the following url:

`https://pututu.uport.me`

It allows you to send encrypted push notifications to your user given that you have a `notification token` that you get when requesting the `'notifications'` permission in the [Selective Disclosure Flow](../flows/selectivedisclosure.md).

#### Endpoint

`GET /api/v1/sns`

#### Headers

`Authorization: Bearer <notification token>`

#### Body
```
{
  message: <encrypted message>
}
```

#### Response

| Status |     Message    |                               |
|:------:|----------------|-------------------------------|
| 200    | Ok             | Message Send                   |
| 400    | Fail           | endpointArn not supported     |
| 400    | Fail           | token not signed by endpointArn user |
| 403    | Forbidden      | JWT token missing or invalid  |
| 500    | Internal Error | Internal error                |

#### Response data
```
{
  status: 'success',
  message: <messageId>
}
```
