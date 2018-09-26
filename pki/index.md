---
title: "Uport PKI"
category: "pki"
type: "reference"
source: "https://github.com/uport-project/specs/blob/develop/pki/index.md"
---

# uPort PKI

uPort implements a simple yet general purpose decentralized PKI system, making it easy to create and verify off-chain JWT messages.

## Purpose

We need a decentralized way to lookup public keys that can be used to verify off-chain JWTs. This allows us to use the power of the Ethereum blockchain to verify signed data privately transferred between parties.

The PKI is not needed for blockchain transactions themselves, as any blockchain already has a PKI-like functionality built in.

We are primarily using it with JWTs, although it could be used for signing other data formats as well.

## Creating and Verifying a JWT

The following overview shows the basic process for creating and verifying a trusted off-chain transaction between two parties using the uPort PKI.

![Create and Verify Data](jwtflow.png)

## Identity Document

We currently support 2 kinds of Identity Documents:

- [DID Documents](./diddocument.md)
- [Legacy Identity Documents](./identitydocument.md) (DEPRECATED)

## Verifying a signature

Any [Signed Message](../messages/index.md) has an `iss` attribute. This contains an [Decentralized ID (DID)](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids).

A [did-resolver](https://github.com/uport-project/did-resolver) is used to resolve the public key of the message.

uPort currently supports the following DID methods:

- [`ethr`](https://github.com/uport-project/ethr-did-resolver) based on [ERC-1056](https://github.com/ethereum/EIPs/issues/1056)
- [`uport`](https://github.com/uport-project/uport-did-resolver) for [legacy uPort identities](./identitydocument.md)
- [`muport`](https://github.com/uport-project/muport-did-resolver) for an experimental did resolver using IPFS and Ethereum

Anyone implementing a new DID method can follow the instructions in the [did-resolver](https://github.com/uport-project/did-resolver) library and it should work with uPort libraries.
