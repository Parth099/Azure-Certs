#!/bin/bash -xe
dnf install bind bind-utils -y
cat <<EOF > /etc/named.conf
options {
  directory	"/var/named";
  dump-file	"/var/named/data/cache_dump.db";
  statistics-file "/var/named/data/named_stats.txt";
  memstatistics-file "/var/named/data/named_mem_stats.txt";
  allow-query { any; };
  recursion yes;
  forward first;
  forwarders {
    192.168.10.2;
  };
  dnssec-validation yes;
  /* Path to ISC DLV key */
  bindkeys-file "/etc/named.iscdlv.key";
  managed-keys-directory "/var/named/dynamic";
};
zone "corp.${zone_name}" IN {
    type master;
    file "corp.${zone_name}";
    allow-update { none; };
};
EOF
cat <<EOF > /var/named/corp.${zone_name}
\$TTL 86400
@   IN  SOA     ns1.mydomain.com. root.mydomain.com. (
        2013042201  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
; Specify our two nameservers
    IN	NS		dnsA.corp.${zone_name}.
    IN	NS		dnsB.corp.${zone_name}.
; Resolve nameserver hostnames to IP, replace with your two droplet IP addresses.
dnsA		IN	A		1.1.1.1
dnsB	  IN	A		8.8.8.8

; Define hostname -> IP pairs which you wish to resolve
@		  IN	A		${application_server_ip}
app		IN	A	  ${application_server_ip}
EOF
service named restart
chkconfig named on