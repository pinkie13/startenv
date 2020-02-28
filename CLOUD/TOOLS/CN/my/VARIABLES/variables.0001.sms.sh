##HEADER##
_FILE_=${BASH_SOURCE[0]}
_NOM_=$(basename $_FILE_ .$CLASSE_EXT | tr '.' '_')
echotools ".. Entering $_FILE_"
# File: variables.0001.sms.sh
# Objet:
# Usage:
# Version:V0.0.0
# Evol:2020-02-05_1920:fw:
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

export tel_FWG='0606567824'

##FOOTER##
export ${_NOM_}='loaded'
[ $rc -eq $OK ] && echotools ".. Living   $_FILE_ [$rc]" || _err_ $_FILE_ "$messerr [$rc]"
return $rc
##FOOTER##
