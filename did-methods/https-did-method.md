# HTTPS DID Method Specification

## Author

- uPort Team <https://www.uport.me/contact>
- Mike Xu <mike.xu@consensy.net>
- Oliver Terbu <oliver.terbu@consensys.net>

## Preface

The HTTPS DID method specification conforms to the requirements specified in the
[DID specification](https://w3c-ccg.github.io/did-spec/), currently published by the W3C Credentials Community Group.
For more information about DIDs and DID method specifications, please see the
[DID Primer](https://github.com/WebOfTrustInfo/rebooting-the-web-of-trust-fall2017/blob/master/topics-and-advance-readings/did-primer.md)

## Abstract

DIDs that target a distributed ledger face significant practical challenges in bootstrapping enough meaningful
trusted data around identities to incentivize mass adoption. We propose using a new DID method in conjunction
with blockchain-based DIDs that allows them to bootstrap trust using a web domain's existing reputation.

## Example

```json
{
  "@context": "https://w3id.org/did/v1",
  "id": "did:https:example.com",
  "publicKey": [{
       "id": "did:https:example.com#owner",
       "type": "Secp256k1VerificationKey2018",
       "owner": "did:https:example.com",
       "ethereumAddress": "0xb9c5714089478a327f09197987f16f9e5d936e8a"
  }],
  "authentication": [{
       "type": "Secp256k1SignatureAuthentication2018",
       "publicKey": "did:https:example.com#owner"
  }]
}
```

## Target System

The target system of the HTTPS DID method is the web host that the domain name described by the DID resolves
to when queried through the Domain Name System (DNS).

## DID Method Name

The namestring that shall identify this DID method is: `https`

A DID that uses this method MUST begin with the following prefix: `did:https`. Per the DID specification, this string 
MUST be in lowercase. The remainder of the DID, after the prefix, is specified below.

## Method Specific Identifier

The method specific identifier is a fully qualified domain name that is secured by a TLS/SSL certificate. The formal
rules describing valid domain name syntax are described in 
[RFC 1035](https://tools.ietf.org/html/rfc1035), [RFC 1123](https://tools.ietf.org/html/rfc1123),
and [RFC 2181](https://tools.ietf.org/html/rfc2181).

The method specific identifier must match the common name used in the SSL/TLS certificate, and it must not
include IP addresses, port numbers, or directories behind the top-level domain extension. 

	https-did = "did:https:" domain-name

### Example

```
did:https:w3c-ccg.github.io
```

## JSON-LD Context Definition

Note this DID method specification uses the `Secp256k1VerificationKey2018`, `Secp256k1SignatureAuthentication2018`
types and an `ethereumAddress` instead of a `publicKeyHex`.

The definition of the https DID JSON-LD context is:

    {
        "@context":
        {
            "ethereumAddress": "https://github.com/uport-project/ethr-did-resolver#ethereumAddress",
            "Secp256k1VerificationKey2018": "https://github.com/uport-project/ethr-did-resolver#Secp256k1VerificationKey2018",
            "Secp256k1SignatureAuthentication2018": "https://github.com/uport-project/ethr-did-resolver#Secp256k1VerificationKey2018",
        }
    }
    
## CRUD Operation Definitions

### Create (Register)

Creating a DID is done by 
1. applying at a domain name registrar for use of a domain name and 
1. storing the location of a hosting service, the IP address at a DNS lookup service 
1. creating the DID document JSON-LD file including a suitable keypair, e.g., using the 
Koblitz Curve, and storing the `did.json` file under the well-known URL.  

For the domain name `w3c-ccg.github.io`, the `did.json` will be available under the following URL: 
```
did:https:w3c-ccg.github.io/.well-known/did.json
```

### Read (Resolve)

The following steps must be executed to resolve the DID document from an https DID:

1. Parse the fully qualified domain name from the identifier.
2. Generate an HTTPS URL to the expected location of the DID document by prepending `https://` and appending 
`/.well-known/did.json` to the domain name.
3. Perform an HTTP `GET` request to the URL using an agent that can successfully negotiate a secure HTTPS connection,
which enforces the security requirements as described in [Security Considerations](Security-Considerations).

### Update

To update the DID document, the `did.json`has to be updated. Please note that the DID will remain the same, but 
the contents of the DID document could change, e.g., by including a new verification key or adding service endpoints.  

### Delete (Revoke)

To delete the DID document, the `did.json`has to be removed or has to be no longer publicly available due to
any other means.

## Security Considerations

At least TLS 1.2 should be configured to use only strong ciphers suites and to use sufficiently large key sizes.
As recommendations may be volatile these days, only the very latest recommendations should be used. However,
as a rule of thumb, the following must be used:

- Ephemeral keys are to be used.
- ECDHE with one of the strong curves {X25519, brainpoolP384r1, NIST P-384, brainpoolP256r1, NIST P-256} shall be
used as key exchange.
- AESGCM or ChaCha20 with 256 bit large keys shall be used for bulk encryption
- ECDSA with one of the strong curves {brainpoolP384r1, NIST P-384, brainpoolP256r1, NIST P-256} or RSA 
(at least 3072) shall be used.
- Authenticated Encryption with Associated Data (AEAD) shall be used as Mac.
- At least SHA256 shall be used, but SHA384 or POLY1305 are recommended.

Examples of strong SSL/TLS configurations for now are:
- `ECDHE-ECDSA-AES256-GCM-SHA384, TLSv1.2, Kx=ECDH, Au=ECDSA, Enc=AESGCM(256), Mac=AEAD`
- `ECDHE-RSA-AES256-GCM-SHA384, TLSv1.2, Kx=ECDH, Au=RSA Enc=AESGCM(256), Mac=AEAD`
- `ECDHE-ECDSA-CHACHA20-POLY1305, TLSv1.2, Kx=ECDH, Au=ECDSA, Enc=ChaCha20-Poly1305, Mac=AEAD`
- `ECDHE-RSA-CHACHA20-POLY1305, TLSv1.2, Kx=ECDH, Au=RSA, Enc=ChaCha20-Poly1305, Mac=AEAD`
- `ECDHE-RSA-AES256-GCM-SHA384, TLSv1.2, Kx=ECDH, Au=RSA, Enc=AESGCM(256), Mac=AEAD`
- `ECDHE-ECDSA-AES256-GCM-SHA384, TLSv1.2, Kx=ECDH, Au=ECDSA, Enc=AESGCM(256), Mac=AEAD`

It is recommended to adhere to [OWASP's](https://www.owasp.org/index.php/Transport_Layer_Protection_Cheat_Sheet)
latest recommendations for hardening TLS configurations.

Delete action can be performed by domain name registars or DNS lookup services.
## Reference Implementations

The code at [https://github.com/uport-project/https-did-resolver](https://github.com/uport-project/https-did-resolver)
is intended to present a reference implementation of this DID method. Any other implementations should ensure that
they pass the test suite described in `/src/__tests__` before claiming compatibility.
