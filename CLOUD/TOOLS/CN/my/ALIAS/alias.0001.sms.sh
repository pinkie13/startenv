##HEADER##
_FILE_=${BASH_SOURCE[0]}
_NOM_=$(basename $_FILE_ .$CLASSE_EXT | tr '.' '_')
echotools ".. Entering $_FILE_"
# File: alias.0001.sms.sh
# Objet:
# Usage:
# Version:V0.0.0
# Evol:2020-02-05_1920:fw:
rc=$OK
##HEADER##
# == Raccourcis sur fonctions de la classe


##FOOTER##
export ${_NOM_}='loaded'
[ $rc -eq $OK ] && echotools ".. Living   $_FILE_ [$rc]" || _err_ $_FILE_ "$messerr [$rc]"
return $rc
##FOOTER##
