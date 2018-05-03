---
title: "Uport Request Flows"
category: "reference"
type: "content"
---

# Uport Request Flows

A request will typically be signed by a client app and sent to mobile app using this generic request flow:

![Generic uPort Request Flow](generic.png)

## Specific Application flows

- [Selective Disclosure Flow](selectivedisclosure.md)
- [Send Verification Claim Flow](verification.md)
- [Request Verification Claim Flow](verificationreq.md)
- [Ethereum Transaction Request Flow](tx.md)
- [Private Chain Provisioning Flow](privatechain.md)

## Errors

Wherever possible errors are based on [OAuth 2.0 RFC 6749 Authorization Errors](https://tools.ietf.org/html/rfc6749#section-4.1.2.1)

An `error` parameter is returned as the response to the Client App, containing one of following:

Error         | Description
------------- | -----------
access_denied | User denies the request
