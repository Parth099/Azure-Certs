# ELB Features

## Connection Draining

- When instances are planned to be de-registered from an ELB, all connections are closed, and no new connections are created. With the `connection-draining` feature, it allows in-flight connections to complete or _timeout_.
    - this feature with this name is only on the CLB.

- _timeout_ value is between 1s to 1hr, default is 5m.

A similar feature called deregistration-delay is on the other ELBs and GWLBs and is defined on target groups. The delay is 5m.

## Identifying Connection Protocols

### `X-Forwarded-For` Protocol

- http header contains the originating IP address
    - managed by LBs. Each time it passes over a LB it right appends the current IP.[^1]

    - Note: Backend needs to be aware of this

- Supported by CLB & ALB

### `Proxy` Protocol

- L4 protocol

- adds a L4 (TCP) header for identifying the origination IP

This protocol is able to support many other application protocols because it makes all its changes at L4.z

## LB Security Policies

A Security Policy is a set of ciphers[^2] and protocols which are ok to use on a listener. In otherwords, you choose what is ok to use between client and LB.

[^1]: Implies the left most IP is the client connection IP

[^2]: Encryption Algorithm
