##HEADER##
_FILE_=${BASH_SOURCE[0]}
_NOM_=$(basename $_FILE_ .$CLASSE_EXT | tr '.' '_')
echotools ".. Entering $_FILE_"
# File: fonctions.spool.sms.sh
# Objet:
# Usage:
# Version:V0.0.0
# Evol:2020-02-21_1602:fw:
rc=$OK
##HEADER##

_fun_=smstools_spool_find
#===========================================
function smstools_spool_find { # <spoolsubdir>[ <filemotif> ...]
#===========================================
local USAGE="<spoolsubdir>[ <filemotif> ...]"
# Objet: - liste les fichiers qui contiennent <filemotif>
# Objet:   dans le ss-repertoire <spoolsubdir> de $SMSTPSPOOL
# Evol: 2020-02-21_1602:fw:
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
[ $# -lt 1 ] && _usage_ $FUNCNAME && return $KO
##VARS##
local rc messerr
rc=$OK
local spoolsubdir motifs
##VARS##
##ARGS##
spoolsubdir="$1" ; shift
motifs="$@"
##ARGS##
##BEGIN##
R=$SMSTPSPOOL/$spoolsubdir
messerr="spoolsubdir [$spoolsubdir] NOT found in $SMSTPSPOOL"
[ ! -d "$R" ] && _err_ $FUNCNAME "$messerr" && return $KO
#_traceif_ $FUNCNAME ""
res=$(ls -1 $R)
while [ -n "$1" ] ; do
  res=$(echo "$res" | grep -e "$1")
  shift
done
echo "$res"
##END##
# == Sortie
[ -z "$res" ] && rc=$KO && messerr="fichier like [$motifs]  NOT found in $spoolsubdir"
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr"
return $rc
}
[ $? -ne $OK ] && _errdef_ "$_fun_" && return $KO
declare -fx $_fun_


_fun_=smstools_spool_v
#===========================================
function smstools_spool_v { #<spoolsubdir> <filename>
#===========================================
local USAGE="<spoolsubdir> <filename>"
# Objet:
# Evol: ##DAT##:##AUT##:
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
[ $# -lt 2 ] && _usage_ $FUNCNAME && return $KO
##VARS##
local rc messerr
rc=$OK
local spoolsubdir fic
##VARS##
##ARGS##
spoolsubdir="$1" ; shift
fic="$1"
##ARGS##
##BEGIN##
#_traceif_ $FUNCNAME ""
messerr="fichier [$fic] NOT found in $spoolsubdir"
[ ! -f $SMSTPSPOOL/$spoolsubdir/$fic ] && _err_ $FUNCNAME "$messerr" && return $KO
sudo v $SMSTPSPOOL/$spoolsubdir/$fic
rc=$? ; messerr="cat $SMSTPSPOOL/$spoolsubdir/$fic [$rc]"
##END##
# == Sortie
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr"
return $rc
}
[ $? -ne $OK ] && _errdef_ "$_fun_" && return $KO
declare -fx $_fun_


_fun_=smstools_spool_cat
#===========================================
function smstools_spool_cat { #<spoolsubdir> <filename>
#===========================================
local USAGE="<spoolsubdir> <filename>"
# Objet:
# Evol: ##DAT##:##AUT##:
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
[ $# -lt 2 ] && _usage_ $FUNCNAME && return $KO
##VARS##
local rc messerr
rc=$OK
local spoolsubdir fic
##VARS##
##ARGS##
spoolsubdir="$1" ; shift
fic="$1"
##ARGS##
##BEGIN##
#_traceif_ $FUNCNAME ""
messerr="fichier [$fic] NOT found in $spoolsubdir"
[ ! -f $SMSTPSPOOL/$spoolsubdir/$fic ] && _err_ $FUNCNAME "$messerr" && return $KO
cat $SMSTPSPOOL/$spoolsubdir/$fic
rc=$? ; messerr="cat $SMSTPSPOOL/$spoolsubdir/$fic [$rc]"
##END##
# == Sortie
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr"
return $rc
}
[ $? -ne $OK ] && _errdef_ "$_fun_" && return $KO
declare -fx $_fun_

_fun_=smstools_spool_purge
#===========================================
function smstools_spool_purge { #<spoolsubdir>[ <filemotif> ...]
#===========================================
local USAGE="<spoolsubdir>[ <filemotif> ...]"
# Objet:
# Evol: ##DAT##:##AUT##:
[ "$1" == '-h' ] && _usage_ $FUNCNAME && return $OK
[ $# -lt 1 ] && _usage_ $FUNCNAME && return $KO
##VARS##
local rc messerr
rc=$OK
local spoolsubdir motifs fic
##VARS##
##ARGS##
spoolsubdir="$1" ; shift
motifs="$@"
##ARGS##
##BEGIN##
#_traceif_ $FUNCNAME ""
res=$(smstools_spool_find $spoolsubdir $motifs)
rc=$? ; [ $rc -ne $OK ] && return $rc
for fic in $res ; do
  sudo rm $SMSTPSPOOL/$spoolsubdir/$fic
  rc=$?;messerr="rm $SMSTPSPOOL/$spoolsubdir/$fic"
done
##END##
# == Sortie
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr"
return $rc
}
[ $? -ne $OK ] && _errdef_ "$_fun_" && return $KO
declare -fx $_fun_

_fun_=smstools_spool_archsent
#===========================================
function smstools_spool_archsent { #
#===========================================
local USAGE="(noargs)"
# Objet: - retirer les fichiers dans sent et les archiver dans $SMSTPARCHSENT
# Objet: sous le nom $(timestamp).tgz
# Evol: ##DAT##:##AUT##:
[ "$1" == '-h' ] && _usage_ $FUNCNAME && return $OK
#[ $# -lt 1 ] && _usage_ $FUNCNAME && return $KO
##VARS##
local rc messerr
rc=$OK
local ARCH INDEX SPOOL nam TAROPTS
##VARS##
##PARAM##
SPOOL=sent
nam=${SPOOL}_$(timestamp)
ARCH=$SMSTPARCHSENT/$nam.tgz
INDEX=$SMSTPARCHSENT/$nam.idx
TAROPTS='--verbose --auto-compress --create'
##PARAM##
##ARGS##
##ARGS##
##BEGIN##
[ $(ls $SMSTPSPOOL/$SPOOL|wc -l) -lt 1 ]  && _warn_  $FUNCNAME "No file in $SMSTPSPOOL/$SPOOL"  && return $KO
[ -f "$ARCH" ] && file_version_inc "$ARCH" && file_version_inc "$INDEX"
_traceif_ $FUNCNAME "archiver $SMSTPSPOOL/$SPOOL"
tar $TAROPTS -f $ARCH --index-file=$INDEX --directory $SMSTPSPOOL/$SPOOL $(ls $SMSTPSPOOL/$SPOOL/)
rc=$? ; messerr="tar $TAROPTS -f $ARCH --index-file=$INDEX --directory $SMSTPSPOOL/$SPOOL * [$rc]"
if [ $rc -eq $OK ] ; then
  smstools_spool_purge sent
  rc=$?;messerr="smstools_spool_purge sent"
fi
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
