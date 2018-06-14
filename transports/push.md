---
title: "Push Notification Transport"
category: "reference"
type: "content"
---

# Push Notification Transport
Push notifications is a transport for sending requests to users. To make sure that the push notification service does not learn any information about what is in the request itself, all requests have to be encrypted. This means that sending a request as a push notification has two steps; encryption and a REST call.

### Proper encoding of the request

The message SHOULD be encrypted. See the [message encryption](/messages/encrypted.md) document for more details.

First, simply wrap the request url in a JSON object and encode it as a string, like so: `{"url":"<request-url>"}`.
We recommend padding the message so that it is less vulnerable to analysis attacks. This is done by appending spaces to the message until it is of length `N * I`, where `N` is any integer and `I` is some consistent number. We recommend `I = 50`.

Lastly by decoding this UTF-8 string to bytes we get message `m`.

## Sending the request
To send the now encrypted message the server described below is used.

### Push notification server

The uPort push notification service is operating from the following url:

`https://api.uport.me/pututu`

It allows you to send encrypted push notifications to your user given that you have a `notification token` that you get when requesting the `'notifications'` permission in the [Selective Disclosure Flow](/flows/selectivedisclosure.md).

#### Endpoint

`POST /sns`

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
