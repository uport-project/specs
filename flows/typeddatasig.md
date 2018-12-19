---
title: "Tyed Data Signature Request Flow"
category: "flows"
type: "reference"
source: "https://github.com/uport-project/specs/blob/develop/flows/typeddatasig.md"
---


# Typed Data Signature Request Flow

Similar to a [Verification request](verificationreq.md), a client application can request that the user sign a piece of typed data, for example one conforming to the EIP712 Specification.

The following shows the basic flow:

![Typed Data Signature Request Flow](typeddatasig.png)

## Endpoint

The request should be sent to the following URLs:

- `https://id.uport.me/req/[JWT]`

## Send Request

Create a valid signed [Typed Data Signature Request](../messages/signtypeddatareq.md).


## Client Callback

The client app MAY include a URL where the response is returned from the user. This can be a HTTPS URL or a custom app URL which receives the response.

Responses are param appended to a URL fragment. If the callback requires the response as a HTTP POST, it is sent as a JSON POST request to the callback URL instead.

### Successful Response

param          | Description
-------------- | -----------
`typedDataSig` | [Signed Typed Data Response](../messages/signtypeddataresp.md)

### Errors

An `error` parameter is returned as the response to the Client App, containing the following:

Error         | Description
------------- | -----------
access_denied | User denies the request
