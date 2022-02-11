#!/bin/sh

### asus-wrapper-acme.sh v.0.0.7 ###
# Created by Garycnew and shared with SNBForums
# https://www.snbforums.com/threads/solution-asus-wrapper-acme-sh-adds-dns-support-for-lets-encrypt-wildcard-san-certs-to-integrated-asus-acme-sh-implementation.75233/
# Should be working 100% except for the revoke command, and according to Gary, that should be straightforward to add.
# This is basically a fork, except git doesn't really have a handler for forking a block of text from a forum.  The only change I made
# was adding this comment block to explain where this came from with no history.

# Default Asus acme.sh cli arguments
#/usr/sbin/acme.sh --home /tmp/.le --certhome /jffs/.le --accountkey /jffs/.le/account.key --accountconf /jffs/.le/account.conf --domain domain.tld --useragent asusrouter/0.2 --fullchain-file /jffs/.le/domain.tld/fullchain.pem --key-file /jffs/.le/domain.tld/domain.key --issue --standalone --httpport 51539
#/usr/sbin/acme.sh --home /tmp/.le --certhome /jffs/.le --accountkey /jffs/.le/account.key --accountconf /jffs/.le/account.conf --domain domain.tld --useragent asusrouter/0.2 --fullchain-file /jffs/.le/domain.tld/fullchain.pem --key-file /jffs/.le/domain.tld/domain.key --issue --standalone --httpport 39388 --staging
#/usr/sbin/acme.sh --home /tmp/.le --certhome /jffs/.le --accountkey /jffs/.le/account.key --accountconf /jffs/.le/account.conf --domain domain.tld --useragent asusrouter/0.2 --fullchain-file /jffs/.le/domain.tld/fullchain.pem --key-file /jffs/.le/domain.tld/domain.key --issue --standalone --httpport 27852 --force --staging
#/usr/sbin/acme.sh --home /tmp/.le --certhome /jffs/.le --accountkey /jffs/.le/account.key --accountconf /jffs/.le/account.conf --domain domain.tld --useragent asusrouter/0.2 --fullchain-file /jffs/.le/domain.tld/fullchain.pem --key-file /jffs/.le/domain.tld/domain.key --issue --standalone --httpport 44797 --debug 1 --staging
#/usr/sbin/acme.sh --home /tmp/.le --certhome /jffs/.le --accountkey /jffs/.le/account.key --accountconf /jffs/.le/account.conf --domain domain.tld --useragent asusrouter/0.2 --fullchain-file /jffs/.le/domain.tld/fullchain.pem --key-file /jffs/.le/domain.tld/domain.key --revoke --debug 1 --force --staging

# Asus acme.sh NVRAM variables
# nvram show | grep -i acme
#le_acme_force=0
#le_acme_auth=http
#le_acme_debug=0
#le_acme_renew_force=0
#le_acme_stage=0
#le_acme_logpath=
# nvram set le_acme_force=[0|1]
# nvram set le_acme_auth=[http|????]
# nvram set le_acme_debug=[0|1|2]
# nvram set le_acme_renew_force=[0|1]
# nvram set le_acme_stage=[0|1]
# nvram set le_acme_logpath=[/tmp/acme.log] (overrides syslog)

# If domains file does not exist, use default Asus DDNS domain
domains="/jffs/.le/domains"

# Make sure the base domain (cert directory name) is last in each entry
# cat /jffs/.le/domains
# www.domain.tld|domain.tld
# *.domain.tld|domain.tld
# *.example.tld|example.tld|*.domain.tld|domain.tld
# *.example.tld|example.tld|*.sample.tld|sample.tld|*.domain.tld|domain.tld
# www.example.tld|example.tld|www.sample.tld|sample.tld|www.domain.tld|domain.tld

# Mount bind caches asus-wrapper-acme.sh. Remount after any script edits.
# cat /jffs/scripts/post-mount
# Check Whether dns_ispman.sh File Exist
#if [ ! -f "/usr/sbin/dnsapi/dns_ispman.sh" ]; then
#   /bin/mount -o bind /jffs/sbin/dnsapi /usr/sbin/dnsapi
#   /bin/mount -o bind /jffs/sbin/asus-wrapper-acme.sh /usr/sbin/acme.sh
#fi

# service restart_letsencrypt

domarg="--domain"
domain="${10}"
dnsarg="--dns"
dnsapi="dns_ispman"

#logger -t acme "$*"

if [ -f "$domains" ]; then
   while read entry; do

   #logger -t acme "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}" "${11}" "${12}" "${13}" "${14}" "${15}" "${16}" "${17}" "${18}" "${19}" "${20}" "${21}" "${22}" "${23}" "${24}" "${25}"
   #echo BEFORE "1:$1" "2:$2" "3:$3" "4:$4" "5:$5" "6:$6" "7:$7" "8:$8" "9:$9" "10:${10}" "11:${11}" "12:${12}" "13:${13}" "14:${14}" "15:${15}" "16:${16}" "17:${17}" "18:${18}" "19:${19}" "20:${20}" "21:${21}" "22:${22}" "23:${23}" "24:${24}" "25:${25}"

   #echo "n: $n"

   if [ -z "$n" ]; then
      IFS=$'|'; for domain in $entry; do :; chainfile="$(echo ${14} | sed -E "s/\/jffs\/\.le\/(.+?)\/fullchain\.pem/\/jffs\/\.le\/$domain\/fullchain\.pem/g;")"; keyfile="$(echo ${16} | sed -E "s/\/jffs\/\.le\/(.+?)\/domain\.key/\/jffs\/\.le\/$domain\/domain\.key/g;")"; done
      #echo "chainfile: $chainfile"
      #echo "keyfile: $keyfile"
      if [ "${24}" ]; then
         set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "${11}" "${12}" "${13}" "$chainfile" "${15}" "$keyfile" "${17}" "${21}" "${22}" "${23}" "${24}" "$dnsarg" "$dnsapi"
      elif [ "${23}" ]; then
         set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "${11}" "${12}" "${13}" "$chainfile" "${15}" "$keyfile" "${17}" "${21}" "${22}" "${23}" "$dnsarg" "$dnsapi"
      elif [ "${22}" ]; then
         set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "${11}" "${12}" "${13}" "$chainfile" "${15}" "$keyfile" "${17}" "${21}" "${22}" "$dnsarg" "$dnsapi"
      elif [ "${21}" ]; then
         set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "${11}" "${12}" "${13}" "$chainfile" "${15}" "$keyfile" "${17}" "${21}" "$dnsarg" "$dnsapi"
      else
         set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "${11}" "${12}" "${13}" "$chainfile" "${15}" "$keyfile" "${17}" "$dnsarg" "$dnsapi"
      fi
   else
      IFS=$'|'; for domain in $entry; do :; chainfile="$(echo ${12} | sed -E "s/\/jffs\/\.le\/(.+?)\/fullchain\.pem/\/jffs\/\.le\/$domain\/fullchain\.pem/g;")"; keyfile="$(echo ${14} | sed -E "s/\/jffs\/\.le\/(.+?)\/domain\.key/\/jffs\/\.le\/$domain\/domain\.key/g;")"; done
      #echo "chainfile: $chainfile"
      #echo "keyfile: $keyfile"
      if [ "${21}" ]; then
         set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}" "${11}" "$chainfile" "${13}" "$keyfile" "${15}" "${16}" "${17}" "${18}" "${19}" "${20}" "${21}"
      elif [ "${20}" ]; then
         set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}" "${11}" "$chainfile" "${13}" "$keyfile" "${15}" "${16}" "${17}" "${18}" "${19}" "${20}"
      elif [ "${19}" ]; then
         set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}" "${11}" "$chainfile" "${13}" "$keyfile" "${15}" "${16}" "${17}" "${18}" "${19}"
      elif [ "${18}" ]; then
         set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}" "${11}" "$chainfile" "${13}" "$keyfile" "${15}" "${16}" "${17}" "${18}"
      else
         set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}" "${11}" "$chainfile" "${13}" "$keyfile" "${15}" "${16}" "${17}"
      fi
   fi

   n=0; IFS=$'|'; for domain in $entry; do :; set -- "$domarg" "$domain" "$@"; n=$((n + 2)); done

   #echo "n: $n"

   #echo AFTER "1:$1" "2:$2" "3:$3" "4:$4" "5:$5" "6:$6" "7:$7" "8:$8" "9:$9" "10:${10}" "11:${11}" "12:${12}" "13:${13}" "14:${14}" "15:${15}" "16:${16}" "17:${17}" "18:${18}" "19:${19}" "20:${20}" "21:${21}" "22:${22}" "23:${23}" "24:${24}" "25:${25}"
   #logger -t acme "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}" "${11}" "${12}" "${13}" "${14}" "${15}" "${16}" "${17}" "${18}" "${19}" "${20}" "${21}" "${22}" "${23}" "${24}" "${25}"

   /jffs/sbin/acme.sh "$@"
   #wait $!

   shift $n
   #unset n
   done <$domains
else
   #logger -t acme "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}" "${11}" "${12}" "${13}" "${14}" "${15}" "${16}" "${17}" "${18}" "${19}" "${20}" "${21}" "${22}" "${23}" "${24}" "${25}"
   #echo BEFORE "1:$1" "2:$2" "3:$3" "4:$4" "5:$5" "6:$6" "7:$7" "8:$8" "9:$9" "10:${10}" "11:${11}" "12:${12}" "13:${13}" "14:${14}" "15:${15}" "16:${16}" "17:${17}" "18:${18}" "19:${19}" "20:${20}" "21:${21}" "22:${22}" "23:${23}" "24:${24}" "25:${25}"

   chainfile="$(echo ${14} | sed -E "s/\/jffs\/\.le\/(.+?)\/fullchain\.pem/\/jffs\/\.le\/$domain\/fullchain\.pem/g;")"; keyfile="$(echo ${16} | sed -E "s/\/jffs\/\.le\/(.+?)\/domain\.key/\/jffs\/\.le\/$domain\/domain\.key/g;")";
   #echo "chainfile: $chainfile"
   #echo "keyfile: $keyfile"
   if [ "${24}" ]; then
      set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "${11}" "${12}" "${13}" "$chainfile" "${15}" "$keyfile" "${17}" "${21}" "${22}" "${23}" "${24}" "$dnsarg" "$dnsapi"
   elif [ "${23}" ]; then
      set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "${11}" "${12}" "${13}" "$chainfile" "${15}" "$keyfile" "${17}" "${21}" "${22}" "${23}" "$dnsarg" "$dnsapi"
   elif [ "${22}" ]; then
      set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "${11}" "${12}" "${13}" "$chainfile" "${15}" "$keyfile" "${17}" "${21}" "${22}" "$dnsarg" "$dnsapi"
   elif [ "${21}" ]; then
      set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "${11}" "${12}" "${13}" "$chainfile" "${15}" "$keyfile" "${17}" "${21}" "$dnsarg" "$dnsapi"
   else
      set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "${11}" "${12}" "${13}" "$chainfile" "${15}" "$keyfile" "${17}" "$dnsarg" "$dnsapi"
   fi

   set -- "$domarg" "$domain" "$@"

   #echo AFTER "1:$1" "2:$2" "3:$3" "4:$4" "5:$5" "6:$6" "7:$7" "8:$8" "9:$9" "10:${10}" "11:${11}" "12:${12}" "13:${13}" "14:${14}" "15:${15}" "16:${16}" "17:${17}" "18:${18}" "19:${19}" "20:${20}" "21:${21}" "22:${22}" "23:${23}" "24:${24}" "25:${25}"
   #logger -t acme "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}" "${11}" "${12}" "${13}" "${14}" "${15}" "${16}" "${17}" "${18}" "${19}" "${20}" "${21}" "${22}" "${23}" "${24}" "${25}"

   /jffs/sbin/acme.sh "$@"
fi
