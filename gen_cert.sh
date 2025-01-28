#!/usr/bin/bash
SELF=$(realpath $0)
SELF_PARENT=$(dirname $SELF)

#path to certificate dir (probably a docker volume):
# find a docker volume by running `docker volume inspect <volume-name>`
#CERT_DIR="${SELF_PARENT}"
CERT_DIR="${SELF_PARENT}/certs"
FQDN="$1"

if [ -z "$FQDN" ];then
    echo "USAGE: ./gen-cert.sh <fqdn>"
    echo "Cert will be generated in ${CERT_DIR}"
    exit 1
fi

mkdir -p "${CERT_DIR}"

# Check if root
if (( $EUID != 0 )); then
    echo "Script must be run as root"
    exit 1
fi

# openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#     --addext "subjectAltName =DNS:${FQDN}" \
#     --keyout ${CERT_DIR}/${FQDN}.key \
#     --out ${CERT_DIR}/${FQDN}.crt \
#     #--subj "/C=/ST=/L=/O=/CN=${FQDN}" \
#     --subj "/C=/ST=/L=/O=/CN="

openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
    -keyout ${CERT_DIR}/${FQDN}.key \
    -out ${CERT_DIR}/${FQDN}.crt \
    -subj "/CN=${FQDN}" \
    -addext "subjectAltName=DNS:${FQDN},DNS:*.${FQDN}"


ln -s ${CERT_DIR}/${FQDN}.key ${CERT_DIR}/cert.key

ln -s ${CERT_DIR}/${FQDN}.crt ${CERT_DIR}/cert.crt
