##HEADER##
_FILE_=${BASH_SOURCE[0]}
_NOM_=$(basename $_FILE_ .$CLASSE_EXT | tr '.' '_')
echotools ".. Entering $_FILE_"
# File: fonctions.0000.sms.sh
# Objet: Outils GAMMU
# Usage:
# Version:V0.0.0
# Evol:2020-02-04_1754:fw:
rc=$OK
##HEADER##

if [ "$GAMMU_ACTIVATED" != 'on' ] ; then
  echotools "GAMMU_ACTIVATED=$GAMMU_ACTIVATED, skipping $_NOM_ ..."
  return $OK
fi

_fun_=sms_gammu_send
#===========================================
function sms_gammu_send { #
#===========================================
local USAGE="\"<text>\" TELnum"
# Objet: Envoi simple de SMS par GAMMU
# Evol: ##DAT##:##AUT##:
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
[ $# -lt 2 ] && _usage_ $FUNCNAME && return $KO
##PARAM##
##PARAM##
##VARS##
local rc=$OK messerr
##VARS##
##ARGS##
text="$1"
numtel="$2"
##ARGS##
##BEGIN##
echo "$text" | /usr/bin/gammu --sendsms TEXT $numtel
rc=$? ; messerr="echo \"$text\" | /usr/bin/gammu --sendsms TEXT $numtel [$rc]"
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
