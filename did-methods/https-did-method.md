# HTTPS DID Method Specification v0.0.1

October 8th, 2018

Mike Xu <mike.xu@consensy.net>

## Preface

This is a DID method specification that conforms to the requirements specified in the [DID specification](https://w3c-ccg.github.io/did-spec/) currently pubished by the W3C Credentials Community Group. For more information about DIDs and DID method specifications, please see the [DID Primer](https://github.com/WebOfTrustInfo/rebooting-the-web-of-trust-fall2017/blob/master/topics-and-advance-readings/did-primer.md)

## Abstract

DIDs that target a distributed ledger face significant practical challenges in bootstrapping enough meaningful trusted data around identities to incentivize mass adoption<sup>[1](#footnote1)</sup>. We propose a new DID method meant to be used in conjunction with blockchain-based DIDs that allows them to bootstrap trust using a web domain's existing reputation.

## Introduction

>  TODO: What should go here that's different from the abstract?

## Example

```json
{
  "@context": "https://w3id.org/did/v1",
  "id": "did:https:example.com",
  "publicKey": [{
       "id": "did:https:example.com#owner",
       "type": "Secp256k1VerificationKey2018",
       "owner": "did:https:example.com",
       "ethereumAddress": "0xb9c5714089478a327f09197987f16f9e5d936e8a"
  }],
  "authentication": [{
       "type": "Secp256k1SignatureAuthentication2018",
       "publicKey": "did:https:example.com#owner"
  }]
}
```

## Target System

This DID method targets the TLS/SSL certificate system used to secure domains in DNS<sup>[2](#footnote2)</sup>.

## DID Method Name

The namestring that shall identify this DID method is: `https`

A DID that uses this method MUST begin with the following prefix: `did:https`. Per the DID specification, this string MUST be in lowercase.

## DID Method Namespace Specific Identifier

The method specific identifier is a fully qualified domain name that is secured by a TLS/SSL certificate.  It is analagous to the common name used in a certificate and must not include IP addresses, port numbers, or directories behind the top-level domain extension. The formal rules describing valid domain name syntax are described in [RFC 1035](https://tools.ietf.org/html/rfc1035), [RFC 1123](https://tools.ietf.org/html/rfc1123), and [RFC 2181](https://tools.ietf.org/html/rfc2181)<sup>[3](#footnote3)</sup>.

### Example

```
did:https:w3c-ccg.github.io
```

## JSON-LD Context Definition

> TODO: Once we define the methods of updating the DID document if they need to reference state within the document

## CRUD Operation Definitions

### Create (Register)

> TODO: Current plan is just to generate this from the app configurator, expose it to the user, and present them with instructions to host it on the web server that resolves from the identifier. We will need to come up with a more legit formal process for this before proposing it as a full DID method.

### Read (Resolve)

The following steps must be performed in order to resolve the DID document from an `https` DID:

1. Parse the fully qualified domain name from the identifier.
2. Generate an https URL to the expected location of the DID document by prepending "https://" and appending "/.well-known/did.json" to the domain name
3. Perform a `GET` request to the URL using an agent that can successfully negotiate a secure https connection

### Update

> TODO: No way to do this at the moment other than manually updating the hosted document. We will need to come up with a more legit formal process for this before proposing it as a full DID method.

### Delete (Revoke)

> TODO: No way to do this at the moment other than manually deleting the hosted document. We will need to come up with a more legit formal process for this before proposing it as a full DID method.

## Security Considerations

> TODO: Not sure if this counts as a security concern or a philosophical one that should be discussed elsewhere.

This DID method is not fully "self-sovereign" due to its reliance on centralized certificate authorities for establishing trust in the ownership of a domain.

## Privacy Considerations

> TODO: Not really any that I can think of. This did will mostly be used to represent an organization rather than individual.

## Reference Implementations

The code at [https://github.com/uport-project/https-did-resolver](https://github.com/uport-project/https-did-resolver) is intended to present a reference implementation of this DID method. Any other implementations should ensure that they pass the test suite described in `/src/__tests__` before claiming compatibility.



<a name="footnote1">1</a>: Not sure about the wording of this sentence. Is this true/useful to put here in the document? Attempting to set the stage for why this DID method is useful. How else to describe the problem of someone verifying a claim made by some DID lacking low friction ways to associate that DID with an existing entity that they trust? Also communicate that this problem occurs because DIDs are new and there will not be enough information associated with them for users to decide to trust them.

<a name="footnote2">2</a> Not sure how to accurately classify the target system. DNS seems too broad, but not sure if TLS/SSL certificate system is enough.

<a name="footnote2">3</a> Is this descriptive enough? Those RFCs are huge and I didn't bother to understand them fully. Do we need to explicitly reproduce the relevant sections of them in this document?