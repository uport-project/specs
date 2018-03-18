---
title: "Private Chain Provisioning"
category: "reference"
index: 0
prefix: "/messages"
type: "content"
tags:
    - programming
    - stuff
    - other
---

# Private Chain Provisioning Message

A Private Chain Provisioning Message can be used for adding an account created on a private Ethereum chain to a users Uport Mobile App.

Private Chain Provisioning Messages are always signed and are created as part of the [Private Chain Provisioning Flow](../flows/privatechain.md).

## Attributes

The following attributes of the JWT are supported:

Name | Description | Required
---- | ----------- | --------
[`iss`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The [MNID](https://github.com/uport-project/mnid) of the signing identity| yes
[`aud`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The [MNID](https://github.com/uport-project/mnid) of the parent identity (the receiver of this account)| yes
[`sub`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The [MNID](https://github.com/uport-project/mnid) encoding of the [private chain account](https://github.com/uport-project/uport-identity/blob/develop/contracts/Proxy.sol)| yes
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of Verification | no
`dad`|Ethereum address of devicekey as passed to provisioning service as `nad` in the [Selective Disclosure Response](./shareresp.md) | yes
`ctl`|Ethereum address of the [Meta Identity Manager](https://github.com/uport-project/uport-identity/blob/develop/contracts/MetaIdentityManager.sol) used to control the account | yes
`reg`|Ethereum address of the [Uport Registry](https://github.com/uport-project/uport-registry/blob/master/contracts/UportRegistry.sol) used on private chain | no
`rel`|Url of [relay service](../rest-apis/relay-server.md) for providing gas on private network | no (recommended)
`fct`|Url of [fueling service](../rest-apis/fuel-server.md) for providing gas on private network | no
`acc`|Fuel token used to authenticate on above `fct` url | yes
