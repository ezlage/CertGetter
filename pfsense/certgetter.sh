#!/bin/sh

echo
echo "========================================="
echo "=              CertGetter!              ="
echo "========================================="
echo "= Developed -by Ezequiel Lage (@ezlage) ="
echo "= Sponsored -by Lageteck (lageteck.com) ="
echo "= Material protected by a license (MIT) ="
echo "========================================="
echo

readonly now=$(date +'on %F at %T (%Z)');
readonly scriptname="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
readonly scriptpath="$(dirname "$0")"
readonly servicename="$(basename "$scriptname" .sh)"
readonly homepath="/home/$servicename"
readonly destination="$homepath/$3"
readonly acmesourcep="/tmp/acme/$1/$2"
readonly logfile="$scriptpath/$servicename.log"
logprefix="[CertGetter $now]"
logsuffix="\n"
copyfailed=false
permfailed=false
havechanges=false

showandsave() {
    msg=$@
    printf "$logprefix $msg $logsuffix" | tee -a $logfile
}

([ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]) && {
    showandsave "Correct usage: $scriptname \"acme-account-name\" \"domain-primary-name\" \"local-destination-name\""
    exit 3
}

[ $(id -u) -ne 0 ] && {
    showandsave "This script needs to be run as root!"
    exit 4
}

[ -d "$acmesourcep" ] || {
    showandsave "Incorrect Account Name and/or Primary Domain Name!"
    exit 5
}

getent passwd $servicename > /dev/null || {
    showandsave "User \"$servicename\" must exist!"
    exit 6
}

[ -d "$homepath" ] || {
    showandsave "A profile directory for \"$servicename\" must exist inside \"\\home\"!"
    exit 7
}

[ -f "$acmesourcep/ca.cer" ] || {
    showandsave "Certificate Authority public key is missing! Did you forget to issue or renew the certificate?"
    exit 8
}

[ -f "$acmesourcep/fullchain.cer" ] || {
    showandsave "Full certificate chain is missing! Did you forget to issue or renew the certificate?"
    exit 9
}

[ -f "$acmesourcep/$2.cer" ] || {
    showandsave "Certificate not found! Did you forget to issue or renew the certificate?"
    exit 10
}

[ -f "$acmesourcep/$2.key" ] || {
    showandsave "Private key not found! Did you forget to issue or renew the certificate?"
    exit 11
}

mkdir -p "$destination" || {
    showandsave "Failed to create directory \"$destination\"!"
    exit 12
}

cmp -s "$acmesourcep/ca.cer" "$destination/$3-ca.cer" || havechanges=true
cmp -s "$acmesourcep/fullchain.cer" "$destination/$3-fc.cer" || havechanges=true
cmp -s "$acmesourcep/$2.cer" "$destination/$3.cer" || havechanges=true
cmp -s "$acmesourcep/$2.key" "$destination/$3.key" || havechanges=true
cmp -s "$acmesourcep/$2.p12" "$destination/$3.p12" || havechanges=true

[ "$havechanges" = true ] || {
    showandsave "No action needed!"
    exit 0
}

openssl pkcs12 -export \
    -certfile "$acmesourcep/fullchain.cer" \
    -in "$acmesourcep/$2.cer" \
    -inkey "$acmesourcep/$2.key" \
    -out "$acmesourcep/$2.p12" \
    -passout pass:

[ $? -ne 0 ] && {
    showandsave "Failed to generate certificate in \".p12\" format!"
    exit 13
}

cp "$acmesourcep/ca.cer" "$destination/$3-ca.cer" || copyfailed=true
cp "$acmesourcep/fullchain.cer" "$destination/$3-fc.cer" || copyfailed=true
cp "$acmesourcep/$2.cer" "$destination/$3.cer" || copyfailed=true
cp "$acmesourcep/$2.key" "$destination/$3.key" || copyfailed=true
cp "$acmesourcep/$2.p12" "$destination/$3.p12" || copyfailed=true

[ "$copyfailed" = false ] || {
    showandsave "Failed to copy files!"
    exit 14
}

chown -R $servicename:nobody "$destination" || permfailed=true
chmod -R 744 "$destination" || permfailed=true

[ "$permfailed" = false ] || {
    showandsave "Failed to apply permissions!"
    exit 15
}

showandsave "Okay, the latest certificate is available for delivery via SCP or RSYNC!"
exit 0