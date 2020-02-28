##HEADER##
_FILE_=${BASH_SOURCE[0]}
_NOM_=$(basename $_FILE_ .$CLASSE_EXT | tr '.' '_')
echotools ".. Entering $_FILE_"
# File: fonctions.gnokii.sms.sh
# Objet:
# Usage:
# Version:V0.0.0
# Evol:2020-02-25_1059:fw:
rc=$OK
##HEADER##

#_fun_=##CLA##_##VERB##
#===========================================
#function ##CLA##_##VERB## { #
#===========================================
#local USAGE=""
# Objet:
# Evol: 2020-02-25_1059:fw:
#[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
#[ $# -lt 1 ] && _usage_ $FUNCNAME && return $KO
##VARS##
#local rc messerr
#rc=$OK
##VARS##
##PARAM##
##PARAM##
##ARGS##
##ARGS##
##BEGIN##

#_traceif_ $FUNCNAME ""
#_err_ $FUNCNAME "$messerr"

##END##
# == Sortie
#[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr"
#return $rc
#}
#[ $? -ne $OK ] && _errdef_ "$_fun_" && return $KO
#declare -fx $_fun_

##FOOTER##
export ${_NOM_}='loaded'
[ $rc -eq $OK ] && echotools ".. Living   $_FILE_ [$rc]" || _err_ $_FILE_ "$messerr [$rc]"
return $rc
##FOOTER##
