##HEADER##
_FILE_=${BASH_SOURCE[0]}
_NOM_=$(basename $_FILE_ .$CLASSE_EXT | tr '.' '_')
echotools ".. Entering $_FILE_"
# File: fonctions.0001.sms.sh
# Objet: Outils GAMMU-SMSD
# Usage:
# Version:V0.0.0
# Evol:2020-02-05_1919:fw:
rc=$OK
##HEADER##

if [ "$GAMMUSMSD_ACTIVATED" != 'on' ] ; then
  echotools "GAMMUSMSD_ACTIVATED=$GAMMUSMSD_ACTIVATED, skipping $_NOM_ ..."
  return $OK
fi

fun_=sms_gammu_smsd_send
#===========================================
function sms_gammu_smsd_send { #
#===========================================
local USAGE="\"<text>\" TELnum"
# Objet: Envoi de SMS par GAMMU_SMSD
# Evol: ##DAT##:##AUT##:
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
[ $# -lt 2 ] && _usage_ $FUNCNAME && return $KO
##PARAM##
##PARAM##
##VARS##
#local rc=$OK messerr
##VARS##
##ARGS##
text="$1"
numtel="$2"
##ARGS##
##BEGIN##
echo "$text" | gammu-smsd-inject TEXT $numtel
rc=$? ; messerr="echo \"$text\" | gammu-smsd-inject TEXT $numtel [$rc]"
##END##
# == Sortie
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr"
return $rc
}
[ $? -ne $OK ] && _errdef_ "$_fun_" && return $KO
declare -fx $_fun_

_fun_=sms_gammu_smsd_logs
#===========================================
function sms_gammu_smsd_logs { #
#===========================================
local USAGE=""
# Objet: tree -D du spool de SMSD
# Evol: ##DAT##:##AUT##:
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
#[ $# -lt 1 ] && _usage_ $FUNCNAME && return $KO
##PARAM##
##PARAM##
##VARS##
local rc=$OK messerr
##VARS##
##ARGS##
##ARGS##
##BEGIN##

tree -D $GAMMU_LOGS
rc=$? ; messerr="tree -D $GAMMU_LOGS"

##END##
# == Sortie
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr"
return $rc
}
[ $? -ne $OK ] && _errdef_ "$_fun_" && return $KO
declare -fx $_fun_

_fun_=sms_gammu_smsd_conf_reload
#===========================================
function sms_gammu_smsd_conf_reload { #
#===========================================
#local USAGE=""
# Objet:
# Evol: ##DAT##:##AUT##:
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
#[ $# -lt 1 ] && _usage_ $FUNCNAME && return $KO
##PARAM##
##PARAM##
##VARS##
local rc=$OK messerr
##VARS##
##ARGS##
##ARGS##
##BEGIN##
gammu-config
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
