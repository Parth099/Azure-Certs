# Route 53

This is a global service.

## Features

1. Domain Registarar
2. Host Zones (managed DNS nameservers)

### Hosted Zones

- Public or Private
- Hosted on 4 name servers (public)
    - monthly cost for zones

#### Public

These hold records for the public internet for your zone (domain or subdomain) via 4 nameservers by default.

Note: AWS can host a zone for a domain NOT registred in AWS. For this, the domain holder has to point the nameservers to the 4 AWS nameservers.

#### Private

These records can ONLY be resolved by VPCs the zone is asscioated with.

Features

- Split-View: have a website publicly resolve to one thing and have it privately resolve to another.
- VPC only, cannot be asscioated with anything else

### R53 Aliases

> Similar to DNS CNAME

**Problem**: CNAMEs cannot make the naked domain to another URL. For example if your webiste is xyz.com you cannot make a record that maps xyz.com => xyz.load-balancer.com

Alias solves this issue by allowing you to point a name to an AWS resource.

An Alias record can be of two types:

- A record
- CNAME record (_solves problem above_)

Consider this senario:

You have a zone for `xyz.com` and you want to point this domain to a ALB which will direct traffic to your application. Normally this **cannot** be done as you cannot point `xyz.com` to the URL of the LB. But you **can**, create a Alias-A record to point

```text
xyz.com => lb.aws.com (sample LB url)
```

Note you have you use a Alias-A record as the lb.aws.com internally points to a IP. If `lb.aws.com` pointed to a CNAME, then youd have to use a Alias-CNAME record.

# R53 Routing

## Simple Routing

Under simple routing, an `A` record can have many IPs which are returned in a random order upon request. This is an example of a very basic DNS based load balancing.

**Important**: R53 will NOT check if the resources on the backend are healthy.

## Health Checking

**Distinction**: These are not created by/with records. Health checks are seperate but later used by records. Health Checks are their own resource under R53.

Apllication Health checking is done by a global fleet of health checkers (implies NSG needs to allow them). Checks are done every 30s or 10s via HTTP/s or TCP. Only 18% of the health checks need to report _ok_ to be considered healthy.

Health checks are of three types:

1. Endpoints
2. Cloud Watch Alarms
3. Check of checks (health based on other health checks)

## Routing Stratigies

| Strategy             | Description                                                                                                                                                                                                                                                                                                                                  |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Fail-Over Routing    | This is when the DNS setup has a _primary_ and _secondary_ record and the secondary record is served _if_ the primary record is showing to be unhealthy.                                                                                                                                                                                     |
| Multi Value Routing  | Many records are created with the same name, each record is health checked. At max, 8 records are returned                                                                                                                                                                                                                                   |
| Weighted Routing     | Given many same name records, each record gets a weight given to it. AWS tries to use the weight ratios to give a record based on the desired weight distribution                                                                                                                                                                            |
| Latency Routing      | Given many same name records, each record is able to be asscioated with one region. When a DNS request for the record comes in, AWS uses an internal region latency table to give out the correct record. If route shows failure than a new route is selected and this process is repeated until a route without failure is chosen.          |
| Geolocation Routing  | Records are tagged with geolocation like continent, country, ... . R53 will try to match the user with the record fom smallest geography to largest. If no records match, no record is returned. There is a default tag for fail-safe senarios.                                                                                              |
| Gropromixity Routing | Similar to Geolocation but returns the closest record. For each record, AWS either knows the location (because its an AWS resource) or a user is required to specfiy the lat,long of the resource. You may use a positive or negative bias to influence the calulation for routing. A larger bias means a larger service area to the record. |
