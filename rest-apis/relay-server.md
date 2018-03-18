---
title: "Meta Transaction Relaying Server"
category: "reference"
index: 0
prefix: "/rest-apis"
type: "content"
tags:
    - programming
    - stuff
    - other
---

# Meta Transaction Relaying Server

All transactions on Ethereum like networks are paid using transaction fees known as `gas`. To avoid the requirement for all end users to fund themselves with ETH on their respective networks we support [meta transactions](https://medium.com/uport/making-uport-smart-contracts-smarter-part-3-fixing-user-experience-with-meta-transactions-105209ed43e0) which allows a 3rd party transaction fueling service to fund and relay transactions without requiring pre-funding the users account.

## API Description

### Fuel Token

A JWT or similar Bearer token (see [RFC 6750](https://tools.ietf.org/html/rfc6750)) SHOULD be issued as part of the [Private Chain Provisioning Flow](../flows/privatechain.md).

Funding service SHOULD verify based on their own business rules that the signer of the transaction is allowed to use the Fuel Token.

### MetaSignedTx

To create a meta transaction, you need the following parameters:

- `txRelayAddress` address of the [txRelay](https://github.com/uport-project/uport-identity/blob/develop/contracts/TxRelay.sol#L28) contract
- `whitelistOwner` (use `0x0000000000000000000000000000000000000000`)
- `metaNonce` the [nonce stored in the txRelay contract](https://github.com/uport-project/uport-identity/blob/develop/contracts/TxRelay.sol#L11). This is NOT the same as the Ethereum account nonce
- `to` ethereum address of recipient of transaction
- `data` the data field of the ethereum transaction

```js
metaTxInput = '1900' + stripHexPrefix(txRelayAddress)
                    + stripHexPrefix(whitelistOwner) + padTo64(metaNonce) + to + data
signature = secp256k1(keccak256(metaTxInput))
```

Create an unsigned wrapper transaction to the [`relayMetaTx`](https://github.com/uport-project/uport-identity/blob/develop/contracts/TxRelay.sol#L28) function.

```js
let wrapperTx = {
      'gasPrice': raw_gasPrice, // ignored
      'gasLimit': raw_gasLimit, // ignored
      'value': 0,
      'to': this.txRelayAddress
    }
let rawMetaSignedTx = txutils.functionTx(txRelayAbi, 'relayMetaTx', [
        signature.v,
        addHexPrefix(Buffer.from(signature.r, 'base64').toString('hex')),
        addHexPrefix(Buffer.from(signature.s, 'base64').toString('hex')),
        raw_to,
        raw_data,
        addHexPrefix(this.whitelistOwner)
      ], wrapperTx)
```

#### Endpoint

`POST /api/v2/relay/`

#### Header

```
Authorization: Bearer <jwt token>
```

#### Body

```
{
  metaSignedTx: <raw signed meta Tx>,
  blockchain: <blockchain id or name>,
  metaNonce: <meta nonce>
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

The transaction hash of the real transaction on the blockchain:

```
{
  txHash: <tx hash>
}
```
