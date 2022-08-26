#!/bin/sh
########################################
#              CertGetter              #
########################################
# Developed by Ezequiel Lage (@ezlage) #
# Sponsored by Lageteck (lageteck.com) #
########################################

readonly now=$(date +'on %F at %T (%Z)');
readonly scriptname="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
readonly username="certgetter"
readonly homepath="/home/$username"
readonly destination="$homepath/$3"
readonly acmesourcep="/tmp/acme/$1/$2"
logprefix="[CertGetter $now]"
logsuffix="\n"
copyfailed=false
permfailed=false
havechanges=false

([ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]) && {
    printf "$logprefix Correct usage: $scriptname \"acme_account_name\" \"domain_primary_name\" \"destination_name\" $logsuffix"
    exit 3
}

[ $(id -u) -ne 0 ] && {
    printf "$logprefix This script needs to be run as root! $logsuffix"
    exit 4
}

[ -d "$acmesourcep" ] || {
    printf "$logprefix Incorrent Account Name and/or Primary Domain Name! $logsuffix"
    exit 5
}

getent passwd $username > /dev/null || {
    printf "[$now] User \"$username\" must exist! $logsuffix"
    exit 6
}

[ -d "$homepath" ] || {
    printf "$logprefix A profile directory for \"$username\" must exist inside \"\\home\"! $logsuffix"
    exit 7
}

[ -f "$acmesourcep/ca.cer" ] || {
    printf "$logprefix Certificate Authority public key is missing! Did you forget to issue or renew the certificate? $logsuffix"
    exit 8
}

[ -f "$acmesourcep/fullchain.cer" ] || {
    printf "$logprefix Full certificate chain is missing! Did you forget to issue or renew the certificate? $logsuffix"
    exit 9
}

[ -f "$acmesourcep/$2.cer" ] || {
    printf "$logprefix Certificate not found! Did you forget to issue or renew the certificate? $logsuffix"
    exit 10
}

[ -f "$acmesourcep/$2.key" ] || {
    printf "$logprefix Private key not found! Did you forget to issue or renew the certificate? $logsuffix"
    exit 11
}

mkdir -p "$destination" || {
    printf "$logprefix Failed to create directory \"$destination\"! $logsuffix"
    exit 12
}

cmp -s "$acmesourcep/ca.cer" "$destination/$3_ca.cer" || havechanges=true
cmp -s "$acmesourcep/fullchain.cer" "$destination/$3_fc.cer" || havechanges=true
cmp -s "$acmesourcep/$2.cer" "$destination/$3.cer" || havechanges=true
cmp -s "$acmesourcep/$2.key" "$destination/$3.key" || havechanges=true
cmp -s "$acmesourcep/$2.p12" "$destination/$3.p12" || havechanges=true

[ "$havechanges" = true ] || {
    printf "$logprefix No action needed! $logsuffix"
    exit 0
}

openssl pkcs12 -export \
    -certfile "$acmesourcep/fullchain.cer" \
    -in "$acmesourcep/$2.cer" \
    -inkey "$acmesourcep/$2.key" \
    -out "$acmesourcep/$2.p12" \
    -passout pass:

[ $? -ne 0 ] && {
    printf "$logprefix Failed to generate certificate in \".p12\" format! $logsuffix"
    exit 13
}

cp "$acmesourcep/ca.cer" "$destination/$3_ca.cer" || copyfailed=true
cp "$acmesourcep/fullchain.cer" "$destination/$3_fc.cer" || copyfailed=true
cp "$acmesourcep/$2.cer" "$destination/$3.cer" || copyfailed=true
cp "$acmesourcep/$2.key" "$destination/$3.key" || copyfailed=true
cp "$acmesourcep/$2.p12" "$destination/$3.p12" || copyfailed=true

[ "$copyfailed" = false ] || {
    printf "$logprefix Failed to copy files! $logsuffix"
    exit 14
}

chown -R $username:nobody "$destination" || permfailed=true
chmod -R 744 "$destination" || permfailed=true

[ "$permfailed" = false ] || {
    printf "$logprefix Failed to apply permissions! $logsuffix"
    exit 15
}

printf "$logprefix All right, the latest certificate is available for delivery via SCP or RSYNC! $logsuffix"
exit 0