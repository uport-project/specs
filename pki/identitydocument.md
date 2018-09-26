---
title: "Identity Document"
category: "pki"
type: "reference"
source: "https://github.com/uport-project/specs/blob/develop/pki/identitydocument.md"
---

# Identity Document (DEPRECATED)

Note this format will be deprecated soon and replaced by a standard [DID Document](./diddocument.md).

The Identity document is stored on IPFS and tied to the address using the uport registry as specified in the [PKI document](../index).

The Identity document is a JSON document (strictly speaking a [JSON-LD](https://json-ld.org/)).

## Contents

The Identity document must contain the public key for the identity, everything else is optional. Anything in this document is public, so please be wary of publishing any Private information to it.

This is an example of a minimal identity document:

```js
{
  "@context":"http://schema.org",
  "@type":"Person",
  "publicKey":"0x04613bb3a4874d27032618f020614c21cbe4c4e4781687525f6674089f9bd3d6c7f6eb13569053d31715a3ba32e0b791b97922af6387f087d6b5548c06944ab062",
  "publicEncKey":"QCFPBLm5pwmuTOu+haxv0+Vpmr6Rrz/DEEvbcjktQnQ="
}
```

This is a example of a identity document for an app with extra public profile information:

```js
{
  "@context":"http://schema.org",
  "@type":"Organization",
  "name":"uPort @ Devcon 3",
  "description":"Uport Attestations","publicKey":"0x04613bb3a4874d27032618f020614c21cbe4c4e4781687525f6674089f9bd3d6c7f6eb13569053d31715a3ba32e0b791b97922af6387f087d6b5548c06944ab062",
  "image":{"@type":"ImageObject","name":"avatar","contentUrl":"/ipfs/QmSCnmXC91Arz2gj934Ce4DeR7d9fULWRepjzGMX6SSazB"}
}
```

### Parameters

Name | Description | Required
---- | ----------- | --------
`@context` | `http://schema.org`| yes
`@type` | `Person`, `App`, `Organization`| yes
`publicKey` | `0x` prefixed hex encoded [secp256k1 ECDSA curve](https://en.bitcoin.it/wiki/Secp256k1) public key | yes
`publicEncKey` | Base64 encoded [`curve25519xsalsa20poly1305`](http://nacl.cr.yp.to/box.html) public key | no
`name` | Name of identity | no
`description` | Description of identity | no
`image` | Avatar or logo of identity (Uses [ImageObject](http://schema.org/ImageObject) with `contentUrl`) | no

### Resolving the Public Key for `iss`

![Resolve Public Key](resolve.png)

1. Decode the MNID of the `iss` and extract the `network` and the `address`
2. In the [uport-registry](https://github.com/uport-project/uport-registry) for the `network` call the function `get("uPortProfileIPFS1220", address, address)` which returns a hash value encoded as 32 bytes
3. Encode the IPFS hash by prepending hex `1220` to the 32 byte hash and encoding it as base58
4. Fetch [JSON Identity Document](./identitydocument.md) from IPFS using IPFS hash
5. Public Key is stored in the `publicKey` key of the Identity Document

### Resolving the Public Encryption Key for `iss`

Done in the same way as above except for the last step:

5. Public Key is stored in the `publicEncKey` key of the [Identity Document](./identitydocument.md)

## Registering an Identity Document

Any address on any supported Ethereum blockchain can register its identity document on the [uport-registry](https://github.com/uport-project/uport-registry).

This shows the basic process:

![Identity Registration](registration.png)

### External Accounts (Key Pairs)

1. Generate a Key Pair
1. Create a [Identity Document](./identitydocument.md) containing the Public Key
1. Publish Identity Document to IPFS
1. Decode IPFS hash returned to get the raw 32 byte hash value
1. Pick an Ethereum network to register your identity on
1. Generate the Ethereum address for your Key Pair
1. Create a transaction in the [uport-registry](https://github.com/uport-project/uport-registry) for the `network` for the function `set("uPortProfileIPFS1220", address, hash)` signed by your Key Pair

### Smart Contract Accounts

Smart contracts can't sign on their own, so a signing Key Pair will need to be created first.

1. Generate a Key Pair
1. Create an Identity Document containing the Public Key
1. Publish Identity Document to IPFS
1. Decode IPFS hash returned to get the raw 32 byte hash value
1. With your smart contract code create an internal transaction to the [uport-registry](https://github.com/uport-project/uport-registry) on the `network` that your smart contract is deployed to for the function `set("uPortProfileIPFS1220", address, hash)`

Here is an example of how to register an Identity for your smart contract in Solidity:

```js
contract Registry { function set(bytes32 key, address subject, bytes32 value); }

contract MyContract {
    address public owner;
    Registry registry;

    function MyContract(address _registry) {
        owner = msg.sender;
        registry = Registry(_registry);
    }

    function setIdentityDoc(bytes32 hash) {
        // Only allow owner of contract to set the identity document.
        // There could of course be more advanced governance mechanisms here.
        require(msg.sender == owner);

        registry.set("uPortProfileIPFS1220", this, hash);
    }
}
```

### uPort Mobile App Created Identities

Identities created by the uPort Mobile App consist of a simple [Proxy](https://github.com/uport-project/uport-identity/blob/develop/contracts/Proxy.sol) smart contract controlled by a flexible access control smart contract that we call the [IdentityManager](https://github.com/uport-project/uport-identity/blob/develop/contracts/IdentityManager.sol).

This structure allows us to create recoverable identities controlled by multiple devices and even allows us to safely upgrade the complex access control logic.

The way an identity is created in the Mobile App is as follows:

![Mobile Identity Registration](mobileregistration.png)

1. Generate a Key Pair on your uPort app
1. Pick an Ethereum network to register your identity on
1. Create an Ethereum transaction registering a [Proxy](https://github.com/uport-project/uport-identity/blob/develop/contracts/Proxy.sol) using the [IdentityManager](https://github.com/uport-project/uport-identity/blob/develop/contracts/IdentityManager.sol)
1. Create an Identity Document containing the Public Key
1. Publish Identity Document to IPFS
1. Decode IPFS hash returned to get the raw 32 byte hash value
1. Create a transaction on the IdentityManager that forwards a transaction to the [uport-registry](https://github.com/uport-project/uport-registry) calling the function `set("uPortProfileIPFS1220", address, hash)` signed by your Key Pair
