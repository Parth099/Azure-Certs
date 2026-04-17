# Cloudtrail

CloudTrail is a service that enables governance, compliance, operational auditing, and risk auditing of your AWS account. With CloudTrail, you can log, continuously monitor, and retain account activity related to actions across your AWS infrastructure. This includes actions taken through the AWS Management Console, AWS SDKs, command-line tools, and other AWS services.

## Basics

- Logs AWS API calls and events which are called CloudTrail events.
    - management operations logged by default
    - data events (ex: S3 and Lambda) are not logged by default, you need to enable them explicitly
- History is kept for 90 days as default
- To customize the behavior you need to create a **trail**.
- regional service, but you can create a trail that applies to all regions
    - these are the only two options, you cannot create a trail that applies to only some regions
    - global services are logged to the us-east-1 region.
- trails can be set to be stored in S3 buckets for a period of time of your choosing
- trails can be set to send logs to CloudWatch Logs for real-time monitoring, alerting, and querying
- cloudtrail is NOT realtime, there is a delay

## CloudTrail Log File Integrity Validation

CloudTrail log file integrity validation is a feature that allows you to verify that your CloudTrail log files have not been tampered with after they have been delivered to your S3 bucket. When you enable log file integrity validation for a trail, CloudTrail creates a hash value for each log file and stores it in a separate folder in the same bucket. You can then use the hash file to verify the integrity of the log files by comparing the hash values in the hash file with the hash values of the log files in your S3 bucket.

The digest files operate in a chain of trust model, each digest file contains a hash of the previous digest file, creating a chain that can be used to verify the integrity of the log files. Verification can be done via the Cloudtrail public key, for now its only available via the CLI.
