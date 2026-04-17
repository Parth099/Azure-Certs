# AWS Firewalls

## Web Application Firewall (WAF)

AWS WAF is a L7 firewall.

Summary:

- WAF protects resources like CloudFront distributions, API Gateway APIs, Application Load Balancers, and AppSync GraphQL APIs.
- WAF has units of configuration called WebACLs, which contain rules that inspect incoming requests and take actions based on the conditions you specify.
  - the WEBACLs contain Rule Groups and Rules

### WEBACLs

- **default action**: The default action is the action that AWS WAF takes when a request doesn't match any of the rules in the WebACL. You can set the default action to either `allow` or `block` requests.
- **region**: region is required if the service you are protecting is regional (ex: ALB), but not required if the service is global (ex: CloudFront).
- **Rule groups**: a rule group is a collection of rules which can be reused across multiple WebACLs. Rule groups mentioned in a WEBACL are processed in order.
  - can be custom or managed. Managed rule groups are pre-configured by AWS or AWS Marketplace sellers to provide protection against common threats, such as SQL injection and cross-site scripting attacks. Custom rule groups are created and managed by you, allowing you to define your own rules based on your specific application requirements.
- **Rules**: a rule defines the conditions under which AWS WAF should allow, block, or count web requests. Rules can be based on various criteria, such as IP addresses, HTTP headers, URI strings, SQL injection patterns, and cross-site scripting patterns.

Note: There is a limit to rule compliexity, AWS WAF calculates rule capacity when you create or update a rule. The maximum capacity for a rule group is 5,000 WCUs.[^1]

#### Rules

Rules have three dimensions:

1. **Type**:
   - `regular`: A regular rule contains a single set of conditions that AWS WAF evaluates when processing web requests. If a request matches all the conditions in the rule, AWS WAF takes the specified action (see below).
   - `rate-based`: A rate-based rule counts the number of requests that match the specified conditions and triggers an action if the rate exceeds a predefined threshold.

2. **Statement**: The statement defines the conditions that AWS WAF evaluates when processing web requests.

3. **Action**: The action specifies what AWS WAF should do when a request matches the conditions defined in the rule. The available actions are:

   - `allow`: AWS WAF allows the request to reach the protected resource.
   - `block`: AWS WAF blocks the request from reaching the protected resource and returns a specified response to the client.
   - `count`: AWS WAF counts the request but doesn't take any action, allowing you to monitor and analyze traffic patterns without affecting the flow of requests to your application.
   - `captcha`: AWS WAF challenges the request with a CAPTCHA test. If the client successfully completes the CAPTCHA, AWS WAF allows the request to reach the protected resource. If the client fails the CAPTCHA, AWS WAF blocks the request.
   - `custom-response`: AWS WAF prefixes the request with a custom header and then allows the request to reach the protected resource. You can use this action to trigger custom logic in your application based on the presence of the custom header. The header key looks like `x-amzn-waf-...`.
   - `label`: AWS WAF adds a custom label to the request and allows for processing inside the other WAF rules. If this label is seen again you can take some action.

## AWS Shield

AWS Shield is a managed Distributed Denial of Service (DDoS) protection service that safeguards applications running on AWS. It provides two levels of protection: AWS Shield Standard and AWS Shield Advanced.

- **AWS Shield Standard**: This is the default level of protection that is automatically included with AWS services at no additional cost. It provides protection against common and most frequently observed DDoS attacks, such as SYN/ACK floods, UDP reflection attacks, and DNS query floods. AWS Shield Standard is designed to protect against attacks that can cause downtime or degrade the performance of your applications. Shield Standard is **free** and sits as a perimeter device on the VPC edge.

- **AWS Shield Advanced**: This is a premium service that provides enhanced DDoS protection for applications running on AWS. It offers additional features such as advanced attack detection and mitigation, real-time visibility into attacks, and access to the AWS DDoS Response Team (DRT) for assistance during an attack. AWS Shield Advanced is designed to protect against larger and more sophisticated DDoS attacks that can cause significant downtime or financial loss. Shield Advanced has a cost associated with it, which includes a high monthly fee and additional charges based on the amount of data processed during an attack.

## AWS Network Firewall

**Enablement Steps**

- Create one Firewall Subnet in each Availability Zone (AZ) where you want to use the firewall.
- Create firewall instance and mention subnets created.
- Update all non-firewall subnets to point all routes to firewall as default route.[^2]
- Update IGW Route table to send all incoming traffic to firewall as default route.[^2]
- firewall subnets should have a route to the internet via IGW for updates and other communications.

### Firewall Policy

A firewall policy defines the behavior of the AWS Network Firewall. It contains a set of rules and actions that determine how the firewall should inspect and handle network traffic. A firewall policy can include the following components:

- rule groups: A rule group is a collection of rules that define the conditions under which the firewall should allow, block, or count network traffic. Rule groups can be shared across multiple firewall policies, allowing you to reuse common rules and simplify management. They have a processing order and a default action. A rule group can be either stateless or stateful. Capacity is measured in Firewall Capacity Units (FCUs), which are based on the number of rules and the complexity of those rules. AWS Network Firewall calculates the capacity required for each rule and rule group, and you can use this information to manage your firewall resources effectively.

| Stateful Rule Group                                                                                                                     | Stateless Rule Group                                     |
| --------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| Inspects traffic flows and maintains context about the traffic state.                                                                   | Inspects individual packets without maintaining context. |
| Actions: allow, drop, or alert.                                                                                                         | Actions: pass, drop, forward, or custom                  |
|                                                                                                                                         | Processes in order of priority (low to high)             |
| Uses `suricata` rules engine, by default it will pass the request. You can swap to a default standard engine for simple/domain list[^3] |                                                          |

[^1]: WCU stands for WebACL Capacity Unit.

[^2]: Ensure local vpc route is present. This will allow traffic leaving the firewall to reach other subnets or IGW correctly.

[^3]: You can create a domain white/black list using the standard engine. Same goes for IPs.

This message is confidential and subject to terms at: https://www.jpmorgan.com/emaildisclaimer including on confidential, privileged or legal entity information, malicious content and monitoring of electronic messages. If you are not the intended recipient, please delete this message and notify the sender immediately. Any unauthorized use is strictly prohibited.
