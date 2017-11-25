# Selective Disclosure Request

The Selective Disclosure Request is created by a client app and sent to a users mobile app during the [Selective Disclosure Flow](../flows/selectivedisclosure.md).

The request can be either signed or unsigned.

#### Attributes

The following attributes of the JWT are supported:

Name | Description | Required
---- | ----------- | --------
`type` | MUST have the value `shareReq` | yes
[`iss`](https://tools.ietf.org/html/rfc7519#section-4.1.1) | The [MNID](https://github.com/uport-project/mnid) of the signing identity| yes
[`iat`](https://tools.ietf.org/html/rfc7519#section-4.1.6) | The time of issuance | yes
[`exp`](https://tools.ietf.org/html/rfc7519#section-4.1.4) | Expiration time of JWT | no
`callback` | Callback URL for returning the response to a request | no
`net` | network id of ethereum chain of identity eg. `0x4` for `rinkeby` | no
`requested` | The self signed claims requested from a user. Array of claim types for self signed claims eg: `["name", "email"]` | no
`verified` | The verified claims requested from a user. Array of claim types for self signed claims eg: `["name", "email"]` | no
`permissions` | An array of permissions asked for. Currently only supported is `notifications` | no

## Unsigned Requests

To perform an unsigned selective disclosure request append the request parameters as URL encoded query parameters to one of the above endpoints and open it. Eg.:

`me.uport:me?callback_url=https://mysite.com/callback&label=My%20Site`

The following

Name | Description | Required
---- | ----------- | --------
`callback_url` | The URL that receives the response | yes
`callback_type` | Valid values `post` or `redirect`. Determines if callback should be sent as a HTTP POST or open the link (`redirect`). If unspecified the mobile app will attempt to pick the correct one| no
`client_id` | The [MNID](https://github.com/uport-project/mnid) of the requesting identity | no
`label` | Plain text name of client to be displayed to user | no
`network_id` | network id of ethereum chain of identity eg. `0x4` for `rinkeby` | no

