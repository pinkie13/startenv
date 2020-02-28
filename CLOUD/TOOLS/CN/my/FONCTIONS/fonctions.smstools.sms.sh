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

if [ "$SMSTOOLS_ACTIVATED" != 'on' ] ; then
  echotools "SMSTOOLS_ACTIVATED=$SMSTOOLS_ACTIVATED, skipping $_NOM_ ..."
  return $OK
fi

_fun_=smstools_msg_edit_and_send
#===========================================
function smstools_msg_edit_and_send { # <file_with_dir> <numtel|-to <motif ...>
#===========================================
local USAGE="<filename> <numtel|-to <motif ...>"
# Objet: - Editer un fichier <filename> dans /var/spool/encours,
# Evol: 2020-02-08_2023:fw:
# Evol: 2020-02-20_1621:fw: simplifier, seulement editer, pas d'envoi
#       appeler smstools_file_send(TODO) pour envoyer
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
[ $# -lt 2 ] && _usage_ $FUNCNAME && return $KO
##PARAM##
##PARAM##
##VARS##
local rc messerr nom fic DEST
rc=$OK
##VARS##
##ARGS##
fic="$1" ; shift
DEST="$@"
##ARGS##
##BEGIN##
_traceif_ $FUNCNAME "Editer fic=$fic"
$XEDITOR $fic
rc=$? ; messerr="$XEDITOR $fic [$rc]"
_traceif_ $FUNCNAME "Envoyer $fic a $dest"
cat ${fic}|smstools_msgsend $DEST
rc=$? ; messerr="cat ${fic}|smstools_msgsend $DEST [$rc]"
##END##
# == Sortie
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr"
return $rc
}
[ $? -ne $OK ] && _errdef_ "$_fun_" && return $KO
declare -fx $_fun_

_fun_=smstools_file_send
#===========================================
function smstools_file_send { # <file_with_dir> <numtel|-to <motif ...>
#===========================================
local USAGE="<filename_with_dir> <numtel|-to <motif ...> "
# Objet: - Editer un fichier <filename> dans /var/spool/encours,
# Evol: 2020-02-08_2023:fw:
# Evol: 2020-02-20_1621:fw: simplifier, seulement editer, pas d'envoi
#       appeler smstools_file_send(TODO) pour envoyer
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
[ $# -lt 2 ] && _usage_ $FUNCNAME && return $KO
##VARS##
local rc messerr nom foot filename dest
rc=$OK
##VARS##
##ARGS##
file="$1" ; shift
[ ! -f "$file" ] && _err_ $FUNCNAME "fichier [$file] NOT found" && return $KO
dest="$@"
##ARGS##
##BEGIN##
_traceif_ $FUNCNAME "Envoyer $file a $dest"
cat ${file}|smstools_msgsend $DEST
rc=$? ; messerr="cat ${file}|smstools_msgsend $DEST"
##END##
# == Sortie
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr"
return $rc
}
[ $? -ne $OK ] && _errdef_ "$_fun_" && return $KO
declare -fx $_fun_


_fun_=smstools_failed_resend
#===========================================
function smstools_failed_resend { #
#===========================================
local USAGE="[filename]"
# Objet:   deposer un fichier <timestamp>_<numtel>[_<dest>] ds outgoing
# Evol: 2020-02-10_1638:fw:
# Evol: 2020-02-20_1638:fw: UN SEUL DESTINATAIRE
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
#[ $# -lt 1 ] && _usage_ $FUNCNAME && return $KO
##VARS##
local rc messerr
rc=$OK
local R MODEL DEST MODEL REPENCOURS REPOUT FMESS numtel tmstmp outfilename
##BEGIN##
_traceif_ $FUNCNAME "# ... renvoyer ls failed's"
for f in $(ls $SMSTPSPOOL/failed/) ; do
  sudo mv $SMSTPSPOOL/failed/$f $SMSTPSPOOL/outgoing/
  rc=$?; messerr="v $SMSTPSPOOL/failed/$f $SMSTPSPOOL/outgoing/"
  [ $rc -ne $OK ] && break
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
function smstools_msgsend { # -to <dest_motifs ...>|<numtel>
#===========================================
local USAGE="<numtel>|-to motif1 motif2 ...
ex1: echo \"Hello\" | smstools_msgsend <numtel> ...
ex2: cat <ficmessage> | smstools_msgsend 33606567824 33605217249
ex3: cat <ficmessage> | smstools_msgsend 33606567824 -to aini wong
- <numtel>   := INTERNATIONAL - remplacer le 0 initial par 33 (sans le +)"
# Objet: - A partir des lignes lues en entree,
# Objet:   deposer un fichier <timestamp>_<numtel>[_<dest>] ds outgoing
# Evol: 2020-02-10_1638:fw:
# Evol: 2020-02-20_1638:fw: UN SEUL DESTINATAIRE
[ "$1" == '-h'  ] && _usage_ $FUNCNAME && return $OK
[ $# -lt 1 ] && _usage_ $FUNCNAME && return $KO
##VARS##
local rc messerr
rc=$OK
local R MODEL DEST MODEL REPENCOURS REPOUT FMESS numtel tmstmp outfilename
##VARS##
##PARAM##
MODEL=$SMSTPMODELS/ISO
REPENCOURS=$SMSTPSPOOL/encours
REPOUT=$SMSTPSPOOL/outgoing
FMESS=/tmp/message_$FUNCNAME
[ -f $FMESS ] && rm $FMESS
touch $FMESS
chmod a+rw $FMESS
##PARAM##
##ARGS##
##ARGS##
##BEGIN##
_traceif_ $FUNCNAME "# ... creer $FMESS"
while read l ; do
  echo "$l"
  _traceif_ $FUNCNAME "echo messline=$l"
done >$FMESS
_traceif_ $FUNCNAME "# ... envoi message au destinataire $@"
numtel=$1
DEST=''
if [ "$numtel" == '-to' ] ; then
 shift
 numtel=$(contacts_search_mobile $@)
 DEST="_$(echo "$@" | tr -s ' ' '_')"
fi
tmstmp=$(date +%Y%m%d_%H%M%S)
outfilename="${numtel}${DEST}_$tmstmp"
_traceif_ $FUNCNAME "tel=$tel ; outfilename=$outfilename"
_traceif_ $FUNCNAME "# .. CREATION FIC OUT with model $(basename $MODEL)"
cat $MODEL | sed "s/##NUMBER##/$numtel/" >$REPENCOURS/$outfilename
rc=$? ; messerr="cat $MODEL | sed \"s/##NUMBER##/$numtel/\" >$REPENCOURS/$outfilename [$rc]"
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr" && return $KO
_traceif_ $FUNCNAME "# .. MESSAGE"
cat $FMESS >>$REPENCOURS/$outfilename
rc=$? ; messerr="cat $FMESS >>$REPENCOURS/$outfilename [$rc]"
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr" && return $KO
_traceif_ $FUNCNAME "# .. ENVOI"
mv $REPENCOURS/$outfilename $REPOUT/
rc=$? ; messerr=" mv $REPENCOURS/$outfilename $REPOUT [$rc]"
[ $rc -ne $OK ] && _err_ $FUNCNAME "$messerr" && return $KO
_traceif_ $FUNCNAME "# === FIN boucle sur liste tels en argument"
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
# Objet: Afficher les infos sur l'etat de SMST (smstools daemon)
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
 'l') OPT='LOG';cat $SMSTFLOG|less ;;
 's') OPT='status';sudo service smstools status ;;
 'spool') OPT='spool';tree -Du $SMSTPSPOOL ;;
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
