##HEADER##
_FILE_=${BASH_SOURCE[0]}
_NOM_=$(basename $_FILE_ .$CLASSE_EXT | tr '.' '_')
echotools ".. Entering $_FILE_"
# File: fonctions.free.sms.sh
# Objet: Utiliser le service notification de free (recevoir des sms via free)
# Usage:
# Version:V0.0.0
# Evol:2020-02-19_1313:fw:
rc=$OK
##HEADER##

_fun_=smstools_free_notif
#===========================================
function smstools_free_notif { # P1:=<user_trigramme> P2:=<message(une ligne)>
#===========================================
local USAGE="<user_trigramme> <message(une ligne)>"
# Objet: envoyer une notif au user du compte freemobile dont le
#        service "notif...' est 'activé'
# PRQ1: FREEFSMSDATAS contient une ligne '<trigramme>:user=<freeuserid>:pass=<passwd>'
# Evol: 2020-02-19_1313:fw:Test OK !
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
[ $# -lt 2 ] && _usage_ $FUNCNAME && return $KO
##VARS##
local rc messerr USR MSG cmd
rc=$OK
##VARS##
##PARAM##
##PARAM##
##ARGS##
USR=$1 ; shift
MSG="$(echo $@ | head -1)"
##ARGS##
##BEGIN##
#_traceif_ $FUNCNAME ""
#cmd="sendmsg?user=${usr}&pass=${pass}&msg=${msg}"
# curl "${u}/$cmd" > curllog
_traceif_ $FUNCNAME ".. user valide ?"
messerr="grep -iqw \"$USR\" $FREEFSMSDATAS"
! grep -iqw "$USR" $FREEFSMSDATAS && _err_ $FUNCNAME "$messerr" && return $KO
messerr="doublons pour \"$USR\" ds $FREEFSMSDATAS"
[ $(grep -iw "$USR" $FREEFSMSDATAS | wc -l ) -gt 1  ] && _err_ $FUNCNAME "$messerr" && return $KO
_traceif_ $FUNCNAME ".. extraire user et pass de FREEFSMSDATAS"
l=$(grep -iw "$USR" $FREEFSMSDATAS)
user=$(echo $l | cut -d':' -f2 | cut -d'=' -f2)
pswd=$(echo $l | cut -d':' -f3 | cut -d'=' -f2)
cmd="sendmsg?user=${user}&pass=${pswd}&msg=${MSG}"
curl "$FREENOTIFURL/$cmd"
rc=$? ; messerr="curl \"$FREENOTIFURL/$cmd\" [$rc]"
##END##
# == Sortie
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr"
return $rc
}
[ $? -ne $OK ] && _errdef_ "$_fun_" && return $KO
declare -fx $_fun_

##FOOTER##
export ${_NOM_}='loaded'
[ $rc -eq $OK ] && echotools ".. Living   $_FILE_ [$rc]" || _err_ $_FILE_ "$messerr [$rc]"
return $rc
##FOOTER##
