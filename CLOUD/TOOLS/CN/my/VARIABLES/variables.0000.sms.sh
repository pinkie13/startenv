##HEADER##
_FILE_=${BASH_SOURCE[0]}
_NOM_=$(basename $_FILE_ .$CLASSE_EXT | tr '.' '_')
echotools ".. Entering $_FILE_"
# File: variables.0000.sms.sh
# Objet:
# Usage:
# Version:V0.0.0
# Evol:2020-02-04_1754:fw:
rc=$OK
##HEADER##
# export [-[rx]] ${a}_${b}[=...]
# readonly <nom> :
# ex: declare [-[rgaAi]] toto=zob ; typeset -p toto
# ex: declare -l var : convertir la valeur de var en minuscules lors de l'affectation
#
# help declare:
# declare [-aAfFgilnrtux] [-p] [nom[=valeur] ...]
#    Définit les valeurs et les attributs des variables.
#
#    Déclare des variables et leur assigne des attributs.  Si aucun NOM n'est donné,
#    affiche les attributs et les valeurs de toutes les variables.
#
#    Options :
#      -f	restreint l'action ou l'affichage aux noms et définitions de fonctions
#      -F	restreint l'affichage aux noms des fonctions uniquement (avec le numéro de ligne
#    		et le fichier source lors du débogage)
#      -g	crée des variables globales lorsqu'utilisée dans une fonction shell ; ignoré sinon
#      -p	affiche les attributs et la valeur de chaque NOM
#
#    Options qui définissent des attributs :
#      -a	NOM est un tableau indexe (si pris en charge)
#      -A	NOM est un tableau associatif (si pris en charge)
#      -i	pour assigner l'attribut « integer » aux NOMs
#      -l	pour convertir la valeur de chaque NOM en minuscules lors de l'affectation
#      -n	transforme NOM en une référence vers une variable nommée d'après sa valeur
#      -r	pour mettre les NOMs en lecture seule
#      -t	pour permettre aux NOMs d'avoir l'attribut « trace »
#      -u	pour convertir les NOMs en majuscules lors de l'affectation
#      -x	pour permettre aux NOMs de s'exporter
#
#    Utiliser « + » au lieu de « - » pour désactiver l'attribut.
# readonly [ENTER] fournit des exemples interessaont
# declare -gr ##CLA##_XX= # .. si -g, le nom est en majuscule sinon en minuscule
# exemple qui marche avec root
#echo "hello world" | /usr/bin/gammu --sendsms TEXT 0606567824

# ### GLOBALS
# .. selon valeurs suivante, activation ou non des
#    variables, fonctions et alias correspondants
#
export GAMMU_ACTIVATED=off
export GAMMUSMSD_ACTIVATED=off
export SMSD_ACTIVATED=on
export ATDEF='at115200'

### PATHS and FILES
# === GAMMU
if [ "$GAMMU_ACTIVATED" == 'on' ] ; then
export GAMMU_PLOGS=/var/spool/gammu
export GAMMU_FCONF=/etc/gammurc
fi

# === GAMMU-SMSD
if [ "$GAMMUSMSD_ACTIVATED" == 'on' ] ; then
export GAMMUSMSD_PLOGS=$GAMMU_PLOGS
export GAMMUSMSD_FCONF=/etc/gammu-smsdrc
fi

# === SMSTOOLS
if [ "$SMST_ACTIVATED" == 'on' ] ; then
export SMSTPLOG=/var/log/smstools/smsd.log
export SMSTPSPOOL=/var/spool/sms
export SMSTPATELIER=$ATELIERS/SMS/SMSTOOLS
export SMSTPMODELS=$SMSTPATELIER/models
export SMSTPRUN=/var/run/smstools
fi
#
# ... FILES
export SMSTFLOCALDOC=/usr/share/doc/smstools/html/doc/index.html
export SMSTFCONF=/etc/smsd.conf
export checkhandler=/usr/local/bin/smscheck
# -> /srv/CLOUD/TOOLS/CN/ATELIERS/SMS/SMSTOOLS/checkhandler.sh-rwxr-xr-x 1 fw fw
export checkhandlerlog=$SMSTPATELIER/logs/checkhandler.log

##FOOTER##
export ${_NOM_}='loaded'
[ $rc -eq $OK ] && echotools ".. Living   $_FILE_ [$rc]" || _err_ $_FILE_ "$messerr [$rc]"
return $rc
##FOOTER##
