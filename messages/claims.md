---
title: "Issuer Claims"
category: "messages"
type: "reference"
source: "https://github.com/uport-project/specs/blob/develop/messages/claims.md"
---

# Issuer Claims

The issuer of a message is the signer of the request. The issuer can present claims about themselves. 

This can be used over time to build trust between the issuer of the message and the consuming party.

## Verified Claims about Issuer

A selection of [verified claims](/messages/verification.md) about the issuer can be included in the `vc` field of a message. 

The verified claims can either be included in their entirety as [JWT's](https://tools.ietf.org/html/rfc7519)'s in an array:

```js
{
  "iss":"did:ethr:0x012abcd...",
  "vc": ["Verified Claim JWT 1", "Verified Claim JWT 2"]
}
```

Or as an array of IPFS hashes containing individual JWTs.

```js
{
  "iss":"did:ethr:0x012abcd...",
  "vc": ["/ipfs/QmbpLchVBiF5Deg8Dp31y4AUSNLiBbF92mHAp3xDcAfg4k"]
}
```


**About image links:** Images must be stored in IPFS. This is to avoid malicious tracking of users through images.

Upload the image like this:

```bash
> curl  "https://ipfs.infura.io:5001/api/v0/add?pin=true" -F file=@logo.png
{"Name":"logo.png","Hash":"QmV3pEPwSzkQVMPmkvpWRvWRxexdMrCNayMnZeao8dibm4","Size":"5779"}
```

Remember to prefix the hash with `/ipfs/`.

### IPLD Format

To reduce the size of messages we remember storing the claims as an [IPLD Document](https://github.com/ipld/specs/blob/master/IPLD.md).
QmbpLchVBiF5Deg8Dp31y4AUSNLiBbF92mHAp3xDcAfg4k

Upload your claims document to IPFS.

Example document:

```js
{
  "name":"My dApp",
  "description":"A really cool place to do stuff decentralized",
  "url":"https://mydapp.example",
  "profileImage":{"/":"/ipfs/QmSCnmXC91Arz2gj934Ce4DeR7d9fULWRepjzGMX6SSazB"},
  "bannerImage":{"/":"/ipfs/QmSCnmXC91Arz2gj934Ce4DeR7d9fULWRepjzGMX6SSazB"},
}
```

Save the above file to `claims.json`

```bash
> curl  "https://ipfs.infura.io:5001/api/v0/add?pin=true" -F file=@claims.json
{"Name":"claims.json","Hash":"QmbpLchVBiF5Deg8Dp31y4AUSNLiBbF92mHAp3xDcAfg4k","Size":"291"}
```

Now use the returned hash in your requests:

```js
{
  "iss":"did:ethr:0x012abcd...",
  "vc": ["/ipfs/QmbpLchVBiF5Deg8Dp31y4AUSNLiBbF92mHAp3xDcAfg4k"]
}
```

**Note:** For links to other IPFS files such as images, you must add them as an [IPLD merkle link](https://github.com/ipld/specs/blob/master/IPLD.md#what-is-a-merkle-link). This just means that instead of using the string `ipfs/QmV3pEPwSzkQVMPmkvpWRvWRxexdMrCNayMnZeao8dibm4` as in an embedded document. You use the object `{"/":"/ipfs/QmV3pEPwSzkQVMPmkvpWRvWRxexdMrCNayMnZeao8dibm4"}` instead.

### Parameters

Name | Description | Required
---- | ----------- | --------
`name`| Name of Issuer | no
`description`| Single sentence describing the Issuer | no
`url` | URL of dApp/Requester | no
`profileImage` | Avatar or logo as JPEG or PNG of requester on IPFS as a `/ipfs/[HASH]` in embedded claims or a [merkle link](https://github.com/ipld/specs/blob/master/IPLD.md#what-is-a-merkle-link) for IPLD documents| no
`bannerImage` | Banner to e used on certain request cards as JPEG or PNG of requester on IPFS as a `/ipfs/[HASH]` in embedded claims or a [merkle link](https://github.com/ipld/specs/blob/master/IPLD.md#what-is-a-merkle-link) for IPLD documents| no

