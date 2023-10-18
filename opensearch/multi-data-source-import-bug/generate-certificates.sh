#!/bin/sh

mkdir _certs

# Root CA
openssl genrsa -out _certs/root-ca-key.pem 2048
openssl req -new -x509 -sha256 -key _certs/root-ca-key.pem -subj "/CN=RootCA/OU=FakeOrganizationUnit/O=FakeOrganization/L=FakeL/ST=FakeST/C=BR" -out _certs/root-ca.pem -days 730

# node secondary
openssl genrsa -out _certs/node-secondary-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in _certs/node-secondary-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out _certs/node-secondary-key.pem
openssl req -new -key _certs/node-secondary-key.pem -subj "/CN=opensearch-secondary.lab/OU=FakeOrganizationUnit/O=FakeOrganization/L=FakeL/ST=FakeST/C=BR" -out _certs/node-secondary.csr
echo 'subjectAltName=DNS:opensearch-secondary.lab' > _certs/node-secondary.ext
openssl x509 -req -in _certs/node-secondary.csr -CA _certs/root-ca.pem -CAkey _certs/root-ca-key.pem -CAcreateserial -sha256 -out _certs/node-secondary.pem -days 730 -extfile _certs/node-secondary.ext

# node main
openssl genrsa -out _certs/node-main-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in _certs/node-main-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out _certs/node-main-key.pem
openssl req -new -key _certs/node-main-key.pem -subj "/CN=opensearch-secondary.lab/OU=FakeOrganizationUnit/O=FakeOrganization/L=FakeL/ST=FakeST/C=BR" -out _certs/node-main.csr
echo 'subjectAltName=DNS:opensearch-main.lab' > _certs/node-main.ext
openssl x509 -req -in _certs/node-main.csr -CA _certs/root-ca.pem -CAkey _certs/root-ca-key.pem -CAcreateserial -sha256 -out _certs/node-main.pem -days 730 -extfile _certs/node-main.ext

# opensearch-dashboards
openssl genrsa -out _certs/opensearch-dashboards-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in _certs/opensearch-dashboards-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out _certs/opensearch-dashboards-key.pem
openssl req -new -key _certs/opensearch-dashboards-key.pem -subj "/CN=opensearch-dashboards.lab/OU=FakeOrganizationUnit/O=FakeOrganization/L=FakeL/ST=FakeST/C=BR" -out _certs/opensearch-dashboards.csr
echo 'subjectAltName=DNS:opensearch-dashboards.lab' > _certs/opensearch-dashboards.ext
openssl x509 -req -in _certs/opensearch-dashboards.csr -CA _certs/root-ca.pem -CAkey _certs/root-ca-key.pem -CAcreateserial -sha256 -out _certs/opensearch-dashboards.pem -days 730 -extfile _certs/opensearch-dashboards.ext

chmod 600 _certs/*
