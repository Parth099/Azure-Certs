# AWS CloudFront (CDN)

## Background

- `origin` is the source of the content that CloudFront will distribute. It can be an S3 bucket, or anything else like an HTTP server, or even a load balancer.
- `distribution` is the configuration that tells CloudFront how to handle requests for your content. It includes settings like caching behavior, SSL certificates, and more. This is the configuration `unit` of CF.
- `edge locations` are the physical data centers where CloudFront caches copies of your content. When a user requests content, CloudFront serves it from the nearest edge location to reduce latency.
- `regional edge caches` are larger caching locations than `edge location` that sit between the origin and the edge locations. They help reduce the load on the origin by caching content that is less frequently accessed.

## CloudFront

The idea is to create distribution configurations for your content. The distribution configuration includes settings like caching behavior, SSL certificates, and more. CloudFront then serves content through its global edge network based on user location and cache state.

When users access content it is directed to an edge location and if there is a cache miss, the request is forwarded to the regional edge cache, and if there is still a cache miss, the request is forwarded to the origin (`origin-fetch`). This helps reduce the load on the origin by caching content that is less frequently accessed.

Facts

- No Write caching, uploads are always sent to the origin.
- Integration with ACM for SSL certs.

### Cloud Front Distribution & Behaviors

CF Origins and Distributions are configured with a set of behaviors: each behavior defines how CloudFront should handle requests for specific URL patterns. For example, you can have different caching policies, allowed HTTP methods, and viewer protocols for different parts of your website.

A distribution can have multiple behaviors, each associated with a specific path pattern. The default behavior applies to all requests that don't match any other behavior. For example your default behavior `*` could be set to cache static assets like images and CSS files, while a specific behavior for `/api/*` could be set to forward requests to your API server without caching.

#### TTL / Invalidation

- TTL (Time to Live) defines how long CloudFront caches your objects at the edge locations. You can set different TTLs for different behaviors. You may use a longer TTL for static assets that don't change often (like images) and a shorter TTL for dynamic content that changes frequently (like API responses). The default value is 24 hours, but you can customize it in the behavior. Different objects can even set their own TTLs using Cache-Control headers. For example, you can set a Cache-Control header of `max-age=3600` on an object to tell CloudFront to cache it for 1 hour.

- Invalidation allows you to remove objects from the cache before they expire. This is useful when you update content and want the changes to be reflected immediately. This occurs on the distribution level. Evidently, this isn't instant.

### CF Domain and Certificates

By default, you will get a random domain ending in `.cloudfront.net`. You can add alternate names (CNAMEs), but they require a matching certificate in ACM. For CloudFront, that certificate must be in US East (N. Virginia), `us-east-1`.

**Note**: The secondary connection (`cf -> origin`) needs a valid TLS certificate that CloudFront can validate for HTTPS origin fetches.

#### Custom Domains

Custom domains are added as CNAMES in r53. Thus, you need a matching SSL certificate for the cnames you choose. This is where ACM comes in (see ACM Notes).

#### Content Delivery Path

There are 3 Sections to consider

```text
[Origin]                -> [CF-Network]         -> [Public Internet]
- Your Workload            - edge caches           - consumer devices

```

##### Securing the `origin`

###### Secure S3 Origins

One method to protect your origin is to only allow requests from CloudFront.

Historically, this used OAI (Origin Access Identity). Current best practice is OAC (Origin Access Control), which uses signed requests from CloudFront to S3 and tighter policy controls.

###### Secure Custom Origins

If viewer and origin protocols are both HTTPS, CloudFront distributions can add a custom HTTP header when performing an `origin-fetch`. You can configure your origin to require that header.

Alternatively, since AWS publishes CloudFront IP ranges, a firewall can also prevent non-CloudFront traffic.

##### Securing Client to Edge Path

###### Geo-Restriction & Custom Checks

There are two ways to control traffic by geo-location:

- CloudFront Geolocation - Has a blacklist/whitelist architecture. Either you allow all and block one by one or you block all and allow one by one. This only has the option to block/allow countries.

- 3rd Party Geolocation - Very customizable
    - requires some form of compute to run your geo-location service. However, once you have compute you can do anything. For example, check banned usernames or check if user has paid for content.

##### Private CF Behaviors

By default, CF behaviors are public.

Private behaviors generally use signed URLs or signed cookies to control access. The preferred signer model uses trusted key groups.

Signed URL vs Cookie Comparison

| Signed URL                                          | Signed Cookie               |
| --------------------------------------------------- | --------------------------- |
| access to one object                                | access to groups of objects |
| can be used when cookies aren't possible (fallback) |                             |

###### Signers

**URL Case**:

- Public keys are loaded on CF and private keys onto the application
- application generates URL cloudfront content url like shown below
- CloudFront verifies if URL is valid using its public key

```shell
https://cdn.example.com/video.mp4?
  Expires=1234567890&
  Signature=abc123...&
  Key-Pair-Id=APKAXXXXX

```

**Cookie Case**:

An additional backend is required to handle the cookie case. Three cookie attributes are set to help CloudFront authorize data retrieval.

This backend can be something like a `lambda@edge`, auth-service, or origin.

Flow:

- User visits yoursite.com/login
- Your server sets 3 cookies in the response
- Browser stores these cookies
- User clicks on https://cdn.example.com/videos/movie.mp4
- Browser automatically sends the cookies to CloudFront
- CloudFront checks: "Is this signature valid?" → Yes → Serves video
