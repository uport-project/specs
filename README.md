# Uport Specs

Uport is a platform for user centric identity and communication. The platform currently consists of our mobile app, ethereum smart contracts and number of open protocols for signed messages and message flow.

## Identities

An identity in Uport is really just someone or something that can sign data or transactions and also receive signed data about itself.

An identity has:

- An Identifier in the form of an [MNID](https://github.com/uport-project/mnid)
- A signing key
- A public key stored on the [Uport Registry](https://github.com/uport-project/uport-registry)

An identity can:

- Sign JWTs (JSON Web Tokens)
  - [Authenticate themselves to a third party](messages/shareresp.md)
  - [Disclose private information about themselves](messages/shareresp.md)
- [Receive requests for disclosure about themselves](messages/sharereq.md)
- [Receive and store signed third party verifications about themselves](flows/verification.md)
- [Sign Ethereum transactions](flows/tx.md)

### Identities created using the Uport Mobile App

Currently most Uport users manage their identities through their mobile app. Identities created today consist of an instance of the [Proxy](https://github.com/uport-project/uport-identity/blob/develop/contracts/Proxy.sol) smart contract deployed on a supported ethereum compatible blockchain.

## Request Flows

A request will typically be signed by a client app and sent to mobile app using this generic request flow:

![Generic Uport Request Flow](flows/generic.png)

We currently support the following flows:

- [Selective Disclosure Flow](flows/selectivedisclosure.md)
- [Send Verification Flow](flows/verification.md)
- [Ethereum Transaction Request Flow](flows/tx.md)

### [More about request flows](flows/index.md)

## Request and Response Transports

There are various ways that requests can be sent to the Uport app and how responses can be returned.

### [Request/Response Transports](transports/index.md)

## Off-chain Messages

Most request and responses are performed Off-chain in a private manner between the different parties to a flow.

Most Off-chain messages consist of signed JWTs (JSON Web Tokens) as defined in [RFC 7519](https://tools.ietf.org/html/rfc7519). Signatures are verified using our simple Uport PKI (see later in this document).

### [More about Off-chain Messages](messages/index.md)

## On-chain Transactions

Ethereum transactions can be requested to be signed by the mobile app

## Uport PKI

Uport implements a simple yet general purpose decentralized PKI system making it easy to create and verify offchain JWT messages.

### Identity Document
### Register Identity Document
### Lookup Identity Document
