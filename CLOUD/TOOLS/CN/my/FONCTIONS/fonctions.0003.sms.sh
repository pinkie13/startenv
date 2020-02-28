##HEADER##
_FILE_=${BASH_SOURCE[0]}
_NOM_=$(basename $_FILE_ .$CLASSE_EXT | tr '.' '_')
echotools ".. Entering $_FILE_"
# File: fonctions.0003.sms.sh
# Objet: Outils SMSTOOLS
# Usage:
# Version:V0.0.0
# Evol:2020-02-08_2023:fw:
rc=$OK
##HEADER##

if [ "$SMST_ACTIVATED" != 'on' ] ; then
  echotools "SMSD_ACTIVATED=$SMSD_ACTIVATED, skipping $_NOM_ ..."
  return $OK
fi

_fun_=smstools_msgnew
#===========================================
function smstools_msgnew_editor { # <numtel(international)> [<filename>]
#===========================================
local USAGE="<filename> <numtel(international:33 au lieu du premier 0)> "
# Objet: - Editer un fichier <filename> dans /var/spool/encours,
# Objet: - Format de filename: 1ere,ligne le no telephone, les
# Objet:   autres le texte.
# Evol: 2020-02-08_2023:fw:
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
[ $# -lt 2 ] && _usage_ $FUNCNAME && return $KO
##PARAM##
MODEL=new
##PARAM##
##VARS##
local rc messerr nom foot
rc=$OK
##VARS##
##BEGIN##
while [ -n "$1" ] ; do
##ARGS##
nom="$1"    ; shift
##ARGS##
foot=$SMSDPSPOOL/encours/${nom}
_traceif_ $FUNCNAME "nom=$nom, numtel=$numtel, OUT=$foot"
[ -f "$foot  " ] && _err_ $FUNCNAME "[$foot] existe DEJA" && return $KO
$XEDITOR $foot
rc=$? ; messerr="$XEDITOR $foot" ; [ $rc -ne $OK ] && break
done
##END##
# == Sortie
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr"
return $rc
}
[ $? -ne $OK ] && _errdef_ "$_fun_" && return $KO
declare -fx $_fun_

_fun_=smstools_msgsend
#===========================================
function smstools_msgsend { # [-to <dest>] <numtel>
#===========================================
local USAGE="[-to <dest>] <numtel>
ex1: echo \"Hello\" | smstools_msgsend -to fwg <numtel>
ex2: cat <ficmessage> | smstools_msgsend 33606567824 33605217249
- <numtel>   := INTERNATIONAL - remplacer le 0 initial par 33 (sans le +)"
# Objet: - A partir des lignes lues en entree,
# Objet:   deposer un fichier de <timestamp>_<numtel>[_<dest>] ds outgoing
# Evol: 2020-02-010_1638:fw:
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
[ $# -lt 1 ] && _usage_ $FUNCNAME && return $KO
##VARS##
local rc messerr
rc=$OK
##VARS##
##PARAM##
local R MODEL DEST
RSMS=$ATELIERS/SMS/SMSTOOLS
MODEL=$ATELIERS/SMS/SMSTOOLS/models/ISO
REPENCOURS=$SMSDPSPOOL/encours
REPOUT=$SMSDPSPOOL/outgoing
FMESS=/tmp/message_$FUNCNAME
[ -f $FMESS ] && rm $FMESS
touch $FMESS
chmod a+rw $FMESS
##PARAM##
##ARGS##
DEST='' ; [ "$1" == '-to' ] && DEST="_$2" &&shift
##ARGS##
##BEGIN##
_traceif_ $FUNCNAME "# ... stockage message  ds fic tempo"
_traceif_ $FUNCNAME "# === boucle sur ligne de texte en entree (message)"
while read l ; do
  echo "$l" >>$FMESS
  rc=$? ; messerr="echo \"$l\" [$rc] >>$FMESS"
  [ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr [$rc]" && return $KO
  _traceif_ $FUNCNAME "echo \"$l\" >>$FMESS"
done # fin while read l
rc=$? ; messerr="boucle sur ligne de texte en entree (message) [$rc]"
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr" && return $KO
_traceif_ $FUNCNAME "# ... envoi message a chq tel num"
_traceif_ $FUNCNAME "# === boucle sur liste tels en argument"
while [ -n "$1" ]; do
  numtel="$1" ; shift
  tmstmp=$(date +%Y%m%d_%H%M)
  outfilename="${numtel}${DEST}_$tmstmp"
  _traceif_ $FUNCNAME "tel=$tel ; outfilename=$outfilename"
  _traceif_ $FUNCNAME "# .. CREATION FIC OUT"
  _traceif_ $FUNCNAME "# .. HEADER with tel num"
  cat $MODEL | sed "s/##NUMBER##/$numtel/" >$REPENCOURS/$outfilename
  rc=$? ; messerr="cat $MODEL | sed \"s/##NUMBER##/$numtel/\" >$REPENCOURS/$outfilename [$rc]"
  [ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr" && return $KO
  _traceif_ $FUNCNAME "# .. MESSAGE"
  cat $FMESS >>$REPENCOURS/$outfilename
  rc=$? ; messerr="cat $FMESS >>$REPENCOURS/$outfilename [$rc]"
  [ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr" && return $KO
  _traceif_ $FUNCNAME "# .. ENVOI"
  mv $REPENCOURS/$outfilename $REPOUT
  rc=$? ; messerr=" mv $REPENCOURS/$outfilename $REPOUT [$rc]"
  [ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr" && return $KO
done # .. fin while [ -n "$1" ]
rm $FMESS
##END##
# == Sortie
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr"
return $rc
}
[ $? -ne $OK ] && _errdef_ "$_fun_" && return $KO
declare -fx $_fun_

_fun_=smstools_status
#===========================================
function smstools_status { #
#===========================================
local USAGE="all l:log s:status spool:files_in_spool"
# Objet: Afficher les infos sur l'etat de SMSD (smstools daemon)
# Evol: 2020-02-08_2023:fw:
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
[ $# -lt 1 ] && _usage_ $FUNCNAME && return $KO
##VARS##
local rc=$OK messerr
rc=$OK
local OPTS OPT opt
##VARS##
##PARAM##
ALLOPTS="l s spool "
##PARAM##
##ARGS##

##ARGS##
##BEGIN##
while [ -n "$1" ] ; do
opt="$1" ; shift
case  "$opt" in
 'all') OPT='all';smstools_status $ALLOPTS ;;
 'l') OPT='LOG';cat $SMSDPLOG|less ;;
 's') OPT='status';sudo service smstools status ;;
 'spool') OPT='spool';tree -Du $SMSDPSPOOL ;;
# '') ;;
esac
rc=$? ; messerr="$OPT :"
done
##END##
# == Sortie
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr [$rc]"
return $rc
}
[ $? -ne $OK ] && _errdef_ "$_fun_" && return $KO
declare -fx $_fun_

##FOOTER##
export ${_NOM_}='loaded'
[ $rc -eq $OK ] && echotools ".. Living   $_FILE_ [$rc]" || _err_ $_FILE_ "$messerr [$rc]"
return $rc
##FOOTER##
