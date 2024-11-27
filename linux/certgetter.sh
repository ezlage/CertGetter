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
readonly acmeserver="$1"
readonly acmesourcep="$2"
readonly homepath="/root/$servicename"
readonly localstaging="$homepath/$acmesourcep"
readonly destination="/etc/$servicename/$acmesourcep"
readonly logfile="$scriptpath/$servicename.log"
logprefix="[CertGetter $now]"
logsuffix="\n"
syncedby="none"
copyfailed=false
permfailed=false
havechanges=false

showandsave() {
    msg=$@
    printf "$logprefix $msg $logsuffix" | tee -a $logfile
}

([ -z "$1" ] || [ -z "$2" ]) && {
    showandsave "Correct usage: $scriptname \"acme-server\" \"remote-source-name\""
    exit 3
}
shift; shift;

[ $(id -u) -ne 0 ] && {
    showandsave "This script needs to be run as root!"
    exit 4
}

mkdir -p "$destination" || {
    showandsave "Failed to create directory \"$destination\"!"
    exit 12
}

([ -f "/root/.ssh/id_rsa" ] && [ -f "/root/.ssh/id_rsa.pub" ]) || {
    showandsave "The root user has no RSA key pair! Did you forget to generate it?"
    exit 16
}

ssh-keyscan -H "$acmeserver" 2>/dev/null >> "/root/.ssh/known_hosts" || {
    showandsave "Could not read the public key of the given server! Incorrect hostname or IP? Exceeded limit?"
    exit 17
}

sort -u "/root/.ssh/known_hosts" -o "/root/.ssh/known_hosts" || {
    showandsave "Unable to manipulate known hosts file!"
    exit 18
}

if scp -rpq -i "/root/.ssh/id_rsa" "$servicename@$acmeserver:$acmesourcep" "$homepath"; then
    syncedby="SCP"
elif rsync -aPvq --no-perms --no-owner --no-group -e "ssh -i /root/.ssh/id_rsa" "$servicename@$acmeserver:$acmesourcep" "$homepath"; then
    syncedby="RSYNC"
else
    showandsave "Both SCP and RSYNC failed to sync!"
    exit 19
fi

cmp -s "$localstaging/$acmesourcep-ca.cer" "$destination/$acmesourcep-ca.cer" || havechanges=true
cmp -s "$localstaging/$acmesourcep-fc.cer" "$destination/$acmesourcep-fc.cer" || havechanges=true
cmp -s "$localstaging/$acmesourcep.cer" "$destination/$acmesourcep.cer" || havechanges=true
cmp -s "$localstaging/$acmesourcep.key" "$destination/$acmesourcep.key" || havechanges=true
cmp -s "$localstaging/$acmesourcep.p12" "$destination/$acmesourcep.p12" || havechanges=true

[ "$havechanges" = true ] || {
    showandsave "$syncedby has successfully copied/synced files, but they have not changed since the last sync!"
    exit 0
}

cp "$localstaging/$acmesourcep-ca.cer" "$destination/$acmesourcep-ca.cer" || copyfailed=true
cp "$localstaging/$acmesourcep-fc.cer" "$destination/$acmesourcep-fc.cer" || copyfailed=true
cp "$localstaging/$acmesourcep.cer" "$destination/$acmesourcep.cer" || copyfailed=true
cp "$localstaging/$acmesourcep.key" "$destination/$acmesourcep.key" || copyfailed=true
cp "$localstaging/$acmesourcep.p12" "$destination/$acmesourcep.p12" || copyfailed=true

[ "$copyfailed" = false ] || {
    showandsave "The files were fetched but could not be copied from \"$localstaging\" to \"$destination\"!"
    exit 14
}

chown -R root:root "$localstaging" || permfailed=true
chmod -R 744 "$localstaging" || permfailed=true
chown -R root:root "$destination/.." || permfailed=true
chmod -R 744 "$destination/.." || permfailed=true

[ "$permfailed" = false ] || {
    showandsave "Failed to apply permissions!"
    exit 15
}

showandsave "Okay, the last certificate was obtained by the $syncedby and then applied; Reload your services!"
exit 0