# Request Response Server

This RESTful API simplifies a few interactions for a serverless Decentralized Apps:

- initiate a request via a compact QR code
- receive a response from client

uPort operates a free implementation of this service at this URL:

`https://chasqui.uport.me`

The [source is available on github](https://github.com/uport-project/chasqui) and you can freely run your own version of it.

## Initiating a request for use in a QR code

Prepare the [Request Message JWT](/messages/index.md). This SHOULD NOT contain any private information.

Just perform a HTTP `DELETE` on the callback url.

#### Endpoint

`POST /api/v1/topic`

#### Body

```js
{"request":"JWT OF REQUEST"}
```

#### Response

| Status |     Message    |                                            |
|:------:|----------------|--------------------------------------------|
| 201    | Created        | Topic created                              |
| 500    | Internal Error | Internal Error                             |

If successful (HTTP code 201) the topic URL to include in the QR code is included in the `Location` HTTP response header.

### End User Client Scanning QR code

If the QR code contains a URL that does not match an existing deep URL used by the mobile client, it will attempt to fetch the request from it.

#### Endpoint

`GET /api/v1/topic/:id`

#### Response

| Status |     Message    |                               |
|:------:|----------------|-------------------------------|
| 200    | Ok.            | Message stored on topic <id>  |
| 500    | Internal Error | Internal error                |

#### Response data

The following is the request made by the mobile client.

```json
{
  "status": "success",
  "message": {
    "request": "JWT OF REQUEST"
  },
  "referrerUrl": "https://mydapp.com"
}
```

## Receiving a response from client

The message sent as a response SHOULD be encrypted. See the [message encryption](/messages/encrypted.md) document for more details.

### Preparing callback URL

To use the messaging server, create a large secure URL safe random number that we call the topic id.

Include the callback URL with the following format in your request `https://chasqui.uport.me/api/v1/topic/[TOPIC ID]`.

### Listening for Response

You can perform polling to the same callback URL you passed along to the request using HTTP GET.

#### Endpoint

`GET /api/v1/topic/:id`

#### Response

| Status |     Message    |                               |
|:------:|----------------|-------------------------------|
| 200    | Ok.            | Message stored on topic <id>  |
| 500    | Internal Error | Internal error                |

#### Response data

If no response has been received the `message` object will be empty:

```json
{
  "status": "success",
  "message": {}
}
```

Once the uPort app returns the response it will be included there:

```json
{
  "status": "success",
  "message": {"access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NksifQ.eyJp..."}
}
```

### Cleanup

To avoid having potentially private data stored on our server please `DELETE` the response after receiving a successful response.

Just perform a HTTP `DELETE` on the callback url.

#### Endpoint

`DELETE /api/v1/topic/:id`

#### Response

| Status |     Message    |                                            |
|:------:|----------------|--------------------------------------------|
| 200    | Ok.            | Topic deleted                              |
| 404    | Not found      | Topic not found                            |
| 500    | Internal Error | Internal Error                             |
