---
title: "Message Style Document"
category: "reference"
type: "content"
source: "https://github.com/uport-project/specs/blob/develop/messages/styles.md"
---

# Styling Requests

As a developer you can provide simple styling in a Style Document hosted on IPFS.

The Style document is a JSON document stored as an [IPLD Document](https://github.com/ipld/specs/blob/master/IPLD.md).

## Contents

The Style document itself is optional and all fields are optional.

This is a example of a Style document for an app with extra public profile information:

```js
{
  "profileImage":{"/":"/ipfs/QmSCnmXC91Arz2gj934Ce4DeR7d9fULWRepjzGMX6SSazB"},
  "bannerImage":{"/":"/ipfs/QmSCnmXC91Arz2gj934Ce4DeR7d9fULWRepjzGMX6SSazB"},
  "accentColor":"#f0c0a3"
}
```

### Parameters

Name | Description | Required
---- | ----------- | --------
`profileImage` | Avatar or logo as JPEG or PNG of requester on IPFS as a [merkle link](https://github.com/ipld/specs/blob/master/IPLD.md#what-is-a-merkle-link)| no
`bannerImage` | Banner to e used on certain request cards as JPEG or PNG of requester on IPFS as a [merkle link](https://github.com/ipld/specs/blob/master/IPLD.md#what-is-a-merkle-link)| no
`accentColor` | Hex color to be used in the request card | no

