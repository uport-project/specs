---
title: "Private Chain Provisioning Flows"
category: "flows"
type: "reference"
source: "https://github.com/uport-project/specs/blob/develop/flows/privatechain.md"
---

# Private Chain Provisioning Flow

Experimental support for supporting Ethereum Accounts on private chains.

The following shows the basic flow:

![Private Chain Provisioning Flow](privatechain.png)

## Requirements

- Ethereum compatible blockchain
- Public facing JSON RPC endpoint (RPC Gateway)
 
## Provisioning Methodology
The provisioning of a new network happens at the selective disclosure request. In the request the JSON RPC endpoint is passed to the uPort Mobile app thru the `rpc` parameter. The uPort Mobile App stores the endpoint and then every tx request to that `networkId` is handled thru the specific endpoint.
