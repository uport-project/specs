# Uport Request Flows

A request will typically be signed by a client app and sent to mobile app using this generic request flow:

![Generic Uport Request Flow](generic.png)

## Specific Application flows

- [Selective Disclosure Flow](selectivedisclosure.md)
- [Send Verification Flow](verification.md)
- [Ethereum Transaction Request Flow](tx.md)

## Errors

Wherever possible errors are based on [OAuth 2.0 RFC 6749 Authorization Errors](https://tools.ietf.org/html/rfc6749#section-4.1.2.1)

An `error` parameter is returned as the response to the Client App, containing one of following:

Error         | Description
------------- | -----------
access_denied | User denies the request

## Request and Response Transports

There are various ways that requests can be sent to the Uport app and how responses can be returned.

### [Request/Response Transports](transports.md)