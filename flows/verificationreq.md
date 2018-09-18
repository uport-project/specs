---
title: "Verification Request Flow"
category: "flows"
type: "reference"
source: "https://github.com/uport-project/specs/blob/develop/flows/verificationreq.md"
---


# Verified Claim Request Flow

A client application can request that the user sign a Verified Claim.

The following shows the basic flow:

![Verified Request Flow](verificationreq.png)

## Endpoint

The request should be sent to the following URLs:

- `https://id.uport.me/req/[JWT]`

## Send Request

Create a valid signed [Verified Claim Request](../messages/verificationreq.md) and send it to the uPort mobile app.

Signed example:

`https://id.uport.me/req/eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NksifQ.eyJp...`


## Client Callback

The client app MUST include a URL where the response is returned from the user. This can be a HTTPS URL or a custom app URL which receives the response.

Responses are param appended to a URL fragment. If the callback requires the response as a HTTP POST, it is sent as a JSON POST request to the callback URL instead.

### Successful Response

param          | Description
-------------- | -----------
`verification` | [Verified Claim](../messages/verification.md)

### Errors

An `error` parameter is returned as the response to the Client App, containing one of following:

Error         | Description
------------- | -----------
access_denied | User denies the request
