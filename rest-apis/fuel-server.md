---
title: "Transaction Fueling Server"
category: "reference"
type: "content"
tags:
    - programming
    - stuff
    - other
---

# Transaction Fueling Server

All transactions on Ethereum like networks are paid using transaction fees known as `gas`. To avoid the requirement for all end users to fund themselves with ETH on their respective networks we support a transaction fueling service, which will be called if the users account does not have enough funds available to fuel the transaction

## API Description

### Fuel Token

A JWT or similar Bearer token (see [RFC 6750](https://tools.ietf.org/html/rfc6750)) SHOULD be issued as part of the [Private Chain Provisioning Flow](/flows/privatechain.md).

Funding service SHOULD verify based on their own business rules that the signer of the transaction is allowed to use the Fuel Token.

### Fund address

This endpoints sends funds to the signing address of the included transaction. Note the funding server does not send the `tx` onto the network. This is the responsibility of the Uport Mobile App.

#### Endpoint

`POST /api/v1/fund/`

#### Header

```
Authorization: Bearer <jwt token>
```

#### Body

```
{
  tx: <signedTx>,
  blockchain: <blockchain id or name>
}
```

#### Response

| Status |     Message    |                               |
|:------:|----------------|-------------------------------|
| 200    | Ok.            | address funded                |
| 403    | Forbidden      | JWT token missing or invalid  |
| 404    | Not found      | Blockchain not found          |
| 429    | Too many conns | Too many connections          |
| 500    | Internal Error | Internal error                |

#### Response data

The transaction hash of the funding transaction:

```
{
  txHash: <tx hash>
}
```
