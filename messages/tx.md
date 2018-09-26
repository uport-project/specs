---
title: "Ethereum Transaction Request"
category: "messages"
type: "reference"
source: "https://github.com/uport-project/specs/blob/develop/messages/tx.md"
---

# Ethereum Transaction Request

This message allows an application to request that a client signs an ethereum transaction.

The Ethereum Transaction Request is created by a client app and sent to a user's mobile app as part of the [Ethereeum Transaction Request Flow](../flows/tx.md).

Requests can be either signed or unsigned.

Unsigned Ethereum Transaction Requests are a superset of [ERC 67](https://github.com/ethereum/EIPs/issues/67) and are deprecated.

## Signed Transaction Request

The Signed Transaction Request is a JWT (JSON Web Token) following the general conventions used throughout this spec for [signed messages](./index.md#json-web-token).

It generally follows the parameters used in the standard [JSON-RPC `eth_sendTransaction()` call](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sendtransaction), making it simple for developers to integrate in their apis.

### Attributes

The following attributes of the JWT are supported:

Name | Description | Required
---- | ----------- | --------
`type` | MUST have the value `ethtx` | yes
[`iss`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The [DID](https://w3c-ccg.github.io/did-spec) or [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids) of the application identity requesting the signature| yes
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of JWT | no
`from` | [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids) or hex encoded address requested to sign the transaction. If not specified the user will select an account. | no
`to` | [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids) or hex encoded address of the recipient of the transaction. If not specified the transaction will create a contract and a bytecode field must exist. | no
`net` | network id of Ethereum chain of identity eg. `0x4` for `rinkeby`. It defaults to the network encoded in the `to` if specified as an [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids). If not it defaults to `0x1` for `mainnet`. | no
`value` | [hex encoded value](https://github.com/ethereum/wiki/wiki/JSON-RPC#hex-value-encoding) in wei | no
`fn` | Solidity function call eg. `transfer(address 0xdeadbeef, uint 5)` | no
`gasPrice` | [hex encoded value](https://github.com/ethereum/wiki/wiki/JSON-RPC#hex-value-encoding) of integer of the gasPrice used for each paid gas. This is only treated as a recommendation. The client may override this. | no
`gas` | [hex encoded value](https://github.com/ethereum/wiki/wiki/JSON-RPC#hex-value-encoding) of integer of the gas provided for the transaction execution. It will return unused gas. This is only treated as a recommendation. The client may change this. | no
`data` | Hex encoded data field of transaction | no
`callback` | The URL that receives the response | no
`callback_type` | Valid values `post` or `redirect`. Determines if callback should be sent as a HTTP POST or open the link (`redirect`). If unspecified the mobile app will attempt to pick the correct one| no
`client_id` | The [DID](https://w3c-ccg.github.io/did-spec) or [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids) of the requesting identity | no
`label` | Plain text name of client to be displayed to user | no
`boxPub` | 32 byte base64 encoded [`Curve25519`](http://nacl.cr.yp.to/box.html) public key of requesting identity. Use to encrypt messages sent to callback URL| no
`issc` | The self signed claims for the `iss` of this message. Either as an Object of claim types for self signed claims eg: `{"name":"Some Corp Inc", "url":"https://somecorp.example","image":{"/":"/ipfs/QmSCnmXC91Arz2gj934Ce4DeR7d9fULWRepjzGMX6SSazB"}}` or the IPFS Hash of a JSON encoded equivalent. See [Issuer Claims](/messages/claims.md) | no
`vc` | Array of Verified Claims JWTs or IPFS hash of JSON encoded equivalent about the `iss` of this message. See [Issuer Claims](/messages/claims.md) and [Verified Claims](/messages/verification.md) | no

The attributes `redirect_url` can also be appended to the signed request as URL encoded query parameters outside of the signed payload. They are used to specify how you want the response and control returned. For more details see [Messages](./index.md#json-web-token).


## ERC 67 Unsigned Transaction Request

To perform an unsigned selective disclosure request append the request parameters as URL encoded query parameters to one of the above endpoints and open it. Eg.:

`me.uport:2oDZvNUgn77w2BKTkd9qKpMeUo8EL94QL5V?transfer(address%200xdeadbeef%2C%20uint%205)&callback_url=https://mysite.com/callback&label=My%20Site`

### Attributes

The following

Name | Description | Required
---- | ----------- | --------
`from` | [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids) or hex encoded address requested to sign the transaction. If not specified the user will select an account. | no
`to` | This is the  [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids) or hex encoded address of the recipient of the transaction. If not specified the transaction will create a contract and a bytecode field must exist. | yes
`net` | network id of Ethereum chain of identity eg. `0x4` for `rinkeby`. It defaults to the network encoded in the `to` if specified as an [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids). If not it defaults to `0x1` for `mainnet`. | no
`value` | [hex encoded value](https://github.com/ethereum/wiki/wiki/JSON-RPC#hex-value-encoding) in wei | no
`function` | Solidity function call eg. `transfer(address 0xdeadbeef, uint 5)` | no
`bytecode` | Hex encoded data field of transaction | no
`gasPrice` | [hex encoded value](https://github.com/ethereum/wiki/wiki/JSON-RPC#hex-value-encoding) of integer of the gasPrice used for each paid gas. This is only treated as a recommendation. The client may override this. | no
`gas` | [hex encoded value](https://github.com/ethereum/wiki/wiki/JSON-RPC#hex-value-encoding) of integer of the gas provided for the transaction execution. It will return unused gas. This is only treated as a recommendation. The client may change this. | no
`callback_url` | The URL that receives the response | no
`callback_type` | Valid values `post` or `redirect`. Determines if callback should be sent as a HTTP POST or open the link (`redirect`). If unspecified the mobile app will attempt to pick the correct one| no
`client_id` | The [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids) of the requesting identity | no
`label` | Plain text name of client to be displayed to user | no

## Addresses and Network selection

Addresses SHOULD be either [DID](https://w3c-ccg.github.io/did-spec/#decentralized-identifiers-dids) encoded so they have the correct network specified with them or be a combination of a normal ethereum hex address and a `net` attribute specifying the network.

If there is any kind of mismatch between `to`, `from` or `net` an error will be returned.

## Transaction Request Validity

There are 3 types of transactions supported by Ethereum. The required fields depend on which kind of transaction you are requesting.

### ETH Value Transfer

The following fields are required:

- `to`
- `value`

### ETH Value Transfer

The following fields are required:

- `to`

Either of these two are required:

- `data` or (`bytecode` for ERC 67)
- `fn` or (`function` for ERC 67)

### Ethereum Smart Contract creation

The following fields are required:

- `data` or (`bytecode` for ERC 67)
- `net`

## Client Callback

The client app SHOULD include a URL where the response is returned from the user. This can be a https url or a custom app url which receives the response.

Responses are param appended to a url fragment. If the callback requires the response as a HTTP POST, it is sent as a JSON POST request to the callback url instead.
