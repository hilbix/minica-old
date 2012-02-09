#!/bin/bash

set -e
if [ -z "$1" ]
then
        echo "Usage: `basename "$0"` filename [bits]"
        echo "Create a self signed certificate.  CN is set to filename."
        exit 1
fi
if [ -f "$1.key" -o -f "$1.pem" -o -f "$1.pub" ]
then
        echo "already exists: $1"
        exit 1
fi

days="$[(2147480000-$(date +%s))/24/60/60]"
openssl genrsa -out "$1.key" "${2:-1024}"
openssl req -config openssl.cnf -subj "/CN=$1" -new -key "$1.key" |
openssl x509 -req -days $days -signkey "$1.key" -out "$1.pub"

cat "$1.pub" "$1.key" > "$1.pem"

echo "private: key $1.key certificate $1.pem"
echo "public:  key $1.pub ($1.pub also is the certificate)"
