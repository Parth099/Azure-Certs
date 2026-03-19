# DNSSEC

## DNSSEC Background

The aim is to verify that the DNS records are authentic and have not been tampered with. DNSSEC provides a way to digitally sign DNS records.

**Key Types and Reasons**

1. Zone Signing Key (ZSK)
    What it does: Signs individual DNS records (A, AAAA, MX, etc.) within a zone
    Who creates it: The DNS zone administrator/operator
    Why it's needed: Provides authenticity for DNS responses. When a resolver queries a record, it can verify the signature using the public ZSK to ensure the data hasn't been tampered with

2. Key Signing Key (KSK)
    What it does: Signs the ZSK's public key (specifically, signs the DNSKEY record set)
    Who creates it: The DNS zone administrator/operator
    Why it's needed: Creates a chain of trust. The KSK is more stable and changes less frequently than the ZSK, making key management easier

All this security business adds in a few new record types:
- RRSIG: Contains the digital signature for a DNS record set
- DNSKEY: Contains the public keys (ZSK and KSK) used to verify signatures
- DS: Delegation Signer record, used to establish a chain of trust between parent and child zones. This is signed by the parent zone and points to the child zone's KSK.
- NSEC/NSEC3: Used to prove the non-existence of a DNS record. NSEC3 adds additional security by hashing the names, making it harder for attackers to enumerate all the names in a zone.

## AWS DNSSEC

- Involves AWS KMS
    - Route 53 DNSSEC uses a KMS asymmetric key for the KSK signing flow. Verification is done using published public key material in DNS.
- Route 53 publishes DNSSEC-related public key material into the DNSKEY record set for the hosted zone.
- To complete the chain of trust, create a DS record in the parent zone (for example, if your domain is `example.com`, the DS record is created in the `.com` zone). This DS points to your child zone KSK information.
