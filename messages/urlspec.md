# Message URLs

These URLs are used for passing request/response JWTs to the mobile app, as well as encoding Ethereum transactions. 

## URL types

The URLs can be either one of these general forms:

### Clickable links

```
https://id.uport.me/command
```

Clicking this link in a document or email or similar opens the uPort client and consumes the message.

### App URL

```
uport://command
```

Launching this App URL opens the uPort app and consumes the message.

### x-callback-url

```
uport://x-callback-url/command
```

`x-callback-url` is a standard for inter-app communication. See <http://x-callback-url.com/examples/> for more information.

## Return value URLs

Return values is returned through specifying a URL using either one of these methods:

### callback_url=<URL>

Specifies the URL where the response will be sent to.

### callback_type=post|redirect

Specifies how the response will be sent to the URL. If post, the result will be POSTed to the URL. If redirect, the result will launch the URL and do a GET request using a built-in browser.

### x-success=<x-callback URL>

This parameter specifies the x-callback-url of the app that is to be opened and given the result. The parameter for the apps x-callback-url is uport_result.

## Examples:

```
uport://command?callback_url=http://example.com&callback_type=post
```

This is an app link which when fired opens the uport app, runs the command, then POSTs the result to http://example.com

```
uport://x-callback-url/command
?x-success=exampleapp://dostuff
&x-source=ExampleApp
```

This link would be fired from ExampleApp. It opens the uport app, runs the command, then in case the command is successful would fire the link

```
exampleapp://dostuff?uport_result=<result>
```

in order to open ExampleApp and process the result.


## Lightweight URLs for Ethereum requests from apps

Request to send your ethereum account address 

```
https://id.uport.me/eth/account
uport://eth/account
uport://x-callback-url/eth/account
```

Request to sign a transaction and send the hash of the transaction to `<endpoint>`:

```
uport://eth/tx/<address>[?value=<value>][?gas=<suggestedGas>][?function=nameOfFunction(param)]&callback_url=<endpoint>
```

Or ETH standard URLs:

```
ethereum:<address>[?value=<value>][?gas=<suggestedGas>][?function=nameOfFunction(param)]&callback_url=<endpoint>
```

See these links for examples of Ethereum URLs:

<https://github.com/ethereum/EIPs/issues/67>

<https://github.com/ethereum/EIPs/pull/681>


## URLs for handling credentials

These URLs are for handling JWT messages like [Share Requests](./sharereq.md) or [Attestation Requests](./attreq.md).

```
uport://credentials?req=<JWT of Request>
```

This will create a response JWT (as outlined above) and send it depending on the method decided in the URL (POSTing, app URL etc)


Provide one or more credentials to user in comma separated list:

```
uport://credentials?to_add=[<JWT of Attestat>,...]
```
