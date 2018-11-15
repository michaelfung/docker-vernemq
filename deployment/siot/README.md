# Deployment for SIOT

## generate tls cert and key

Place the cert and key file in ./tls folder.

**IMPORTANT**
The CA certificates chain must be put in one CA certfile.
The server cert file contains only the single server cert.
This is different from most http servers that put intermediate certs in the server cert file.


## create secret to hold the cert and key

    # syntax:
    # generic NAME [--type=string] [--from-file=[key=]source] [--from-literal=key1=value1] [--dry-run]

    # delete existing: kubectl delete secrets/vmq-tls
    kubectl create secret generic vmq-tls --from-file=./tls


## create configMap

Run:
    # delete if aleady exists: kubectl delete configmap/vmq-siot-config
    kubectl create configmap vmq-siot-config --from-file=./vernemq-siot.conf --from-file=./vmq.acl

After done, dump it to a yaml file and check it , edit it and use it to recreate the configmap if needed.

    kubectl get configmap vmq-siot-config -o yaml > vmq-siot-config.yaml


## create a Pod with the configMap

Create pod:

    # delete if aleady exists: kubectl delete pod/vmq-siot
    kubectl create -f ./vmq-siot-pod.yaml


## expose the ports to the world

Use NodePort so that we can test easily from outside by a port forwarding rule, or IP mapping:

    kubectl expose pod vmq-siot --type NodePort --name=vmq

Read the assigned ports:

    kubectl get services | grep vmq
    vmq          NodePort    10.43.62.230    <none>        8883:32693/TCP,8885:32224/TCP,8888:30042/TCP   18h

Test it using Node's address (e.g. ros-node3.lan) from outside:

    curl -q "http://ros-node3.lan:30042/metrics"

Test it using cluster address (must test from inside cluster):

    curl -q "http://vmq:8888/metrics"

Test SSL connection to mqtt port from outside of cluster:

    openssl s_client -connect ros-node3.lan:32693 -CAfile OEM_ROOT_CA.crt -cert siot_sample_client_01.crt -key siot_sample_client_01.key

Screen Dump:

```
CONNECTED(00000003)
depth=2 C = HK, O = OEM, OU = MIS, CN = OEM ROOT CA
verify return:1
depth=1 C = HK, O = OEM, OU = MIS, CN = OEM SIOT CA
verify return:1
depth=0 C = HK, L = Hong Kong, O = OEM, OU = MIS, CN = *.siot.localdomain
verify return:1
139773239550400:error:14094418:SSL routines:ssl3_read_bytes:tlsv1 alert unknown ca:../ssl/record/rec_layer_s3.c:1399:SSL alert number 48
---
Certificate chain
 0 s:/C=HK/L=Hong Kong/O=OEM/OU=MIS/CN=*.siot.localdomain
   i:/C=HK/O=OEM/OU=MIS/CN=OEM SIOT CA
 1 s:/C=HK/O=OEM/OU=MIS/CN=OEM SIOT CA
   i:/C=HK/O=OEM/OU=MIS/CN=OEM ROOT CA
 2 s:/C=HK/O=OEM/OU=MIS/CN=OEM ROOT CA
   i:/C=HK/O=OEM/OU=MIS/CN=OEM ROOT CA
---
Server certificate
-----BEGIN CERTIFICATE-----
MIIDujCCAqKgAwIBAgIBBDANBgkqhkiG9w0BAQsFADA/MQswCQYDVQQGEwJISzEM
MAoGA1UEChMDT0VNMQwwCgYDVQQLEwNNSVMxFDASBgNVBAMTC09FTSBTSU9UIENB
MB4XDTE4MDgwNjA2MzMwMFoXDTIzMDgwNjA2MzMwMFowWjELMAkGA1UEBhMCSEsx
EjAQBgNVBAcTCUhvbmcgS29uZzEMMAoGA1UEChMDT0VNMQwwCgYDVQQLEwNNSVMx
GzAZBgNVBAMMEiouc2lvdC5sb2NhbGRvbWFpbjCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBANQggsJl0mx1jfIbfKimDXexcPtVuYC9eNLGBvGm76zpRQqp
/8Mg36CkVNSx9QtxzNAUCYFb7b3RV2jy0cIKdro4QaliFO4d1wYLCyybOghWosWd
YWFpa/7XGhJrJR4MWfdMXHiAs3mjKUw5FbOQRzgTaZjXP6/MU2T7IP31Bp1sDkQu
CNn7XeZrcEnR/k4oDpqQAyr6EdZyaMZkzZqANAGtQH4ItJCIjYYpjstpYfG/dkp/
J8wzvDUw6N4R3IlZKeJcoI4q6KHdnk5NyZ7OPALKMDDJ/113F1HXZXMXkMuCFUF0
iXqtDSDk5hlXRZaqYtuh6FnMx3sdR3RmUnCUy8cCAwEAAaOBpTCBojAJBgNVHRME
AjAAMB0GA1UdDgQWBBQgwbCKuZ2DNOqPVFI3uGXlagt1RzAfBgNVHSMEGDAWgBSk
1gQMQqRRrE5eZ9HPgRWTv0C49jAOBgNVHQ8BAf8EBAMCBaAwEwYDVR0lBAwwCgYI
KwYBBQUHAwEwHQYDVR0RBBYwFIISKi5zaW90LmxvY2FsZG9tYWluMBEGCWCGSAGG
+EIBAQQEAwIGQDANBgkqhkiG9w0BAQsFAAOCAQEAtyUrAvUzrHSCX3U3XeCk+XIa
Gm1wAEWZ7BIxj4KoIPTV538U2LPfaoL40r1gwDy+x0L5mUraWCuB31zBrJ+HI/zd
zha4ObTiOU7sw1YlDcV15IOPTNk77nWKIOulQRNFlGG9Yblli/pt0Ri/MrHE/kHN
yl9X0nSFojEqivxGwhSWr4ChJmGFqzmXns6MLXl60rHZJFj/adL07ECQNEdgWh2z
NdPhpaodOITd043nv1PDYZq0iiE2Vre5WOwtVlogxRnnScNPS33C6rVIFHR8Tcu6
TTfPtKXgy/6DpUxniPpfjxbfUGdPQgUxRJm8fS22fyzcLmm0tFKoQehps3cP+Q==
-----END CERTIFICATE-----
subject=/C=HK/L=Hong Kong/O=OEM/OU=MIS/CN=*.siot.localdomain
issuer=/C=HK/O=OEM/OU=MIS/CN=OEM SIOT CA
---
Acceptable client certificate CA names
/C=HK/O=OEM/OU=MIS/CN=OEM SIOT CA
/C=HK/O=OEM/OU=MIS/CN=OEM ROOT CA
Client Certificate Types: ECDSA sign, RSA sign, DSA sign
Requested Signature Algorithms: ECDSA+SHA512:RSA+SHA512:ECDSA+SHA384:RSA+SHA384:ECDSA+SHA256:RSA+SHA256:ECDSA+SHA224:RSA+SHA224:ECDSA+SHA1:RSA+SHA1:DSA+SHA1
Shared Requested Signature Algorithms: ECDSA+SHA512:RSA+SHA512:ECDSA+SHA384:RSA+SHA384:ECDSA+SHA256:RSA+SHA256:ECDSA+SHA224:RSA+SHA224:ECDSA+SHA1:RSA+SHA1:DSA+SHA1
Peer signing digest: SHA512
Server Temp Key: ECDH, P-256, 256 bits
---
SSL handshake has read 3339 bytes and written 1452 bytes
Verification: OK
---
New, TLSv1.2, Cipher is ECDHE-RSA-AES256-GCM-SHA384
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES256-GCM-SHA384
    Session-ID: C100D36FC42D39CA9FF77EC0E824D3100772D0F1A5DCF9996B8D5910BBEDC9D4
    Session-ID-ctx:
    Master-Key: B25086AD81AB9E029977FA2D0E6207779D60262DED8CA8EFDB5B42CD590E64BDFAAF1BDA73F5470D284316F1EDD1A5A9
    PSK identity: None
    PSK identity hint: None
    SRP username: None
    Start Time: 1542171658
    Timeout   : 7200 (sec)
    Verify return code: 0 (ok)
    Extended master secret: no
---

```
