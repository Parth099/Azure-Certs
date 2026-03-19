# ACM (AWS Certificate Manager)

## Web Certs Background

Website servers must present a valid certificate matching their serving domain name during TLS handshake. This is to ensure that the client (browser) can verify the server's identity and establish a secure connection. Further checks are committed by the client to check if the certificate is valid, not expired, and issued by a trusted Certificate Authority (CA).

If you wanted a raw server (ex; `ec2`) to serve a website over HTTPS, you would need to:

- obtain a domain name via a registrar
- obtain a certificate from a CA (Certificate Authority) for that domain name
- software installs certs on the server
- webserver software (like Apache or Nginx) is configured to use the certificate and private key for HTTPS connections

## ACM

ACM handles the certificate lifecycle for you, including provisioning, deployment, and renewal. It can issue public and private SSL/TLS certificates for use with AWS services and your internal connected resources.

Certificates issued by ACM are trusted by most browsers and devices (chain of trust), making it easier to secure your applications and websites. ACM also integrates with other AWS services like CloudFront, Elastic Load Balancing, and API Gateway, allowing you to easily deploy certificates to these services without manual configuration. If you are using ACM as a private CA then the cert chain of trust is limited to the devices that have the private CA root certificate installed.

ACM has integrations with DNS where it is able to renew the certs automatically. ACM can deploy certificates to certain supported services like

- ALBs
- CloudFront

ACM is a regional service, meaning that certificates are issued and managed within a specific AWS region. For CloudFront, ACM certificates must be requested in the US East (N. Virginia) region, as CloudFront is a global service and requires certificates to be available in that region for distribution.
